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

1.  Extracts only the lines where the feature names have exactly the word "mean" or "std"
    in them.
2.  Removes any missing values in the resulting character vector.
3.  Removes the parentheses from the feature name.


This leaves us with a character vector whose elements are strings with the following form:

`<col_index> <feature_name>`

The remaining code simply:

1.  Splits each string by the space separating the column index and feature name
2.  Builds these components into a data frame
3.  Converts all hyphens ('-') in the `feature_names` column to underscores ('_')
4.  Converts all of the column indices to integers

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

### Combining training and test sets

At this point we should have data frames for both the training and test set. The next step
is to combine them into a single data set which is done using the `bind_rows` `tidyverse`
function rather than the user-defined functions we've been using up to this point. We also
convert the `subject_id` and `activities` columns in the combined data set to factors in
preparation for future analysis.

### Summarizing the data by subject and activity

The final step is to take the mean of each measurement by subject and activity. This is
easily accomplished using the `tidyverse` `group_by` and `summarize_all` functions as can
be seen in the block of code at the end of the data wrangling section of the code before
the clean up section. In order to have the names of the columns better reflect the values
contained in them we also slightly modified the column names by adding the string `_mean`
to the ends of all of the columns containing measurement data.

## Variable descriptions

Here we briefly describe each feature in the final tidy data set. The first two features
are associated with the subjects:

- `subject_id`: a numeric code in the range `[1, 30]` representing each of the 30
  participants in this study.
- `activity`: a label describing the activity performed by a subject. Measurements were
  taken as each subject performed the following six activities:
  + Laying down
  + Sitting
  + Standing
  + Walking
  + Walking upstairs
  + Walking downstairs

The remaining features are associated with the means of each measurement taken by the
researchers. It should be noted that each of these values are themselves means taken
across each activity for each subject hence the additional `_mean` added to each feature
name. Below is a list of each of these features as well as a brief description:

Mean of the means of the raw accelerometer reading in the x-, y-, and z-axes attributable
to the motion of a subject's body

- `tBodyAcc_mean_X_mean`
- `tBodyAcc_mean_Y_mean`
- `tBodyAcc_mean_Z_mean`

Mean of the standard deviations of the raw accelerometer reading in the x-, y-, and z-axes
attributable to the motion of the subject's body

- `tBodyAcc_std_X_mean`
- `tBodyAcc_std_Y_mean`
- `tBodyAcc_std_Z_mean`

Mean of the means of the raw accelerometer reading in the x-, y-, and z-axes attributable
to the effects of gravity

- `tGravityAcc_mean_X_mean`
- `tGravityAcc_mean_Y_mean`
- `tGravityAcc_mean_Z_mean`

Mean of the standard deviations of the raw accelerometer reading in the x-, y-, and z-axes
attributable to the effects of gravity

- `tGravityAcc_std_X_mean`
- `tGravityAcc_std_Y_mean`
- `tGravityAcc_std_Z_mean`

Mean of the means of the jerk calulated from the `tBodyAcc_mean_*_mean` features

- `tBodyAccJerk_mean_X_mean`
- `tBodyAccJerk_mean_Y_mean`
- `tBodyAccJerk_mean_Z_mean`

Mean of the standard deviations of the jerk calculated from the `tBodyAcc_mean_*_mean`
features

- `tBodyAccJerk_std_X_mean`
- `tBodyAccJerk_std_Y_mean`
- `tBodyAccJerk_std_Z_mean`

Mean of the means of the raw gyroscope reading in the x-, y-, and z-axes attributable to
the motion of a subject's body

- `tBodyGyro_mean_X_mean`
- `tBodyGyro_mean_Y_mean`
- `tBodyGyro_mean_Z_mean`

Mean of the standard deviations of the raw gyroscope reading in the x-, y-, and z-axes
attributable to the motion of a subject's body

- `tBodyGyro_std_X_mean`
- `tBodyGyro_std_Y_mean`
- `tBodyGyro_std_Z_mean`

Mean of the means of the jerk calculated from the `tBodyGyro_mean_*_mean` features

- `tBodyGyroJerk_mean_X_mean`
- `tBodyGyroJerk_mean_Y_mean`
- `tBodyGyroJerk_mean_Z_mean`

Mean of the standard deviations of the jerk calculated from the `tBodyGyro_mean_*_mean`
features

- `tBodyGyroJerk_std_X_mean`
- `tBodyGyroJerk_std_Y_mean`
- `tBodyGyroJerk_std_Z_mean`

Mean and standard deviation of the means of the magnitude of the `tBodyAcc_mean_*_mean`
variables calculated as the Euclidean norm

- `tBodyAccMag_mean_mean`
- `tBodyAccMag_std_mean`

Mean and standard deviation of the means of the magnitude of the
`tGravityAcc_mean_*_mean` variables calculated as the Euclidean norm

- `tGravityAccMag_mean_mean`
- `tGravityAccMag_std_mean`

Mean and standard deviation of the means of the magnitude of the
`tBodyAccJerk_mean_*_mean` variables calculated as the Euclidean norm

- `tBodyAccJerkMag_mean_mean`
- `tBodyAccJerkMag_std_mean`

Mean and standard deviation of the means of the magnitude of the `tBodyGyro_mean_*_mean`
variables calculated as the Euclidean norm

- `tBodyGyroMag_mean_mean`
- `tBodyGyroMag_std_mean`

Mean and standard deviation of the means of the magnitude of the
`tBodyGyroJerk_mean_*_mean` variables calculated as the Euclidean norm

- `tBodyGyroJerkMag_mean_mean`
- `tBodyGyroJerkMag_std_mean`

Mean of the of means of the FFT processed accelerometer reading in the x-, y-, and z-axes
attributable to the motion of a subject's body

- `fBodyAcc_mean_X_mean`
- `fBodyAcc_mean_Y_mean`
- `fBodyAcc_mean_Z_mean`

Standard deviation of the of means of the FFT processed accelerometer reading in the x-,
y-, and z-axes attributable to the motion of a subject's body

- `fBodyAcc_std_X_mean`
- `fBodyAcc_std_Y_mean`
- `fBodyAcc_std_Z_mean`

Mean of the means of the FFT processed `tBodyAccJerk_mean_*_mean` features

- `fBodyAccJerk_mean_X_mean`
- `fBodyAccJerk_mean_Y_mean`
- `fBodyAccJerk_mean_Z_mean`

Standard deviation of the means of the FFT processed `tBodyAccJerk_mean_*_mean` features

- `fBodyAccJerk_std_X_mean`
- `fBodyAccJerk_std_Y_mean`
- `fBodyAccJerk_std_Z_mean`

Mean of the means of the FFT processed `tBodyGyro_mean_*_mean` features

- `fBodyGyro_mean_X_mean`
- `fBodyGyro_mean_Y_mean`
- `fBodyGyro_mean_Z_mean`

Standard deviation of the means of the FFT processed `tBodyGyro_mean_*_mean` features

- `fBodyGyro_std_X_mean`
- `fBodyGyro_std_Y_mean`
- `fBodyGyro_std_Z_mean`

Mean and standard deviation of the means of the FFT processed `tBodyAccMag_mean_*_mean`
features

- `fBodyAccMag_mean_mean`
- `fBodyAccMag_std_mean`

Mean and standard deviation of the means of the FFT processed `tBodyAccJerk_mean_*_mean`
features

- `fBodyBodyAccJerkMag_mean_mean`
- `fBodyBodyAccJerkMag_std_mean`

Mean and standard deviation of the means of the FFT processed `tBodyGyro_mean_*_mean`
features

- `fBodyBodyGyroMag_mean_mean`
- `fBodyBodyGyroMag_std_mean`

Mean and standard deviation of the means of the FFT processed `tBodyGyroJerk_mean_*_mean`
features

- `fBodyBodyGyroJerkMag_mean_mean`
- `fBodyBodyGyroJerkMag_std_mean`
