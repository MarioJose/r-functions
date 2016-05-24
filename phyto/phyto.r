# Function for calculate phytosociological table
# Version: 1.2.0
# https://github.com/MarioJose/r-functions/tree/master/phyto

phyto <- function(x, filter = NULL, area = NULL, criteria = NULL, measure = NULL, incDead = TRUE, nmDead = "Dead", diversity = TRUE, evenness = TRUE){
  # x must be data frame with: plot, family, specie, diameter, (height).
  #   It must be in this order, but not necessarily with this names. Height is
  #   optional
  
  # Checking input
  # ++++++++++++++
  
  if(!is.data.frame(x)){
    stop("'x' must be a data frame")
  } else {
    if(dim(x)[2] < 4 | dim(x)[2] > 5){
      stop("Your data frame must have at least 4 columns with the follow data at the same order: 'plot', 'family', 'specie', 'diameter'. The column 'height' is optional")
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
  
  # Convert family and species column to character
  x[ ,2] <- as.character(x[ ,2])
  x[ ,3] <- as.character(x[ ,3])
  
  # Remove dead individuals (column 'specie')
  if(!incDead){
    didx <- grep(nmDead , x[ ,3])
    x <- x[-didx, ]
    print(paste("Removed", length(didx), "individual named as", nmDead))
  }


  # Functions
  # +++++++++
  
  # Split multiple diameter or height and return diameter of total basal area of
  # each individual or mean height of each individual
  splitMultiple <- function(x, m){
    
    if(!is.numeric(x)) tmp <- as.numeric(unlist(strsplit(x , "+", TRUE)))
    else tmp <- x

    # Return diameter of total basal area
    if(m == "d") out <- sqrt(4 * sum((pi * (tmp ^ 2)) / 4) / pi)

    # Convert circunference and return diameter of total basal area
    if(m == "c") out <- sqrt(4 * sum((tmp ^ 2) / (4 * pi)) / pi)

    # Return mean of height
    if(m == "h") out <- mean(tmp)
    
    return(out)
  }
  
  # Shannon and Simpson diversity index
  shannon_fn <- function(x){
    p <- x / sum(x)
    H <- -sum(p * log(p))    
    # Variance as Hutcheson (1970)
    varH <- ((sum(p * (log(p)^2)) - sum(p * log(p))^2) / sum(x)) + ((length(x) - 1) / (2 * (length(x)^2)))
    
    return(c(H = H, varH = varH))
  }
  
  simpson_fn <- function(x, var = FALSE){
    # As Simpson (1949)
    N <- sum(x)
    p <- x / N
    D <- sum(x * (x - 1)) / (N * (N - 1))
    varD <- ( 4*N*(N - 1)*(N - 2)*sum(p^3) + 2*N*(N - 1)*sum(p^2) - 2*N*(N - 1)*(2*N - 3)*(sum(p^2)^2) ) / (N*(N - 1))^2
    # if N be very large, approximately 
    #varD <- (4/N) * ( (sum(p^3)) - (sum(p^2))^2 );
    
    return(c(D = D, varD = varD))
  }
  
  # Evar and E1/D evenness index
  evenness_fn <- function(x){
    # As Smith & Wilson (1996)

    mulog <- sum(log(x)) / length(x)
    # 0 = minimum eveness
    Evar <- 1 - (2 / pi) * atan( sum((log(x) - mulog)^2) / length(x) )
    E1D <- (1 / simpson_fn(x)[["D"]]) / length(x)
    
    return(c(Evar = Evar, E1D = E1D))
  }

  
  # Checking data
  # +++++++++++++
  
  # Columns names
  colnames(x) <- c("plot", "family", "specie", "diameter", "height")[1:dim(x)[2]]
  
  # Create column with genus
  x$genus <- sapply(x$specie, function(x) strsplit(x, " ")[[1]][1])
  
  # Order data frame
  x <- x[, c(1:2, dim(x)[2], 3:(dim(x)[2] - 1))] 
  
  # Standardize measure to diameter. Split multiples measures and return 
  # diameter of total basal area to individual
  if(is.character(x$diameter) | is.factor(x$diameter))
    x$diameter <- sapply(as.character(x$diameter), splitMultiple, m = measure)
  else if(measure == "c") x$diameter <- x$diameter / pi
  
  # Standardize height. Split multiples measures and return mean of height to
  #   individual
  if(dim(x)[2] == 6)
    if(is.character(x$height) | is.factor(x$height))
      x$height <- sapply(as.character(x$height), splitMultiple, m = "h")
  
  # Filter by inclusion criteria
  cidx <- x$diameter >= criteria
  x <- x[cidx, ]
  
  if(dim(x)[1] < 1) stop("Your criteria removed all individuals")
  else print(paste("Removed", length(cidx) - sum(cidx), "individual(s) by criteria", criteria))
  
  
  # Calculate parameters 
  # ++++++++++++++++++++
  
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
    
    if(diversity){
      out[ ,c("H", "varH")] <- aggregate(x$specie, by = list(x$plot), FUN = function(x){shannon_fn(table(as.character(x)))})[[2]]
      out[ ,c("D", "varD")] <- aggregate(x$specie, by = list(x$plot), FUN = function(x){simpson_fn(table(as.character(x)))})[[2]]
    }
    
    if(evenness)
      out[ ,c("Evar","E1D")] <- aggregate(x$specie, by = list(x$plot), FUN = function(x){evenness_fn(table(as.character(x)))})[[2]]
    
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
  
  # Convert diameter measure from centimeters to meters
  x$diameter <- x$diameter / 100
  out[ ,"tBasalArea"] <- aggregate(x$diameter, by = list(x[ ,filter]), FUN = function(x){sum((pi * (x^2)) / 4)})$x
  
  if(filter != "plot"){
    out[ ,"AbsDens"] <- out$nInd / area
    out[ ,"RelDens"] <- (out$nInd / sum(out$nInd)) * 100
    
    # Species or genera by plot
    tmp <- aggregate(list(nInd = x[ ,filter]), by = list(filter = x[ ,filter], plot=x$plot), FUN = length)
    out[ ,"nPlot"] <- aggregate(tmp$filter, by = list(tmp$filter), FUN = length)$x
    out[ ,"AbsFreq"] <- (out[ ,"nPlot"] / length(unique(x$plot))) * 100
    out[ ,"RelFreq"] <- (out$AbsFreq / sum(out$AbsFreq)) * 100
    
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
