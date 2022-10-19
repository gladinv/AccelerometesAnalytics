#---------------------------
# Author: "Gladin Varghese"
# Date: "2022-10-19"
# Title: run_analysis.R
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
#
# remove any variables defined in the workspace
rm(list =ls())
# import libraries
library(dplyr)
#set your working directory as described above. Mine is shown below. Yours will be different
# setwd("/home/kal/RProgramming/cleanData/motionAnalytics")
# set the paths to the test and train folders of the unzipped data package
trainPath <- file.path(getwd(),"train")
testPath <- file.path(getwd(),"test")

# read table of activity labels with their description from the provided file
activity_labels <- as_tibble(read.csv(file.path(getwd(),"activity_labels.txt"), header = FALSE))
# split data in activity labels into two columns: activity_id and activity
activity_labels <- activity_labels %>% separate(col = V1, into = c("activity_id", "activity"), sep = " ")
# change activity data type to factor and activity_id to integer
activity_labels$activity <- as.factor(activity_labels$activity)
activity_labels$activity_id <- as.integer(activity_labels$activity_id)
# read the features files and separate the data into two columns
# to get the number of the feature/variable in the first column
# and the name of the feature/variable in the second column
features <- as_tibble(read.csv(file.path(getwd(),"features.txt"), header = FALSE, sep = "\n"))
features <- separate(features,col = "V1", into = c("f_id","name"), sep = " ")
# now store all of the variable names in a character vector
featuresNames <- features$name
remove(features)
##### -----------------------------------------------------------------------
# Optional
# fixing duplicate feature names. If you check the forum discussions on this assignment
# you will realize that the variable names have a few duplicates. You could either
# ignore the duplicates when assigning the variable names as the name vector
# for the merged dataset (training and test) or you could remove the duplicate
# names by appending the missing -X , -Y, -Z to the names of the duplicates
# as shown below. I have chosen option 2
# ------------
# identify the variables that have missing info on the axis of measurement 
#fBodyAcc
fba_x <- featuresNames[303:316]
fba_y <- featuresNames[317:330]
fba_z <- featuresNames[331:344]
# fBobyAccJerk
fbj_x <-  featuresNames[382:395]
fbj_y <- featuresNames[396:409]
fbj_z <- featuresNames[410:423]
# fBobyGyro
fbg_x <- featuresNames[461:474]
fbg_y <- featuresNames[475:488]
fbg_z <- featuresNames[489:502]

# fixing the X axis set, Note that there are 14 measurement for each axis 
# and there are 3 sets of measurements = 126 measurement variables need to be fixed
featuresNames[303:316] <- paste0(fba_x,"-X")
featuresNames[382:395]<- paste0(fbj_x,"-X")
featuresNames[461:474] <- paste0(fbg_x,"-X")
# fixing the Y axis set
featuresNames[317:330] <- paste0(fba_y,"-Y")
featuresNames[396:409]<- paste0(fbj_y,"-Y")
featuresNames[475:488] <- paste0(fbg_y,"-Y")
# fixing the Z axis set
featuresNames[331:344] <- paste0(fba_z,"-Z")
featuresNames[410:423]<- paste0(fbj_z,"-Z")
featuresNames[489:502] <- paste0(fbg_z,"-Z")
# remove variables that are not needed anymore
remove(fba_x, fba_y, fba_z)
remove(fbj_x, fbj_y, fbj_z)
remove(fbg_x, fbg_y, fbg_z)

# if you want to test for no duplicates you could uncomment below line and
# check the output
# table(duplicated(featuresNames))

## ---------------------------------------------------------------------------
# read train data into tibbles
##----------------------------------------------------------------------------
subject_train <- as_tibble(read.csv(file.path(trainPath,"subject_train.txt"), header = FALSE))
X_train <-       as_tibble(read.csv(file.path(trainPath,"X_train.txt"), header = FALSE))
# read the train data for 561 variables. Note that each observation is captured
# in one field. So y_train has only one column
y_train <-       as_tibble(read.csv(file.path(trainPath,"y_train.txt"), header = FALSE))
# provide meaningful column names by renaming the default column name "V1"
subject_train <- rename(subject_train, subject = "V1")
y_train       <- rename(y_train, activity_id = "V1")
# separate the variables that are in one column in X_train into 561 columns
# and assign col names which were assigned above to featuresNames
# where separator between variable names is one or more spaces, 
# but exclude the space that starts the record / observation otherwise you will have
# a column in the beginning of each observation that is empty
X_train <- as_tibble(X_train)
# (purpose 4 - Appropriately labels the train data set with descriptive variable names)
X_train <- separate(X_train,col = "V1", into = featuresNames, sep = "[^ ] +" )
# change the columns to type numeric (from char)
X_train <- as_tibble(sapply(X_train, as.numeric))

## ---------------------------------------------------------------------------
# read test data into tibbles - same logic as for the train data
##----------------------------------------------------------------------------

subject_test <- as_tibble(read.csv(file.path(testPath,"subject_test.txt"), header = FALSE))
X_test <-       as_tibble(read.csv(file.path(testPath,"X_test.txt"), header = FALSE))
y_test <-      as_tibble(read.csv(file.path(testPath,"y_test.txt"), header = FALSE))
# rename columns
subject_test <- rename(subject_test, subject = "V1")
y_test       <- rename(y_test, activity_id = "V1")
# separate the test data into 561 features and assign col names to test data set
X_test <- as_tibble(X_test)
# (purpose 4 - Appropriately labels the test data set with descriptive variable names)
X_test <- separate(X_test,col = "V1", into = featuresNames, sep = "[^ ] +" )
X_test <- as_tibble(sapply(X_test, as.numeric))

## ----------------------------------------------------------------
##
## join the columns of the subject and activity id and the train data set
dataset1 <- as_tibble(cbind(subject_train, y_train, X_train))
# join the columns of the subject and activity id and the test data set
dataset2 <- as_tibble(cbind(subject_test, y_test, X_test))
# (purpose 1) now join the rows of the train and test datasets into one set
dataset <- rbind(dataset1, dataset2)
# (purpose 3) then add the activity description using the activity_labels table
dataset <- as_tibble(merge(activity_labels,dataset))
# remove the variables that are not required anymore
remove(dataset1, dataset2, subject_train, y_train, X_train, subject_test, y_test, X_test)
## now identify the vectors that are either mean or std ( 
#"mean()"
#"std()"
#"meanFreq()"
#gravityMean
#tBodyAccMean
#tBodyAccJerkMean
#tBodyGyroMean
#tBodyGyroJerkMean
# save the names vector of the combined dataset (train and test)
names <- colnames(dataset)
# regular expression that would match any name that has mean or Mean or std 
rexp_output <- "[Mm]ean|std"
# save the 
names <- names[grep(rexp_output,names)]
# (purpose 2 - Extracts only the measurements on the mean and standard deviation
# for each measurement). Note activity_id is removed as we have added the descriptive
# name of the activity. See comment above where purpose 3 was achieved
dataset <- dataset %>% select(subject, activity,all_of(names), -activity_id)
browser()
datasettidy <- dataset
# (purpose 5- From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity
# and each subject.
datasettidy <- datasettidy %>% group_by(subject, activity) %>% summarize_all(., mean)
# writing the tidy dataset to file
write.csv(datasettidy, "finaltidydataset.csv")
