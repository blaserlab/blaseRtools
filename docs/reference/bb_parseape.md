# Parse a Genebank File and Construct an APE Object

This is the main function for reading file in genebank/ape/equivalent
format and generating an instance of the Ape class. String manipulations
are used to parse the input ape file. Biostrings and GRanges functions
are called to generate DNAStringSet and GRanges objects to store
sequence and feature data, respectively. The Ape constructor function is
called internally at the end.

## Usage

``` r
bb_parseape(input_file)
```

## Arguments

- input_file:

  The genebank/ape file to parse and construct into an instance of the
  Ape class.

## Value

An Ape object
