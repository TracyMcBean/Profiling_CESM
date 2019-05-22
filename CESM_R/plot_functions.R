# File with plotting functions

#' Plots 5 days vs 10 days value of either the tagged or non tagged sets
#' 
#' @param xarg Data for the x axis
#' @param yarg Data for the y axis
#' @param xarg2 Second set of data for the x axis
#' @param yarg2 Second set of data for the y axis
#' @param isTagged Logical value is this a tagged set or not 
#' @param title Character string containing measured variable
#' @param isSaved Logical, Shall the plot be saved or not
#' @param filename Character string containing name of save plot
plot_5vs10_single <- function(xarg, yarg, xarg2=xarg, yarg2=yarg, isTagged=FALSE, title=NA, isSaved=FALSE, filename=""){
  
  if (isTagged == TRUE){
    main_title = paste(title, "(tagged)")
  } else {
    main_title = paste(title, "(no tags)")
  }
  
  if (isSaved == TRUE){
    png(filename = paste("/home/tracy/Documents/IASS/Profiling_CESM/CESM_R/Plots/", filename, ".png", sep = ""))
  }
  
  plot(xarg, yarg, pch=15, type = "p", col="darkblue", ylim=c(min(c(yarg,yarg2)), max(c(yarg,yarg2)) ),
       main= main_title, xlab="Number of cores", ylab="Duration in seconds", xaxt="n")
  points(xarg2, yarg2, pch=16, type = "p", col="red")
  legend("topright", legend = c("5 days", "10 days"), col= c("darkblue", "red"), pch = c(15, 16),
         bty="n")
  axis(1, at=c(28,56,84,112,140,168,196, 224))
   
  
  if (isSaved == TRUE){
    dev.off()
  }
}


#' Plots 5 days vs 10 days value of both the tagged or non tagged sets
#' 
#' @param xarg Data for the x axis
#' @param yarg Data for the y axis
#' @param xarg2 Second set of data for the x axis
#' @param yarg2 Second set of data for the y axis
#' @param xarg3 Tagged data for the x axis
#' @param yarg3 Tagged data for the y axis
#' @param xarg4 Second tagged set of data for the x axis
#' @param yarg4 Second tagged set of data for the y axis
#' @param title Character string containing measured variable
#' @param isSaved Logical, Shall the plot be saved or not
#' @param filename Character string containing name of save plot
plot_5vs10_all <- function(xarg, yarg, xarg2, yarg2, xarg3, yarg3, xarg4, yarg4, title, isSaved=FALSE, filename=""){
  
  if (isSaved == TRUE){
    png(filename = paste("/home/tracy/Documents/IASS/Profiling_CESM/CESM_R/Plots/", filename, ".png", sep = ""))
  }
  
  plot(xarg, yarg, pch=2, type = "p", col="darkblue", ylim=c(min(c(yarg,yarg2, yarg3, yarg4)), max(c(yarg,yarg2, yarg3, yarg4)) ),
       main= paste(title, "tagged vs no tags"), xlab="Number of cores", ylab="Duration in seconds", xaxt="n")
  points(xarg2, yarg2, pch=2, type = "p", col="red")
  points(xarg3, yarg3, pch=16, type = "p", col="darkblue")
  points(xarg4, yarg4, pch=16, type = "p", col="red")
  legend("topright", legend = c("5 days no tags", "10 days no tags", "5 days tagged", "10 days tagged"),
         col= c("darkblue", "red", "darkblue", "red"), pch = c(2, 2, 16, 16), bty = "n")
  axis(1, at=c(28,56,84,112,140,168,196, 224))
  grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted",
       lwd =1, equilogs = TRUE)
  # TODO: Add grid to make reading easier.
  
  if (isSaved == TRUE){
    dev.off()
  }
}

# Same as plot_5vs10_single but axis label is dynamic.
#' @param ytext label of y axis
plot_5vs10_flex <- function(xarg, yarg, xarg2=xarg, yarg2=yarg, ytext="", isTagged=FALSE, title=NA, isSaved=FALSE, filename=""){
  
  if (isTagged == TRUE){
    main_title = paste(title, "(tagged)")
  } else {
    main_title = paste(title, "(no tags)")
  }
  
  if (isSaved == TRUE){
    png(filename = paste("/home/tracy/Documents/IASS/Profiling_CESM/CESM_R/Plots/", filename, ".png", sep = ""))
  }
  
  plot(xarg, yarg, pch=15, type = "p", col="darkblue", ylim=c(min(c(yarg,yarg2)), max(c(yarg,yarg2)) ),
       main= main_title, xlab="Number of cores", ylab=ytext, xaxt="n")
  points(xarg2, yarg2, pch=16, type = "p", col="red")
  legend("topright", legend = c("5 days", "10 days"), col= c("darkblue", "red"), pch = c(15, 16),
         bty="n")
  axis(1, at=c(28,56,84,112,140,168,196, 224))
  
  
  if (isSaved == TRUE){
    dev.off()
  }
}
