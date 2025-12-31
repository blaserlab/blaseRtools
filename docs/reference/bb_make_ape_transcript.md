# Make an Ape Transcriptome Object

This function takes a specific ensembl transcript identifier, such as
ENST00000348343.11, and gets the cDNA sequence from the corresponding
transcriptomic reference. This is returned as an Ape object with the
UTR's and the CDS annotated as features.

## Usage

``` r
bb_make_ape_transcript(query, transcriptome = c("hg38", "GRCz11"))
```

## Arguments

- query:

  A specific ensembl transcript identifier.

- transcriptome:

  Genome/transcriptome reference to use, Default: c("hg38", "GRCz11")

## Value

OUTPUT_DESCRIPTION

## Details

DETAILS

## See also

[`TxDb.Hsapiens.UCSC.hg38.knownGene`](https://rdrr.io/pkg/TxDb.Hsapiens.UCSC.hg38.knownGene/man/package.html)
[`BSgenome.Hsapiens.UCSC.hg38`](https://rdrr.io/pkg/BSgenome.Hsapiens.UCSC.hg38/man/package.html)
[`org.Hs.eg.db`](https://rdrr.io/pkg/org.Hs.eg.db/man/org.Hs.egBASE.html)
`character(0)`
[`BSgenome.Drerio.UCSC.danRer11`](https://rdrr.io/pkg/BSgenome.Drerio.UCSC.danRer11/man/package.html)
[`org.Dr.eg.db`](https://rdrr.io/pkg/org.Dr.eg.db/man/org.Dr.egBASE.html)
[`cli_abort`](https://cli.r-lib.org/reference/cli_abort.html)
[`matchPattern`](https://rdrr.io/pkg/Biostrings/man/matchPattern.html)

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
 #EXAMPLE1
 }
} # }
```
