# Profiling data CESM 1

#-------------------------------------------------------------------------------------------#
# Content of case data:
# case:     Name of case
# tagged:   Tagged mechanism (0=NO/1=YES)
# cores:    Number of cores
# ndays:    Number of simulated days
# dur_init: Duration of initialization [s]
# dur_run:  Duration of run [s]
# dur_fin:  Duration of finalization
# duration_tot: Duration of total computation [s]
# cost:     Model cost [pe-hrs/simulated_yrs]
# throughput: Throughput of [simulation simulated_yrs/day]
# ID:       Starting time
#
# Combining the case and the starting time gives the unique identifier for each run.
# Eg.: test_190515_1 and 101006 means that the relevant files for that run are marked with 101006
# data array name: 
# run_AABBCC with AA run ID (01-04), BB cores, CC ndays
#--------------------------------------------------------------------------------------------#

#'Save data of runs into dataframe.
#'
get_data <- function(){
  run_015601 <- c("test_190515_1", 1, 56, 1, 407.483, 2810.483, 0.114, (407.483+2810.483+0.114), 15957.30, 0.08, "100256")
  run_015605 <- c("test_190515_1", 1, 56, 5, 348.113, 11986.458, 0.084, (348.113+11986.458+0.084), 13611.29, 0.10 , "112230")
  run_018405 <- c("test_190515_1", 1, 84, 5, 43.779, 2342.394, 0.025, (43.779+2342.394+0.025), 3989.88, 0.51, "160758")
  run_0111205 <- c("test_190515_1", 1, 112, 5, 64.100, 2934.124, 0.020, (64.100+2934.124+0.020), 6663.72, 0.40, "095004")
  run_0111210 <- c("test_190515_1", 1, 112, 10, 42.054, 4073.074, 0.022, (42.054+4073.074+0.022), 4625.20, 0.58, "123658")
  run_0114010 <- c("test_190515_1", 1, 140, 10, 948.187, 12534.565, 0.071, (948.187+12534.565+0.071), 17792.12, 0.19, "113255")
  run_0122410 <- c("test_190515_1", 1, 224, 10, 139.575, 6648.940, 0.077, (139.575+6648.940+0.077), 15100.48, 0.36, "115631")
  run_0122405 <- c("test_190515_1", 1, 224, 5, 66.299, 2256.704, 0.022, (66.299+2256.704+0.022), 10250.45, 0.52, "094444")
  run_0122401 <- c("test_190515_1", 1, 224, 1, 56.616, 512.651, 0.018, (56.616+512.651+0.018), 11642.87, 0.46, "103838")
  run_0119610 <- c("test_190515_1", 1, 196, 10, 54.925, 5009.043, 0.018, (54.925+5009.043+0.018), 9954.08, 0.47, "111813")
  run_0119605 <- c("test_190515_1", 1, 196, 5, 50.167, 2591.286, 0.021, (50.167+2591.286+0.021), 10298.92, 0.46, "204830")
  run_0119601 <- c("test_190515_1", 1, 196, 1, 51.437, 550.663, 0.035, (51.437+550.663+0.035), 10942.89, 0.43, "214334")
  run_012805 <- c("test_190515_1", 1, 28, 5, 46.053, 5067.374, 0.045, (46.053+5067.374+0.045), 2877.14, 0.23, "113921")
  run_012810 <- c("test_190515_1", 1, 28, 10, 49.311, 9430.567, 0.047, (49.311+9430.567+0.047), 2677.23, 0.25, "140026")
  run_015610 <- c("test_190515_1", 1, 56, 10, 36.112, 9572.090, 0.029, (36.112+9572.090+0.029), 5434.82, 0.25, "181204")
  run_018410 <- c("test_190515_1", 1, 84, 10, 41.736, 6314.646, 0.026, (41.736+6314.646+0.026), 5377.97, 0.37, "094851")
  run_0114010_2 <- c("test_190515_1", 1, 140, 10, 69.488, 6058.157, 0.20, (69.488+6058.157+0.20), 8599.22, 0.39, "114744")
  run_0114005 <- c("test_190515_1", 1, 140, 5, 58.918, 2944.369, 0.031, (58.918+2944.369+0.031), 8358.74, 0.40, "134459")
  run_015605_2 <- c("test_190515_1", 1, 56, 5, 33.529, 4712.964, 0.081, (33.529+4712.964+0.081), 5351.83, 0.25, "144738")
  run_015610_2 <- c("test_190515_1", 1, 56, 10, 42.072, 9254.271, 0.041, (42.072+9254.271+0.041), 5254.37, 0.26, "083656")
  run_015610_3 <- c("test_190515_1", 1, 56, 10, 47.257, 8680.38, 0.275, (47.257+8680.38+0.275), 4928.33, 0.27, "174343")
  run_0116810 <- c("test_190515_1", 1, 168, 10, 40.657, 3390.145, 0.024,(40.657+3390.145+0.024), 5774.55, 0.70,"091805")
  run_0116805 <- c("test_190515_1", 1, 168, 5, 42.405, 1631.437, 0.019, (42.405+1631.437+0.019), 5557.76, 0.73, "130425")
  
  run_025601 <- c("test_190515_2", 0, 56, 1, 35.345, 225.224, 0.018, (35.345+225.224+0.018), 1278.77, 1.05, "101006")
  run_025605 <- c("test_190515_2", 0, 56, 5, 31.013, 1103.814, 0.017, (31.013+1103.814+0.017), 1253.44 , 1.07, "105339")
  run_028405 <- c("test_190515_2", 0, 84, 5, 78.896, 1553.196, 0.020, (78.896+1553.196+0.020), 2645.61, 0.76, "093632")
  run_0211205 <- c("test_190515_2", 0, 112, 5, 35.486, 704.287, 0.015, (35.486+704.287+0.015), 1599.51, 1.86, "113246")
  run_0211210 <- c("test_190515_2", 0, 112, 10, 29.676, 1435.667, 0.016, (29.676+1435.667+0.016), 1630.28, 1.65, "120848")
  run_022801 <- c("test_190515_2", 0, 28, 1, 22.505, 304.565, 0.022, (22.505+304.565+ 0.022), 864.63, 0.78, "112213" )
  run_022805 <- c("test_190515_2", 0, 28, 5, 35.214, 1337.747, 0.023, (35.214+1337.747+0.023), 759.54, 0.88, "115727")
  run_0222410<- c("test_190515_2", 0, 224, 10,  66.701,  2408.698, 0.013, (66.701+2408.698+0.013), 5470.42,  0.98, "155302")
  run_0222405 <- c("test_190515_2", 0, 224, 5, 61.807, 960.428, 0.026, (61.807+960.428+0.026), 4362.48, 1.23, "164356")
  run_0219605 <- c("test_190515_2", 0, 196, 5, 42.476, 1021.120, 0.031, (42.476+1021.120+0.031), 4058.39, 1.16, "202752")
  run_0219610 <- c("test_190515_2", 0, 196, 10, 37.347, 2028.238, 0.013, (37.347+2028.238+0.013), 4030.56, 1.17, "225842")
  run_0216810 <- c("test_190515_2", 0, 168, 10, 38.995, 1905.249, 0.029, (38.995+1905.249+ 0.029),  3245.27, 1.24, "100705")
  run_0216805 <- c("test_190515_2", 0, 168, 5, 38.675, 967.417, 0.013, (38.675+ 967.417+ 0.013), 3295.67, 1.22, "105507")
  run_0214005 <- c("test_190515_2", 0, 140, 5, 35.456, 1069.512, 0.008, (35.456+1069.512+ 0.008), 3036.22, 1.11, "112847")
  run_0214010 <- c("test_190515_2", 0, 140, 10, 34.518, 2164.423, 0.033, (34.518+2164.423+0.033), 3072.28, 1.09, "115041")
  run_028410 <- c("test_190515_2", 0, 84, 10, 20.210, 1657.025, 0.017, (20.210+1657.025+ 0.017), 1411.23, 1.43, "135839")
  run_028405_2 <- c("test_190515_2", 0, 84, 5, 19.495, 811.968, 0.012, (19.495+811.968+0.012), 1383.05, 1.46, "143315")
  run_025610 <- c("test_190515_2", 0, 56, 10, 20.580, 2291.347, 0.019, (20.580+2291.347+0.019), 1300.98, 1.03, "150757")
  run_022810 <- c("test_190515_2", 0, 28, 10, 23.4446, 3615.697, 0.024, (23.4446+3615.697+0.024), 1026.43, 0.65, "161950")

  row.names <- c("Case", "Tagged", "Cores", "NDays", "Dur_init", "Dur_run", "Dur_fin", 
                  "Duration_tot", "Cost", "Throughput", "ID")

# tagged runs
  prof_data_tagged <- array(c(run_015601, run_018405, run_0111205, run_0111210, 
                           run_0122410, run_0122405, run_0122401, run_0119610,
                            run_0119605, run_0119601, run_012805, run_012810, run_015610, 
                            run_018410, run_0114010_2, run_0114005, run_015605_2, run_015610_2, 
                            run_015610_3, run_0116810, run_0116805 )
                          , dim = c(length(run_0111205), 21, 1))
  `row.names<-`(prof_data_tagged, row.names)
# No tags 
  prof_data_not <- array(c(run_025601, run_025605, run_028405, run_028405_2, run_0211205, run_0211210,
                         run_022801, run_022805, run_0222410, run_0222405, run_0219605, 
                         run_0219610, run_0216810, run_0216805, run_0214005, run_0214010,
                         run_028410, run_025610, run_022810),
                       dim = c(length(run_0211205),19,1))
  `row.names<-`(prof_data_not, row.names)

# Conversion to data frame
  prof_tagged_df <- data.frame(Case=as.character(prof_data_tagged[1,,1]),
                                Tagged=as.numeric(prof_data_tagged[2,,1]),
                                Cores=as.numeric(prof_data_tagged[3,,1]),
                                NDays=as.numeric(prof_data_tagged[4,,1]),
                                Dur_init=as.numeric(prof_data_tagged[5,,1]),
                                Dur_run=as.numeric(prof_data_tagged[6,,1]),
                                Dur_fin=as.numeric(prof_data_tagged[7,,1]),
                                Dur_tot=as.numeric(prof_data_tagged[8,,1]),
                                Cost=as.numeric(prof_data_tagged[9,,1]),
                                Throughput=as.numeric(prof_data_tagged[10,,1]),
                                ID=as.character(prof_data_tagged[11,,1]),
                                stringsAsFactors=FALSE)
# no tags
  prof_not_df <- data.frame(Case=as.character(prof_data_not[1,,1]),
                             Tagged=as.numeric(prof_data_not[2,,1]),
                             Cores=as.numeric(prof_data_not[3,,1]),
                             NDays=as.numeric(prof_data_not[4,,1]),
                             Dur_init=as.numeric(prof_data_not[5,,1]),
                             Dur_run=as.numeric(prof_data_not[6,,1]),
                             Dur_fin=as.numeric(prof_data_not[7,,1]),
                             Dur_tot=as.numeric(prof_data_not[8,,1]),
                             Cost=as.numeric(prof_data_not[9,,1]),
                             Throughput=as.numeric(prof_data_not[10,,1]),
                             ID=as.character(prof_data_not[11,,1]),
                             stringsAsFactors=FALSE)

  return(list(prof_not_df, prof_tagged_df))
}


#### add_func_data ###--------------------------------------------------------------------------------------
#' Add data from a run to the function list
#' @param filename File where timing data of functions is stored.
#' @param IDvar is the starting time
add_func_data <- function(filename, IDvar){
  
  if (length(subset(func_df, func_df[,1,]==IDvar)) > 0){
    print("ERROR: ID used already!")
  } else {
    timing_data <- read.table(filename, skip = 5, header=TRUE)
    # ErrorID is for checking if run is in data frame containing prof data
    ErrorID <- FALSE
    for (func in 1:length(timing_data$name)){
      
      subset_data <- subset(timing_data, name==func_names[func])
      # Check if function has been called:
      if (length(subset_data$walltotal)== 0){
        print(paste("Run", filename, "did not use following function:"))
        print(paste("Function name:", func_names[func]))
      } else {
        func_df[nrun,6,func] <- subset_data$walltotal
        func_df[nrun,7,func] <- subset_data$wallmax
        func_df[nrun,8,func] <- subset_data$wallmin
      }
      
      subset_prof_data <- as.numeric(subset(prof_tagged_df, ID == IDvar, 
                                            select = c(ID, Tagged, Cores, NDays, Dur_tot)))
      if (is.na(subset_prof_data[1]) ){
        subset_prof_data <- as.numeric(subset(prof_not_df, ID == IDvar,
                                              select = c(ID, Tagged, Cores, NDays, Dur_tot)))
        if (is.na(subset_prof_data[1]) ){
          ErrorID <- TRUE
        }
      }
      
      func_df[nrun,1,func] <- subset_prof_data[1]
      func_df[nrun,2,func] <- subset_prof_data[2]
      func_df[nrun,3,func] <- subset_prof_data[3]
      func_df[nrun,4,func] <- subset_prof_data[4]
      func_df[nrun,5,func] <- subset_prof_data[5]
    }
    if (ErrorID){
      print("ERROR: No fitting ID in input data set from profiling.")
      print(paste("ID:", IDvar))
    }
    # Continue to next run
    nrun <- nrun + 1
  }
  return(list(func_df, nrun))
}

