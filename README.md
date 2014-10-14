DataScrubbing
=============

Holds the Coursera Getting and Cleaning Data course project.

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 
 
The 'run_analysis.R' script should be executed after setting the working directory to a directory of your choice,
where data will be created by the script.

Required packages
----------------------
The script uses  the package 'plyr'.

Download raw data
----------------------
The raw data is downloaded and unzipped to a sub directory called 'data' under your current working directory.
if the 'data' sub directory already exists, it is assumed it already contains the downloaded and unzipped raw data.

Feature loading and merging
-----------------------------------
The training and test measure files and loaded and merged to a single table

Activity loading and merging
--------------------------------
The training and test activity files and loaded and merged to a single table

Subject loading and merging
---------------------------------
The training and test subject files and loaded and merged to a single table

Subsetting the feature set
----------------------------------------------
The output data set is required to contain only the 'mean' and 'std' features.
Therefore:
- The 'features' table is loaded, containing the features identifiers and names.
- The script locates the 'mean' and 'std' feature identifiers (column numbers) from the 'features' table.
- A subset data frame of the entire feature set is created, containing only the columns representing 'mean' and 'std' features
- The selected 'mean' and 'std' feature names as=re assigned as column heading to the subset data frame


Setting descriptive Activities
--------------------------------
The output data set is required to contain descriptive instead of numeric activitiy identifiers.
Therefore:
- The 'activity_labels' table is loaded
- The numeric Activity identifiries are replaced with descriptive strings located by activity identifier in the 'activity_labels' table


Creating the consolidated data frame
------------------------------------------
The target data frame is created by binding the columns of the 3 different tables, as follows:
- Column 1 - the Subject (volunteer) whose measures were taken
- Column 2 - the Activity the Subject did and that was measured
- Columns 3 and on - the mean and std features
- Self-explanatory ('Subject' and 'Activity') column headings are set t the 2 first columns

Creating the output data set
--------------------------------
The output data set is required to have the mean for each feature, to be calculated per group, where a group is designated for each combination of Subject and Activity.
This is achieved by using 'ddply' function, see explanation on how it is used within the script.
The resulting data frame is written to disk as a csv file.

