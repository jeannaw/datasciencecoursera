library(dplyr)

# read features.txt for naming measurement data
df.features <- read.table("./UCI HAR Dataset/features.txt")
# print(df.features[,2])

# read activity_labels.txt and name the columns
df.activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(df.activitylabels) <- c("activityno", "activitylabel")
# print(head(df.activitylabels,2))


# Read train data
df.xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
df.ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
df.subjecttrain <-
    read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read test data
df.xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
df.ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
df.subjecttest <-
    read.table("./UCI HAR Dataset/test/subject_test.txt")


## Appropriately labels the data set with descriptive variable names.
namesFeatures <- paste (df.features[,1],df.features[,2], sep="_")
namesFeatures <-
    gsub("[(.*)]", "", namesFeatures) # replace parenthesis with empty string
namesFeatures <-
    gsub(",", "_", namesFeatures) # replace commas with underline
namesFeatures <-
    gsub("-", "_", namesFeatures) # replace dashes with underline
# print("##################################")
# print(namesFeatures)
names(df.xtrain) <- namesFeatures
names(df.ytrain) <- c("activityno")
names(df.subjecttrain) <- c("subjectno")
# print(head(df.ytrain,2))
# print(head(df.subjecttrain,2))
# print(head(df.xtrain,2))

names(df.xtest) <- namesFeatures
names(df.ytest) <- c("activityno")
names(df.subjecttest) <- c("subjectno")
# print(head(df.ytest,2))
# print(head(df.subjecttest,2))
# print(head(df.xtest,2))


## Uses descriptive activity names to name the activities in the data set
df.ytest <-
    merge(x = df.ytest,
          y = df.activitylabels,
          by = "activityno",
          all.x = TRUE)
df.ytrain <-
    merge(x = df.ytrain,
          y = df.activitylabels,
          by = "activityno",
          all.x = TRUE)
# print(head(df.ytest,10))
# print(head(df.ytest,10))


# combine train data and test separately
df.train <- cbind(df.subjecttrain, df.ytrain, df.xtrain)
df.test  <- cbind(df.subjecttest, df.ytest, df.xtest)
# View(head(df.train,2))
# View(head(df.test,2))


## Merge the training and the test sets to create one data set.
df <- rbind(df.train, df.test)
View(head(df,2))
# print(nrow(df))
# print(ncol(df))
# writeLines(names(df))


## Extracts only the measurements on the mean and standard deviation for each measurement.
# print(names(df))
loc.mean1 <- grep("mean$", names(df))
loc.std1 <- grep("std$", names(df))
loc.mean2 <- grep("_mean_", names(df))
loc.std2 <- grep("_std_", names(df))
loc.meanstd <- sort(c(loc.mean1, loc.std1, loc.mean2, loc.std2))
# print(loc.meanstd)
df.meanstd <- df[, loc.meanstd]
View(head(df.meanstd, 5))


## creates a second, independent tidy data set with the average of each variable for each activity and each subject.
df.avg <- df %>% group_by(subjectno, activityno, activitylabel) %>% summarise_each(funs(mean))
print(df.avg)



