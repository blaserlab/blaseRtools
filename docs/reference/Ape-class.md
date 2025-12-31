# An S4 class to hold genebank/APE file data.

An instance of this class is best created by calling "bb_parseape()" on
a genebank or APE-formatted file. That function will parse the file,
correctly format the sections and place them in the slots of the Ape
Object. Technically only "LOCUS" is a required slot for the Ape object,
however there is no point without having "ORIGIN" (sequence data), and
so bb_parseape() will fail without an "ORIGIN" section. Other slots are
optional. Additional slots will be ignored by the constructor function.
DNA sequence will be stored in a DNAStringSet object and features in a
GRanges object. See
https://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html for genebank file
specification.

## Slots

- `LOCUS`:

  The LOCUS line of the genebank formatted as a character string.

- `DEFINITION`:

  The DEFINITION line of the genebank file formatted as a character
  string.

- `ACCESSION`:

  The ACCESSION section of the genebank file formatted as a character
  string.

- `VERSION`:

  The VERSION section of the genebank file formatted as a character
  string.

- `SOURCE`:

  The SOURCE section of the genebank file formatted as a character
  string.

- `COMMENT`:

  The COMMENT section of the genebank file formatted as a character
  string.

- `FEATURES`:

  The FEATURES section of the genebank file formatted as a character
  string. Created internally from the GRanges object. Caution: some
  FEATURE attributes may be lost in conversion.

- `ORIGIN`:

  The DNA sequence

- `end_of_file`:

  The end of the file signal.

- `dna_biostring`:

  The entire ORIGIN sequence formatted as a DNAStringSet of length 1.

- `granges`:

  Genebank features formatted as a GRanges object.
