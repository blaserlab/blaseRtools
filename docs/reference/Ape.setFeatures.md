# Set the FEATURES Slot of a GRanges Object

Set the FEATURES Slot of a GRanges Object

## Usage

``` r
Ape.setFeatures(ape, gr)
```

## Arguments

- ape:

  An ape object

- gr:

  A GRanges object. This object will become the new FEATURES and granges
  slots for the Ape object. So if you want to keep the old features, the
  new features need to be appended using c(old_gr, new_gr) as the value
  for the gr argument.
