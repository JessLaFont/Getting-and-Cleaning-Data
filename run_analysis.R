#Getting and Cleaning Data Course Project 

#The purpose of this project is to demonstrate your ability to 
#collect, work with, and clean a data set. The goal is to prepare tidy 
#data that can be used for later analysis. You will be required to submit:
##1. a tidy data set as described below
##2. a link to a github repository with your script for performing the analysis
##3. a codebook that describes the variables, the data, and any transformations
##   or work you did to clean up the data called CodeBook.md
##4. README.md that explains how all of the scripts work and how they are
##   connected

#You should create one R script called run_analysis.R that does the following:
##1. Merges the training and test data sets to create one data set
##2. Extracts only the measurements on the mean and standard deviation for each 
##   measurement.
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names
##5. From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject.

#Preliminary tasks 

##Set Working Directory
setwd("~/Desktop/GCD")

##Downloading and Reading Data
install.packages("downloader")
library(downloader)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url, "./dataset.zip", mode = "wb")
unzip("dataset.zip")
unlink(url)

##Archive and Save unprocessed files as "UCI HAR Dataset"

##Create variable to reference location 
pathIn <- file.path("UCI HAR Dataset")
list.files(pathIn, recursive = TRUE)

##Load data.table library
library(data.table)

##Read in Subject Data
SubjectTrain <- fread(file.path(pathIn, "train", "subject_train.txt"))
SubjectTest  <- fread(file.path(pathIn, "test" , "subject_test.txt" ))

##Read in Activity & Features Data
ActivityTrain <- fread(file.path(pathIn, "train", "y_train.txt"))
ActivityTest  <- fread(file.path(pathIn, "test" , "y_test.txt" ))
ActivityNames <- fread(file.path(pathIn, "activity_labels.txt"))
Features <- fread(file.path(pathIn, "features.txt"))

##Read in Data Files
dtTrain <- fread(file.path(pathIn, "train", "X_train.txt"))
dtTest <- fread(file.path(pathIn, "test", "X_test.txt"))

##Assign column names to data imported above
colnames(SubjectTrain) = "SubjectId"
colnames(ActivityNames) = c("ActivityId", "ActivityType")
colnames(dtTrain) = Features$V2
colnames(ActivityTrain) = "ActivityId"
colnames(SubjectTest) = "SubjectId"
colnames(dtTest) = Features$V2
colnames(ActivityTest) = "ActivityId"
colnames(Features) = c("FeatureNumber", "FeatureName")
 
#Part 1: Merging Data sets

##Merge Training Data
TrainingData <- cbind(SubjectTrain, ActivityTrain, dtTrain)

##Merge Testing Data
TestData <- cbind(SubjectTest, ActivityTest, dtTest)

##Merge Training and Testing Data
MergedData <- rbind(TrainingData, TestData)

##Set Key
setkey(MergedData, SubjectId, ActivityId)

#Part 2: Extracting Mean and Standard Deviation Measures

##Define desired features
Features <- Features[grepl("mean", FeatureName) | grepl("std", FeatureName)]
colNames <- Features$FeatureName

##Subset MergedData using Features 
select <- c(key(MergedData), colNames)
MergedData <- MergedData[,select, with = FALSE]

#Part 3: Use descriptive activity names to label activities in the data set

##Merge ActivityNames with MergedData to name activities in the data set
MergedData <- merge(MergedData, ActivityNames, by="ActivityId", all.x = TRUE)

##Update colNames vector to include the new column names after merge
colNames <- colnames(MergedData)

#Part 4: Appropriately label the data set with descriptive activity names.

##Clean up variable names
for (i in 1:length(colNames)) {
        colNames[i] = gsub("\\()", "", colNames[i])
        colNames[i] = gsub("-std$", "SD", colNames[i])
        colNames[i] = gsub("-mean", "Mean", colNames[i])
        colNames[i] = gsub("^t", "Time", colNames [i])
        colNames[i] = gsub("^f", "Freq", colNames[i])
        colNames[i] = gsub(("[Gg]ravity"), "Gravity", colNames[i])
        colNames[i] = gsub(("[Bb]ody"), "Body", colNames[i])
        colNames[i] = gsub(("[Gg]yro"), "Gyro", colNames[i])
        colNames[i] = gsub("AccMag", "AccMagnitude", colNames[i])
        colNames[i] = gsub(("[Bb]odyaccjerkmag"), "BodyAccJerkMagnitude", colNames[i])
        colNames[i] = gsub("JerkMag", "JerkMagnitude", colNames[i])
        colNames[i] = gsub("GyroMag", "GyroMagnitude", colNames [i])
        }

##Reassign new descriptive column names to MergedData data set.
colnames(MergedData) = colNames

#Part 5: Create an independent data set with the average for each variable for each activity and subject.

##Remove ActivityType variable from MergedData.
MergedData$ActivityType <- NULL

##Summarize the MergedData table to include only the mean of each variable for each 
##activity and each subject.
TidyData <- aggregate(MergedData, by=list(ActivityId = MergedData$ActivityId, SubjectId = MergedData$SubjectId), FUN = mean)

##Remove duplicate columns.
TidyData <- TidyData[,!duplicated(colnames(TidyData))]

##Merging TidyData with ActivityNames to include descriptive activity labels.
TidyData <- merge(TidyData, ActivityNames, by= "ActivityId", all.x = TRUE)

##Set key to maintain data integrity
TidyData <- as.data.table(TidyData)
setkey(TidyData, SubjectId, ActivityId, ActivityType)

##Export the TidyData data set
write.table(TidyData, "./TidyData.txt", row.names = FALSE, sep = "\t")
