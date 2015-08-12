################################################################################
#   CHECKS FOR REQUIRED PACKAGES AND INSTALLS THEM IF NECESSARY                #
################################################################################

installpkg <- function(x) {
  if(x %in% rownames(installed.packages())==FALSE) {
    install.packages(x)
  }
}

required_packages <- c("dplyr", "car", "plyr")
lapply(required_packages, installpkg)



################################################################################
#   LOADS NECESSARY LIBRARIES                                                  #
################################################################################

library(plyr)
library(dplyr)
library(car)



################################################################################
#   READS IN TRAINING AND TEST DATA FILES                                      #
################################################################################

xtrain <- read.table("train/X_train.txt", header=FALSE, fill=TRUE)
xtest <- read.table("test/X_test.txt", header=FALSE, fill=TRUE)



################################################################################
#   READS IN TRAINING AND TEST LABELS                                          #
################################################################################

ytrain <- read.table("train/y_train.txt", header=FALSE, fill=TRUE)
ytest <- read.table("test/y_test.txt", header=FALSE, fill=TRUE)



################################################################################
#   READS IN TRAINING AND TEST SUBJECT IDs                                     #
################################################################################

subtrain <- read.table("train/subject_train.txt", header=FALSE, fill=TRUE)
subtest <- read.table("test/subject_test.txt", header=FALSE, fill=TRUE)



################################################################################
#   READS IN FEATURES AND SETS UP A VECTOR FOR COLUMN NAMES                    #
################################################################################

features <- read.table("features.txt", header=FALSE, fill=TRUE)
colfeatures <- make.names(features[,2], unique=TRUE, allow_=TRUE)


################################################################################
#   MERGING OPERATIONS FOR TRAINING AND TEST SETS                              #
################################################################################

datamerge <- rbind(xtrain, xtest) # merges training and test data
labelmerge <- rbind(ytrain, ytest) # merges training and test labels
subjmerge <- rbind(subtrain, subtest) # merges training and test subject IDs



################################################################################
#   MERGING OPERATIONS TO ADD LABELS AND SUBJECT COLUMNS TO DATA SET           #
################################################################################

alldata <- cbind(subjmerge, labelmerge, datamerge) 



################################################################################
#   ADDS COLUMN LABELS TO OVERALL DATA SET                                     #
################################################################################

names(alldata) <- c("Subject", "Label", colfeatures)



################################################################################
#   ARRANGES DATA BY SUBJECT, THEN BY LABEL                                    #
################################################################################

alldata <- arrange(alldata, Subject, Label)



################################################################################
#   EXTRACTS MEAN AND ST DEV COLUMNS FOR EACH MEASUREMENT                      #
################################################################################

selectdata <- alldata[grep("Mean|mean|std|Subject|Label", names(alldata))]



################################################################################
#   REMOVES ANGLE AND MEAN FREQUENCY COLUMNS, WHICH ARE NOT TRUE MEANS         #
################################################################################

selectdata <- select(selectdata, -grep("meanFreq|angle", names(selectdata)))



################################################################################
#   CALCULATES AVERAGE FOR EACH SUBJECT + ACTIVITY COMBINATION                 #
################################################################################

meandata <- ddply(selectdata, c("Subject","Label"), function(x) colMeans(x))



################################################################################
#   REPLACES LABEL NUMBERS WITH DESCRIPTIVE NAMES                              #
################################################################################

lab <- read.table("activity_labels.txt", fill=TRUE) # reads in descriptive names
lab <- tolower(gsub("_","", lab[,2])) # converts to lowercase with no underscore

for (i in 1:length(lab)) {
  meandata$Label <- recode(meandata$Label, "i=lab[i]")
}



################################################################################
#   CLEANS UP VARIABLE NAMES                                                   #
################################################################################

names(meandata) <- gsub("\\.mean\\...|\\.Mean\\...", "Mean", names(meandata))
names(meandata) <- gsub("\\.mean\\..", "Mean", names(meandata))
names(meandata) <- gsub("\\.std\\...|\\.std\\..", "Std", names(meandata))
names(meandata) <- gsub("BodyBody", "Body", names(meandata))



################################################################################
#   WRITES A NEW TABLE WITH THE CLEANED DATA SET                               #
################################################################################

write.table(meandata, file="ProjectData.txt", row.name=FALSE)
