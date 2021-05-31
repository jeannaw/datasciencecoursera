
### Project Introduction - Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:  [Samsung Smartphones Data Set Description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)


Here are the data for the project:  [Data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 

You should create one R script called run_analysis.R that does the following. 

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


### Scripts Description

In run_analysis.R scripts, we process data by seven steps.

#### 1. Read property data

- Read features.txt for naming measurement data by `read.table` function, and store them to `df.features`
- Read activity_labels.txt and name the columns by `read.table` function, and store them to ` df.activitylabels`

```r
df.features <- read.table("./UCI HAR Dataset/features.txt")
df.activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(df.activitylabels) <- c("activityno", "activitylabel")
```
#### 2. Read train/test data 

Read the following train/test data files by `read.table` function

- X_train.txt  
- y_train.txt  
- subject_train.txt  
- X_test.txt  
- y_test.txt  
- subject_test.txt  

Store data set into `df.xtrain`, `df.ytrain`, `df.subjecttrain`, `df.xtest`, `df.ytest`, `df.subjecttest`

```r
# Read train data
df.xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
df.ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
df.subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read test data
df.xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
df.ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
df.subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

```
#### 3. Labels the data set with descriptive variable names

In order to appropriately labels the data set with descriptive variable names, firstly we concatenate `df.features[,1]` and `df.features[,2]` to avoid duplicate name and store into `namesFeatures`, then remove parenthesis, commas and dashes from `namesFeatures`.

Next rename all column name for `df.xtrain` and `df.xtest` by `namesFeatures`

Then rename column name for  `df.ytrain` and `df.ytest` to **"activityno"**

Finally rename column name for  `df.subjecttrain` and `df.subjecttest` to **"subjectno"**

```r
#concatenate df.features[,1] and df.features[,2]
namesFeatures <- paste (df.features[,1],df.features[,2], sep="_") 
namesFeatures <- gsub("[(.*)]", "", namesFeatures) # replace parenthesis with empty string
namesFeatures <- gsub(",", "_", namesFeatures) # replace commas with underline
namesFeatures <- gsub("-", "_", namesFeatures) # replace dashes with underline

names(df.xtrain) <- namesFeatures
names(df.ytrain) <- c("activityno")
names(df.subjecttrain) <- c("subjectno")

names(df.xtest) <- namesFeatures
names(df.ytest) <- c("activityno")
names(df.subjecttest) <- c("subjectno")
```

#### 4. Uses descriptive activity name the activities in the data set

Merge `df.ytrain` and `df.activitylabels` and assign to `df.ytrain` by **activityno***, then similarly merge `df.ytest` and `df.activitylabels` and assign to `df.ytest`. 

```r
df.ytest <- merge(x = df.ytest, y = df.activitylabels, by = "activityno", all.x = TRUE)
df.ytrain <- merge(x = df.ytrain, y = df.activitylabels, by = "activityno", all.x = TRUE)          
```          

#### 5. Merges the training and the test sets to create one data set.
Firstly, combine train data and test separately
Then Merge the training and the test sets to create one data set.

```r
# combine train data and test separately
df.train <- cbind(df.subjecttrain, df.ytrain, df.xtrain)
df.test  <- cbind(df.subjecttest, df.ytest, df.xtest)

df <- rbind(df.train, df.test)
```
#### 6. Extracts only the measurements on the mean and standard deviation for each measurement.

1. Firstly, `grep` function to find the location for the measurements on the mean and standard deviation. 
2. Then sort the combined location vector
3. Finally extracts the measurements on the mean and standard deviation

```r
loc.mean1 <- grep("mean$", names(df))
loc.std1 <- grep("std$", names(df))
loc.mean2 <- grep("_mean_", names(df))
loc.std2 <- grep("_std_", names(df))
loc.meanstd <- sort(c(loc.mean1, loc.std1, loc.mean2, loc.std2))

df.meanstd <- df[, loc.meanstd]
```
#### 7. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

First using 'group_by' function to group dataset `df` by columns `subjectno`, `activityno`, and `activitylabel`, then apply mean to each values by function `summarise_each`

```r
df.avg <- df %>% group_by(subjectno, activityno, activitylabel) %>% summarise_each(funs(mean))
```

