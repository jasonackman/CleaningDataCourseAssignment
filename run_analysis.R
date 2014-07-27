# Define a convenience method to read in data files.
my.read.data <- function(filename) {
    library(data.table)
    
    testsetfile <- file(filename)
    testsetdata <- readLines(testsetfile)
    close(testsetfile)
    testsetdata <- gsub("  ", " ", testsetdata)
    testsetdata <- gsub("^ ", "", testsetdata)
    data <- paste(testsetdata, collapse = "\n")
    
    dataset <- fread(input = data)
    
    dataset <- as.data.frame(dataset)
    
    dataset
}

# PRE-STEP 0: SET FILE VARIABLES
# set file variables
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "./data/dataset.zip"
extractDir <- "./data"

# PRE-STEP 1: CREATE DATA DIRECTORY
# Check that the data directory exists. If not, create it.
if (!file.exists("data")) {
    dir.create("data")
}

# PRE-STEP 2: DOWNLOAD AND UNZIP DATA FILE
# Download file
download.file(fileUrl, 
              zipFile, 
              method="curl")

# Unzip the file.
unzip(zipfile = zipFile,
      exdir = extractDir)

# PRE-STEP 3: Read in the features.txt file so we can get a list of column names.
featuresfilename <- "./data/UCI HAR Dataset/features.txt"
featuresset <- read.delim(featuresfilename, sep = " ", header = FALSE)
features <- featuresset[,2]
features <- as.character(features)

# PRE-STEP 4: Load the activity types
activitiesfilename <- "./data/UCI HAR Dataset/activity_labels.txt"
activitiesset <- read.delim(activitiesfilename, sep = " ", header = FALSE)
colnames(activitiesset) <- c("ActivityNumber", "ActivityName")


# STEP 1: Read the data from the datasets, merge with the subjects and activity numbers and names.
# SUBSTEP 1: Testing Set
testsetfilename <- "./data/UCI HAR Dataset/test/X_test.txt"
testsetlabelfilename <- "./data/UCI HAR Dataset/test/y_test.txt"
testsetsubjectfilename <- "./data/UCI HAR Dataset/test/subject_test.txt"

testsetlabels <- read.delim(testsetlabelfilename, header = FALSE)
testsetsubjects <- read.delim(testsetsubjectfilename, header = FALSE)
testset <- my.read.data(testsetfilename)

testset <- data.frame(testsetlabels, testsetsubjects, testset)

colnames(testset) <- c("ActivityNumber", "Subject", features)

testset <- merge(x = testset, 
                  y = activitiesset,
                  by = "ActivityNumber",
                  all.x = TRUE)

# SUBSTEP 2: Training Set
trainsetfilename <- "./data/UCI HAR Dataset/train/X_train.txt"
trainsetlabelfilename <- "./data/UCI HAR Dataset/train/y_train.txt"
trainsetsubjectfilename <- "./data/UCI HAR Dataset/train/subject_train.txt"

trainsetlabels <- read.delim(trainsetlabelfilename, header = FALSE)
trainsetsubjects <- read.delim(trainsetsubjectfilename, header = FALSE)
trainset <- my.read.data(trainsetfilename)

trainset <- data.frame(trainsetlabels, trainsetsubjects, trainset)

colnames(trainset) <- c("ActivityNumber", "Subject", features)

trainset <- merge(x = trainset, 
                  y = activitiesset,
                  by = "ActivityNumber",
                  all.x = TRUE)


# STEP 2: Merge data from testset and trainset.
dataset <- rbind(testset, trainset)


# STEP 3 : Select only the columns that provide the means and standard deviations.
colsOfInterest <- colnames(dataset)[grepl("mean|std", colnames(dataset))]

dataset <- dataset[,c("Subject", "ActivityNumber", "ActivityName", colsOfInterest)]

# STEP 4: Melt the dataset so we can summarize
library(reshape2)

datasetMelt <-  melt(dataset,
                     id = c("Subject", "ActivityName"),
                     measure.vars = colsOfInterest)

# Summarize data by Subject and ActivityName.
tidydataset <- dcast(datasetMelt, Subject + ActivityName ~ variable, mean)

# STEP 5: Write to tidy data file.
write.csv(tidydataset, "./data/tidydataset.csv")