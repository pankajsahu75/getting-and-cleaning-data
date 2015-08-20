## Pankaj Sahu run analysis R script
library(dplyr)
library(data.table)
library(reshape2)

## read data into table variables

dirpath <- "C:/Users/pankaj/Downloads/r/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/"

featuresdf <- read.table(paste(dirpath,"features.txt",sep=""),header = FALSE)

##tot_features <- nrow(featuresdf)

activities_list <- read.table(paste(dirpath,"activity_labels.txt",sep=""),header = FALSE)

##tot_activity <- nrow(activities_list)

xtrain <- read.table(paste(dirpath,"train/X_train.txt",sep=""),header = FALSE)
ytrain <- read.table(paste(dirpath,"train/Y_train.txt",sep=""),header = FALSE)
strain <- read.table(paste(dirpath,"train/subject_train.txt",sep=""),header = FALSE)


xtest <- read.table(paste(dirpath,"test/X_test.txt",sep=""),header = FALSE)
ytest <- read.table(paste(dirpath,"test/Y_test.txt",sep=""),header = FALSE)
stest <- read.table(paste(dirpath,"test/subject_test.txt",sep=""),header = FALSE)

## 1. Merges the training and the test sets to create one data set.
trainall <- cbind(strain,ytrain,xtrain)

testall <- cbind(stest,ytest,xtest)

fulldata <- rbind(trainall, testall)
colnames(fulldata) <- c("subject","Y",as.character(featuresdf$V2))
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

mn_sd_data <- fulldata[c(1,2,grep('mean|std',colnames(fulldata)))]

##3. Uses descriptive activity names to name the activities in the data set

mn_sd_data <- merge(mn_sd_data, activities_list, by.x = "Y", by.y = "V1", all.x = TRUE)
##4. Appropriately labels the data set with descriptive variable names. 
clist <- gsub(x = colnames(mn_sd_data), pattern = "Acc", replacement = "Accelerator")
clist <- gsub(x = colnames(mn_sd_data), pattern = "V2", replacement = "Activity")
colnames(mn_sd_data) <- clist


## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
mn_sd_data <- select(mn_sd_data, -Y)

tidydf <- aggregate(. ~ Activity + subject , mn_sd_data, mean, na.rm = TRUE)

write.table(mn_sd_data, file = paste(dirpath,"tidy_data.txt"), row.names = FALSE)
            
## end of code