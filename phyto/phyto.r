phyto <- function(x, filter = NULL, area = NULL, criteria = NULL, measure = NULL, incDead = TRUE, nmDead = "Dead"){
  # x must be data frame with: plot, family, specie, diameter, (height).
  #   It must be in this order, but not necessarily with this names. Height is optional
  
  if(!is.data.frame(x)){
    stop("'x' must be a data frame")
  } else {
    if(dim(x)[2] < 4 | dim(x)[2] > 5){
      stop("Your data frame must have at least 4 columns with the follow data at the same order: 'plot', 'family', 'specie', 'diameter'. The column 'height' is optional")
    }
  }
  
  if(!is.numeric(x[ ,4])){
    stop("'diameter' column must be numeric")
  }
  
  if(length(x[1, ]) == 5){
    if(!is.numeric(x[ ,5])){
      stop("'height' column must be numeric")
    }
  }
  
  if(is.null(filter)){
    stop("You must inform the filter to summarization: 'plot', 'family', 'genus', 'specie'")
  } else {
    if(!(filter %in% c("plot", "family", "genus", "specie"))){
      stop("You must inform one of the follow option to filter: 'plot', 'family', 'genus', 'specie'")
    }
  }
  
  if(is.null(area)){
    stop("You must inform the area sampled")
  }
  
  if(is.null(criteria)){
    stop("You must inform the diameter criteria for individual inclusion")
  }

  if(is.null(measure)){
    stop("You must inform the measure: \"d\" = diameter; \"c\" = circunference")
  } else {
    if(!(measure %in% c("d","c"))){
      stop("You must inform one of the follow option to measure: \"d\" = diameter; \"c\"c = circunferente")
    }
  }
  
  # Functions
  basalArea <- function(v){
    return((pi * (v) ^ 2) / 4)
  }
  
  # Split multiple diameter or height and return diameter of total basal area of each
  #   individual or mean height of each individual.
  splitMultiple <- function(dt, m){
    out <- c()
    for(i in 1:length(dt)){
      if(!is.numeric(dt[i])){
        tmp <- as.numeric(unlist(strsplit(dt[i] , "+", TRUE)))
      } else {
        tmp <- dt[i]
      }
      if(m == "d"){
        # Return diameter of total basal area
        out[i] <- sqrt(4 * sum((pi * (tmp) ^ 2) /4) / pi)
      }
      if(m == "c"){
        # Convert circunference and return diameter of total basal area
        out[i] <- sqrt(4 * sum((tmp ^ 2) / (4 * pi)) / pi)
      }
      if(m == "h") {
        out[i] <- mean(tmp)
      }
    }
    return(out)
  }
  
  # Columns names
  colnames(x) <- c("plot", "family", "specie", "diameter", "height")[1:dim(x)[2]]
  
  # Create column with genus
  x$genus <- sapply(strsplit(as.character(x$specie), " "), function(x) x[1])
  
  # Order data frame
  x <- x[, c(1:2, dim(x)[2], 3:(dim(x)[2] - 1))] 
  
  # Standardize diameter. Split multiples measures and return diameter 
  #   of total basal area to individual
  if(is.character(x$diameter) | is.factor(x$diameter)){
    x$diameter <- splitMultiple(as.character(x$diameter), m = measure)
  }
  
  # Standardize height. Split multiples measures and return mean of height to individual
  if(dim(x)[2] == 6){
    if(is.character(x$height) | is.factor(x$height)){
      x$height <- splitMultiple(as.character(x$height), m = "h")
    }
  }
  
  # Filter by inclusion criteria
  x <- x[x$diameter >= criteria, ]
  
  if(dim(x)[1] < 1){
    stop("Your criteria removed all individuals")
  }
  
  # Remove dead
  if(!incDead){
    x <- x[-grep(nmDead , x$specie), ]
  }
  
  # Create output data frame
  out <- aggregate(list(nInd = x$specie), by = list(c1 = x[ ,filter]), FUN = length)
  colnames(out) <- c(filter, "nInd")
  
  # Add families
  if(filter %in% c("genus", "specie")){
    tf <- aggregate(list(nInd = x[ ,filter]), by = list(family = x$family, filter = x[ ,filter]), FUN = length)
    out$family <- tf$family[match(out[ ,filter], tf$filter)]
    out <- out[ ,c("family", filter, "nInd")]
  }
  
  if(filter == "plot"){
    # Number of families per plot
    out[ ,"nFamilies"] <- aggregate(x$family, by = list(x$plot), FUN = function(x){length(unique(x))})$x
    
    # Number of genera per plot
    out[ ,"nGenera"] <- aggregate(x$genus, by = list(x$plot), FUN = function(x){length(unique(x))})$x
    
    # Number of species per plot
    out[ ,"nSpecies"] <- aggregate(x$specie, by = list(x$plot), FUN = function(x){length(unique(x))})$x
  }
  
  if(filter == "family"){
    # Number of genera per family
    out[ ,"nGenera"] <- aggregate(x$genus, by = list(x$family), FUN = function(x){length(unique(x))})$x
    
    # Number of species per family
    out[ ,"nSpecies"] <- aggregate(x$specie, by = list(x$family), FUN = function(x){length(unique(x))})$x
  }

  if(filter == "genus"){
    # Number of species per genus
    out[ ,"nSpecies"] <- aggregate(x$specie, by = list(x$genus), FUN = function(x){length(unique(x))})$x
  }
  
  if(filter != "plot"){
    out[ ,"AbsDens"] <- out$nInd / area
    out[ ,"RelDens"] <- (out$nInd / sum(out$nInd)) * 100
    
    # Species or genera by plot
    tmp <- aggregate(list(nInd = x[ ,filter]), by = list(filter = x[ ,filter], plot=x$plot), FUN = length)
    out[ ,"nPlot"] <- aggregate(tmp$filter, by = list(tmp$filter), FUN = length)$x
    out[ ,"AbsFreq"] <- (out[ ,"nPlot"] / length(unique(x$plot))) * 100
    out[ ,"RelFreq"] <- (out$AbsFreq / sum(out$AbsFreq)) * 100
    
    # Convert diameter measure from centimeters to meters
    x$diameter <- x$diameter / 100
    out[ ,"tBasalArea"] <- aggregate(x$diameter, by = list(x[ ,filter]), FUN = function(x){sum(basalArea(x))})$x
    out[ ,"AbsDom"] <-  out[ ,"tBasalArea"] / area
    out[ ,"RelDom"] <- (out[ ,"tBasalArea"] / sum(out[ ,"tBasalArea"])) * 100
    
    out[ ,"IVI"] <- out$RelDens + out$RelFreq + out$RelDom
    out[ ,"CVI"] <- out$RelDens + out$RelDom
  }
  
  if(length(x[1, ]) == 6){
    out[ ,"meanHeight"] <- aggregate(x[ ,6], by = list(x[ ,filter]), FUN = mean)$x
    out[ ,"sdHeight"] <- aggregate(x[ ,6], by = list(x[ ,filter]), FUN = sd)$x
  }
  
  return(out)
}
