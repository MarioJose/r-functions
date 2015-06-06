plot.scatter.box <- function(x, g1, g2 = NULL, pcol = "black", mcol = "red", hlg = NULL, hlc = NULL, ...){
  
  if(length(x) != length(g1)) stop("'x' and 'g1' must have same length")
  
  if(!is.null(g2)) if(length(x) != length(g2)) stop("'g2' must have same length of 'x' ang 'g1'")
  
  if(!is.null(hlg) & !is.null(hlc)) if(length(hlg) != length(hlc)) stop("'hlg' and 'hlc' must have same length")
  
  if((is.null(hlg) & !is.null(hlc)) | (!is.null(hlg) & is.null(hlc))) stop("both 'hlg' and 'hlc' must be informed")
  
  dots <- list(...)
  if(!is.null(g2)) dt <- data.frame(x, g1, g2)
  else dt <- data.frame(x, g1)
  g <- levels(dt$g1) # groups
  xr <- 2 * length(g) # x range
  tk <- seq(from = 1, to = xr, by = 2) # ticks

  if(!exists("xlab", dots)) dots[["xlab"]] <- names(dt)[2]
  if(!exists("ylab", dots)) dots[["ylab"]] <- names(dt)[1]
  if(!exists("pch", dots)) dots[["pch"]] <- 1
  
  if(!is.null(g2)){
    gcol <- data.frame(g = unique(dt$g2))
    gcol$col <- pcol
    
    if(!is.null(hlg)){
      for(i in 1:length(hlg)){
        gcol$col[gcol$g == hlg[i]] <- hlc[i]
      }
    }
  }

  do.call(plot, c(list(x = 0, y = 0, xlim = c(0, xr), ylim = range(dt$x), type = "n", 
                       xaxt = "n", yaxt = "n", bty = "n"), dots))
  axis(side = 1, at = tk, labels = g)
  axis(side = 2)
  
  for(i in 1:length(g)){
    r <- sample(seq(from = (tk[i] - 0.5), to = (tk[i] + 0.5), 
                    length.out = length(dt$x[dt$g1 == g[i]])))
    m <- mean(dt$x[dt$g1 == g[i]])
    
    if(!is.null(g2)) cl <- gcol$col[match(dt$g2[dt$g1 == g[i]], gcol$g)]
    else cl <- pcol
    
    points(x = r, y = dt$x[dt$g1 == g[i]], lwd = 2, pch = dots[["pch"]], col = cl)
    segments(x0 = (tk[i] - 0.5), x1 = (tk[i] + 0.5), y0 = m, y1 = m, lwd = 2, col = mcol)
  }
}
