# Download the data set
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip", method = "curl")

# Unzip data sets
unzip("Dataset.zip")

#
# (1)
# Merges the training and the test sets to create one data set.
#

# load test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# load training data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# merge data
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)


#
# (2)
# Extracts only the measurements on the mean and standard deviation for each 
# measurement. 
#

# get the feature description
features <- read.table("UCI HAR Dataset/features.txt")
# search for those features that contain mean or std
mean_std_subset <- grep("-(mean|std)\\(\\)", features[, 2])
# create a subset for the features and store it into x
x <- x[, mean_std_subset]
# assign feature names to column headers
names(x) <- features[mean_std_subset, 2]


#
# (3)
# Uses descriptive activity names to name the activities in the data set.
#

# load the activity names
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# map the values in y to the activity names
y_vals <- y[, 1]
map_to_activity <- activities[y_vals, 2]
y[, 1] <- map_to_activity


#
# (4)
# Appropriately labels the data set with descriptive variable names.
#

# rename the activity column
names(y) <- "activity"

# rename the subject column
names(subject) <- "subject"

# merge everything into one data set
smartphone <- cbind(x, y, subject)

# 
# (5)
# From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
#

# load dplyr
library(dplyr)

# create a dplyr table for smartphones
activity_means <- tbl_df(smartphone)

# create the means
activity_means <- aggregate(activity_means, by = list(activity_means$subject, activity_means$activity), FUN = mean)

# correct column titles
activity_means <- activity_means[, 1:68]
names(activity_means) <- c("subject", "activity", names(activity_means)[3:68])

# write to csv
write.csv(activity_means, "tidy_activity_means.csv")