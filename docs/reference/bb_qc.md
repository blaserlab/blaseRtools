# A function to run qc tests on cds objects.

A function to run qc tests on cds objects.

## Usage

``` r
bb_qc(
  cds,
  cds_name,
  genome = c("human", "mouse", "zfish"),
  nmad_mito = 2,
  nmad_detected = 2,
  max_mito = NULL,
  min_log_detected = NULL
)
```

## Arguments

- cds:

  A cell data set object to run qc functions on

- cds_name:

  The name of the cds

- genome:

  The species to use for identifying mitochondrial genes. Choose from
  "human", "mouse", "zfish", "human_mouse" for pdx.

- max_mito:

  Manual cutoff for mitochondrial percentage. May be more strict, i.e.
  lower, than the automated cutoff but not less strict, Default: NULL

- min_log_detected:

  Manual cutoff for log detected features. May be more strict, i.e.
  higher, than the automated cutoff not not less strict, Default: NULL

## Value

A list of qc objects
