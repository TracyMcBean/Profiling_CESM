# Visualize profiling data
rm(list=ls())

require(splines)
source("./CESM_prof.R")
source("./plot_functions.R")

#### ---------------------------------------------------------------------------------

# get data and save in data frames
prof_data <- get_data()

prof_tagged_df <- prof_data[[2]]
prof_not_df <- prof_data[[1]]

ndays5_tag <- subset(prof_tagged_df, NDays == 5 )
ndays10_tag <- subset(prof_tagged_df, NDays == 10)

ndays5_notag <- subset(prof_not_df, NDays == 5 )
ndays10_notag <- subset(prof_not_df, NDays == 10)

# reset par
dev.off()

#### PLOTS ####-------------------------------------------------------------------------
saveVar <- FALSE
# Set isTagged to TRUE for tagged title
# Total duration
plot_5vs10_single(ndays5_tag$Cores, ndays5_tag$Dur_tot, ndays10_tag$Cores,
                  ndays10_tag$Dur_tot, isTagged=TRUE, "Total Duration", isSaved=saveVar, "5vs10_dur_tot_tag")

# Init duration
plot_5vs10_single(ndays5_tag$Cores, ndays5_tag$Dur_init, ndays10_tag$Cores,
                  ndays10_tag$Dur_init,TRUE, "Initialization Duration", saveVar, "5vs10_dur_init_tag")

# Run duration
plot_5vs10_single(ndays5_tag$Cores, ndays5_tag$Dur_run, ndays10_tag$Cores,
                  ndays10_tag$Dur_run, TRUE, "Run Duration",  saveVar, "5vs10_dur_run_tag")

# Fin duration
plot_5vs10_single(ndays5_tag$Cores, ndays5_tag$Dur_fin, ndays10_tag$Cores,
                  ndays10_tag$Dur_fin, TRUE, "Finish Duration",  saveVar, "5vs10_dur_fin_tag")

### Throughput and Cost ###--------------------------------------------------------------
# See page 43 of CESM user guide 1.2 for explanation
plot_5vs10_flex(ndays5_tag$Cores, ndays5_tag$Throughput, ndays10_tag$Cores,
                  ndays10_tag$Throughput, ytext="Simulated_years / day ", isTagged=TRUE,
                "Throughput", saveVar, "5vs10_troughput_tagged")
# Cost
# The cost is expected to increase if using more cores for CESM
plot_5vs10_flex(ndays5_tag$Cores, ndays5_tag$Cost, ndays10_tag$Cores,
                ndays10_tag$Cost, ytext="pe-hrs/simulated_years", isTagged=TRUE,
                "Cost",  saveVar, "5vs10_cost_tagged")


### Plots both ####--------------------------------------------------------------
saveVar <- FALSE
# Total duration
plot_5vs10_all(ndays5_notag$Cores, ndays5_notag$Dur_tot, ndays10_notag$Cores,
                  ndays10_notag$Dur_tot, ndays5_tag$Cores, ndays5_tag$Dur_tot, ndays10_tag$Cores,
                  ndays10_tag$Dur_tot, "Total Duration", saveVar, "5vs10_dur_tot_both")

# Init duration
plot_5vs10_all(ndays5_notag$Cores, ndays5_notag$Dur_init, ndays10_notag$Cores,
               ndays10_notag$Dur_init, ndays5_tag$Cores, ndays5_tag$Dur_init, ndays10_tag$Cores,
               ndays10_tag$Dur_init, "Initialization Duration",  saveVar, "5vs10_dur_init_both")

# Run duration
plot_5vs10_all(ndays5_notag$Cores, ndays5_notag$Dur_run, ndays10_notag$Cores,
               ndays10_notag$Dur_run, ndays5_tag$Cores, ndays5_tag$Dur_run, ndays10_tag$Cores,
               ndays10_tag$Dur_run, "Run Duration",  saveVar, "5vs10_dur_run_both")

# Fin duration
plot_5vs10_all(ndays5_notag$Cores, ndays5_notag$Dur_fin, ndays10_notag$Cores,
               ndays10_notag$Dur_fin, ndays5_tag$Cores, ndays5_tag$Dur_fin, ndays10_tag$Cores,
               ndays10_tag$Dur_fin, "Finish Duration",  saveVar, "5vs10_dur_fin_both")

#### Fitting ####-----------------------------------------------------------------------------
xarg <- ndays5_notag$Cores
yarg <- ndays5_notag$Throughput
xarg2 <- ndays10_notag$Cores
yarg2 <- ndays10_notag$Throughput
xarg3 <- ndays5_tag$Cores
yarg3 <- ndays5_tag$Throughput
xarg4 <- ndays10_tag$Cores
yarg4 <- ndays10_tag$Throughput

#fit_5d_notag <- lm(Dur_tot ~ bs(Cores, knots = c(28,112,196)), data = ndays5_notag)

plot(xarg, yarg, pch=2, type = "p", col="darkblue", ylim=c(min(c(yarg,yarg2, yarg3, yarg4)), max(c(yarg,yarg2, yarg3, yarg4)) ),
     main= "Throughput tagged vs no tags", xlab="Number of cores", ylab="Simulated_years / day ", xaxt="n")
axis(1, at=c(28,56,84,112,140,168,196, 224))
abline(v=c(28,56,84,112,140,168,196, 224), col = "lightgray", lty = "dotted", 
       lwd=1)
abline(h=seq(0,2,0.5), col = "lightgray", lty = "dotted", 
       lwd=1)
points(xarg2, yarg2, pch=2, type = "p", col="red")
points(xarg3, yarg3, pch=16, type = "p", col="darkblue")
points(xarg4, yarg4, pch=16, type = "p", col="red")
legend("topleft", legend = c("5 days no tags", "10 days no tags", "5 days tagged", "10 days tagged"),
       col= c("darkblue", "red", "darkblue", "red"), pch = c(2, 2, 16, 16), bty = "n")


# spline with 3 degrees of freedom
sspline_5_not <- smooth.spline(xarg, yarg, df=3)
sspline_5_tag <- smooth.spline(xarg3, yarg3, df=3)
sspline_10_not <- smooth.spline(xarg2, yarg2, df=3)
sspline_10_tag <- smooth.spline(xarg4, yarg4, df=3)
lines(sspline_10_tag, col="red", lty = 3); 
lines(sspline_5_tag, col="darkblue", lty = 3);
lines(sspline_10_not, col="red", lty = 2); 
lines(sspline_5_not, col="darkblue", lty = 2)
