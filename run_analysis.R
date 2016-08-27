## Coursera course "Getting and Cleaning Data Course Project"
## script for peer-review assignment. 
## The analysis consists of 5 steps as described below: 

# make sure that the packages "dplyr" and "data.table" are installed before running this script. 

library(dplyr)
library(data.table)
source("activityName.R")  ## load the function "activityName.R". 
## This function is used to change activity labels (1, 2, ..., 6) to activity names (walking, ... laying)



## Step -1: Download the data, and unzip it: 

URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

FileName <- "assignmentData.zip"
if (!file.exists(FileName))
{
  download.file(URL,destfile = FileName, method="auto")
  unzip(FileName,overwrite=FALSE) ## unzip the data file
  
}

## step 0: load the data into R:

setwd("assignmentData/UCI HAR Dataset")  # go to the folder of the data: 

X_trainData <- tbl_df(read.table("train/X_train.txt"))
X_testData <- tbl_df(read.table("test/X_test.txt"))
Y_trainData <- tbl_df(read.table("train/y_train.txt"))
Y_testData <- tbl_df(read.table("test/y_test.txt"))
subject_train <- tbl_df(read.table("train/subject_train.txt"))
subject_test <- tbl_df(read.table("test/subject_test.txt"))
Features <- tbl_df(read.table("features.txt")) ## this is used as descriptive variable names. 

setwd("../..")  # go back to the original folder, which contains the R scripts. 


## step 1: merge the training and test data sets: 
X_Data <- rbind(X_trainData,X_testData)
Y_Data <- rbind(Y_trainData,Y_testData)
subject <- rbind(subject_train,subject_test)

rm(X_trainData,X_testData,Y_trainData,Y_testData,subject_test,subject_train) # remove redundant variables. 


## step 2: Use descriptive variable names: (this is step 4 in the instruction)
FeatureNames <- as.character(Features[[2]])  # convert to a character vector. 

## Remove the characters "()" in the feature names: 
FeatureNames <- gsub("\\(","",FeatureNames) ## remove the "(" character
FeatureNames <- gsub("\\)","",FeatureNames) ## remove ")"

# make valid column names: 
FeatureNames <- make.names(FeatureNames,unique=TRUE)  

## rename the variables of the data: 
setnames(X_Data,old=names(X_Data),new = FeatureNames) 


## Step 3: Extracts only the measurements on the mean and standard deviation for each measurement: 

X_Data <- select(X_Data,matches(".mean|.std",ignore.case = FALSE))  ## note that the columns with names "meanFreq", "gravityMean" are not taken
X_Data <- select(X_Data,-matches("meanFreq"))  ## remove the columns  whose names contain "meanFreq". These are not the mean values of measurements. 


## Step 4: Uses descriptive activity names to name the activities in the data set
activityNames <- activityName(Y_Data)  # the activity labels are given in the file "Y_Data". Function "activityName" converts the labels to the corresponding names.

## add the activity names and subject ID columns to the left of the data set: 
X_Data <- cbind(subject, activityNames, X_Data)
X_Data <- rename(X_Data,subject=V1)  # rename the first variable to "subject", the people ID from 1 - 30. 



## Step 5: From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.


X_Data <- data.table(X_Data) ## convert to data.table (I use functions in package data.table to find the mean)
TidyData <- X_Data[, lapply(.SD,mean), by=list(`subject`, `activityNames`)] # calculate the mean of each variable for each subject and each activity
setkey(TidyData,`subject`)  # sort the data in ascending order of subject. 


# write the tidy data to a file, use commas "," to separate the columns
write.table(TidyData, file = "TidyData.txt", sep = ",", row.names=FALSE)

## you can load this data file into R by the following command: 
# data <- read.table("TidyData.txt",sep = ",")



## Write the variable names to a file to make a codebook (used only once)
#VarNames <- names(Data3)

#fileConn<-file("codeBook.md")
#writeLines(VarNames, fileConn)
#close(fileConn)




