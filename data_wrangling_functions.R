#
#   data_wrangling_functions.R - a script containing the functions used to load
#   and wrangle the data for this project.
#

# Get target (i.e., 'y') values and assign descriptive labels to the
# corresponding activity code. Returns a data frame of activity labels.
get_targets <- function(fpath) {
    read_lines(fpath) %>%
        enframe(name = NULL, value = 'activity_code') %>%
        mutate(activity =
               case_when(activity_code == '1' ~ 'walking',
                         activity_code == '2' ~ 'walking upstairs',
                         activity_code == '3' ~ 'walking downstairs',
                         activity_code == '4' ~ 'sitting',
                         activity_code == '5' ~ 'standing',
                         activity_code == '6' ~ 'laying')) %>%
        select(activity)
}

# Get subject IDs. Returns a data frame.
get_sub_ids <- function(fpath) {
    read_lines(fpath) %>% enframe(name = NULL, value = 'subject_id')
}

# Get all of the features corresponding to the means and standard deviation of
# the quantities of interest. Returns a data frame containing the feature name
# and its corresponding index.
get_required_features <- function(fpath) {
    feature_names_req <- read_lines(fpath) %>%
        map_chr(~ str_match(.x, pattern = '(.*(?:mean|std))\\(\\)(.*)') %>%
                            .[2:3] %>% paste(collapse = '')) %>%
        grep(pattern = 'NA', value = T, invert = T) %>%
        map_df(~ str_split(.x, pattern = ' ', simplify = T) %>% as.list() %>%
               set_names(c('index', 'feature_name'))) %>%
        mutate(feature_name = str_replace_all(feature_name, '-', '_'))
    feature_names_req$index %<>% as.integer()

    feature_names_req
}

# Get design matrix by first loading it from the specified file and then
# extracting only the necessary features with appropriately named columns.
# Returns a data frame.
get_design_matrix <- function(fpath, features) {
    read_delim(fpath, delim = ' ', col_names = F,
               col_types = cols(.default = 'n')) %>%
    select(features$index) %>%
    set_names(features$feature_name)
}
