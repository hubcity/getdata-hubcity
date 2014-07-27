# load necessary libraries
library(plyr)
library(reshape2)


# This function will be called later, once for "train" and once for "test"
clean_dir <- function(dir, subdir, activity, feature_names, feature_keep) {
  # read subjects
  subject_file <- paste(dir, subdir, "/subject_", subdir, ".txt", sep="")
  subject_values <- read.table(subject_file, col.names = c("Subject"))
  subject_values$Subject <- as.factor(subject_values$Subject)
  
  # read y file
  y_file <- paste(dir, subdir, "/y_", subdir, ".txt", sep="")
  y_values <- read.table(y_file, col.names = c("ActivityCode"))
  
  # replace y_value ActivityCodes with actual Acitivity names
  y_values$ActivityCode <- as.character(y_values$ActivityCode)
  y_values$ActivityCode <- revalue(y_values$ActivityCode, activity)
  y_values$ActivityCode <- as.factor(y_values$ActivityCode)
  
  # rename the column
  y_values <- rename(y_values, c("ActivityCode" = "Activity"))
  
  # read X
  X_file <- paste(dir, subdir, "/X_", subdir, ".txt", sep="")
  X_values <- read.table(X_file, col.names = feature_names)
  # only keep a subset of the features
  X_values <- X_values[,feature_keep]
  
  # concatenate the data frames
  combined <- data.frame(subject_values, y_values, X_values)
  # ignore rows with NA values (this dataset doesn't have that issue)
  combined <- combined[complete.cases(combined),]
  
  return(combined)
}


# unzip the datafile if not already unzipped
if (!file.exists("./UCI HAR Dataset")) {
  zipfile <- "./getdata-projectfiles-UCI HAR Dataset.zip"
  # download the datafile if it doesn't exist
  if (!file.exists(zipfile)) {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipfile <- tempfile()
    download.file(url, zipfile, "curl")
  }
  unzip(zipfile)
  # delete the zipfile if we didn't use an already existing one
  if (zipfile != "./getdata-projectfiles-UCI HAR Dataset.zip") {
    unlink(zipfile)
  }
}

# load column names
features <- read.table("UCI HAR Dataset/features.txt")
# make array of ones to keep - "-mean()" and "-std()"
keep <- features[grep("-mean\\(\\)|-std\\(\\)", features[,2]),1]
# remove parens from feature names b/c R is going to replace with hard to read dots
nice_feature_names <- as.character(features[,2])
nice_feature_names <- gsub("\\(\\)", "", nice_feature_names)

# load activity labels and create named chr array
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityCode", "Activity"))
activity_code <- as.character(activity_labels[,1])
activity <- as.character(activity_labels[,2])
names(activity) <- activity_code

# tidy up the training data
train <- clean_dir("UCI HAR Dataset/", "train", activity, nice_feature_names, keep)

# tidy up the test data
test <- clean_dir("UCI HAR Dataset/", "test", activity, nice_feature_names, keep)

# concatenate that data
total <- rbind(train, test)

# compute averages based on Subject and Activity
molten_data <- melt(total, id=c("Subject", "Activity"))
ans = dcast(molten_data, Subject + Activity ~ variable, mean)

# write out the answer
write.csv(ans, file = "UCI_HAR_tidy.csv")
