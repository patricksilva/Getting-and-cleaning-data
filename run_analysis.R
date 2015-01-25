## This script is designed to do:
## 1).. Merge the training and the test sets
## 2).. Extract measurements on the mean and standard deviation for each measurement
## 3).. Name the activities in the data set
## 4).. Label the data set with those names, and
## 5).. Create another tidy data set with the average of each variable for each activity and each subject

## The data files are located in ./rdata/UCI HAR Dataset/ and sub folders


## 1).. Merge data sets
dataMerge <- function(directory) {
     path <- paste("./", directory, "/test/X_test.txt", sep="")
     test_data <- read.table(path)
     path <- paste("./", directory, "/train/X_train.txt", sep="")
     train_data <- read.table(path)
     
     ## Grab labels from file
     path <- paste("./", directory, "/activity_labels.txt", sep="")
     activity_labels <- read.table(path)
     
     ## Grab the test and training subject labels from file
     path <- paste("./", directory, "/train/subject_train.txt", sep="")
     subject_train <- read.table(path)
     path <- paste("./", directory, "/test/subject_test.txt", sep="")
     subject_test <- read.table(path)
     
     ## Grab the test and training "y" labels
     path <- paste("./", directory, "/train/y_train.txt", sep="")
     y_train <- read.table(path)
     path <- paste("./", directory, "/test/y_test.txt", sep="")
     y_test <- read.table(path)
     
     ## Combine all labels
     y_train_labels <- merge(y_train,activity_labels,by="V1")
     y_test_labels <- merge(y_test,activity_labels,by="V1")
     
     ## Merge the training set and the test set with the labels
     train_data <- cbind(subject_train,y_train_labels,train_data)
     test_data <- cbind(subject_test,y_test_labels,test_data)
     
     ## Merge the data sets together
     all_data <- rbind(train_data,test_data)
     
     return (all_data)
}


## 2).. Extract means and std dev'ns
extractMeanStd <- function(data_set, directory) {
     path <- paste("./", directory, "/features.txt", sep="")
     features_data <- read.table(path)
     ## Create subset consisting only of rows containing the words mean and std
     mean_std_rows <- subset(features_data,  grepl("(mean\\(\\)|std\\(\\))", features_data$V2) )
     
     ## set column headers
     colnames(data_set) <- c("Subject","Activity_Id","Activity",as.vector(features_data[,2]))
     
     ## extract data from the merged set where the column names are mean or std
     mean_columns <- grep("mean()", colnames(data_set), fixed=TRUE)
     std_columns <- grep("std()", colnames(data_set), fixed=TRUE)
     
     ## create a vector for mean and std columns than sort
     mean_std_column_vector <- c(mean_columns, std_columns)
     mean_std_column_vector <- sort(mean_std_column_vector)
     
     ## extract columns with std and mean in their column headers
     extracted_data_set <- data_set[,c(1,2,3,mean_std_column_vector)]
     return (extracted_data_set)
}


## 3).. Name the activities in the data set
## 4).. Label the data set with those names, and
## 5).. Create another tidy data set with the average of each variable for each activity and each subject
rewriteTidyData_set <- function(data_set, path_to_tidyset_file) {
     ## reshape the set
     require(reshape2)
     melted_data <- melt(data_set, id=c("Subject","Activity_Id","Activity"))
     
     ## put it into tidy_data format
     tidy_data <- dcast(melted_data, formula = Subject + Activity_Id + Activity ~ variable, mean)
     
     ## format and insert column headers
     col_names_vector <- colnames(tidy_data)
     col_names_vector <- gsub("-mean()","Mean",col_names_vector,fixed=TRUE)
     col_names_vector <- gsub("-std()","Std",col_names_vector,fixed=TRUE)
     col_names_vector <- gsub("BodyBody","Body",col_names_vector,fixed=TRUE)
     colnames(tidy_data) <- col_names_vector
     
     ## output to file
     write.table(tidy_data, file=path_to_tidyset_file, sep="\t", row.names=FALSE)
}

merged_data <- dataMerge("UCI HAR Dataset")
extracted_mean_std_data_set <- extractMeanStd(merged_data, "UCI HAR Dataset")
rewriteTidyData_set(extracted_mean_std_data_set, "./tidyset.txt")
