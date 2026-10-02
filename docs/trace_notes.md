# Notes: Spinning off Trace into a standalone Bioconductor-ready package

Context: these notes capture a design discussion about extracting the
`Trace` S4 class and its associated
`bb_plot_trace_*`/`bb_makeTrace`/`bb_import_*` functions out of
`blaseRtools` into its own package, aimed at eventual Bioconductor
submission. Revisit this file when picking the work back up — nothing
here has been implemented yet.

## Why do this (recap of the design discussion)

- The unmet need `Trace` fills: a **lightweight, range-validated
  container** bundling coverage/peaks/links/gene-model GRanges for one
  genomic locus, with `setValidity()` enforcing matching genome/seqnames
  and containment within a shared `plot_range`. Plain `GRangesList`
  doesn’t give you this — each element can have an incompatible schema
  and nothing stops a peaks track from referring to a different region
  than the coverage track.
- Plotting functions return **plain `ggplot2` objects**, freely
  themeable and composable with `patchwork`/`cowplot`. This was a
  deliberate reaction against `Gviz` (not well liked) and is a real
  differentiator from `Gviz`/`ggbio`.
- Compared against **plotgardener** (Bioconductor, Kramer et al. 2022):
  it’s grid-graphics, coordinate/page-based (`pageCreate()` + explicit
  inch-based `x`/`y`/`width`/`height` placement for every track),
  re-reads bigwig/BAM/.hic data on every plotting call, and has a much
  larger surface area (45+ functions: Hi-C matrices, ideograms,
  Manhattan plots, raster, etc.) with a correspondingly heavier
  dependency footprint (`rhdf5`, `strawr`, `Rcpp`, `plyranges`, …).
- **Decision: do not try to compete with plotgardener’s breadth.** The
  scope of a standalone package should stay narrow and opinionated:
  single-locus, multi-track (coverage + peaks + links + gene model),
  validated, ggplot2-native. That’s the pitch — not “another general
  genome visualization framework.”

## Blocking issue: hardcoded genome support

The single biggest blocker to calling this “Bioconductor-ready” is that
genome support is hardcoded to two species via two bundled, pre-built
annotation tables. Inventory of every touchpoint (as of `blaseRtools`
current `trace_funcs.R`):

| Location | Current behavior |
|----|----|
| `setValidity("Trace", ...)` | Explicitly whitelists `genome(...) %in% c("danRer11", "hg38")` |
| [`bb_makeTrace()`](reference/bb_makeTrace.md) | `genome = c("hg38", "danRer11")` via `match.arg`; looks up gene model from bundled `hg38_granges_reduced` / `zfin_granges_reduced` |
| [`bb_plot_trace_model()`](reference/bb_plot_trace_model.md) (`select_transcript` lookup) | `bind_rows(mcols(hg38_granges_reduced), mcols(zfin_granges_reduced))` |
| [`bb_plot_trace_axis()`](reference/bb_plot_trace_axis.md) | `if/else` on `genome == "hg38"` / `"danRer11"` just to build an axis title string |

### Proposed fix: TxDb/OrgDb-based assembly abstraction

1.  Replace the `genome = c("hg38", "danRer11")` argument with an
    `assembly` concept: accept a `TxDb` object (or a package name string
    to load one) plus an `OrgDb`/gene-symbol source. Keep
    `"hg38"`/`"danRer11"` as convenience shortcuts resolving to default
    TxDb/OrgDb pairs so existing lab scripts don’t break.
2.  Replace `hg38_granges_reduced` / `zfin_granges_reduced` with a
    `build_gene_model(txdb, gene_to_plot, range)` helper built on
    [`GenomicFeatures::exonsBy()`](https://rdrr.io/pkg/GenomicFeatures/man/transcriptsBy.html)
    / `cdsBy()` / `fiveUTRsByTranscript()` / `threeUTRsByTranscript()`.
    Still computed once at [`bb_makeTrace()`](reference/bb_makeTrace.md)
    time and cached in the `Trace` object’s `gene_model` slot — same
    performance characteristics as today.
3.  Drop the explicit genome whitelist in `setValidity()`. The existing
    checks already require all slots’ `genome()` values to match each
    other; only the `%in% c(...)` gate is genome-specific and can simply
    be removed.
4.  Fix [`bb_plot_trace_axis()`](reference/bb_plot_trace_axis.md)’s
    title logic to use `genome(gr0)` directly (or accept a display-name
    override) instead of hardcoding two assembly strings.

### Open design question: transcript selection without APPRIS

`select_the_transcripts()` currently ranks transcripts by **APPRIS**
tier (`principal1 < ... < principal5 < alternative1 < alternative2`),
which is what produced the `dll4` “line extends to the window edge”
situation we debugged (the top-ranked `principal5` transcript happened
to lack a `five_prime_UTR` annotation). APPRIS is not part of a `TxDb`,
is mainly available for human/mouse, and won’t be available for most
other species users might want to bring via a TxDb. Decide explicitly
(don’t let this fall out implicitly):

- Fallback candidates: longest transcript; most exons; “first transcript
  with both UTRs annotated, else longest.”
- Surface the selected transcript’s UTR completeness to the user somehow
  (message/warning) rather than silently drawing the “continues past
  window edge” placeholder line — this is exactly the kind of surprise a
  Bioconductor audience unfamiliar with the internals would file as a
  bug.

## Bioconductor-readiness checklist

Bioconductor has specific, actively-enforced package guidelines beyond
normal CRAN practice. Key items to plan for:

### Package structure & naming

- Package name should not already exist on CRAN/Bioconductor; check
  early.
- Must pass `R CMD build`, `R CMD check --as-cran`, and Bioconductor’s
  own
  [`BiocCheck::BiocCheck()`](https://rdrr.io/pkg/BiocCheck/man/BiocCheck.html)
  cleanly (no ERRORs, minimal WARNINGs).
- Vignette(s) in `.Rmd`/Quarto format with `BiocStyle` formatting,
  demonstrating a complete workflow (not just function-by-function
  docs).
- `biocViews` terms in `DESCRIPTION` (e.g. `Visualization`, `Coverage`,
  `GenomeAnnotation`, `Transcription`) chosen from the controlled
  vocabulary.
- Version numbers follow Bioconductor’s even/odd release-cycle
  convention once accepted (`x.y.z`, y even in release, odd in devel) —
  different from this lab’s internal `0.0.0.9NNN` convention, so this
  needs to be switched over before submission, not after.

### Dependencies / code style

- Current tidyverse-heavy style (`dplyr`, `stringr`, `tidyr` pipelines)
  is allowed on Bioconductor but worth auditing — minimize dependency
  surface where reasonable, and prefer Bioconductor-native
  classes/generics (`GenomicRanges`, `S4Vectors`, `IRanges`) over
  converting to tibbles internally where it’s not needed for clarity.
- Adopt the Bioconductor S4 conventions more consistently: currently the
  package mixes `bb_*`-prefixed plain functions with `Trace.*`
  pseudo-methods that aren’t real S4 generics dispatched through
  `setGeneric()`/`setMethod()` in the idiomatic way Bioconductor
  reviewers expect (e.g., accessor generics named after the slot, like
  `traceData()`, `peaks()`, `links()`, `geneModel()`, `plotRange()`,
  with `<-` replacement methods for setters instead of
  [`Trace.setData()`](reference/Trace.setData.md)/[`Trace.setRange()`](reference/Trace.setRange.md)/etc.).
- Decide on a public naming scheme distinct from the lab-internal `bb_`
  prefix — Bioconductor reviewers will flag non-descriptive/inconsistent
  naming.
- Remove or formalize currently-unexported internal helpers that encode
  real logic (`fill_gaps_with_tiles`, `classify_utrs`,
  `select_the_transcripts`, `set_range`, `seq_with_end`) — these should
  get proper roxygen docs (even if unexported, `@keywords internal` +
  examples help reviewers and future maintainers) and unit tests, since
  correctness currently depends on reading source code (as happened when
  debugging the `dll4` issue).

### Testing

- No test suite currently exists for this module. Bioconductor expects
  `testthat`-based unit tests with meaningful coverage, especially for:
  - `setValidity()` edge cases (mismatched genome/seqnames/containment)
  - `classify_utrs()` / `select_the_transcripts()` edge cases (missing
    UTRs, ties, single-exon transcripts)
  - Each `bb_plot_trace_*()`/renamed equivalent producing a valid ggplot
    object without error across representative inputs (both strands,
    both UTR-complete and UTR-incomplete transcripts, empty peaks/links)
  - Round-tripping through [`bb_makeTrace()`](reference/bb_makeTrace.md)
    from both Signac/Seurat objects and plain GRanges/bigwig-derived
    input

### Example/test data

- Bioconductor packages need runnable `@examples` and vignettes without
  depending on lab-internal private data files
  (`multiome.analyses.datapkg.shared_data`, etc.). Plan either:
  - Small, packaged example data (`data/`) under the package’s own data
    license, generated via a documented `data-raw/` script, **or**
  - An `ExperimentHub`/`AnnotationHub`-based companion data package if
    example data is too large to ship directly — this is the standard
    Bioconductor pattern for larger example datasets.
- Current internal datasets (`hg38_granges_reduced`,
  `zfin_granges_reduced`) should be dropped entirely once the TxDb/OrgDb
  refactor lands (see above) — no bundled annotation tables should ship
  in the new package.

### Documentation

- Every exported function/class needs complete roxygen2 docs: `@param`,
  `@return`, `@examples` that actually run, `@seealso` cross-references.
  Several current docstrings have literal `PARAM_DESCRIPTION`
  placeholders that were never filled in (e.g. `bb_import_bw`’s
  `coverage_column`, `bb_import_seacr_peaks`’s
  `group_variable`/`group_value`) — these need auditing and completing.
- Class documentation (`@slot` docs on `Trace`) is already solid and
  should carry over largely as-is, updated to reflect the TxDb-based
  genome handling.

### CI / tooling

- Set up GitHub Actions running `R CMD check`, `BiocCheck`, and
  `testthat` on each push/PR, ideally against both release and devel
  Bioconductor.
- Consider `covr`/Codecov integration once tests exist.
- `NEWS.md`/versioning conventions need to switch from this lab’s
  internal `0.0.0.9NNN` pattern to Bioconductor’s semantic versioning
  once a submission track is chosen.

## Suggested order of operations (when resumed)

1.  Decide the new package name and public function/accessor naming
    scheme.
2.  Implement the TxDb/OrgDb-based genome/assembly abstraction (replaces
    the two hardcoded genomes and bundled annotation tables) — this is
    the prerequisite for everything else being broadly useful.
3.  Decide and implement the APPRIS-free transcript-selection fallback.
4.  Extract class + functions into a fresh package skeleton; convert
    `Trace.*` pseudo-methods to idiomatic S4 generics/replacement
    methods.
5.  Write `testthat` tests alongside the extraction (don’t defer to the
    end).
6.  Write a vignette demonstrating the full workflow on small, packaged
    (or ExperimentHub-backed) example data.
7.  Run `BiocCheck`, fix findings, iterate.
8.  Only then: consider Bioconductor submission vs. just publishing via
    R-universe/GitHub if submission overhead isn’t worth it for the
    project’s anticipated audience.
