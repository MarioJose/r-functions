# Function to calculate phytosociological table
# Autor: Mario José Marques-Azevedo
# email: gnumario [at] gmail [dot] com
# Licence: GPLv3

phyto <- function(x, filter = NULL, area = NULL, criteria = NULL, incDead = TRUE, nmDead = "Dead"){
  # x must be data frame with: plot, family, specie, diameter, (height).
  #   It must be in this order, but not necessarily with this names. Height is optional
  
  if(!is.data.frame(x)){
    stop("'x' must be a data frame")
  } else {
    if(length(x[1, ]) < 4 | length(x[1, ]) > 5){
      stop("Your data frame must have at least 4 columns with the follow data at the same order: 'plot', 'family', 'specie', 'diameter'.The column 'height' is optional")
    }
  }
  
  if(is.null(filter)){
    stop("You must inform the filter to summarization: 1 = plot; 2 = family; 3 = specie")
  } else {
    if(!(filter %in% 1:3)){
      stop("You must inform one of the follow option to filter: 1 = plot; 2 = family; 3 = specie")
    }
  }
  
  if(is.null(area)){
    stop("You must inform the area sampled")
  }
  
  if(is.null(criteria)){
    stop("You must inform the diameter criteria for individual inclusion")
  }
  
  # Functions
  basalArea <- function(x){
    return((pi * (x) ^ 2) / 4)
  }
  
  # Split multiple diameter or height and return diameter of total basal area of each
  #   individual or mean height of each individual.
  splitMultiple <- function(x, d){
    out <- c()
    for(i in 1:length(x)){
      if(!is.numeric(x[i])){
        tmp <- as.numeric(unlist(strsplit(x[i] , "+", TRUE)))
      } else {
        tmp <- x[i]
      }
      if(d){
        # Return diameter of total basal area
        out[i] <- sqrt(4 * sum((pi * (tmp) ^ 2) /4) / pi)
      } else {
        out[i] <- mean(tmp)
      }
    }
    return(out)
  }
  
  # filter: 1=plot, 2=family, 3=specie
  idxName <- c("plot", "family", "specie")
  
  # Standardize diameter. Split multiples measures and return diameter 
  #   of total basal area to individual
  x[ ,4] <- splitMultiple(x[ ,4], d = TRUE)
  
  # Standardize height. Split multiples measures and return mean of height to individual
  x[ ,5] <- splitMultiple(x[ ,5], d = FALSE)
  
  # Filter by inclusion criteria
  x <- x[x[ ,4] >= criteria, ]
  
  if(length(x[ ,1]) < 1){
    stop("Your criteria removed all individuals")
  }
  
  # Remove dead
  if(!incDead){
    x[-grep(nmDead , x[ ,3]), ]
  }
  
  out <- aggregate(list(nInd = x[ ,3]), by = list(c1 = x[ ,filter]), FUN = length)
  colnames(out) <- c(idxName[filter], "nInd")
  
  tmp <- aggregate(list(nInd = x[ ,filter]), by = list(c1 = x[ ,filter], plot=x[ ,1]), FUN = length)
  colnames(tmp) <- c(idxName[filter], "plot", "nInd")

  if(filter == 1){
    out[ ,"nFamilies"] <- aggregate(x[ ,2], by = list(x[ ,1]), FUN = function(x){length(unique(x))})$x
    out[ ,"nSpecies"] <- aggregate(x[ ,3], by = list(x[ ,1]), FUN = function(x){length(unique(x))})$x
  }
  
  if(filter == 2){
    out[ ,"nSpecies"] <- aggregate(x[ ,3], by = list(x[ ,2]), FUN = function(x){length(unique(x))})$x
  }
  
  if(filter != 1){
    out[ ,"AbsDens"] <- out$nInd / area
    out[ ,"RelDens"] <- out$nInd / sum(out$nInd)
    
    out[ ,"Freq"] <- aggregate(tmp[ ,1], by = list(tmp[ ,1]), FUN = length)$x
    out[ ,"AbsFreq"] <- out[ ,"Freq"] / length(unique(x[ ,1]))
    out[ ,"RelFreq"] <- out$AbsFreq / sum(out$AbsFreq)
    
    # Convert diameter measure from centimeters to meters
    x[ ,4] <- x[ ,4] / 100
    out[ ,"tBasalArea"] <- aggregate(x[ ,4], by = list(x[ ,filter]), FUN = function(x){sum(basalArea(x))})$x
    out[ ,"AbsDom"] <-  out[ ,"tBasalArea"] / area
    out[ ,"RelDom"] <- out[ ,"tBasalArea"] / sum(out[ ,"tBasalArea"])
    
    out[ ,"IVI"] <- out$RelDens + out$RelFreq + out$RelDom
    out[ ,"IVC"] <- out$RelDens + out$RelDom
  }
  
  if(length(x[1, ]) == 5){
    out[ ,"meanHeight"] <- aggregate(x[ ,5], by = list(x[ ,filter]), FUN = mean)$x
    out[ ,"sdHeight"] <- aggregate(x[ ,5], by = list(x[ ,filter]), FUN = sd)$x
  }
  
  return(out)
}
