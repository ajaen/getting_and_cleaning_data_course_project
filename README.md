Before executing the run_analysis.R file we need to install the dplyr package (this can be done by running this code in the R console: install.packages("dplyr"))

We have divided the run_analysis.R file into some steps:

STEP 0:
downloads and unzips the file containing the data for the project (If you are not currently
using Windows you may have to set method = curl when calling the download.file function)

STEP 1:
merges the train and test sets to create one data set

STEP 2:
extracts only the measurements on the mean and standard deviation for each measurement
(in addition to the two first columns that are referred to the subject and the activity)

STEP 3:
replaces the numerical value of our second column in the merged data (activity) by the activity
names listed in "activity_labels.txt"

STEP 4:
labels the columns with the respective variable names from features.txt

STEP 5:
creates an independent tidy data set with the average of each variable
for each activity and each subject and creates a txt file containing the tidy data set.
