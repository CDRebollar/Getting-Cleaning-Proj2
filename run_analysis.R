# Getting & Cleaning Data, Project 2 R Script

# Load packages
library(data.table)
library(dplyr)

# Load data
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = URL, destfile = "Proj2Dat.zip")
unzip(zipfile = "Proj2Dat.zip")
path <- getwd()

# Load activity labels & features
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                  , col.names = c("classLabels", "activityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))

# Creates list of indices of features wanted
iFeatures <- grep("(mean|std)\\(\\)", features$featureNames)

# Creates character vector of features containing "mean" or "std"
featuresWanted <- features[grep("(mean|std)\\(\\)", features$featureNames),] %>%
                  select(featureNames) %>% unlist

# Gets training data
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, iFeatures, with = F]
names(train) <- featuresWanted
trainAct <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                  , col.names = "Activity")
trainSubj <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                   , col.names = "SubjectNum")
train <- cbind(trainSubj, trainAct, train)

# Gets testing data
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, iFeatures, with = F]
names(test) <- featuresWanted
testAct <- fread(file.path(path, "UCI HAR Dataset/test/y_test.txt")
                 , col.names = "Activity")
testSubj <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                  , col.names = "SubjectNum")
test <- cbind(testSubj, testAct, test)

# Merges the training and test sets to create one data set
combined <- rbind(train, test)

# Adds labels to combined$Activity and turns SubjectNum to factor
combined$Activity <- factor(combined$Activity)
levels(combined$Activity) <- activityLabels$activityName
combined$SubjectNum <- as.factor(combined$SubjectNum)

# Creates a second, independent tidy data set w/ average of each variable 
# for each Activity and SubjectNum
combinedMean <- melt(combined, id = c("SubjectNum", "Activity")) %>%
  dcast(SubjectNum + Activity ~ variable, mean)

write.table(combinedMean, "tidy.txt", row.names = F, quote = F)