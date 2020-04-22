This file describes the R script run_analysis.R, which downloads a raw dataset from the UCI data archive and transforms it into a tidy dataset for downstream analysis. This tidy data set is then saved to file inside the current working directory.

run_analysis.R was created and tested under the following conditions:

OS - Windows 10, x64, build 18362
R version - 3.6.3
Date - 22/04/2020
dplyr version - 0.8.2
tidyr version - 1.0.2

The script consists of seven code blocks seperated by text describing their function. Below is a detailed description of each code block.

1)
        - Load dplyr and tidyr packages
        - Download the raw data set from the internet archive and save it into the directory "data"
        - Print the date that this was downloaded
        
2)
        - Unzip the downloaded raw dataset
        - Read into R all the files that will be used

3)
        - Create two new vectors "test" and "train" to identify whether or not the observations come from the test or train groups. This is important because just merging the datasets would lose important information which might be needed downstream
        - Create two dataframes, testdf and traindf, from the test and train raw datasets (plus the vectors we just made) and name the variables as per the 
"features" text file in the raw dataset
        - Merge these two dataframes together

4)
        - Create a logical vector that identifies the columns in the dataframe that will be subsetted
        - Subset these colums from the dataframe into a new dataframe "subdf"
        
5)
        - Create a vector with descriptive activity names
        - Substitute the "activity" column data with the desciptive activity names
        
6)
This next code block takes "subdf", the subset of the dataframe we created, and computes the mean of each activity for each subject.

        - First, we create two objects "subdfname" and "n" to be used later
        - "subdf" is then grouped and a dataframe, "outputdf", is created and its columns are named
        - the "for" loop then calculates the mean of each variable in the "grouped" dataframe and binds the result into the "outputdf" dataframe

7)
        - Finally, the tidy dataset "outputdf" is saved into the working directory with the name "Tidy Means and SDs"