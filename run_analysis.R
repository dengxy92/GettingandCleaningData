library(dplyr)
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
activities <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",header = FALSE)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)

#Merges the training and the test sets to create one data set.
x <- rbind(x_train,x_test)
colnames(x) <- t(features[2])
y <- rbind(y_train, y_test)
colnames(y) <- "Activity"
subject<- rbind(subject_train, subject_test)
colnames(subject) <- "Subject"
data <- cbind(subject, y, x)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
idx <- grep(".*Mean.*|.*Std.*", names(data), ignore.case=TRUE)
idx_new <- c(1,2,idx) #Add activity and subject columns
data_new <- data[,idx_new]
dim(data_new)

#Uses descriptive activity names to name the activities in the data set
data_new$Activity <- as.character(data_new$Activity)
for (i in 1:6){
  data_new$Activity[data_new$Activity == i] <- as.character(activities[i,2])
}
data_new$Activity <- as.factor(data_new$Activity)
#Appropriately labels the data set with descriptive variable names. 
names(data_new)<-gsub("Acc", "Accelerometer", names(data_new))
names(data_new)<-gsub("Gyro", "Gyroscope", names(data_new))
names(data_new)<-gsub("BodyBody", "Body", names(data_new))
names(data_new)<-gsub("Mag", "Magnitude", names(data_new))
names(data_new)<-gsub("^t", "Time", names(data_new))
names(data_new)<-gsub("^f", "Frequency", names(data_new))
names(data_new)<-gsub("tBody", "TimeBody", names(data_new))
names(data_new)<-gsub("-mean()", "Mean", names(data_new), ignore.case = TRUE)
names(data_new)<-gsub("-std()", "STD", names(data_new), ignore.case = TRUE)
names(data_new)<-gsub("-freq()", "Frequency", names(data_new), ignore.case = TRUE)
names(data_new)<-gsub("angle", "Angle", names(data_new))
names(data_new)<-gsub("gravity", "Gravity", names(data_new))
data_new$Subject <- as.factor(data_new$Subject)
data_new<- as.data.frame(data_new)

#creates a second, independent tidy data set with the average of each variable 
#for each activity and each subject.
tidydata <- aggregate(. ~Subject + Activity, data_new, mean)
tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
write.table(tidydata, file = "Tidydata.txt", row.names = FALSE)
