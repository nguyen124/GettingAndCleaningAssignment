## load library
install.packages("reshape2")
library(reshape2)
## down load source
if(!file.exists("dat.zip")){
	download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile ="dat.zip")
}
## unzip file
if(!file.exists("UCI HAR Dataset")){
	unzip("dat.zip")
}
## load data
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/Y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

## find index of mean and standar deviation
MeanAndStd <- grep(".*mean.*|.*std.*",features[,2])
## filter data
xTrain <- xTrain[MeanAndStd]
xTest <- xTest[MeanAndStd]
## combine all data
allTrain <- cbind(xTrain,yTrain,subjectTrain)
allTest <- cbind(xTest,yTest,subjectTest)
all <- rbind(allTrain,allTest)
## set descriptive names for data
MeanAndStd.names <- features[MeanAndStd,2]
colnames(all) <- c("subject", "activity", MeanAndStd.names)
## change to factors
all$activity <- factor(all$activity,levels = actLabels[,1],label=actLabels[,2])
all$subject <- as.factor(all$subject)
## melt data
all.meltData <- melt(all,id =c("subject","activity"))
all.mean <- dcast(all.meltData, subject + activity ~ variable, mean)
## write out tidy data
write.table(all.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
