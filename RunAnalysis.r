## 1. Merges the training and the test sets to create one data set.

##setting working directory
setwd("D:/01 Programming/02 R/01 Johns Hopkings-Coursera/03 Getting and Cleaning Data/05 Project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

##reading the training and test data
trainx <- read.table("train/X_train.txt")
testx <- read.table("test/X_test.txt")

trainy <- read.table("train/y_train.txt")
testy <- read.table("test/y_test.txt")

train_subject <- read.table("train/subject_train.txt")
test_subject <- read.table("test/subject_test.txt")

##merging sets
x <- rbind(trainx,testx)
y <- rbind(trainy,testy)
subject <- rbind(train_subject,test_subject)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")

flag_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

x <- x[, flag_features]

names(x) <- features[flag_features, 2]

names(x) <- gsub("\\(|\\)", "", names(x))

names(x) <- tolower(names(x))

## 3. Uses descriptive activity names to name the activities in the data set

activity <- read.table("activity_labels.txt")
activity[,2] <- gsub("_","",tolower(as.character(activity[,2])))
y[,1] <- activity[y[,1],2]
names(y) <- "activity"

## 4. Appropriately labels the data set with descriptive variable names.

names(subject) <- "subject"
clean_data <- cbind(subject,y,x)
write.table(clean_data,"merge_data_tidy.txt") ## creates a file in the current directory

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
unique_subjects <- unique(subject)[,1]
num_subjects <- length(unique(subject)[,1])
num_activities <- length(activity[,1])
num_columns <- dim(clean_data)[2]
results <- clean_data[1:(num_activities*num_subjects),]

for (i in 1:num_subjects){
  
  for (a in 1:num_activities){
    
    results[row, 1] <- unique_subjects[i]
    
    results[row, 2] <- activity[a, 2]
    
    temp <- clean_data[clean_data$subject == i & clean_data$activity == activity[a, 2], ]
    
    results[row, 3:num_columns] <- colMeans(temp[, 3:num_columns])
    
    row <- row + 1
    
  }
  
}

write.table(results,"data_average.txt")