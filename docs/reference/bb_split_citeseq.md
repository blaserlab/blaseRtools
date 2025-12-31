# Split Antibody Capture Data into Alt Experiment

If you have cite-seq data together with gene expression data, this
function will move the cite seq data to a new separate experiment. It
will use Seurat to normalize these data using the CLR method and store
them in a new assay.

## Usage

``` r
bb_split_citeseq(cds)
```

## Arguments

- cds:

  the cell data set to split

## Value

a new CDS

## See also

[`SummarizedExperiment-class`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
