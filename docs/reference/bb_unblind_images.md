# Rejoin Blinded Scores to Original File Names

Will rejoin scoresheet and blinded key to produce unblinded results. If
you change the names of either of those files, they have to be provided
as arguments to the function. Otherwise keyfile and scorefile are
optional.

## Usage

``` r
bb_unblind_images(
  directory,
  keyfile = "blinding_key.csv",
  scorefile = "scoresheet.csv",
  analysis_file,
  file_column
)
```

## Arguments

- directory:

  The linux-style filepath of the folder containing the scoresheet and
  blinded key.

- keyfile:

  Optional: filename of the key file. Defaults to "blinding_key.csv".

- scorefile:

  Optional: filename of the score file. Defaults to "scoresheet.csv".

- analysis_file:

  Complete file path to the the unblinded main analysis sheet. The
  function will will left_join analysis_file and unblinded results. In
  the process, it will necessarily convert windows file paths to
  linux-style file paths. Samples not included in the blinding should
  return with NA values for the added columns. New data columns being
  added on from scoresheet should be unique relative to analysis_file.

- file_column:

  The column in analysis_file containing file paths for the files that
  were blinded.

## Value

nothing
