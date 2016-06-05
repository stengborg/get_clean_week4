library(dplyr)
library(data.table)

#Reading the data
test <- read.table("./test/X_test.txt")
training <- read.table("./train/X_train.txt")

#reading the subject id
subj_id_train <- read.table("./train/subject_train.txt")
subj_id_test <- read.table("./test/subject_test.txt")
colnames(subj_id_train) <- "subject_id"
colnames(subj_id_test) <- "subject_id"

#adding the subject id to the train and test data set respectively
training <- cbind(subj_id_train, training)
test <- cbind(subj_id_test, test)



#read in the acivity id
train_labs <- read.table("./train/y_train.txt")
test_labs <- read.table("./test/y_test.txt")

#read in the acvivity name
activity_name <- read.table("./activity_labels.txt")

#merging the activity id with the name
train_labs <- merge(activity_name, train_labs)
colnames(train_labs) <- c("activity_id", "activity_name")
train_w_labs <- cbind(train_labs,training)

test_labs <- merge(activity_name, test_labs)
colnames(test_labs) <- c("activity_id", "activity_name")
test_w_labs <- cbind(test_labs, test)


#Combining the two data sets
all <- rbind(test_w_labs, train_w_labs)





#Reading in the column names
features <- read.table("./features.txt")


#adding feature names to the columns
first_3 <- c("activity_id", "activity_name", "subject_id")
first_3 <- as.data.frame(first_3)
colnames(first_3) <- "labs"
new<- as.data.frame(as.character(features$V2))
colnames(new) <- "labs"

all_labs <- rbind(first_3, new)
all_labs <- as.character(all_labs$labs)
#Adding the column names
setnames(all, old=colnames(all), new=all_labs)


#selecting only the mean and std variables:
only_std_mean <- subset(all, select = grep("mean()|std()|activity_name|subject_id|activity_id", names(all)))

#Setting appropriate column names
names(only_std_mean) <- gsub("-", '_', names(only_std_mean), fixed = T)
names(only_std_mean) <- gsub("()", '', names(only_std_mean), fixed = T)

#Creating a new data set with mearuser per subject and feature
#average of each variable for each activity and each subject.

new_tidy_data_set <- only_std_mean

by_activity_subject <- group_by(only_std_mean, activity_id, subject_id)
aggr_tidy_data <- summarise_each(by_activity_subject ,funs(mean))
aggr_tidy_data <- select(aggr_tidy_data, -activity_name)


## Final data set is aggr_tidy_data







