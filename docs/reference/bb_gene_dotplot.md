# Make a dotplot of gene expression by cell population

Make a dotplot of gene expression by cell population

## Usage

``` r
bb_gene_dotplot(
  cds,
  markers,
  group_cells_by,
  reduction_method = "UMAP",
  norm_method = c("size_log", "log_only"),
  scale_expression_by_gene = FALSE,
  lower_threshold = 0,
  max.size = 10,
  group_ordering = "bicluster",
  gene_ordering = NULL,
  pseudocount = 1,
  scale_max = 3,
  scale_min = -3,
  colorscale_name = NULL,
  sizescale_name = NULL,
  ...
)
```

## Arguments

- cds:

  A cell data set object

- markers:

  A character vector of genes to plot

- group_cells_by:

  A cds colData column. Use "multifactorial" to pick 2 categorical
  variables to put on X axis and to facet by. See ordering below.

- norm_method:

  How to normalize gene expression. Size_factor and log normalized or
  only log normalized.

- scale_expression_by_gene:

  Whether to scale expression values according to gene. Defaults to
  FALSE.

- lower_threshold:

  Lower cutoff for gene expression

- max.size:

  The maximum size of the dotplot

- group_ordering:

  Defaults to "biclustering" method from pheatmap. Optionally will take
  a vector of group values to set the axis order explicitly. If using
  group_cells_by = "multifactorial" you will need a df to define facet
  and axis levels. See example.

- gene_ordering:

  Optional vector of gene names to order the plot.

- pseudocount:

  Add to zero expressors. Default = 1

- scale_max:

  Expression scale max

- scale_min:

  Expression scale min

- colorscale_name:

  Label for the color scale

- sizescale_name:

  Label for the size scale

- ...:

  Additional parameters to pass to facet_wrap.

## Value

A ggplot
