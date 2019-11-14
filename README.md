# JHU Data Science Specialization - Getting and Cleaning Data Project

This repository contains my Getting and Cleaning Data project submission. Here you will
find the final tidy data set, the script used to create the data set, and a file detailing
the entire process of creating this data set as well as information about the variables in
the data set.

## Running the script

Make sure that the following packages have been installed and loaded into the current R
session:

- `tidyverse`
- `magrittr`
- `zeallot`

I have divided the script into two files:

- `clean_smartphone_data.R`: this file is the script for performing the actual data
  wrangling.
- `data_wrangling_functions.R`: this file contains the functions called in the
  `clean_smartphone_data.R` script.

The script uses data from the *Human Activity Recognition Using Smartphones Data Set* that
can be found [here.][1] The data is stored in a zip file which, when unpacked, will have a
structure similar to the following diagram:

```
UCI HAR Dataset
├ test
│   └ Inertial Signals
└ train
    └ Inertial Signals
```

This is important to note as the script assumes that this directory is a subdirectory of
the current directory. In order to run the script either copy the unpacked *UCI HAR
Dataset* directory to the current directory or copy the `features.txt` file along with the
`train` and `test` directories to a new directory that you've created in the current
directory. From there, make sure that the R files listed above are in the current working
directory before setting this directory to be the current R working environment. You can
then run the `clean_smartphone_data.R` script by sourcing it and it will produce a tidy
data frame (or more accurately, a tibble) called `smartphone_data`. More information on
the transformations applied to the data as well as on the variables contained in
`smartphone_data` can be found in the `CodeBook.md` file.


[1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
