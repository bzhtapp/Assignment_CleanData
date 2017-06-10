
# Need to set your directory to "UCI HAR Dataset"
# setwd("E:/R3/UCI HAR Dataset")

library(data.table)
library(dplyr)

### Load data

activitylabels <- read.table("activity_labels.txt") %>% tbl_df %>% rename(activityid=V1, activity=V2)
features <- read.table("features.txt") %>% tbl_df

# Feature column name index beyound 316 starts to have duplicates after row 316
trainset <- read.table("train/X_train.txt") %>% tbl_df
trainset <-  setnames(trainset, names(trainset), as.character(features$V2) )
trainlabel <- read.table("train/Y_train.txt") %>% tbl_df %>% rename(activityid = V1)
subjecttrain <- read.table("train/subject_train.txt") %>% tbl_df %>% rename(subject = V1)
train <- cbind(subjecttrain, trainlabel)  %>% cbind(trainset)

testset <- read.table("test/X_test.txt") %>% tbl_df
testset <-  setnames(testset, names(testset), as.character(features$V2) )
testlabel <- read.table("test/y_test.txt") %>% tbl_df %>% rename(activityid = V1)
subjecttest <- read.table("test/subject_test.txt") %>% tbl_df %>% rename(subject = V1)
test <- cbind(subjecttest, testlabel)  %>% cbind(testset)

### 1. Merges the training and the test sets to create one data set.

all <- rbind(train, test)


### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

meanandstd <- grep("mean|std", names(all))

allmeanstd <- all[, c(1:2, meanandstd)]

### 3. Uses descriptive activity names to name the activities in the data set

allmeanstd <- merge(allmeanstd, activitylabels)

### 4. Appropriately labels the data set with descriptive variable names.

# This was done at beginning during load process

### 5. From the data set in step 4, creates a second, independent tidy data set 
### with the average of each variable for each activity and each subject.

allmean <- aggregate(allmeanstd [, 3:81], by=list(allmeanstd$activity, allmeanstd$subject),FUN=mean) %>%
  rename( activity=Group.1, subject=Group.2)

write.table(allmean, "result.txt", row.name=FALSE)
