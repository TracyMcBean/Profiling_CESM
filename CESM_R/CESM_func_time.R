# Read timing of functions/drivers and visualize
# 1. Combine datasets to create sets for each function

source("./CESM_prof.R")

timing_data <- read.table("~/Documents/IASS/Profiling_CESM/Timing_data/ccsm_timing_stats.190515-100256", 
                          skip = 5, header=TRUE)
# get function names
func_names <- as.vector(timing_data$name)
rm(timing_data)

# Create data file
row_names=c(NULL)
column_names=c("ID", "tagged", "cores", "ndays", "tot_time_run", "walltotal", "wallmax", "wallmin")
func_df <- array(NA, dim = c(40,8,length(func_names)), dimnames=list(row_names, column_names, func_names))

prof_data <- get_data()
prof_tagged_df <- prof_data[[2]]
prof_not_df <- prof_data[[1]]

add_func_data("~/Documents/IASS/Profiling_CESM/Timing_data/ccsm_timing_stats.190515-100256", "100256")

# number of runs added initialize
nrun <- 1

#### add_func_data ###--------------------------------------------------------------------------------------
# Add data from a run to the function list
# ID is the starting time.
add_func_data <- function(filename, ID){
  
  if (length(subset(func_df, func_df[,1,]==ID[1])) > 0){
    print("ERROR: ID used already!")
  } else {
    timing_data <- read.table(filename, skip = 5, header=TRUE)
    for (func in 1:length(timing_data$name)){
      subset_data <- subset(timing_data, timing_data$name==func_names[func])
      func_df[nrun,6,func] <- as.numeric(subset_data$walltotal)
      func_df[nrun,7,func] <- subset_data$wallmax
      func_df[nrun,8,func] <- subset_data$wallmin
    
      subset_prof_data <- as.numeric(subset(prof_tagged_df, prof_tagged_df$ID == ID[1], 
                                            select = c(ID, Tagged, Cores, NDays, Dur_tot)))
      if (length(subset_prof_data) == 0 ){
        subset_prof_data <- subset(prof_not_df, prof_not_df$ID == ID[1],
                                   select = c(ID, Tagged, Cores, NDays, Dur_tot))
        if (length(subset_prof_data) == 0 ){
          print("ERROR: No fitting ID in input data set from profiling.")
        }
      }
      func_df[nrun,1,func] <- subset_prof_data[1]
      func_df[nrun,2,func] <- subset_prof_data[2]
      func_df[nrun,3,func] <- subset_prof_data[3]
      func_df[nrun,4,func] <- subset_prof_data[4]
      func_df[nrun,5,func] <- subset_prof_data[5]
    }
    # Continue to next run
    nrun <- nrun + 1
  }
  return(func_df)
}


