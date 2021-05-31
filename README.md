
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
#### 3. Merge the training and the test sets to create one data set.

Merge train data and test data by `rbind` function 

```R
df.x <- rbind(df.xtrain, df.xtest)
df.y <- rbind(df.ytrain, df.ytest)
df.subject <- rbind(df.subjecttrain, df.subjecttest)

names(df.ytrain) <- c("activityno")
names(df.subject) <- c("subjectno")
```

#### 4. Extracts only the measurements on the mean and standard deviation for each measurement.


1. Firstly, use `grepl` function to find the location for the measurements on the mean and standard deviation. 
2. Then extracts the measurements on the mean and standard deviation
3. Then extracts the name features for mean and standard deviation
4. Finally name data frame `df.xmeanstd`

```r
loc.meanstd <- grepl("-(mean|std)\\(\\)",df.features[, 2]) 
df.xmeanstd <- df.x[, loc.meanstd]
VectFeaturesName <- gsub("\\(\\)", "", df.features[loc.meanstd, 2]) 
VectFeaturesName <- gsub("-", "_", VectFeaturesName) 
names(df.xmeanstd) <- VectFeaturesName

```


#### 5. Uses descriptive activity names to name the activities in the data set

Rename activity labels lower without underscore, and name activity data set

```r
df.activitylabels[,2] <- tolower(sub("_", " ", df.activitylabels[,2]))  ## Rename Var lower without underscore
df.y1 = df.y 
df.y1[,1] = df.activitylabels[df.y1[,1],2]   # Temp Variable  
names(df.y1) <- c("Activity")  # write all activities name for each index
```

#### 6. Appropriately labels the data set with descriptive variable names. 

Create a Data Table with subject, Data activity and measures Tided data

```r
df.tidytable <- cbind(df.subject, df.y1, df.xmeanstd)   
write.table(df.tidytable, file = "merged_Tidy_Data.txt")   
```

#### 7. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

First using 'group_by' function to group dataset `df.tidytable` by columns `subjectno` and `Activity`, then apply mean to each values by function `summarise_each`

```r
df.avg <- df.tidytable %>% 
    group_by(subjectno, Activity) %>% 
    summarise_each(funs(mean))
write.table(df.avg, file = "run_analysis_avg.txt", row.name=FALSE)

```
