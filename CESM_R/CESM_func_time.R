# Read timing of functions/drivers and visualize
# 1. Combine datasets to create sets for each function

source("./CESM_prof.R")

# Get data
prof_data <- get_data()
prof_tagged_df <- prof_data[[2]]
prof_not_df <- prof_data[[1]]

timing_data <- read.table("~/Documents/IASS/Profiling_CESM/Timing_data/ccsm_timing_stats.190515-100256", 
                          skip = 5, header=TRUE)
# get function names
func_names <- as.vector(timing_data$name)
rm(timing_data)
# Create data file
row_names=c(NULL)
column_names=c("ID", "tagged", "cores", "ndays", "tot_time_run", "walltotal", "wallmax", "wallmin")
func_df <- array(NA, dim = c(40,8,length(func_names)), dimnames=list(row_names, column_names, func_names))
# number of runs added initialize
nrun <- 1

# Some runs from 1 missing. Ending at 190521-114744
dateID <- c(190515, 190515, 190515, 190516, 190516, 190517, 190518, 190519, 190519, 190519, 190519, 190519, 190520,
            190520, 190520, 190521, 190521, 190515, 190515, 190516, 190516, 190516,
            190517, 190517, 190518, 190518, 190519, 190519, 190520, 190520, 190520,
            190520, 190520, 190520, 190520, 190520)
# numbers starting with zeros lose zeros if not saved as character explicitly
timeID <- c(100256, 112230, 160758, "095004", 123658, 113255, 115631, "094444", 103838, 111813, 204830, 214334, 113921,
            140026, 181204, "094851", 114744, 101006, 105339, "093632", 113246, 120848,
            112213, 115727, 155302, 164356, 202752, 225842, 100705, 105507, 112847,
            115041, 135839, 143315, 150757, 161950)

for (i in 1:length(dateID)){
  list_data <- add_func_data(paste("~/Documents/IASS/Profiling_CESM/Timing_data/ccsm_timing_stats.",dateID[i], "-", as.character(timeID[i]), sep=""),
                             as.character(timeID[i]))
  func_df <- list_data[[1]]
  nrun <- list_data[[2]]
}

# Save created data set
# write.csv(func_df, file = "~/Documents/IASS/Profiling_CESM/Timing_data/function_timing.csv")

# wallmax as percentage of total run (tot_time_run)
for (i in 1:length(func_df[1,1,])){
  # y and x axis data
  cores_tag <- func_df[which(func_df[,4,i]==10 & func_df[,2,1]==1),3,i]
  wallclock_per_tag <- (func_df[which(func_df[,4,i]==10 & func_df[,2,i]==1),7,i]/ func_df[which(func_df[,4,i]==10 & func_df[,2,i]==1),5,i]) *100
  cores_not <- func_df[which(func_df[,4,i]==10 & func_df[,2,1]==0),3,i]
  wallclock_per_not <- (func_df[which(func_df[,4,i]==10 & func_df[,2,i]==0),7,i]/ func_df[which(func_df[,4,i]==10 & func_df[,2,i]==0),5,i]) *100
  # y limits
  ymin <- min(wallclock_per_not, wallclock_per_tag,na.rm = TRUE)
  ymax <- max(wallclock_per_not, wallclock_per_tag,na.rm = TRUE)
  # plot
  #png(paste("~/Documents/IASS/Profiling_CESM/CESM_R/Plots/", names(func_df[1,1,])[i], "_10days", sep=""))
  plot(cores_tag, wallclock_per_tag, ylim=c(ymin, ymax),
       ylab = "% of total", xlab="Cores", main = paste("Wallclock time", names(func_df[1,1,])[i], "(10 day run)"), pch=15, col="red" )
  points(cores_not, wallclock_per_not, col = "darkgreen", pch = 16)
  legend("topleft", legend=c("tagged", "no tags"), col=c("red", "darkgreen"), pch = c(15,16), bty="n")
  #dev.off()
}

i <- 1
# Check out the situtation of the average values and their spread.
wallclock_per_tag <- (func_df[which(func_df[,4,i]==10 & func_df[,2,i]==1),7,i]/ func_df[which(func_df[,4,i]==10 & func_df[,2,i]==1),5,i]) *100
round(mean(wallclock_per_tag), digits=3)


