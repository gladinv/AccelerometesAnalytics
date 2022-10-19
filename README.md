#---------------------------
# Author: "Gladin Varghese"
# Date: "2022-10-19"
# Title: README.md
# ---
# AccelerometesAnalytics

This project provides statistical analysis of the various readings of the gyroscope and accelerometer of an attached Samsung cell phone to 
30 subjects.
# ---
# data source
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# make sure that the folder you use on your workstation to extract the zip file
# is set as your working directory in RStudio using setwd()
# ---
# Purpose:
# 1- Merges the training and the test sets of the human activity recognition 
#    using smartphones to create one data set.
# 2- Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3- Uses descriptive activity names to name the activities in the data set
# 4- Appropriately labels the data set with descriptive variable names. 
# 5- From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
# -----------------------------------------------------------------------------

Refer to README.txt for the description of the assignment and the associated
input files and description of the provided data sets

Refer to CodeBook.md for:
1-  A list of outputs with their description
2-  A description of the main flow to reach the output
3- Description of the output data frame datasettidy and output file
   finaltidydataset.csv
   
 Note that there are duplicate names in variables in the feature/variables list.
 This has been corrected and the details are in the run_analysis.R and clearly commented
 Note that the output datasettidy has 180 observations and contains 88 columns

