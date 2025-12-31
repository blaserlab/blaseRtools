# Infer Cell-Cell Communication

Use this function to identify ligand/receptor pairs expressed by cell
clusters in human, mouse or zebrafish single cell data. A CellChat
object is generated which can be used to visualize these connections
using bb_cellchat_heatmap or other tools from package CellChat.

## Usage

``` r
bb_cellchat(
  cds,
  group_var,
  n_cores = 12,
  species = c("human", "mouse", "zebrafish"),
  min_cells = 10,
  prob_type = c("triMean", "truncatedMean", "median"),
  prob_trim = NULL,
  project = TRUE,
  pop_size_arg = TRUE,
  ask = TRUE
)
```

## Arguments

- cds:

  The cell data set object. It should usually be pre-filtered to conatin
  a single biological sample.

- group_var:

  The cell metadata column identifying cell groups for cell-cell
  communication inference.

- n_cores:

  Number of cores for the analysis, Default: 12

- species:

  Species for the assay, Default: c("human", "mouse", "zebrafish")

- min_cells:

  Cell clusters smaller than this value will be ignored., Default: 10

- prob_type:

  Methods for computing the average gene expression per cell group. By
  default = "triMean", producing fewer but stronger interactions; When
  setting ‘type = "truncatedMean"', a value should be assigned to
  ’trim', producing more interactions, Default: c("triMean",
  "truncatedMean", "median")

- prob_trim:

  the fraction (0 to 0.25) of observations to be trimmed from each end
  of x before the mean is computed if using truncatedMean, Default: NULL

- project:

  Whether or not to smooth gene expression, Default: TRUE

- pop_size_arg:

  Whether consider the proportion of cells in each group across all
  sequenced cells. Set population.size = FALSE if analyzing
  sorting-enriched single cells, to remove the potential artifact of
  population size. Set population.size = TRUE if analyzing unsorted
  single-cell transcriptomes, with the reason that abundant cell
  populations tend to send collectively stronger signals than the rare
  cell populations., Default: TRUE

## Value

A CellChat object

## Details

see github::sqjin/CellChat

## See also

[`normalized_counts`](https://rdrr.io/pkg/monocle3/man/normalized_counts.html)
[`mutate-joins`](https://dplyr.tidyverse.org/reference/mutate-joins.html),[`pull`](https://dplyr.tidyverse.org/reference/pull.html)
[`tibble`](https://tibble.tidyverse.org/reference/tibble.html)
[`createCellChat`](https://rdrr.io/pkg/CellChat/man/createCellChat.html),[`CellChatDB.human`](https://rdrr.io/pkg/CellChat/man/CellChatDB.human.html),[`CellChatDB.mouse`](https://rdrr.io/pkg/CellChat/man/CellChatDB.mouse.html),`character(0)`,[`subsetData`](https://rdrr.io/pkg/CellChat/man/subsetData.html),[`identifyOverExpressedGenes`](https://rdrr.io/pkg/CellChat/man/identifyOverExpressedGenes.html),[`identifyOverExpressedInteractions`](https://rdrr.io/pkg/CellChat/man/identifyOverExpressedInteractions.html),[`projectData`](https://rdrr.io/pkg/CellChat/man/projectData.html),[`computeCommunProb`](https://rdrr.io/pkg/CellChat/man/computeCommunProb.html),[`filterCommunication`](https://rdrr.io/pkg/CellChat/man/filterCommunication.html),[`computeCommunProbPathway`](https://rdrr.io/pkg/CellChat/man/computeCommunProbPathway.html),[`aggregateNet`](https://rdrr.io/pkg/CellChat/man/aggregateNet.html)
`character(0)`
[`plan`](https://future.futureverse.org/reference/plan.html)
