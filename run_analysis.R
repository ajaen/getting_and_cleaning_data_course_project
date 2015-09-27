rm(list=ls())

library(dplyr) #we should previously install dplyr (install.packages("dplyr"))

#STEP 0
#to begin we download and unzip the file containing the data for the project (If you are not currently
#using Windows you may set method = curl when calling the download.file function)

fileName<-"getdata.zip"
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists(fileName)){download.file(fileUrl,destfile=fileName)
    assign(paste0("date_",fileName,"_downloaded"),date())}

if(!file.exists("UCI HAR Dataset")){unzip(fileName)}

rm(fileName,fileUrl)

#STEP 1
#here we merge the train and test sets to create one data set

X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")



X<-rbind(X_train,X_test)
y<-rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)

rm(X_train,y_train,subject_train,X_test,y_test,subject_test)

merged_data<-cbind(subject,y,X)  #so the first two columns of this table are the one referred to the subject
                                  #and the one referred to the activity
rm(X,y,subject)

#STEP 2
#in this step we extract only the measurements on the mean and standard deviation for each measurement
#(in addition to the two first columns that are referred to the subject and the activity)

features<-read.table("UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)

features_mean<-grepl("mean()",features[,2],fixed=TRUE)
features_std<-grepl("std()",features[,2],fixed=TRUE)
features_mean_std<-(features_mean|features_std)

rm(features_mean,features_std)

features_selected<-c(TRUE,TRUE,(features_mean_std))

selected_data<-subset(merged_data,,features_selected)

rm(features_selected, merged_data)

#STEP 3
#in this step we replace the numerical value of our second column in the merged data (activity) by the activity
#names listed in "activity_labels.txt"

selected_data[,2][selected_data[,2]==1]<-"WALKING"                            
selected_data[,2][selected_data[,2]==2]<-"WALKING_UPSTAIRS"
selected_data[,2][selected_data[,2]==3]<-"WALKING_DOWNSTAIRS"
selected_data[,2][selected_data[,2]==4]<-"SITTING"
selected_data[,2][selected_data[,2]==5]<-"STANDING"
selected_data[,2][selected_data[,2]==6]<-"LAYING"

#STEP 4
#now we are going to label the columns with the respective variable names from features.txt

colnames(selected_data)<-c("subject","activity",features[,2][features_mean_std])

rm(features,features_mean_std)

#STEP 5
#to finish the analysis we create an independent tidy data set with the average of each variable
#for each activity and each subject. 

tidy_data<- selected_data %>% group_by(subject,activity) %>% summarize_each(funs(mean))
                                                                        
write.table(tidy_data, "tidy_data_set.txt", row.names = FALSE)