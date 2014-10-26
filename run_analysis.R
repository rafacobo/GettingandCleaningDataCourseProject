# COURSE PROJECT GETTING AND CLEANING DATA

# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Download and unzip
# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileUrl, destfile = "Dataset.zip", method = "curl")
# unzip("Dataset.zip")
# setwd(Containing UCI HAR Dataset) 

# Reading raindata and testdata
DataTrain                <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
ActivityTrain            <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
SubjectTrain             <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
DataTest                 <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
ActivityTest             <- read.table("./UCI HAR Dataset/test/y_test.txt", header= FALSE)
SubjectTest              <- read.table("./UCI HAR Dataset/test/subject_test.txt", header= FALSE)

# Uses descriptive activity names to name the activities in the data set (3).
ActivitiesLabels         <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, colClasses = "character")
ActivityTrain$V1         <- factor(ActivityTrain$V1, levels = ActivitiesLabels$V1, labels = ActivitiesLabels$V2)
ActivityTest$V1          <- factor(ActivityTest$V1, levels = ActivitiesLabels$V1, labels = ActivitiesLabels$V2)
colnames(ActivityTrain)  <- "Activity" 
colnames(ActivityTest)   <- "Activity"

# Appropriately labels the data set with descriptive variable names (4).
Features                 <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, colClasses = "character")
colnames(DataTrain)      <- Features$V2
colnames(DataTest)       <- Features$V2
colnames(SubjectTrain)   <- "Subject" 
colnames(SubjectTest)    <- "Subject"

# Merges the training and the test sets to create one data set (1).
AllData                  <- rbind(cbind(DataTrain, SubjectTrain, ActivityTrain), cbind(DataTest, SubjectTest, ActivityTest))

# Extracts only the measurements on the mean and standard deviation for each measurement (2). 
AllDataMean              <- sapply(AllData[, 1:561], mean, na.rm=TRUE) # We do not calculate on character columns
AllDataSd                <- sapply(AllData[, 1:561], sd, na.rm=TRUE)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject (5).
library(reshape2)
MeltData                 <- melt(AllData, id.vars = c("Activity", "Subject"))
TidyData                 <- dcast(MeltData, Activity + Subject ~ variable, mean)
write.table(TidyData, "TidyDataSet.txt")



