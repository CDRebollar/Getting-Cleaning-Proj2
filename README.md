# Getting-Cleaning-Proj2
Getting &amp; Cleaning Data on Coursera, Project 2

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

- Downloads dataset into working directory and unzips the folder.
- Loads activity & feature info
- Loads training & test datasets, keeping columns which contain "mean" | "std"
- Loads Activity and SubjectNum data for each dataset, and merges those columns with the dataset
- Merges test & training
- Converts Activity and SubjectNum columns into factors
- Creates tidy dataset consisting of average value of each variable for each SubjectNum - Activity pair.
- End result shown in file tidy.txt.