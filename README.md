# Getting-and-Cleaning-Data
Course Project for Coursera/JHU Getting and Cleaning Data Course

##Project Parameters
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit:

1. a tidy data set as described below
2. a link to a github repository with your script for performing the analysis
3. a codebook that describes the variables, the data, and any transformations or work you did to clean up the data called CodeBook.md
4. README.md that explains how all of the scripts work and how they are connected

You should create one R script called run_analysis.R that does the following:

1. Merges the training and test data sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. From the data set in step 4, creates a second, independent tidy data set 
with the average of each variable for each activity and each subject.

The data linked to the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description of the data are available in the UCI HAR Dataset, or can be accessed here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data for the project are likewise stored in the UCI HAR Dataset, and can also be sourced from : 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##Repo Contents
This repo contains the following files:

* README.md - Congratulations, you're here!
* run_analysis.R - the complete annotated script for reproducing this project
* CodeBook.md - a description of the final data set (TidyData.txt), including variable descriptions and details of anayses/trandformations performed
* TidyData.txt - the resulting data set produced by the script
* UCI HAR Dataset - Unprocessed files data sourced from the above website

For the purposes of this anaysis, neither of the UCI HAR Dataset Inertial Signals Folders were utilized. For more information regarding the unprocessed data set, please see the README.txt document located in the UCI HAR Dataset Folder.


##Modifying the Script
Once you have opened the R script run_analysis.R, you will need to modify your working directory (change the setwd() command on line 25 to match your desired working directory) and the pathIn variable (line 39), which functions as a reference marker for locating files. 

##Output
*Tidy Data Set

