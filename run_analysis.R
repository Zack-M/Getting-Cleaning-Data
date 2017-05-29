## Load the requisite libraries
library(data.table)
library(dplyr)

# Alter the folder name, I dont prefer spaces in names.
setwd("/Users/zack-m/UCI-HAR-Dataset")

# Reading metadata files
featureNames <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt", header = FALSE)

# 1. Merging the training and the test sets 

# Reading training data
subTrain <- read.table("train/subject_train.txt", header = FALSE)
actTrain <- read.table("train/y_train.txt", header = FALSE)
featTrain <- read.table("train/X_train.txt", header = FALSE)

# Reading test data
subTest <- read.table("test/subject_test.txt", header = FALSE)
actTest <- read.table("test/y_test.txt", header = FALSE)
featTest <- read.table("test/X_test.txt", header = FALSE)

# Combining the respective data in training and test data sets

features <- rbind(featTrain, featTest)
activity <- rbind(actTrain, actTest)
subject <- rbind(subTrain, subTest)


# Naming the columns
colnames(features) <- t(featureNames[2])

# Merging data
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

# 2. Extracts only the measurements on the mean and standard deviation for
# each measurement

columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)
extractedData <- completeData[,requiredColumns]
dim(extractedData)

# 3. Uses descriptive activity names to name the activities in the data set

extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}
extractedData$Activity <- as.factor(extractedData$Activity)

# 4. Reassigning labels

names(extractedData)

# Renaming variables from labels

names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))

names(extractedData)

# 5. Creating tidy data with mean values for each activity

extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

# 6. Creating the "Tidy.txt" file
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)