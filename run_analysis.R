# Getting and Cleanign Data - Course Project
# Author - Harrison Sweeney

# 0. Loads the required data from source files
test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)

# 1. Merges the training and the test sets to create one data set.
combined <- rbind.data.frame(test, train)
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)

# 4. Appropriately labels the data set with descriptive variable names.
names(combined) <- features$V2

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
combined <- combined[,grep("mean|std", names(combined))]

# 3. Uses descriptive activity names to name the activities in the data set

# Read in the label information for both test and train datasets
test_labels <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
train_labels <- read.csv("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)

# Add the label information as a new column in the combined dataset and name appropriately
combined_labels <- rbind(test_labels, train_labels)
combined <- cbind(combined, combined_labels)
names(combined)[80] <- "activity"

# Convert to a factor variable
combined$activity <- factor(combined$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.

# Read in the subject information for both test and train datasets
test_subjects <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
train_subjects <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)

# Add the subject information as a new column in the combined dataset and name appropriately
combined_subjects <- rbind(test_subjects, train_subjects)
combined <- cbind(combined, combined_subjects)
names(combined)[81] <- "subject"

# Clean up the variable names
colNames <- colnames(combined)
for (i in 1:length(colNames)) 
{
        colNames[i] = gsub("\\()","",colNames[i])
        colNames[i] = gsub("-std$","StdDev",colNames[i])
        colNames[i] = gsub("-mean","Mean",colNames[i])
        colNames[i] = gsub("^(t)","time",colNames[i])
        colNames[i] = gsub("^(f)","freq",colNames[i])
        colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
        colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
        colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};
colnames(combined) <- colNames

# Use the aggregate function to calculate means for eaach column grouped by activity and subject
groupedaverages <- aggregate(combined[,1:79], list(activity=combined$activity, subject=combined$subject), mean)
