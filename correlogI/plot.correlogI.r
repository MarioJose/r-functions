plot.correlogI <- function(x, expected = TRUE, label.dist = FALSE, significance = TRUE, line.alpha = TRUE, line.alpha.bonf = TRUE, ci = TRUE, ...){
  
  dots <- list(...)
  
  if(!"main" %in% names(dots)) dots$main <- "Correlogram"
  if(!"xlab" %in% names(dots)) dots$xlab <- "Distance class"
  
  if(label.dist == TRUE) dcl <- round(x$result$distMax, 2)
  else dcl <- x$result$class
  
  do.call(plot, c(list(x = dcl, y = x$result$I,
                       ylim = c(-1, 1), xlim = c(-0.2, 0.2) + range(dcl),
                       type = "n", bty = "n", xaxt = "n",
                       ylab = "Moran I"), dots))
  axis(side = 1, at = dcl, labels = dcl)
  
  if(expected == TRUE) abline(h = x$EI, col = "black", lty = 2)
  
  if(x$tail == "two" | x$tail == "upper"){
    if(line.alpha == TRUE) lines(x = dcl, y = x$result$Ia.up, col = "red")
    if(x$seq.bonferroni == TRUE & line.alpha.bonf == TRUE) lines(x = dcl, y = x$result$Ia.up.bonf, col = "red", lty = 2)
  }

  if(x$tail == "two" | x$tail == "lower"){
    if(line.alpha == TRUE) lines(x = dcl, y = x$result$Ia.lo, col = "red")
    if(x$seq.bonferroni == TRUE & line.alpha.bonf == TRUE) lines(x = dcl, y = x$result$Ia.lo.bonf, col = "red", lty = 2)
  }
  
  if(significance == TRUE) points(x = dcl, y = x$result$I, pch=(15 * as.numeric(x$result["."] == "*")))
  else points(x = dcl, y = x$result$I, pch=0)

  if(ci == TRUE){
    arrows(x0 = dcl, 
           x1 = dcl, 
           y0 = x$result$I, 
           y1 = x$result$I + qnorm(x$alpha) * sqrt(x$result$varI), 
           length = 0.07, angle = 90)
    arrows(x0 = dcl, 
           x1 = dcl, 
           y0 = x$result$I, 
           y1 = x$result$I - qnorm(x$alpha) * sqrt(x$result$varI), 
           length = 0.07, angle = 90)
  }
}
