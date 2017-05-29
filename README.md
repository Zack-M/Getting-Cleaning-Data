## Getting and Cleaning Data final course project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 
You will be graded by your peers on a series of yes/no questions related to the project. 

## Requirement & Review Criteria:
	1.	Data Set: The submitted data set is tidy.
	2.	GitHub Repo: Contains the required scripts.
	3.	Codebook.md: Includes datasets' description, variables, summaries, and analyses.
	4.	README.md: that explains the analysis files is clear and understandable.
	5.	The work submitted for this project is the work of the student who submitted it.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article: 
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### ```R Script Highlights```

### Loading reqd. packages & libraries
library(data.table)
library(dplyr)

### 0. Setting The Working Directory, 
#### prefer no spaces in variable, file & folder names.
setwd("/Users/zack-m/UCI-HAR-Dataset")

### Reading metadata files
featureNames <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt", header = FALSE)

## 1. Merging the training and the test sets 

### Reading training data
subTrain <- read.table("train/subject_train.txt", header = FALSE)
actTrain <- read.table("train/y_train.txt", header = FALSE)
featTrain <- read.table("train/X_train.txt", header = FALSE)

### Reading test data
subTest <- read.table("test/subject_test.txt", header = FALSE)
actTest <- read.table("test/y_test.txt", header = FALSE)
featTest <- read.table("test/X_test.txt", header = FALSE)

### Combining the respective data in training and test data sets

features <- rbind(featTrain, featTest)
activity <- rbind(actTrain, actTest)
subject <- rbind(subTrain, subTest)


### Naming the columns
colnames(features) <- t(featureNames[2])

### Merging data
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

## 2. Extracts only the measurements on the mean and standard deviation for
## each measurement

columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)
extractedData <- completeData[,requiredColumns]
dim(extractedData)

## 3. Uses descriptive activity names to name the activities in the data set

extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}
extractedData$Activity <- as.factor(extractedData$Activity)

## 4. Reassigning labels

names(extractedData)

### Renaming variables from labels

names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))

Similarly replace original colnames by their respective variable names viz.
"Gyroscope","Body", "Magnitude", "Time", "Frequency", "TimeBody","Mean", "STD", "Frequency", "Angle", and "Gravity." 


## 5. Creating tidy data with mean values for each activity

extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

## 6. Creating the "Tidy.txt" file
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
