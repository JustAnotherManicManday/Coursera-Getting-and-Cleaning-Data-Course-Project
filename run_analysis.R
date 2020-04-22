
# Download data and store it in directory "data". If "data" doesn't exist then
# create it and also print the date that the file was downloaded.

library(dplyr)
library(tidyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        if (!file.exists("data")) {
                dir.create("data")
        }
download.file(url, destfile = "./data/phonerawdata", method = "curl")
datedownloaded <- date()
datedownloaded


# Unzip phonerawdata and read in the files that we will use to create and name our
# tables.


unzip("./data/phonerawdata", exdir = "./data")
data_variables <- read.table("./data/UCI Har Dataset/features.txt", stringsAsFactors = FALSE)

test_files <- list.files(path = "./data/UCI Har Dataset/test", full.names = TRUE)
test_subject <- read.table(test_files[[2]], stringsAsFactors = FALSE)
test_data <- read.table(test_files[[3]], stringsAsFactors = FALSE)
test_activities <- read.table(test_files[[4]], stringsAsFactors = FALSE)

train_files <- list.files(path = "./data/UCI Har Dataset/train", full.names = TRUE)
train_subject <- read.table(train_files[[2]], stringsAsFactors = FALSE)
train_data <- read.table(train_files[[3]], stringsAsFactors = FALSE)
train_activities <- read.table(train_files[[4]], stringsAsFactors = FALSE)


# Create a test and a train dataframe (with appropriate names) and then merge them 
# together. In addition to this, I create another column "data_type" to identify
# whether the data came from the test or train data set. In this code block I fulfill
# steps 1 and 4 of the assignment; merge the data into one dataframe and name the 
# variables


data_set1 <- rep(c("test"), nrow(test_data))
testdf <- cbind(test_subject, test_activities, data_set1, test_data)
names(testdf) <- c("subject", "activity", "data_set", data_variables[, 2])

data_set2 <- rep(c("train"), nrow(train_data))
traindf <- cbind(train_subject, train_activities, data_set2, train_data)
names(traindf) <- c("subject", "activity", "data_set", data_variables[, 2])

df <- rbind(testdf, traindf)


# Moving onto step 2, we seperate the joined data frame into measurements for only
# std and mean. We do this by creating a logical vector that identifies variables
# with the correct words in their name and then using that to subset the data.


logical <- grepl("mean|std|activity|subject|data_set", colnames(df))
subdf <- df[, logical]


# To fulfill step 3 we next have to replace the activity data with actual activity
# names, e.g "walking"


activity_names <- c("walking", "walking upstairs", "walking downstairs", "sitting",
                    "standing", "laying")
        for (i in 1:6) {
                subdf$activity <- gsub(i, activity_names[[i]], subdf$activity)
        }


# We have already done step 4, "Appropriately label the data set with descriptive
# variable names", so now we move onto step 5, calculate the mean of every variable
# per subject/acivity pair. We do this by looping through a summarise function for
# each variable. The tibbles created by summarise have to be ungrouped and coerced
# back into data frames for this to work.


subdfname <- colnames(subdf)
n <- length(subdfname) - 4
grouped <- group_by(subdf, subject, activity, data_set)
outputdf <- summarise(grouped, zero = mean(!! sym(subdfname[4])))
colnames(outputdf)[4] <- subdfname[4]

        for (i in 1:n) {
                outputdf <- ungroup(outputdf)
                outputdf <- as.data.frame(outputdf)
                intermediate <- summarise(grouped, x = mean(!! sym(subdfname[i+4])))
                intermediate <- ungroup(intermediate)
                intermediate <- as.data.frame(intermediate)
                outputdf <- cbind(outputdf, intermediate[, 4])
                colnames(outputdf)[i+4] <- subdfname[i+4]
}
# Finally, we write a file with the output dataframe into the working directory

write.table(outputdf, "Tidy Means and SDs", row.names = FALSE)
