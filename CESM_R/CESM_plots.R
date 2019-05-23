# Visualize profiling data
rm(list=ls())

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
                  ndays10_tag$Throughput, ytext="Simulated_years / day ", isTagged=TRUE, "Throughput", saveVar, "5vs10_troughput_tagged")
# Cost
# The cost is expected to increase if using more cores for CESM
plot_5vs10_flex(ndays5_tag$Cores, ndays5_tag$Cost, ndays10_tag$Cores,
                ndays10_tag$Cost, ytext="pe-hrs/simulated_years", isTagged=TRUE, "Cost",  saveVar, "5vs10_cost_tagged")


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

