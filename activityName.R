## convert from activity label (1, 2, 3, 4, 5, 6) 
## to activity names (walking, walking upstairs, walking downstairs, sitting, standing, laying)
## Input: a tbl_df data frame of activity labels. 
## output: a data frame of activity names. 

activityName <- function(activityLabel)
{
  activityNames <- c("Walking","Walking_upstairs","Walking_downstairs","Sitting","Standing","Laying")
  
  activityLabel <- mutate(activityLabel,Activity="")
  
  for (n in 1:dim(activityLabel)[1])
  {
    activityLabel[n,2] <- activityNames[as.integer(activityLabel[n,1])] 
  }
  return(activityLabel$Activity)  ## return a character vector of activity names only, no labels are included in the output. 
  
}