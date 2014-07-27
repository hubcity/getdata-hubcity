getdata-hubcity
===============

This files in this project complete the Getting and Cleaning Data Course Project by working with the UCI HAR dataset.

The assignment was as follows:
```
You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```

Files
-----
- README.md - On overview of this project.
- CodeBook.md - A brief description of the fields in the resulting tidy dataset.
- run_analysis.R - The R file that creates the tidy dataset.

Prerequisites
-------------
- R - The R software version 3.0.2 or newer.
- reshape2 - The reshape2 package installed in R.  
  (Can be installed with the R command `install.packages("reshape2")`)
- plyr - The plyr package installed in R.  
  (Can be installed with the R command `install.packages("plyr")`)
- The original zip file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip should be in your R working directory and be named `getdata-projectfiles-UCI HAR Dataset.zip`.

Description
-----------
To run the code open the file `run_analysis.R` in R (or RStudio) and run the file.

The code implements the goals of the assignment as listed above.  

A brief summary of what is accomplished:

- Downloads and unzips the datafile if not present in the working directory
- Reads the columns names from features.txt and finds the ones related to mean and standard deviation.  I did this by searching for "-mean()" or "-std()" in the column name.
- Reads the activities from activity_labels.txt
- Cleans up the training data by
 * Reading the subjects, y, and X files and attaching descriptive column names to each dataframe
 * Replacing the values read from the y file with the actual activity names
 * Keeping only the mean and standard deviation fields from X (as calculated earlier)
 * Concatenating the subject, y, and X dataframes
- Cleans the test data in the same way that the training data was cleaned
- Concatenates the clean test and clean training data into one dataset
- Computes the averages based on Subject and Activity
- Writes out a tidy CSV file

The resulting dataset will be written to your working directory as a CSV file named `UCI_HAR_tidy.csv`.  Please see CodeBook.md for a listing of the fields.
