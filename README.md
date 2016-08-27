Files in this repository: 
1. TidyData.csv: the tidy data created by the script "run_analysis.R"
2. "run_analysis.R": the main script to create the tidy data set
3. "activityName.R": an R function for converting the activity labels to activity names
4. "codeBook.md": describes the data set and the variables

Note: the script was run in Rstudio on Windows

How to run the script for creating the tidy data set: 
1. Download all the files "run_analysis.R" and "activityName.R" to a folder on your computer.  
2. Open Rstudio, go to the folder containing these two files.
3. Make sure that "dplyr" and "data.table" packages have been installed 
4. type source("run_analysis.R") in the Rstudio command window.

Note that in the first time you run the script, it will download the original data from the internet, then unzip the data. Then it will load the data into R, then do the following: 
1. Merge the train and test data sets
2. Use descriptive variable names: (this is step 4 in the instruction). I found that it is easier to add the descriptive names first before choosing columns of the mean and standard deviation of each measurement because we can then select columns whose names contain "mean" or "std". However, there are some columns named "...gravityMean", ..."meanFreq". These columns are not chosen as they are not mean values. So these columns are deleted from the data set. When using the character vectors from the file "features.txt" for the variable names, please note that we must convert those characters into valid R names by using the function "make.names". I also remove the parentheses in mean() and std() from the names. 
3. Extract only columns with names mean() and std(). 
4. Covert activity labels to descriptive activity names. Then, add the subject and activity names to the data. These are the first and second columns of the data. Name the first column as "subject"
5. Create a new tidy data set: each value of a variable is the mean value of the corresponding measurement of a specified subject when this person is doing a specified activity. This can be done using the  lapply function for data.table class. 

Then the tidy data is written to the file named "TidyData.csv" using "write.table" function. This data can be read into R by 

data <- read.table("TidyData.csv",sep = ",")

Thank you very much for spending your time to read this and grade my work!
