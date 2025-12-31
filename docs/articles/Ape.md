# Reading, Editing and Writing DNA Sequences with Ape

``` r
# Attach the packages you will need for the analysis.
library(blaseRtools)
library(blaseRdata)
library(GenomicRanges)
library(tidyverse)
```

This is a brief tutorial to show you how to programmatically read and
write DNA sequences in a user-friendly format.

This set of functions are designed to work with genbank-formatted DNA
sequence files. Genbank is a long-standing, text-based DNA sequence
format. There are many programs to view and edit genbank-format files.
My recommendation is that you use
[ApE](https://jorgensen.biology.utah.edu/wayned/ape/). This program is
very easy to use.

## Ape Class

We designed a data structure which we refer to as “Ape”, in reference to
the gui-based program mentioned above, which is designed to hold
genbank-formatted DNA sequence data within an R programming environment.

The motivation behind this is as follows: Let’s say you wanted to clone
a gene enhancer from genomic DNA, or edit a specific exon with CRISPR,
or map putative transcription factor binding sites. One way to do this
is to go to ensembl, download the sequence, manually annotate the
sequence files as desired, and then work on your experiment. This is
100% interactive and 0% programmatic. You can also use pure
R/bioconductor tools to get sequence and feature information. This is
more programmatic, but the problem is that you will have to learn how to
access genomic sequence data via R and use GenomicRanges and Biostrings
to define your features. Some of this could be done programmatically but
it will require a lot of hard coding to get it done. This is not how I
would want to accomplish this task.

The Ape class and few associated functions automate most of these tasks
for you. You can read and write genebank/Ape format files for
interactive and programmatic editing. Ape class objects store sequence
internally as a
[Biostring](https://bioconductor.org/packages/release/bioc/html/Biostrings.html)
and features as a
[GenomicRanges](https://bioconductor.org/packages/release/bioc/html/GenomicRanges.html)
object so you can use those interfaces for your data as desired.

In the companion blaseRdata package we have precompiled hg38 and
danRer11 genome references and gene models for human and zebrafish so
this is one-stop shopping for sequence data. Mouse data will be added in
a future version.

## Reading, Creating, or Writing Genbank/Ape Files

Lets say you have a collection of genbank/Ape files that you would like
to read into R so that you can extract the sequence and/or feature
information for programmatic analysis.

``` r
# Read in the data

vignette_CXCL8_ape <- bb_parseape(system.file("extdata/hg38_CXCL8.ape", package = "blaseRdata"))
```

You can show the sequence information in your R console by typing the
name of the Ape object like so:

``` r
# Show the Ape Data 

vignette_CXCL8_ape
#> LOCUS       CXCL8                   3176 bp ds-DNA     linear        21-JAN-2022  
#> DEFINITION     
#> ACCESSION     
#> VERSION     
#> SOURCE     
#> COMMENT     Sequence is from Homo sapiens, GRCh38.
#> COMMENT     Gene models are from ensembl.
#> COMMENT     Gene is CXCL8
#> COMMENT     Extensions 0 bp left and 0 bp right.
#> COMMENT     Final genomic coordinates are:
#> COMMENT     chr4 73740541-73743716
#> FEATURES             Location/Qualifiers
#> 
#>      gene            1..3176
#>                      /locus_tag="CXCL8_gene"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             119..182
#>                      /locus_tag="CXCL8_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             1002..1137
#>                      /locus_tag="CXCL8_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             1409..1496
#>                      /locus_tag="CXCL8_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             119..182
#>                      /locus_tag="CXCL8_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             1002..1137
#>                      /locus_tag="CXCL8_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             1409..1492
#>                      /locus_tag="CXCL8_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             1909..1924
#>                      /locus_tag="CXCL8_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      mRNA            1..1790
#>                      /locus_tag="CXCL8_mRNA"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      five_prime_UTR  1..118
#>                      /locus_tag="CXCL8_five_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#>      exon            1..182
#>                      /locus_tag="CXCL8_exon_1"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            1002..1137
#>                      /locus_tag="CXCL8_exon_4"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            1409..1790
#>                      /locus_tag="CXCL8_exon_7"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      three_prime_UTR 1497..1790
#>                      /locus_tag="CXCL8_three_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#>      lnc_RNA         29..1446
#>                      /locus_tag="CXCL8_lnc_RNA"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      exon            29..182
#>                      /locus_tag="CXCL8_exon_2"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            1002..1446
#>                      /locus_tag="CXCL8_exon_5"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      mRNA            29..3176
#>                      /locus_tag="CXCL8_mRNA"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      five_prime_UTR  29..118
#>                      /locus_tag="CXCL8_five_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#>      exon            29..182
#>                      /locus_tag="CXCL8_exon_3"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            1002..1137
#>                      /locus_tag="CXCL8_exon_6"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            1409..1492
#>                      /locus_tag="CXCL8_exon_8"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            1909..3176
#>                      /locus_tag="CXCL8_exon_9"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      three_prime_UTR 1925..3176
#>                      /locus_tag="CXCL8_three_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#> ORIGIN
#>         1 AAAAAGCCAC CGGAGCACTC CATAAGGCAC AAACTTTCAG AGACAGCAGA GCACACAAGC
#>        61 TTCTAGGACA AGAGCCAGGA AGAAACCACC GGAAGGAACC ATCTCACTGT GTGTAAACAT
#>       121 GACTTCCAAG CTGGCCGTGG CTCTCTTGGC AGCCTTCCTG ATTTCTGCAG CTCTGTGTGA
#>       181 AGGTAAGCAC ATCTTTCTGA CCTACAGCGT TTTCCTATGT CTAAATGTGA TCCTTAGATA
#>       241 GCAAAGCTAT TCTTGATGCT TTGGTAACAA ACATCCTTTT TATTCAGAAA CAGAATATAA
#>       301 TCTTAGCAGT CAATTAATGT TAAATTGAAG ATTTAGAAAA AACTATATAT AACACTTAGG
#>       361 AAAGTATAAA GTTTGATCAA TATAGATATT CTGCTTTTAT AATTTATACC ATGTAGCATG
#>       421 CATATATTTA ACGTAAATAA GTAATTTATA GTATGTCCTA TTGAGAACCA CGGTTACCTA
#>       481 TATTATGTAT TAATATTGAG TTGAGCAAGG TAACTCAGAC AATTCCACTC CTTGTAGTAT
#>       541 TTCATTGACA AGCCTCAGAT TTGTCATTAA TTCCTGTCTG GTTTAAAGAT ACCCTGATTA
#>       601 TAGACCAGGC ATGTATAACT TATTTATATA TTTCTGTTAA TTCTTTCTGA AGGCAATTTC
#>       661 TATGCTGGAG AGTCTTAGCT TGCCTACTAT AAATAACACT GTGGTATCAC AGAGGATTAT
#>       721 GCAATATTGA CCAGATAAAA ATACCATGAA GATGTTGATA TTGTACAAAA AGAACTCTAA
#>       781 CTCTTTATAT AGGAAGTCGT TCAATGTTGT CAGTTATGAC TGTTTTTTAA AACAAAGAAC
#>       841 TAACTGAGGT CAAGGGCTAG GAGAATATTC AGGAATGAGT TCACTAGAAA CATGATGCCT
#>       901 TCCATAGTCT CCAAATAATC ATATTGGAAT TAGAAAGGAA GTAGCTGGCA GAGCTGTGCC
#>       961 TGTTGATAAA ATCAATCCTT AATCACTTTT TCCCCCAACA GGTGCAGTTT TGCCAAGGAG
#>      1021 TGCTAAAGAA CTTAGATGTC AGTGCATAAA GACATACTCC AAACCTTTCC ACCCCAAATT
#>      1081 TATCAAAGAA CTGAGAGTGA TTGAGAGTGG ACCACACTGC GCCAACACAG AAATTATGTA
#>      1141 AGTACTTTAA AAAAGATTAG ATATTTTGTT TTAGCAAACT TAAAATTAAG GAAGGTGGAA
#>      1201 ATATTTAGGA AAGTTCCAGG TGTTAGGATT ACAGTAGTAA ATGAAACAAA ACAAAATAAA
#>      1261 AATATTTGTC TACATGACAT TTAAATATGG TAGCTTCCAC AACTACTATA AATGTTATTT
#>      1321 TGGACTTAGA CTTTATGCCT GACTTAAGGA ATCATGATTT GAATGCAAAA ACTAAATATT
#>      1381 AATCTGAACC ATTTCTTTCT TATTTCAGTG TAAAGCTTTC TGATGGAAGA GAGCTCTGTC
#>      1441 TGGACCCCAA GGAAAACTGG GTGCAGAGGG TTGTGGAGAA GTTTTTGAAG AGGTAAGTTA
#>      1501 TATATTTTTT AATTTAAATT TTTCATTTAT CCTGAGACAT ATAATCCAAA GTCAGCCTAT
#>      1561 AAATTTCTTT CTGTTGCTAA AAATCGTCAT TAGGTATCTG CCTTTTTGGT TAAAAAAAAA
#>      1621 AGGAATAGCA TCAATAGTGA GTTTGTTGTA CTCATGACCA GAAAGACCAT ACATAGTTTG
#>      1681 CCCAGGAAAT TCTGGGTTTA AGCTTGTGTC CTATACTCTT AGTAAAGTTC TTTGTCACTC
#>      1741 CCAGTAGTGT CCTATTTTAG ATGATAATTT CTTTGATCTC CCTATTTATA GTTGAGAATA
#>      1801 TAGAGCATTT CTAACACATG AATGTCAAAG ACTATATTGA CTTTTCAAGA ACCCTACTTT
#>      1861 CCTTCTTATT AAACATAGCT CATCTTTATA TTTTTAATTT TATTTTAGGG CTGAGAATTC
#>      1921 ATAAAAAAAT TCATTCTCTG TGGTATCCAA GAATCAGTGA AGATGCCAGT GAAACTTCAA
#>      1981 GCAAATCTAC TTCAACACTT CATGTATTGT GTGGGTCTGT TGTAGGGTTG CCAGATGCAA
#>      2041 TACAAGATTC CTGGTTAAAT TTGAATTTCA GTAAACAATG AATAGTTTTT CATTGTACCA
#>      2101 TGAAATATCC AGAACATACT TATATGTAAA GTATTATTTA TTTGAATCTA CAAAAAACAA
#>      2161 CAAATAATTT TTAAATATAA GGATTTTCCT AGATATTGCA CGGGAGAATA TACAAATAGC
#>      2221 AAAATTGAGG CCAAGGGCCA AGAGAATATC CGAACTTTAA TTTCAGGAAT TGAATGGGTT
#>      2281 TGCTAGAATG TGATATTTGA AGCATCACAT AAAAATGATG GGACAATAAA TTTTGCCATA
#>      2341 AAGTCAAATT TAGCTGGAAA TCCTGGATTT TTTTCTGTTA AATCTGGCAA CCCTAGTCTG
#>      2401 CTAGCCAGGA TCCACAAGTC CTTGTTCCAC TGTGCCTTGG TTTCTCCTTT ATTTCTAAGT
#>      2461 GGAAAAAGTA TTAGCCACCA TCTTACCTCA CAGTGATGTT GTGAGGACAT GTGGAAGCAC
#>      2521 TTTAAGTTTT TTCATCATAA CATAAATTAT TTTCAAGTGT AACTTATTAA CCTATTTATT
#>      2581 ATTTATGTAT TTATTTAAGC ATCAAATATT TGTGCAAGAA TTTGGAAAAA TAGAAGATGA
#>      2641 ATCATTGATT GAATAGTTAT AAAGATGTTA TAGTAAATTT ATTTTATTTT AGATATTAAA
#>      2701 TGATGTTTTA TTAGATAAAT TTCAATCAGG GTTTTTAGAT TAAACAAACA AACAATTGGG
#>      2761 TACCCAGTTA AATTTTCATT TCAGATAAAC AACAAATAAT TTTTTAGTAT AAGTACATTA
#>      2821 TTGTTTATCT GAAATTTTAA TTGAACTAAC AATCCTAGTT TGATACTCCC AGTCTTGTCA
#>      2881 TTGCCAGCTG TGTTGGTAGT GCTGTGTTGA ATTACGGAAT AATGAGTTAG AACTATTAAA
#>      2941 ACAGCCAAAA CTCCACAGTC AATATTAGTA ATTTCTTGCT GGTTGAAACT TGTTTATTAT
#>      3001 GTACAAATAG ATTCTTATAA TATTATTTAA ATGACTGCAT TTTTAAATAC AAGGCTTTAT
#>      3061 ATTTTTAACT TTAAGATGTT TTTATGTGCT CTCCAAATTT TTTTTACTGT TTCTGATTGT
#>      3121 ATGGAAATAT AAAAGTAAAT ATGAAACATT TAAAATATAA TTTGTTGTCA AAGTAA
#> 
#> //
```

Printing this data out to the console may not be the most useful thing
to do, but it shows you that everything has been parsed correctly. It
should look like a genbank/Ape file.

You can also create an Ape object based on hg38 or danRer11 reference
data like so:

``` r

vignette_CXCL1_ape <- bb_make_ape_genomic("CXCL1", genome = "hg38")

vignette_CXCL1_ape
#> LOCUS       CXCL1                   1916 bp ds-DNA     linear        31-DEC-2025 
#> COMMENT     Sequence is from Homo sapiens hg38.
#> COMMENT     Gene models are from ensembl.
#> COMMENT     Gene is CXCL1
#> COMMENT     Extensions 0 bp left and 0 bp right.
#> COMMENT     Final genomic coordinates are:
#> COMMENT     chr4 73869393-73871308
#> FEATURES             Location/Qualifiers
#> 
#>      gene            1..1916
#>                      /locus_tag="CXCL1_gene"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             79..178
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             277..400
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             514..597
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             1129..1144
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      lnc_RNA         1..785
#>                      /locus_tag="CXCL1_lnc_RNA"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      exon            1..178
#>                      /locus_tag="CXCL1_exon_1"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            277..400
#>                      /locus_tag="CXCL1_exon_3"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            514..785
#>                      /locus_tag="CXCL1_exon_5"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      mRNA            1..1916
#>                      /locus_tag="CXCL1_mRNA"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      five_prime_UTR  1..78
#>                      /locus_tag="CXCL1_five_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#>      exon            1..178
#>                      /locus_tag="CXCL1_exon_2"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            277..400
#>                      /locus_tag="CXCL1_exon_4"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            514..597
#>                      /locus_tag="CXCL1_exon_6"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            1129..1916
#>                      /locus_tag="CXCL1_exon_7"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      three_prime_UTR 1145..1916
#>                      /locus_tag="CXCL1_three_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#> ORIGIN
#>         1 ACAGAGCCCG GGCCGCAGGC ACCTCCTCGC CAGCTCTTCC GCTCCTCTCA CAGCCGCCAG
#>        61 ACCCGCCTGC TGAGCCCCAT GGCCCGCGCT GCTCTCTCCG CCGCCCCCAG CAATCCCCGG
#>       121 CTCCTGCGAG TGGCACTGCT GCTCCTGCTC CTGGTAGCCG CTGGCCGGCG CGCAGCAGGT
#>       181 GGGTACCGGC GCCCTGGGGT CCCCGGGCCG GACGCGGCTG GGGTAGGCAC CCAGCGCCGA
#>       241 CAGCCTCGCT CAGTCAGTGA GTCTCTTCTT CCCTAGGAGC GTCCGTGGCC ACTGAACTGC
#>       301 GCTGCCAGTG CTTGCAGACC CTGCAGGGAA TTCACCCCAA GAACATCCAA AGTGTGAACG
#>       361 TGAAGTCCCC CGGACCCCAC TGCGCCCAAA CCGAAGTCAT GTAAGTCCCG CCCCGCGCTG
#>       421 CCTCTGCCAC CGCCGGGGTC CCAGACCCTC CTGCTGCCCC AACCCTGTCC CCAGCCCGAC
#>       481 CTCCTGCCTC ACGAGATTCC CTTCCCTCTG CAGAGCCACA CTCAAGAATG GGCGGAAAGC
#>       541 TTGCCTCAAT CCTGCATCCC CCATAGTTAA GAAAATCATC GAAAAGATGC TGAACAGGTG
#>       601 AGTTATGGTT TCCATGTACA CAGGCGACTG GAGCCGTTGG TCAGAAATAC TGGCATGTGC
#>       661 CCCCTAAAAA TAAAATCAGG AAAACCCAGG GGTTAGTTGA AGGACTAGAA ATTGGGATTA
#>       721 TTGTTTTCAC AATTAAGGTT TCCTTTACGA TAATTACTGC TCTGGTGCCA GAGGATATTC
#>       781 CCAATGCCTG GCGTCCCCAC CCTGGTTCTT CCTTCGTTCC AATGAATGTA GGTAAAACTG
#>       841 CCTTCATTTG AGGCCCAGTA GGACAAACAG CAACAGGTTC TGGCTGTTTT TAATCCAATA
#>       901 GTACAGTGGA GACCACCGCC CCACCCCACC CCCATTCCTA AAAGAGCATC CCAAGCTTAG
#>       961 AGGTCCCTGC CACACAGCAC AGCTGTCATA GGCAGTAGCC ACTTGGTTGC CAGGCTGGGG
#>      1021 AAACTGCATT CGGAAAACTC TAGAGGCTGG AGGAGCAGGG CAGGAGAAGA GTGTTGTGCA
#>      1081 ATCAGCTTTC CCGAGCACCT ACTCAGGGCA CCCATTTTCT CATTGCAGTG ACAAATCCAA
#>      1141 CTGACCAGAA GGGAGGAGGA AGCTCACTGG TGGCTGTTCC TGAAGGAGGC CCTGCCCTTA
#>      1201 TAGGAACAGA AGAGGAAAGA GAGACACAGC TGCAGAGGCC ACCTGGATTG TGCCTAATGT
#>      1261 GTTTGAGCAT CGCTTAGGAG AAGTCTTCTA TTTATTTATT TATTCATTAG TTTTGAAGAT
#>      1321 TCTATGTTAA TATTTTAGGT GTAAAATAAT TAAGGGTATG ATTAACTCTA CCTGCACACT
#>      1381 GTCCTATTAT ATTCATTCTT TTTGAAATGT CAACCCCAAG TTAGTTCAAT CTGGATTCAT
#>      1441 ATTTAATTTG AAGGTAGAAT GTTTTCAAAT GTTCTCCAGT CATTATGTTA ATATTTCTGA
#>      1501 GGAGCCTGCA ACATGCCAGC CACTGTGATA GAGGCTGGCG GATCCAAGCA AATGGCCAAT
#>      1561 GAGATCATTG TGAAGGCAGG GGAATGTATG TGCACATCTG TTTTGTAACT GTTTAGATGA
#>      1621 ATGTCAGTTG TTATTTATTG AAATGATTTC ACAGTGTGTG GTCAACATTT CTCATGTTGA
#>      1681 AACTTTAAGA ACTAAAATGT TCTAAATATC CCTTGGACAT TTTATGTCTT TCTTGTAAGG
#>      1741 CATACTGCCT TGTTTAATGG TAGTTTTACA GTGTTTCTGG CTTAGAACAA AGGGGCTTAA
#>      1801 TTATTGATGT TTTCATAGAG AATATAAAAA TAAAGCACTT ATAGAAAAAA CTCGTTTGAT
#>      1861 TTTTGGGGGG AAACAAGGGC TACCTTTACT GGAAAATCTG GTGATTTATA TCAATA
#> 
#> //
```

You can select certain feature types to include by specifying the
`include_type` argument.

You may also add flanking sequences or specify genomic regions by
coordinate rather than gene name.

``` r
# Get genomic sequence and extend 100 bp left and right.
vignette_CXCL1_ape <- bb_make_ape_genomic("CXCL1", genome = "hg38", extend_left = 100, extend_right = 100)

vignette_CXCL1_ape
#> LOCUS       CXCL1                   2116 bp ds-DNA     linear        31-DEC-2025 
#> COMMENT     Sequence is from Homo sapiens hg38.
#> COMMENT     Gene models are from ensembl.
#> COMMENT     Gene is CXCL1
#> COMMENT     Extensions 100 bp left and 100 bp right.
#> COMMENT     Final genomic coordinates are:
#> COMMENT     chr4 73869293-73871408
#> FEATURES             Location/Qualifiers
#> 
#>      gene            101..2016
#>                      /locus_tag="CXCL1_gene"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             179..278
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             377..500
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             614..697
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             1229..1244
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      lnc_RNA         101..885
#>                      /locus_tag="CXCL1_lnc_RNA"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      exon            101..278
#>                      /locus_tag="CXCL1_exon_1"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            377..500
#>                      /locus_tag="CXCL1_exon_3"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            614..885
#>                      /locus_tag="CXCL1_exon_5"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      mRNA            101..2016
#>                      /locus_tag="CXCL1_mRNA"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      five_prime_UTR  101..178
#>                      /locus_tag="CXCL1_five_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#>      exon            101..278
#>                      /locus_tag="CXCL1_exon_2"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            377..500
#>                      /locus_tag="CXCL1_exon_4"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            614..697
#>                      /locus_tag="CXCL1_exon_6"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            1229..2016
#>                      /locus_tag="CXCL1_exon_7"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      three_prime_UTR 1245..2016
#>                      /locus_tag="CXCL1_three_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#> ORIGIN
#>         1 TCGGGATCGA TCTGGAACTC CGGGAATTTC CCTGGCCCGG GGGCTCCGGG CTTTCCAGCC
#>        61 CCAACCATGC ATAAAAGGGG TTCGCGGATC TCGGAGAGCC ACAGAGCCCG GGCCGCAGGC
#>       121 ACCTCCTCGC CAGCTCTTCC GCTCCTCTCA CAGCCGCCAG ACCCGCCTGC TGAGCCCCAT
#>       181 GGCCCGCGCT GCTCTCTCCG CCGCCCCCAG CAATCCCCGG CTCCTGCGAG TGGCACTGCT
#>       241 GCTCCTGCTC CTGGTAGCCG CTGGCCGGCG CGCAGCAGGT GGGTACCGGC GCCCTGGGGT
#>       301 CCCCGGGCCG GACGCGGCTG GGGTAGGCAC CCAGCGCCGA CAGCCTCGCT CAGTCAGTGA
#>       361 GTCTCTTCTT CCCTAGGAGC GTCCGTGGCC ACTGAACTGC GCTGCCAGTG CTTGCAGACC
#>       421 CTGCAGGGAA TTCACCCCAA GAACATCCAA AGTGTGAACG TGAAGTCCCC CGGACCCCAC
#>       481 TGCGCCCAAA CCGAAGTCAT GTAAGTCCCG CCCCGCGCTG CCTCTGCCAC CGCCGGGGTC
#>       541 CCAGACCCTC CTGCTGCCCC AACCCTGTCC CCAGCCCGAC CTCCTGCCTC ACGAGATTCC
#>       601 CTTCCCTCTG CAGAGCCACA CTCAAGAATG GGCGGAAAGC TTGCCTCAAT CCTGCATCCC
#>       661 CCATAGTTAA GAAAATCATC GAAAAGATGC TGAACAGGTG AGTTATGGTT TCCATGTACA
#>       721 CAGGCGACTG GAGCCGTTGG TCAGAAATAC TGGCATGTGC CCCCTAAAAA TAAAATCAGG
#>       781 AAAACCCAGG GGTTAGTTGA AGGACTAGAA ATTGGGATTA TTGTTTTCAC AATTAAGGTT
#>       841 TCCTTTACGA TAATTACTGC TCTGGTGCCA GAGGATATTC CCAATGCCTG GCGTCCCCAC
#>       901 CCTGGTTCTT CCTTCGTTCC AATGAATGTA GGTAAAACTG CCTTCATTTG AGGCCCAGTA
#>       961 GGACAAACAG CAACAGGTTC TGGCTGTTTT TAATCCAATA GTACAGTGGA GACCACCGCC
#>      1021 CCACCCCACC CCCATTCCTA AAAGAGCATC CCAAGCTTAG AGGTCCCTGC CACACAGCAC
#>      1081 AGCTGTCATA GGCAGTAGCC ACTTGGTTGC CAGGCTGGGG AAACTGCATT CGGAAAACTC
#>      1141 TAGAGGCTGG AGGAGCAGGG CAGGAGAAGA GTGTTGTGCA ATCAGCTTTC CCGAGCACCT
#>      1201 ACTCAGGGCA CCCATTTTCT CATTGCAGTG ACAAATCCAA CTGACCAGAA GGGAGGAGGA
#>      1261 AGCTCACTGG TGGCTGTTCC TGAAGGAGGC CCTGCCCTTA TAGGAACAGA AGAGGAAAGA
#>      1321 GAGACACAGC TGCAGAGGCC ACCTGGATTG TGCCTAATGT GTTTGAGCAT CGCTTAGGAG
#>      1381 AAGTCTTCTA TTTATTTATT TATTCATTAG TTTTGAAGAT TCTATGTTAA TATTTTAGGT
#>      1441 GTAAAATAAT TAAGGGTATG ATTAACTCTA CCTGCACACT GTCCTATTAT ATTCATTCTT
#>      1501 TTTGAAATGT CAACCCCAAG TTAGTTCAAT CTGGATTCAT ATTTAATTTG AAGGTAGAAT
#>      1561 GTTTTCAAAT GTTCTCCAGT CATTATGTTA ATATTTCTGA GGAGCCTGCA ACATGCCAGC
#>      1621 CACTGTGATA GAGGCTGGCG GATCCAAGCA AATGGCCAAT GAGATCATTG TGAAGGCAGG
#>      1681 GGAATGTATG TGCACATCTG TTTTGTAACT GTTTAGATGA ATGTCAGTTG TTATTTATTG
#>      1741 AAATGATTTC ACAGTGTGTG GTCAACATTT CTCATGTTGA AACTTTAAGA ACTAAAATGT
#>      1801 TCTAAATATC CCTTGGACAT TTTATGTCTT TCTTGTAAGG CATACTGCCT TGTTTAATGG
#>      1861 TAGTTTTACA GTGTTTCTGG CTTAGAACAA AGGGGCTTAA TTATTGATGT TTTCATAGAG
#>      1921 AATATAAAAA TAAAGCACTT ATAGAAAAAA CTCGTTTGAT TTTTGGGGGG AAACAAGGGC
#>      1981 TACCTTTACT GGAAAATCTG GTGATTTATA TCAATATTTC TCAATTTTTT AATTGTGTTT
#>      2041 ATTTTTCTGG GTGTTCAATT TGCTATACAG ATAAATCAAA CTATGAGTTA TGCTTCATTT
#>      2101 CATGCGGTGA TTGCTG
#> //
```

Note that the extension arguments are strictly relative to the top or +
strand, so the sense of upstream or downstream may be different relative
to your gene of interest if that gene is on the top or bottom strand.

You will notice that all feature coordinates have been recalculated and
are relative to the sequence present in the object. Let’s say you had a
feature that you knew about in terms of genomic coordinates that you
wanted include when making the object. Here is how you do that:

``` r
# Get genomic sequence and extend 100 bp left and right.
# Now add a new custom feature based on original coordinates:  chr4 73869293-73871408
vignette_CXCL1_ape <- bb_make_ape_genomic(
  "CXCL1",
  genome = "hg38",
  extend_left = 100,
  extend_right = 100,
  additional_granges = GenomicRanges::makeGRangesFromDataFrame(
    data.frame(
      seqname = "chr4",
      start = 73869293,
      end = 73871408,
      strand = "+",
      gene_name = "CXCL1",
      type = "custom_feature",
      label = "custom_feature_1",
      fwdcolor = "red",
      revcolor = "blue"
    ),
    keep.extra.columns = T
  )
)

vignette_CXCL1_ape
#> LOCUS       CXCL1                   2116 bp ds-DNA     linear        31-DEC-2025 
#> COMMENT     Sequence is from Homo sapiens hg38.
#> COMMENT     Gene models are from ensembl.
#> COMMENT     Gene is CXCL1
#> COMMENT     Extensions 100 bp left and 100 bp right.
#> COMMENT     Final genomic coordinates are:
#> COMMENT     chr4 73869293-73871408
#> FEATURES             Location/Qualifiers
#> 
#>      gene            101..2016
#>                      /locus_tag="CXCL1_gene"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             179..278
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             377..500
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             614..697
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      CDS             1229..1244
#>                      /locus_tag="CXCL1_CDS"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      lnc_RNA         101..885
#>                      /locus_tag="CXCL1_lnc_RNA"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      exon            101..278
#>                      /locus_tag="CXCL1_exon_1"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            377..500
#>                      /locus_tag="CXCL1_exon_3"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            614..885
#>                      /locus_tag="CXCL1_exon_5"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      mRNA            101..2016
#>                      /locus_tag="CXCL1_mRNA"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#>      five_prime_UTR  101..178
#>                      /locus_tag="CXCL1_five_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#>      exon            101..278
#>                      /locus_tag="CXCL1_exon_2"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            377..500
#>                      /locus_tag="CXCL1_exon_4"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            614..697
#>                      /locus_tag="CXCL1_exon_6"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      exon            1229..2016
#>                      /locus_tag="CXCL1_exon_7"
#>                      /ApEinfo_fwdcolor="#3182bd"
#>                      /ApEinfo_revcolor="#31a354
#> 
#>      three_prime_UTR 1245..2016
#>                      /locus_tag="CXCL1_three_prime_UTR"
#>                      /ApEinfo_fwdcolor="#9ecae1"
#>                      /ApEinfo_revcolor="#a1d99b
#> 
#>      custom_feature  1..2116
#>                      /locus_tag="CXCL1_custom_feature_1"
#>                      /ApEinfo_fwdcolor="red"
#>                      /ApEinfo_revcolor="blue
#> 
#> ORIGIN
#>         1 TCGGGATCGA TCTGGAACTC CGGGAATTTC CCTGGCCCGG GGGCTCCGGG CTTTCCAGCC
#>        61 CCAACCATGC ATAAAAGGGG TTCGCGGATC TCGGAGAGCC ACAGAGCCCG GGCCGCAGGC
#>       121 ACCTCCTCGC CAGCTCTTCC GCTCCTCTCA CAGCCGCCAG ACCCGCCTGC TGAGCCCCAT
#>       181 GGCCCGCGCT GCTCTCTCCG CCGCCCCCAG CAATCCCCGG CTCCTGCGAG TGGCACTGCT
#>       241 GCTCCTGCTC CTGGTAGCCG CTGGCCGGCG CGCAGCAGGT GGGTACCGGC GCCCTGGGGT
#>       301 CCCCGGGCCG GACGCGGCTG GGGTAGGCAC CCAGCGCCGA CAGCCTCGCT CAGTCAGTGA
#>       361 GTCTCTTCTT CCCTAGGAGC GTCCGTGGCC ACTGAACTGC GCTGCCAGTG CTTGCAGACC
#>       421 CTGCAGGGAA TTCACCCCAA GAACATCCAA AGTGTGAACG TGAAGTCCCC CGGACCCCAC
#>       481 TGCGCCCAAA CCGAAGTCAT GTAAGTCCCG CCCCGCGCTG CCTCTGCCAC CGCCGGGGTC
#>       541 CCAGACCCTC CTGCTGCCCC AACCCTGTCC CCAGCCCGAC CTCCTGCCTC ACGAGATTCC
#>       601 CTTCCCTCTG CAGAGCCACA CTCAAGAATG GGCGGAAAGC TTGCCTCAAT CCTGCATCCC
#>       661 CCATAGTTAA GAAAATCATC GAAAAGATGC TGAACAGGTG AGTTATGGTT TCCATGTACA
#>       721 CAGGCGACTG GAGCCGTTGG TCAGAAATAC TGGCATGTGC CCCCTAAAAA TAAAATCAGG
#>       781 AAAACCCAGG GGTTAGTTGA AGGACTAGAA ATTGGGATTA TTGTTTTCAC AATTAAGGTT
#>       841 TCCTTTACGA TAATTACTGC TCTGGTGCCA GAGGATATTC CCAATGCCTG GCGTCCCCAC
#>       901 CCTGGTTCTT CCTTCGTTCC AATGAATGTA GGTAAAACTG CCTTCATTTG AGGCCCAGTA
#>       961 GGACAAACAG CAACAGGTTC TGGCTGTTTT TAATCCAATA GTACAGTGGA GACCACCGCC
#>      1021 CCACCCCACC CCCATTCCTA AAAGAGCATC CCAAGCTTAG AGGTCCCTGC CACACAGCAC
#>      1081 AGCTGTCATA GGCAGTAGCC ACTTGGTTGC CAGGCTGGGG AAACTGCATT CGGAAAACTC
#>      1141 TAGAGGCTGG AGGAGCAGGG CAGGAGAAGA GTGTTGTGCA ATCAGCTTTC CCGAGCACCT
#>      1201 ACTCAGGGCA CCCATTTTCT CATTGCAGTG ACAAATCCAA CTGACCAGAA GGGAGGAGGA
#>      1261 AGCTCACTGG TGGCTGTTCC TGAAGGAGGC CCTGCCCTTA TAGGAACAGA AGAGGAAAGA
#>      1321 GAGACACAGC TGCAGAGGCC ACCTGGATTG TGCCTAATGT GTTTGAGCAT CGCTTAGGAG
#>      1381 AAGTCTTCTA TTTATTTATT TATTCATTAG TTTTGAAGAT TCTATGTTAA TATTTTAGGT
#>      1441 GTAAAATAAT TAAGGGTATG ATTAACTCTA CCTGCACACT GTCCTATTAT ATTCATTCTT
#>      1501 TTTGAAATGT CAACCCCAAG TTAGTTCAAT CTGGATTCAT ATTTAATTTG AAGGTAGAAT
#>      1561 GTTTTCAAAT GTTCTCCAGT CATTATGTTA ATATTTCTGA GGAGCCTGCA ACATGCCAGC
#>      1621 CACTGTGATA GAGGCTGGCG GATCCAAGCA AATGGCCAAT GAGATCATTG TGAAGGCAGG
#>      1681 GGAATGTATG TGCACATCTG TTTTGTAACT GTTTAGATGA ATGTCAGTTG TTATTTATTG
#>      1741 AAATGATTTC ACAGTGTGTG GTCAACATTT CTCATGTTGA AACTTTAAGA ACTAAAATGT
#>      1801 TCTAAATATC CCTTGGACAT TTTATGTCTT TCTTGTAAGG CATACTGCCT TGTTTAATGG
#>      1861 TAGTTTTACA GTGTTTCTGG CTTAGAACAA AGGGGCTTAA TTATTGATGT TTTCATAGAG
#>      1921 AATATAAAAA TAAAGCACTT ATAGAAAAAA CTCGTTTGAT TTTTGGGGGG AAACAAGGGC
#>      1981 TACCTTTACT GGAAAATCTG GTGATTTATA TCAATATTTC TCAATTTTTT AATTGTGTTT
#>      2041 ATTTTTCTGG GTGTTCAATT TGCTATACAG ATAAATCAAA CTATGAGTTA TGCTTCATTT
#>      2101 CATGCGGTGA TTGCTG
#> //
```

This turns out to be a useful feature but it does force you into using
some GenomicRanges code which is verbose and less familiar. The help
page for this function will remind you how to create the GRanges object.
Note that you can supply any number of GRanges in the object to generate
features.

Methods are provided for saving Ape objects as either genbank/Ape files
or fasta files:

``` r
# Save as a genbank/Ape file
Ape.save(vignette_CXCL1_ape, out = "/path/to/file/filename.ape")

# Save as fasta
Ape.fasta(vignette_CXCL1_ape, out = "/path/to/file/filename.fa")
```

## Getting and Setting Ape Object Slots

You may want to programmatically change the features of an Ape object,
or extract sequences or features to use elsewhere. Here you will need to
know a bit more about GRanges and Biostrings.

To get the sequence or features from an Ape Object:

``` r
# get the sequence
Ape.DNA(vignette_CXCL1_ape)
#> DNAStringSet object of length 1:
#>     width seq                                               names               
#> [1]  2116 TCGGGATCGATCTGGAACTCCGG...TTCATTTCATGCGGTGATTGCTG ape_seq

# get the features
Ape.granges(vignette_CXCL1_ape)
#> GRanges object with 17 ranges and 4 metadata columns:
#>                          seqnames    ranges strand |            type
#>                             <Rle> <IRanges>  <Rle> |     <character>
#>               CXCL1_gene  ape_seq  101-2016      + |            gene
#>                CXCL1_CDS  ape_seq   179-278      + |             CDS
#>                CXCL1_CDS  ape_seq   377-500      + |             CDS
#>                CXCL1_CDS  ape_seq   614-697      + |             CDS
#>                CXCL1_CDS  ape_seq 1229-1244      + |             CDS
#>                      ...      ...       ...    ... .             ...
#>             CXCL1_exon_4  ape_seq   377-500      + |            exon
#>             CXCL1_exon_6  ape_seq   614-697      + |            exon
#>             CXCL1_exon_7  ape_seq 1229-2016      + |            exon
#>    CXCL1_three_prime_UTR  ape_seq 1245-2016      + | three_prime_UTR
#>   CXCL1_custom_feature_1  ape_seq    1-2116      + |  custom_feature
#>                                       locus_tag    fwdcolor    revcolor
#>                                     <character> <character> <character>
#>               CXCL1_gene             CXCL1_gene     #deebf7     #e5f5e0
#>                CXCL1_CDS              CXCL1_CDS     #deebf7     #e5f5e0
#>                CXCL1_CDS              CXCL1_CDS     #deebf7     #e5f5e0
#>                CXCL1_CDS              CXCL1_CDS     #deebf7     #e5f5e0
#>                CXCL1_CDS              CXCL1_CDS     #deebf7     #e5f5e0
#>                      ...                    ...         ...         ...
#>             CXCL1_exon_4           CXCL1_exon_4     #3182bd     #31a354
#>             CXCL1_exon_6           CXCL1_exon_6     #3182bd     #31a354
#>             CXCL1_exon_7           CXCL1_exon_7     #3182bd     #31a354
#>    CXCL1_three_prime_UTR  CXCL1_three_prime_UTR     #9ecae1     #a1d99b
#>   CXCL1_custom_feature_1 CXCL1_custom_feature_1         red        blue
#>   -------
#>   seqinfo: 1 sequence from an unspecified genome; no seqlengths
```

You can set the features of an Ape object like so:

``` r
# define the new feature set
old_features <- Ape.granges(vignette_CXCL1_ape)
new_features <- old_features[mcols(old_features)$type == "gene"]

new_vignette_CXCL1_ape <- Ape.setFeatures(vignette_CXCL1_ape, gr = new_features)
new_vignette_CXCL1_ape
#> LOCUS       CXCL1                   2116 bp ds-DNA     linear        31-DEC-2025 
#> COMMENT     Sequence is from Homo sapiens hg38.
#> COMMENT     Gene models are from ensembl.
#> COMMENT     Gene is CXCL1
#> COMMENT     Extensions 100 bp left and 100 bp right.
#> COMMENT     Final genomic coordinates are:
#> COMMENT     chr4 73869293-73871408
#> FEATURES             Location/Qualifiers
#> 
#>      gene            101..2016
#>                      /locus_tag="CXCL1_gene"
#>                      /ApEinfo_fwdcolor="#deebf7"
#>                      /ApEinfo_revcolor="#e5f5e0
#> 
#> ORIGIN
#>         1 TCGGGATCGA TCTGGAACTC CGGGAATTTC CCTGGCCCGG GGGCTCCGGG CTTTCCAGCC
#>        61 CCAACCATGC ATAAAAGGGG TTCGCGGATC TCGGAGAGCC ACAGAGCCCG GGCCGCAGGC
#>       121 ACCTCCTCGC CAGCTCTTCC GCTCCTCTCA CAGCCGCCAG ACCCGCCTGC TGAGCCCCAT
#>       181 GGCCCGCGCT GCTCTCTCCG CCGCCCCCAG CAATCCCCGG CTCCTGCGAG TGGCACTGCT
#>       241 GCTCCTGCTC CTGGTAGCCG CTGGCCGGCG CGCAGCAGGT GGGTACCGGC GCCCTGGGGT
#>       301 CCCCGGGCCG GACGCGGCTG GGGTAGGCAC CCAGCGCCGA CAGCCTCGCT CAGTCAGTGA
#>       361 GTCTCTTCTT CCCTAGGAGC GTCCGTGGCC ACTGAACTGC GCTGCCAGTG CTTGCAGACC
#>       421 CTGCAGGGAA TTCACCCCAA GAACATCCAA AGTGTGAACG TGAAGTCCCC CGGACCCCAC
#>       481 TGCGCCCAAA CCGAAGTCAT GTAAGTCCCG CCCCGCGCTG CCTCTGCCAC CGCCGGGGTC
#>       541 CCAGACCCTC CTGCTGCCCC AACCCTGTCC CCAGCCCGAC CTCCTGCCTC ACGAGATTCC
#>       601 CTTCCCTCTG CAGAGCCACA CTCAAGAATG GGCGGAAAGC TTGCCTCAAT CCTGCATCCC
#>       661 CCATAGTTAA GAAAATCATC GAAAAGATGC TGAACAGGTG AGTTATGGTT TCCATGTACA
#>       721 CAGGCGACTG GAGCCGTTGG TCAGAAATAC TGGCATGTGC CCCCTAAAAA TAAAATCAGG
#>       781 AAAACCCAGG GGTTAGTTGA AGGACTAGAA ATTGGGATTA TTGTTTTCAC AATTAAGGTT
#>       841 TCCTTTACGA TAATTACTGC TCTGGTGCCA GAGGATATTC CCAATGCCTG GCGTCCCCAC
#>       901 CCTGGTTCTT CCTTCGTTCC AATGAATGTA GGTAAAACTG CCTTCATTTG AGGCCCAGTA
#>       961 GGACAAACAG CAACAGGTTC TGGCTGTTTT TAATCCAATA GTACAGTGGA GACCACCGCC
#>      1021 CCACCCCACC CCCATTCCTA AAAGAGCATC CCAAGCTTAG AGGTCCCTGC CACACAGCAC
#>      1081 AGCTGTCATA GGCAGTAGCC ACTTGGTTGC CAGGCTGGGG AAACTGCATT CGGAAAACTC
#>      1141 TAGAGGCTGG AGGAGCAGGG CAGGAGAAGA GTGTTGTGCA ATCAGCTTTC CCGAGCACCT
#>      1201 ACTCAGGGCA CCCATTTTCT CATTGCAGTG ACAAATCCAA CTGACCAGAA GGGAGGAGGA
#>      1261 AGCTCACTGG TGGCTGTTCC TGAAGGAGGC CCTGCCCTTA TAGGAACAGA AGAGGAAAGA
#>      1321 GAGACACAGC TGCAGAGGCC ACCTGGATTG TGCCTAATGT GTTTGAGCAT CGCTTAGGAG
#>      1381 AAGTCTTCTA TTTATTTATT TATTCATTAG TTTTGAAGAT TCTATGTTAA TATTTTAGGT
#>      1441 GTAAAATAAT TAAGGGTATG ATTAACTCTA CCTGCACACT GTCCTATTAT ATTCATTCTT
#>      1501 TTTGAAATGT CAACCCCAAG TTAGTTCAAT CTGGATTCAT ATTTAATTTG AAGGTAGAAT
#>      1561 GTTTTCAAAT GTTCTCCAGT CATTATGTTA ATATTTCTGA GGAGCCTGCA ACATGCCAGC
#>      1621 CACTGTGATA GAGGCTGGCG GATCCAAGCA AATGGCCAAT GAGATCATTG TGAAGGCAGG
#>      1681 GGAATGTATG TGCACATCTG TTTTGTAACT GTTTAGATGA ATGTCAGTTG TTATTTATTG
#>      1741 AAATGATTTC ACAGTGTGTG GTCAACATTT CTCATGTTGA AACTTTAAGA ACTAAAATGT
#>      1801 TCTAAATATC CCTTGGACAT TTTATGTCTT TCTTGTAAGG CATACTGCCT TGTTTAATGG
#>      1861 TAGTTTTACA GTGTTTCTGG CTTAGAACAA AGGGGCTTAA TTATTGATGT TTTCATAGAG
#>      1921 AATATAAAAA TAAAGCACTT ATAGAAAAAA CTCGTTTGAT TTTTGGGGGG AAACAAGGGC
#>      1981 TACCTTTACT GGAAAATCTG GTGATTTATA TCAATATTTC TCAATTTTTT AATTGTGTTT
#>      2041 ATTTTTCTGG GTGTTCAATT TGCTATACAG ATAAATCAAA CTATGAGTTA TGCTTCATTT
#>      2101 CATGCGGTGA TTGCTG
#> //
```

That shows you how to subset a granges object. If you want to combine
two granges objects, run `c(object_1, object_2)` etc.

### Annotating Putative Transcription Factor Binding Sites

This is a pretty common function and there are several other tools you
can use to do this, but here we use
[FIMO](https://meme-suite.org/meme/doc/fimo.html) from the MEME suite to
do the annotation.

The prerequisite here is that you have to install FIMO on your system.
Instructions are available at the link provided. To find TFBS in your
Ape file you will use the [`Ape.fimo()`](../reference/Ape.fimo.md)
function.

``` r
Ape.fimo(vignette_CXCL1_ape, fimo_feature = "CXCL1_gene")
```

For this to run properly you have to identify the feature name within
the Ape object that you want to evaluate. This is the name of the Ape
object GRanges element or the locus_tag from the genbank/Ape file.

If your installation of FIMO can’t be found it will provide instructions
for you.

The function returns a GRanges object with the results. Optionally
(recommended) you can specify an output directory for detailed output
data.

## Conclusion

Good luck working with your DNA sequences!
