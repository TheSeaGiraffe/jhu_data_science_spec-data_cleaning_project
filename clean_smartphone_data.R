#
#   clean_smartphone_data.R - a script to test the code for loading in the data
#   for this project.
#

# Load the required packages
library(tidyverse)
library(magrittr)
library(zeallot)

# Source the functions defined for this task
source('tmp_data_cleaning_scripts/data_loading_functions.R')

#######################
# Data wrangling prep #
#######################

# Get path to necessary files
data_dir <- 'data'
train_test_data <- file.path(data_dir, c('train', 'test'))

#########################
# Load and wrangle data #
#########################

# Get features
req_features <- get_required_features(file.path(data_dir, 'features.txt'))

# Get training and test data
#---------------------------

loaded_data <- list()
for (i in seq_along(train_test_data)) {
    # Get paths to all the necessary files
    c(subject_file, x_file, y_file) %<-%
        list.files(train_test_data[i], full.names = T, pattern = '.txt$')

    # Get subject IDs, design matrix and targets
    subject_ids <- get_sub_ids(subject_file)
    targets <- get_targets(y_file)
    design_matrix <- get_design_matrix(x_file, req_features)

    # Combine all of the data into a single data frame and load it into
    # loaded_data
    loaded_data[[i]] <- bind_cols(subject_ids, design_matrix, targets)
}

# Combine the training and test data into a single data frame
smartphone_data <- bind_rows(loaded_data)

############
# Clean up #
############

# Variables from this script
rm(loaded_data, subject_ids, targets, design_matrix, req_features, data_dir,
   train_test_data, subject_file, x_file, y_file, i)

# Functions loaded from the 'data_loading_functions.R' file
rm(get_targets, get_sub_ids, get_required_features, get_design_matrix)
