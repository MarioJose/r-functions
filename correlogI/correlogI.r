correlogI <- function(x, dt, method = "euclidean", nc = NULL, thresh = NULL, alpha = 0.05, tail = "upper", seq.bonferroni = TRUE){
  if(!is.vector(x)) stop("\"x\" must be a vector")
  if(!is.data.frame(dt) & !is.matrix(dt)) stop("\"dt\" must be a data frame or matrix")
  if(length(dt[1, ]) != 2) stop("\"dt\" must have two columns")
  if(length(x) != length(dt[ ,1])) stop("number of \"dt\" rows must be iqual to \"x\" length")
  if(!(is.null(nc) | is.null(thresh))) stop("one of \"nc\" or \"thresh\" must be specified")
  if(sum(tail %in% c("two", "upper", "lower")) == 0) stop("tail must be one of: \"two\", \"upper\", \"lower\"")
    
  # Distance matrix
  D <- as.matrix(dist(dt, method = "euclidean"))
  
  # Number of observations
  n <- dim(D)[1]
  
  if(is.null(nc) & is.null(thresh)){
    # Number of classes: Sturges' rule
    nc <- round(1 + (1/log10(2)) * log10(length(D[upper.tri(D, diag = FALSE)])), 0)
    thresh <- (max(D) / nc)
  }
  
  if(!is.null(thresh)){
    if(thresh >= max(D)) stop(paste("\"thresh\" must be less than maximum distance:", round(max(D), 2)))
    # Define nc by informed threshold distance
    nc <- round(max(D) / thresh, 0)
  }
  
  if(!is.null(nc)){
    # Ensure that nc is integer
    nc <- round(nc, 0)
    thresh <- (max(D) / nc)
  }
  
  # Distance classses (equal length)
  d <- array((1:nc) * thresh, nc, list(1:nc))

  # Data frame with variables to each class
  res <- data.frame(class = 1:nc, distMax = d, I = NA, W = NA, varI = NA)
  if(tail == "two" | tail == "upper"){
    res$Ia.up <- NA
    if(seq.bonferroni == TRUE) res$Ia.up.bonf <- NA
  }
  if(tail == "two" | tail == "lower"){
    res$Ia.lo <- NA
    if(seq.bonferroni == TRUE) res$Ia.lo.bonf <- NA
  }
  res$pvalue <- NA
  res[ ,"."] <- NA

  # Correction to bicaucal test
  if(tail == "two") alpha <- alpha / 2
  
  # For each distance classes
  for(cl in 1:nc){
    # Binary weight
    if(cl == 1) w <- D <= d[cl]
    else w <- D > d[cl - 1] & D <= d[cl]
    
    # Convert logical to numeric and dicart upper triangle, including diagonal (simetric weight matrix)
    w[upper.tri(w, diag = TRUE)] <- 0
    
    # Number of pais in distance class
    res$W[cl] <- sum(w)
    
    # Moran I
    res$I[cl] <- ((1 / res$W[cl]) * sum(w * ((x - mean(x)) %o% (x - mean(x))))) / ((1/n) * sum((x - mean(x))^2))
    
    # Expected I
    EI <- -(n - 1)^-1
    
    # Variance
    S1 <- (1/2) * sum((w + t(w)) ^ 2)
    
    S2 <- sum((apply(w, 1, sum) + apply(w, 2, sum)) ^ 2)
    
    b2 <- (n * sum((x - mean(x)) ^ 4)) / ((sum((x - mean(x)) ^ 2)) ^ 2)
    
    num1 <- n * ( (((n^2) - (3*n) + 3) * S1) - (n*S2) + (3 * (res$W[cl]^2)) )
    num2 <- b2 * ( (((n^2) - n) * S1) - (2*n*S2) + (6 * (res$W[cl]^2)) )
    den <- (n-1) * (n-2) * (n-3) * (res$W[cl]^2)
    
    res$varI[cl] <- ((num1 - num2) / den) - (EI ^ 2)
    
    # Correction to small n
    if((4 * (n - sqrt(n))) < res$W[cl] & res$W[cl] <= (4 * ((2*n) - (3*sqrt(n)) + 1)))
      kalpha <- sqrt(10 * alpha)
    else kalpha <- 1
    
    # Critical Ialpha with correction to small n
    if(tail == "two" | tail == "upper"){
      res$Ia.up[cl] <- (kalpha * EI) + abs(qnorm(alpha, 0, 1)) * sqrt(res$varI[cl])
      if(seq.bonferroni == TRUE)
        res$Ia.up.bonf[cl] <- (kalpha * EI) + abs(qnorm(alpha / cl, 0, 1)) * sqrt(res$varI[cl])
    }
    if(tail == "two" | tail == "lower"){
      res$Ia.lo[cl] <- (kalpha * EI) - abs(qnorm(alpha, 0, 1)) * sqrt(res$varI[cl])
      if(seq.bonferroni == TRUE)
        res$Ia.lo.bonf[cl] <- (kalpha * EI) - abs(qnorm(alpha / cl, 0, 1)) * sqrt(res$varI[cl])
    }
    
    # Probability
    if(tail == "two") 
      res$pvalue[cl] <-  2 * pnorm(res$I[cl], (kalpha * EI), sqrt(res$varI[cl]), lower.tail = ifelse(res$I[cl] >= EI, FALSE, TRUE))
    
    if(tail == "upper")
      res$pvalue[cl] <- pnorm(res$I[cl], (kalpha * EI), sqrt(res$varI[cl]), lower.tail = FALSE)
    
    if(tail == "lower")
      res$pvalue[cl] <- pnorm(res$I[cl], (kalpha * EI), sqrt(res$varI[cl]))
    
    # Significance
    if(seq.bonferroni == TRUE)
      res[cl, "."] <- ifelse(res$pvalue[cl] < (ifelse(tail == "two", (alpha * 2), alpha) / cl), "*", "")
    else res[cl, "."] <- ifelse(res$pvalue[cl] < ifelse(tail == "two", (alpha * 2), alpha), "*", "")
  }
  
  return(list(EI = EI, 
              alpha = alpha, 
              tail = tail,
              seq.bonferroni = seq.bonferroni,
              result = res))
}
