# An S4 Class for Holding Heatmap Data

This is an S4 Class that is part of a solution to optimize plotting
heatmaps. This class is derived from the SummarizedExperiment class. It
inherits structure and methods and adds some structures.

Like the SummarizedExperiment Class it is built around a matrix. Like
the SingleCellExperiment and cell_data_set classes which are also
derived from SummarizedExperiment, SummarizedHeatmap holds metadata
about the columns and rows of the matrix. This enables plotting useful
annotation information with a set of plotting functions
(bb_plot_heatmap...)

Use the SummarizedHeatmap constructor to make an instance of the class
from a matrix. Use colData and rowData to get or set these values.
Internal validity checks will ensure the columns and rows match.

New to this object are colDendro and rowDendro slots. These hold
hierarchical clustering information used for ordering the heatmap plot
and plotting the dendrogrms. These are generated automatically when the
object is created.

In order to manually set the order of the columns or rows, supply values
to the rowOrder or colOrder parameters. This will prevent creation of
dendrograms for the respective colums or rows.

## Usage

``` r
SummarizedHeatmap(
  mat,
  colOrder = NULL,
  rowOrder = NULL,
  cluster_method = "ave",
  ...
)
```

## Arguments

- mat:

  A matrix to build the object from.

- colOrder:

  A character string corresponding to matrix column names.

- rowOrder:

  A character string corresponding to matrix row names.

- cluster_method:

  Clusterihng algorithm. See stats::hclust.

- ...:

  other arguments to pass into SummarizedExperiment

## Value

A SummarizedHeatmap object

## See also

[`SummarizedExperiment-class`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html),
[`SummarizedExperiment`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
[`DataFrame-class`](https://rdrr.io/pkg/S4Vectors/man/DataFrame-class.html),
`S4VectorsOverview`

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
 #EXAMPLE1
mat <- matrix(rnorm(100), ncol=5)
colnames(mat) <- letters[1:5]
rownames(mat) <- letters[6:25]
test_sh <- SummarizedHeatmap(mat)
colData(test_sh)$sample_type <- c("vowel", "consonant", "consonant", "consonant", "vowel")
colData(test_sh)$sample_type2 <- c("vowel2", "consonant2", "consonant2", "consonant2", "vowel2")
isVowel <- function(char) char %in% c('a', 'e', 'i', 'o', 'u')
rowData(test_sh)$feature_type <- ifelse(isVowel(letters[6:25]), "vowel", "consonant")
rowData(test_sh)$feature_type2 <- paste0(rowData(test_sh)$feature_type, "2")
 }
} # }
```
