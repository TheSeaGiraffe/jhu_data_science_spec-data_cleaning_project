# Code Book

This document goes over what each variable in the final tidy datset represents as well as
the process by which this data set was obtained.

## Data cleaning process

The data cleaning process can be broken down into five main operations:

1.  Extracting the features corresponding to the means and standard deviation for each
    measurement from the orginal data set.
2.  Replacing the activity codes with their corresponding label.
3.  Constructing a data frame from the pieces obtained in the previous steps for both the
    training and test data.
4.  Combining the training and test data into a single data set.
5.  Taking the mean of each feature by subject and activity.

Each of these steps will be discussed in their own sections. Before we proceed, it's worth
reminding the reader that the code for cleaning the data is split into two parts: the
actual data cleaning code and the functions used by said code. The file
`clean_smartphone_data.R` contains the data cleaning code while the file
`data_wrangling_functions.R` contain the necessary functions. It should also be noted that
the code makes use of the `tidyverse` suite of functions. For those unfamiliar with the
`tidyverse` it is enough to know that the pipe operator `%>%` means that we are taking the
output of some function and passing it as the input to (i.e., "piping" it to) another
function.

### Extracting the required fields

For this particular assignment, we were instructed to extract only the features
corresponding to the means and standard deviation of each measurement. In the zip archive
containing the original data, we are provided with the names of each feature along with
the feature's column index in the file `features.txt`. If you look in the
`clean_smartphone_data.R` file, you'll see that these features were exracted using the
function `get_required_features`. Looking at the defintion of this function in the
`data_wraningling_functions.R` file, we can see that it first loads the `features.txt`
file and performs the following three operations:

1.  Extracts only the lines where the feature names have the word "mean" or "std" in them.
2.  Removes any missing values in the resulting character vector.
3.  Removes the parentheses from the feature name.

This leaves us with a character vector whose elements are strings with the following form:

`<col_index> <feature_name>`

The remaining code simply splits each string by the space separating the column index and
feature name, builds these components into a data frame, and converts all of the column
indices to integers.

### Replacing activity codes with corresponding labels

In the original data set, the activities performed by each subject are encoded as integers
in the interval `[1, 6]`. The zip archive of the data contains a file called
`activity_labels.txt` that lists these encodings along with a string describing the
activity indicated by the code. These labels are hard coded into the function
`get_targets` which simply reads the `y_*.txt` file and replaces each numeric code with
the associated label string.

### Building training and test data frames

The `train` and `test` subdirectories of the zip archive contain the files `X_*.txt`,
`subject_*.txt` and `y_*.txt`. From the previous two sections, we now have the pieces
needed to assemble data frames for both the training and test sets. Using the feature
labels and their corresponding column indices it's easy to extract just the features that
we need from the data contained in the `X_*.txt` file and then assign appropriate names to
them. This process is carried out by the `get_design_matrix` function which does the
following after reading the data from an `X_*.txt` file:

1.  Select the required features by their column indices.
2.  Assign the name associated with a column index to that column. This is done for each
    feature in the resulting data frame.

This entire process returns a data frame representing the design matrix for either the
training or test set depending on the current loop iteration. Once this is done we simply
need to read the subject IDs from the `subject_*.txt` file and then combine them with the
design matrix and the activity labels. You can see that this is done at the end of each
iteration of the main loop.

## Variable descriptions
