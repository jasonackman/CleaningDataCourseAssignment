Course Project
=========

Introduction
------------
This readme file will explain the files in this git repository and explain the steps used by run_analysis.R.

This project was created to fullfill the requirements for the Course Project for the Data Science Obtaining and Cleaning Data Coursera course.

Files
-----
- README.md: This file.
- CodeBook.md: The code book for the resulting data file.
- run_analysis.R: Performs the downloading and analysis of the data file for the project.

Process
-------
There are a number of steps that the run_analysis.R performs in order to obtain and process the raw data into the final dataset.

### Pre-Steps
The following pre-steps are performed prior to processing the data.

1. Defines standard variables. Verifies the data directory exists. If not, the data directory is created.
2. Downloads and unzips the dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
3. Reads the features.txt file to obtain the list of variables.
4. Read the activity_labels.txt to obtain the list of activities.

### Steps
1. Reads the test set and test set subjects. Merges the test set with the subjects and activities names. Sets column names based on data from features.txt.
2. Reads the training set and training set subjects. Merges the training set with the subjects and activity names. Sets column names based on data from features.txt.
3. rbinds the test set and training set.
4. Reduces the columns in the dataset to only the mean and standard deviation columns.
5. Melts and summarizes the dataset by activity and subject.
6. Writes output to csv file tidydataset.csv.
