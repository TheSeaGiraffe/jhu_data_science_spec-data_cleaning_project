#
#   clean_smartphone_data.R - a script to load and wrangle the data for this
#   project with the goal of creating a tidy data set.
#

# Load the required packages
cat('Loading libraries...\n')
r_libs <- c('tidyverse', 'magrittr', 'zeallot')
suppressMessages(sapply(r_libs, library, character.only = T))

# Source the functions defined for this task
source('data_wrangling_functions.R')

#######################
# Data wrangling prep #
#######################

# Get path to necessary files
data_dir <- 'data'
train_test_data <- file.path(data_dir, c('train', 'test'))

#########################
# Load and wrangle data #
#########################

# Get features along with corresponding column index
req_features <- get_required_features(file.path(data_dir, 'features.txt'))

# Get training and test data
#---------------------------

loaded_data <- list()
for (i in seq_along(train_test_data)) {
    curr_data_file <- train_test_data[i]
    curr_data <- curr_data_file %>% str_extract('(?<=/).*$')
    cat('Getting', curr_data, 'data...\n')

    # Get paths to all the necessary files
    c(subject_file, x_file, y_file) %<-%
        list.files(curr_data_file, full.names = T, pattern = '.txt$')

    # Get subject IDs, design matrix and targets
    subject_ids <- get_sub_ids(subject_file)
    targets <- get_targets(y_file)
    design_matrix <- get_design_matrix(x_file, req_features)

    # Combine all of the data into a single data frame and load it into
    # loaded_data
    loaded_data[[i]] <- bind_cols(subject_ids, design_matrix, targets)
}

cat('Tidying data...\n')

# Combine the training and test data into a single data frame
smartphone_data <- bind_rows(loaded_data)

# Convert 'subject_id' and 'activity' columns to factors
smartphone_data %<>% mutate(subject_id = as.factor(subject_id),
                            activity = as.factor(activity))

# Create final tidy data set by taking the mean of all variables for each
# activity and each subject and then renaming the columns to more accurately
# reflect the values contained within them.
smartphone_data %<>% group_by(subject_id, activity) %>% summarize_all(mean)
new_col_names <- smartphone_data %>% names() %>%
    map_chr(str_replace, pattern = '(?<=(mean|std|[XYZ])$)',
            replace = '_mean')
smartphone_data %<>% set_names(new_col_names)

############
# Clean up #
############

cat('Cleaning up...\n')

# Variables from this script
rm(loaded_data, subject_ids, targets, design_matrix, req_features, data_dir,
   train_test_data, subject_file, x_file, y_file, i, new_col_names, curr_data,
   curr_data_file, r_libs)

# Functions loaded from the 'data_loading_functions.R' file
rm(get_targets, get_sub_ids, get_required_features, get_design_matrix)

cat('Done!\n')
