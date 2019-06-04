# Read timing of functions/drivers and visualize
# 1. Combine datasets to create sets for each function

source("./CESM_prof.R")
library(igraph)

# Get data
prof_data <- get_data()
prof_tagged_df <- prof_data[[2]]
prof_not_df <- prof_data[[1]]

timing_data <- read.table("../Timing_data/ccsm_timing_stats.190515-100256", 
                          skip = 5, header=TRUE)
# get function names
func_names <- as.vector(timing_data$name)
rm(timing_data)
# Create data file
row_names=c(NULL)
column_names=c("ID", "tagged", "cores", "ndays", "tot_time_run", "walltotal", "wallmax", "wallmin")
func_df <- array(NA, dim = c(42,8,length(func_names)), dimnames=list(row_names, column_names, func_names))
# number of runs added initialize
nrun <- 1

# Some runs from 1 missing. Ending at 190521-114744
dateID <- c(190515, 190515, 190516, 190516, 190518, 190519, 190519, 190519, 190519, 190519, 190520,
            190520, 190520, 190521, 190521, 190521, 190521, 190522, 190522, 190523, 190526,
            190515, 190515, 190516, 190516, 190516, 190517, 190517, 190518, 190518, 190519, 190519, 190520, 190520, 
            190520, 190520, 190520, 190520, 190520, 190520)
# numbers starting with zeros lose zeros if not saved as character explicitly
timeID <- c(100256, 160758, "095004", 123658, 115631, "094444", 103838, 111813, 204830, 214334, 113921,
            140026, 181204, "094851", 114744, 134459, 144738, "083656", 174343, "091805", 130425,
            101006, 105339, "093632", 113246, 120848, 112213, 115727, 155302, 164356, 202752, 225842, 100705, 105507,
            112847, 115041, 135839, 143315, 150757, 161950)

for (i in 1:length(dateID)){
  list_data <- add_func_data(paste("../Timing_data/ccsm_timing_stats.",dateID[i], "-", as.character(timeID[i]), sep=""),
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
  #png(paste("./Plots/", names(func_df[1,1,])[i], "_10days", sep=""))
  plot(cores_tag, wallclock_per_tag, ylim=c(ymin, ymax),
       ylab = "% of total", xlab="Cores", main = paste("Wallclock time", names(func_df[1,1,])[i], "(10 day run)"), pch=15, col="red" )
  points(cores_not, wallclock_per_not, col = "darkgreen", pch = 16)
  legend("topleft", legend=c("tagged", "no tags"), col=c("red", "darkgreen"), pch = c(15,16), bty="n")
  #dev.off()
}

# Create empty array to save mean and difference between the mean of both
wc_means <- array(NA, dim = c(length(func_names),2))
wc_diff <- array(NA, dim = length(func_names))
wc_diff_score <- array(NA, dim = length(func_names))

# Compute the mean of the wallclock time of each timer in percent of total run
# Exclude runs covering only 1 day
for (i in 1:length(func_names)){
  #wallclock_per_tag <- (func_df[which(func_df[,4,i]!=1 & func_df[,2,i]==1),7,i]/ func_df[which(func_df[,4,i]!=1 & func_df[,2,i]==1),5,i]) *100
  #wallclock_per_not <- (func_df[which(func_df[,4,i]!=1 & func_df[,2,i]==0),7,i]/ func_df[which(func_df[,4,i]!=1 & func_df[,2,i]==0),5,i]) *100
  # Not the percentage!!!
  wallclock_per_tag <- (func_df[which(func_df[,4,i]!=1 & func_df[,2,i]==1),7,i])
  wallclock_per_not <- (func_df[which(func_df[,4,i]!=1 & func_df[,2,i]==0),7,i])
  
  wc_means[i,1] <- round(mean(wallclock_per_tag, na.rm = TRUE), digits=5)
  wc_means[i,2] <- round(mean(wallclock_per_not, na.rm=TRUE), digits=5)
  
  wc_diff[i] <- wc_means[i,1]-wc_means[i,2]
  if (wc_means[i,1] > 0){
    wc_diff_score[i] <- wc_means[i,2]/wc_means[i,1]
  } else {
    wc_diff_score[i] <- NaN
  }
}


# If the difference is positive then the non tagged version took longer for that timer.
#par(mar=c(5,9,4,2)+0.1)
# default:
par(mar=c(5, 4, 4, 2) + 0.1)
barplot(wc_diff[which(wc_diff > 3 | wc_diff < -3)], horiz=TRUE, col = c(rep("blue",6), rep("green", 13)),
        main = "Timer difference", sub = "Wallclock time of timer taken in percent of total wallclock time of run (includes 5 and 10 days run)",
        xlab = "Difference Tagged - No tag in %")
mtext(side = 2, text = func_names[which(wc_diff > 3 | wc_diff < -3)], las=1, at=seq(0.7,23, 1.21), cex=0.8)
abline(h=seq(0,23, 1.21), col="grey", lty="dotted")
#TODO: How to include variance?

### Proportional tagged vs not tagged ###----------------------------------------------------------
## Use Percentages and calculate differences between those

wc_max_means <- array(NA, dim = c(length(func_names),2))
wallclock_prop <- array(NA, dim = length(func_names))

# (t_tagged-t_not)/t_not
for (i in 1:length(func_names)){
  wallclock_tag_max <- func_df[which(func_df[,4,i]!=1 & func_df[,2,i]==1),7,i]
  wallclock_not_max <- func_df[which(func_df[,4,i]!=1 & func_df[,2,i]==0),7,i]
  
  wc_max_means[i,1] <- round(mean(wallclock_tag_max, na.rm = TRUE), digits=5)
  wc_max_means[i,2] <- round(mean(wallclock_not_max, na.rm=TRUE), digits=5)
  
  # Wallclock max proportion of tagged to not tagged duration
  if (wc_max_means[i,2] != 0){
    wallclock_prop[i] <- (wc_max_means[i,1] - wc_max_means[i,2]) / wc_max_means[i,2]
  } else {
    wallclock_prop[i] = 0
  }
}

wallclock_lim_pos <- mean(wallclock_prop) + sd(wallclock_prop)
wallclock_lim_neg <- mean(wallclock_prop) - sd(wallclock_prop)
par(mar=c(5,9,4,2)+0.1)
barplot(wallclock_prop[which( wallclock_prop > wallclock_lim_pos | wallclock_prop < wallclock_lim_neg)],
        horiz=TRUE, col = c("#B1DDF0", "#107E93"),
        main = "Timer differences", xaxt="n",
        xlab = expression("" * mu ~ "(Including 5 and 10 day runs)") )
mtext(side = 2, text = func_names[which( wallclock_prop > wallclock_lim_pos | wallclock_prop < wallclock_lim_neg)],
      las=1, at=seq(0.7,27, 1.21), cex=0.8)
axis(1, at=seq(0,26,2), labels = TRUE )
#abline(h=seq(0,26, 1.21), col="grey", lty="dotted")
abline(v=seq(0,26,5), col="grey", lty="dotted")


#TODO: How to include variance?

#### Sunlplot ####----------------------------------------------------------------------------------
# Calculate average difference
sd(wallclock_prop, na.rm = T)
mean(wallclock_prop, na.rm=T)

# Select the differences which are more extreme
wc_above_names <- func_names[which( wallclock_prop > (mean(wallclock_prop, na.rm=T) + sd(wallclock_prop, na.rm = T) )) ]
wc_below_names <- func_names[which( wallclock_prop < (mean(wallclock_prop, na.rm=T) - sd(wallclock_prop, na.rm = T) )) ]
wc_above <- wallclock_prop[which( wallclock_prop > (mean(wallclock_prop, na.rm=T) + sd(wallclock_prop, na.rm = T) )) ]
wc_below <- wallclock_prop[which( wallclock_prop < (mean(wallclock_prop, na.rm=T) - sd(wallclock_prop, na.rm = T) )) ]

# Create sunplot using the given functions
# https://plot.ly/r/sunburst-charts/
sunplot_df <- data.frame(loop=c("DRIVER_RUN_LOOP"),
                         parents=c("DRIVER_ATM_RUN", "DRIVER_OCNPREP", "DRIVER_LNDPREP" ),
                         child1=c("CAM_run2", "CAM_run1" ),
                         child2=c( "phys_run2" , "stepon_run2", "stepon_run1"),
                         child3=c("ac_physics", "p_d_coupling", "d_p_coupling"),
                         child4=c("chunk_to_block", "block_to_chunk" )
                         )

### Try Network plots
# Connect by dependency

links<-data.frame(source=c("DRIVER_RUN_LOOP", "DRIVER_RUN_LOOP", "DRIVER_RUN_LOOP", "DRIVER_ATM_RUN", 
                          "DRIVER_ATM_RUN", "...", "CAM_run2", "CAM_run2", "phys_run2", "stepon_run2",
                          "p_d_coupling", "d_p_coupling"),
                 target=c("DRIVER_ATM_RUN","DRIVER_OCNPREP", "DRIVER_LNDPREP", "...",
                          "CAM_run2", "d_p_coupling", "phys_run2", "stepon_run2", "ac_physics", 
                          "p_d_coupling", "chunk_to_block", "block_to_chunk" ))

# Order of vertices:
# "DRIVER_RUN_LOOP", "DRIVER_ATM_RUN", "...", "CAM_run2", "phys_run2", "stepon_run2",
# "p_d_coupling", "d_p_coupling","DRIVER_OCNPREP", "DRIVER_LNDPREP", "ac_physics", 
# "chunk_to_block", "block_to_chunk"

# Turn it into an igraph object
network <- graph_from_data_frame(d=links, directed=F)
coords <- matrix(c(30,10,30,8 ,1 ,15,15,30,42,50,1,15,30,
                   30,26,22,20,15,15,10,15,22,26,10,5,5),
                 nrow= 13, ncol=2)
# Parameters can be found here: https://igraph.org/r/doc/plot.common.html
plot(network, main=expression("Timer differences " * Delta ~ "between tagged and non tagged runs"),
     sub="Dependencies depicted through layers",
     # === layout
     layout=coords,
     # === edges and arrows
     edge.width=2.5, 
     edge.color="grey60",
     # === Vertex
     vertex.color=c("#B1DDF0", "#B1DDF0",  "#B1DDF0", "#5bab7d", "#5bab7d", "#5bab7d", "#5bab7d",  "#B1DDF0",
                    "#CBAADB", "#B1DDF0", "#5bab7d",  "#5bab7d", "#B1DDF0"),
     vertex.frame.color=c("#B1DDF0", "#B1DDF0",  "#B1DDF0", "#5bab7d", "#5bab7d", "#5bab7d", "#5bab7d",  "#B1DDF0",
                          "#CBAADB", "#B1DDF0", "#5bab7d",  "#5bab7d", "#B1DDF0"),
     vertex.label.family="sans", 
     vertex.label.dist=1, 
     vertex.label.color="black",
     vertex.size=5*c(wc_above[1], wc_above[11], 0.5, wc_above[12:13], wc_above[18], 
                    wc_above[19], wc_above[25], wc_above[2], wc_above[4], wc_above[17],
                    wc_above[20], wc_above[26]))
legend("bottomright", legend = c(expression("" * Delta ~ "< 3") , expression("5 <" *~Delta ~ "< 7"), expression("" * Delta ~ "> 9")), col=c( "#B1DDF0", "#5bab7d", "#CBAADB"),
       pch=16)

print(network, v=TRUE, e=TRUE)
