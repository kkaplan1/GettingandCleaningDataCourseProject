library(plyr)
##load data
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjecttrain <- read.table("train/subject_train.txt")
xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjecttest <- read.table("test/subject_test.txt")
##bind data
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subjectdata <- rbind(subjecttrain, subjecttest)
alldata <- cbind(xdata, ydata, subjectdata)
##subset data
features <- read.table("features.txt")
meanstd <- grep("-(mean|std)\\(\\)", features[, 2])
featureswanted <- features[meanstd, 2]
colswanted <- c(featureswanted, 562, 563)
alldata2 <- alldata[, colswanted]
##label data
activitylabels <- read.table("activity_labels.txt")
featureswanted1 <- as.character(featureswanted)
names <- c(featureswanted1, "Activity", "Subject")
colnames(alldata2) <- names
alldata2$Activity <- factor(alldata2$Activity, levels = activitylabels[, 1], labels = activitylabels[, 2])
#average data
dataavg <- ddply(alldata2, .(Subject, Activity), function(x) colMeans(x[, 1:66]))
#write second tidy data
write.table(dataavg, "averagedata.txt", row.names = FALSE)