library(dplyr)
library(data.table)

# read features.txt for naming measurement data
df.features <- read.table("./UCI HAR Dataset/features.txt")

# read activity_labels.txt and name the columns
df.activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Read train data
df.xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
df.ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
df.subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read test data
df.xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
df.ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
df.subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## 1. Merge the training and the test sets to create one data set.
# combine train data and test separately
df.x <- rbind(df.xtrain, df.xtest)
df.y <- rbind(df.ytrain, df.ytest)
df.subject <- rbind(df.subjecttrain, df.subjecttest)

names(df.ytrain) <- c("activityno")
names(df.subject) <- c("subjectno")

# combine train data and test sets to one data set
# df <- cbind(df.subject, df.y, df.x)
# print(head(df,2))

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
loc.meanstd <- grepl("-(mean|std)\\(\\)",df.features[, 2]) 
df.xmeanstd <- df.x[, loc.meanstd]
VectFeaturesName <- gsub("\\(\\)", "", df.features[loc.meanstd, 2])             ## Remove "()" from each var name
VectFeaturesName <- gsub("-", "_", VectFeaturesName) # replace dashes with underline
names(df.xmeanstd) <- VectFeaturesName

# print(loc.meanstd)
df.meanstd <- df[, loc.meanstd]
# View(head(df.meanstd, 5))


## 3. Uses descriptive activity names to name the activities in the data set
df.activitylabels[,2] <- tolower(sub("_", " ", df.activitylabels[,2]))           ##Rename Var lower without underscore
df.y1 = df.y 

# Temp Variable
df.y1[,1] = df.activitylabels[df.y1[,1],2]    

# write all activities name for each index 
names(df.y1) <- c("Activity")


## 4. Appropriately labels the data set with descriptive variable names. 
df.tidytable <- cbind(df.subject, df.y1, df.xmeanstd)                               ## Create a Data Table with subject, Data activity name and measures Tided
write.table(df.tidytable, file = "merged_Tidy_Data.txt")                            ## Create a plain file with Tidy Data


##5. From the data set in step 4, creates a second, independent tidy data set with
##   the average of each variable for each activity and each subject.
df.avg <- df.tidytable %>% 
    group_by(subjectno, Activity) %>% 
    summarise_each(funs(mean))
write.table(df.avg, file = "run_analysis_avg.txt", row.name=FALSE)

