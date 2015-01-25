# Getting-and-cleaning-data

##Description
run_analysis.R is a script that is designed to:
1).. Merge the training and the test sets
2).. Extract measurements on the mean and standard deviation for each measurement
3).. Name the activities in the data set
4).. Label the data set with those names, and
5).. Create another tidy data set with the average of each variable for each activity and each subject

Functions are written to handle the various requirements listed above:
- dataMerge handles the the 1st, 3rd, and 4th
- extractMeanStd handles the 2nd, 3rd, and 4th
- rewriteTidyData_set handles the 5th requirement and write out the tidy set file

##dataMerge

Purpose: to merge all the data from the various text files into a single giant data table. No subset or extractions performed on the data set once merged.

Parameters: directory: a character vector that indicates the folder residing inside the working directory

Value: all_data: a merged data table containing training and test data and 3 additional columns for subject, activity, and activity id. This amounts to 10299 observations of 564 variables

##extractMeanStd

Purpose: Performs subset on the giant data set of merged data to extract just the mean and std related data

Parameters: data_set: a data table containing the training set and test set data and 3 additional columns for subject, activity, and activity id directory: a character vector that indicates the folder residing inside the working directory

Value: extracted_data_set: after performing subset on the data_set parameter, this is a data table that contains just 10299 observations of 69 variables basically the same 3 additional columns of subject, activity, and activity id plus the 66 columns whose headers contain the characters mean() and std()

##rewriteTidyData_set

Purpose: Performs melt data, casting back to tidy data format, and then writing the data out to a text file

Parameters: extracted_mean_std_data_set: a data table containing the training set and test set data and 3 additional columns for subject, activity, and activity id but has already extracted out the mean and std columns path_to_tidyset_file: a character vector that indicates the path to write the tidy set file to

Value: n/a

##read_tidy_set

Purpose: Reads the tidy set file back into data table

Parameters: path_to_tidyset_file: a character vector that indicates the path to the tidy set file

Value: datatable of data inside the tidy set file

##Bugs & issues
Table too big to display correctly in .txt format.
Displays correctly in Excel.
Displays correctly in Open Office Sheets.
