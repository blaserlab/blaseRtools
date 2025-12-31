# Make a Copy of Image Files and Rename With File Hashes in Blinded Folder

Will copy and rename the files and generate two files:
"blinding_key.csv" with the original and blinded file names, and
"scoresheet.csv" with just the blinded filenames. Add columns as needed
to scoresheet, for example, runx_count. Then run bb_unblind to rejoin
scoresheet to the key and generate an unblinded result file.

## Usage

``` r
bb_blind_images(analysis_file, file_column, output_dir)
```

## Arguments

- analysis_file:

  The analysis file for the experiment. It should contain 1 line for
  every biological sample and should have a filename for every file to
  be blinded.

- file_column:

  The column name in the analysis_file with the files to be blinded.

- output_dir:

  The linux-style file path for the directory that will hold the blinded
  images. The directory will be created by the function.

## Value

nothing
