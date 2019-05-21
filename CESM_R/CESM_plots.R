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

# Set isTagged to TRUE for tagged title
# Total duration
plot_5vs10_single(ndays5_tag$Cores, ndays5_tag$Dur_tot, ndays10_tag$Cores,
                  ndays10_tag$Dur_tot, TRUE, "Total Duration", TRUE, "5vs10_dur_tot_tagged")

# Init duration
plot_5vs10_single(ndays5_tag$Cores, ndays5_tag$Dur_init, ndays10_tag$Cores,
                  ndays10_tag$Dur_init, TRUE, "Initialization Duration",  TRUE, "5vs10_dur_init_tagged")

# Run duration
plot_5vs10_single(ndays5_tag$Cores, ndays5_tag$Dur_run, ndays10_tag$Cores,
                  ndays10_tag$Dur_run, TRUE, "Run Duration",  TRUE, "5vs10_dur_run_tagged")

# Fin duration
plot_5vs10_single(ndays5_tag$Cores, ndays5_tag$Dur_fin, ndays10_tag$Cores,
                  ndays10_tag$Dur_fin, TRUE, "Finish Duration",  TRUE, "5vs10_dur_fin_tagged")

### Throughput ###--------------------------------------------------------------
# See page 43 of CESM user guide 1.2 for explanation
plot(ndays5_notag$Cores, ndays5_notag$Throughput)
plot(ndays5_notag$Cores, ndays5_notag$Cost)

### Plots both ####--------------------------------------------------------------
# Total duration
plot_5vs10_all(ndays5_notag$Cores, ndays5_notag$Dur_tot, ndays10_notag$Cores,
                  ndays10_notag$Dur_tot, ndays5_tag$Cores, ndays5_tag$Dur_tot, ndays10_tag$Cores,
                  ndays10_tag$Dur_tot, "Total Duration", FALSE, "5vs10_dur_tot_both")

# Init duration
plot_5vs10_all(ndays5_notag$Cores, ndays5_notag$Dur_init, ndays10_notag$Cores,
               ndays10_notag$Dur_init, ndays5_tag$Cores, ndays5_tag$Dur_init, ndays10_tag$Cores,
               ndays10_tag$Dur_init, "Initialization Duration", FALSE, "5vs10_dur_init_both")

# Run duration
plot_5vs10_all(ndays5_notag$Cores, ndays5_notag$Dur_run, ndays10_notag$Cores,
               ndays10_notag$Dur_run, ndays5_tag$Cores, ndays5_tag$Dur_run, ndays10_tag$Cores,
               ndays10_tag$Dur_run, "Run Duration", FALSE, "5vs10_dur_run_both")

# Fin duration
plot_5vs10_all(ndays5_notag$Cores, ndays5_notag$Dur_fin, ndays10_notag$Cores,
               ndays10_notag$Dur_fin, ndays5_tag$Cores, ndays5_tag$Dur_fin, ndays10_tag$Cores,
               ndays10_tag$Dur_fin, "Finish Duration", FALSE, "5vs10_dur_fin_both")

