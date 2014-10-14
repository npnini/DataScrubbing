# 
# Project for Coursera "Getting and Cleaning Data" course 
#
# The purpose of this project is to demonstrate the ability to collect, 
# work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. 
#
# Download data
#
# The raw data comes in a zip file that has to be unloaded and unzipped.
# If a directory called "data" does not exist, it is created, raw data is downloaded and unzipped.
#
library(plyr)
if (!file.exists("./data")) {
	dir.create("./data")
	fileUrl = "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(fileUrl,destfile="./data/raw.zip", method="auto")
	unzip("./data/raw.zip",exdir="./data")
	}

# Load and merge the test and training sets

message("loading and merge x training and test data ...")

x_training <- read.table(".\\data\\UCI HAR Dataset\\train\\X_train.txt")
x_test <- read.table(".\\data\\UCI HAR Dataset\\test\\X_test.txt")
merged_x <- rbind(x_training, x_test)

message("loading and merging y training and test data ...")

y_training <- read.table(".\\data\\UCI HAR Dataset\\train\\y_train.txt")
y_test <- read.table(".\\data\\UCI HAR Dataset\\test\\y_test.txt")
merged_y <- rbind(y_training, y_test)

message("loading and merging subject training and test data ...")

subject_training <- read.table(".\\data\\UCI HAR Dataset\\train\\subject_train.txt")
subject_test <- read.table(".\\data\\UCI HAR Dataset\\test\\subject_test.txt")
merged_subject <- rbind(subject_training, subject_test)
#
# It is required to extract from the raw data only the "mean" and "std"
# features. We use the "features.txt" dataset to locate those features.
# Each row in the "features" table describes 1 feature:
# Column 1 is the feature number
# Column 2 is the feature name, containing "meam" or "std" as part of the name
# once we have the "mean" and "std" feature numbers, we can create a new "x" data frame containing
# only the required columns.

# Load the features table

features <- read.table(".\\data\\UCI HAR Dataset\\features.txt")

# Find the "-mean()" feature identifiers

mean_Ids <- sapply(features[,2], function(x) grepl("-mean()", x, fixed=T))

# Find the "-std()" features identifiers

std_Ids <- sapply(features[,2], function(x) grepl("-std()", x, fixed=T))

# Create a subset of merged_x with only the mean and std features

sub_df <- merged_x[, (mean_Ids | std_Ids)]

# Assign the feature names as the column headings

colnames(sub_df) <- features[(mean_Ids | std_Ids), 2]

# Transform numeric activity values to descriptive strings.
# To achieve that, the "activity_labels" file is loaded, followed by itterating over
# "merged_y" to replace numeric by descriptive activities

# Load the "activitiy_labels" table

activities <- read.table(".\\data\\UCI HAR Dataset\\activity_labels.txt")

# Replace activity identifier by descriptive activity

for (i in 1:nrow(merged_y)) {
	merged_y$V1 <- activities[merged_y$V1,2]
	}

# Create the target data frame, structured as follows:
# column 1 - the Subject (volunteer) whose measures were taken
# column 2 - the Activity the Subject did and that was measured
# columns 3 and on - the mean and std features

merged_df<-cbind(merged_subject,merged_y,sub_df)

# Assign self-explanatory column headings to the 2 first columns

colnames(merged_df)[1]<-"Subject"
colnames(merged_df)[2]<-"Activity"

# Create the output dataset, having the average of each feature, grouped by Subject and Activity.
# Meaning, a row per group (Subject and Activity).
# In the following ddply:
# merged_df - is the dataset containing the data, see comments above.
# .(Subject,Activity) - instructus to split and apply the function on each subset grouped by those keys
# function - colMeans is executed on all feaure columns. 
#            the feature columns are all columns except the 2 key columns

mean_subject_activity <- ddply(merged_df, .(Subject,Activity), function(x) colMeans(x[,3:ncol(merged_df)]))

# the resulting data frame is written to disk

write.csv(mean_subject_activity, ".\\data\\tidy.csv", row.names=FALSE)
