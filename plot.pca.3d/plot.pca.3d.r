plot.pca.3d <- function(pca, x = 1, y = 2, z = 3, type = 's', size = 1, scaling = 2,
                        col = 'black', box.col = 'grey', adj = c(0.5, -1), 
                        main = NULL, xlab = NULL, ylab = NULL, zlab = NULL,
                        axes.edges = c('x', 'y', 'z-+'), axes.cex = 0.7, axes.lwd = 2,
                        projection = 'z', segment.col = 'black', 
                        grid.side = c('z'), grid.col = 'grey',
                        sites.names = TRUE, species.names = TRUE, species.vectors = TRUE,
                        species.col = 'red', species.cex = 0.8, species.adj = c(0.5, 0)){

  # requering rgl and vegan package
  require(rgl)
  require(vegan)
  
  # options to check
  side.opt <- c('n', paste(c('x', 'y', 'z'), rep(c('', '+', '-'), each = 3), sep = ''))
  edge.opt <- c(side.opt, paste(c('x', 'y', 'z'), 
                                rep(c('-+', '+-'), each = 3), sep = ''))
  
  if(sum(grid.side %in% side.opt) < length(grid.side))
    stop('"grid.side" has invalid value. Accepted values: ', paste(side.opt, ''))
  
  if(sum(projection %in% side.opt) < length(projection))
    stop('"projection" has invalid value. Accepted values: ', paste(side.opt, ''))
  
  if(sum(axes.edges %in% edge.opt) < length(axes.edges))
    stop('"axes.edge" has invalid value. Accepted values: ', paste(edge.opt, ''))
  
  if(!'rda' %in% class(pca))
    stop('"pca" must be "rda" class.')
  
  if(is.null(main)) 
    main <- paste('PCA - scaling', scaling)
  
  rm(site.opt, edge.opt)
    
  # default: x- y- z-
  idx <- grid.side %in% c('x', 'y', 'z')
  grid.side[idx] <- paste(grid.side[idx], "-", sep = "")
  
  idx <- projection %in% c('x', 'y', 'z')
  projection[idx] <- paste(projection[idx], "-", sep = "")
  
  rm(idx)
  
  # extract scores
  pca.scores <- scores(pca, scaling = scaling, choices = c(x, y, z))
  
  if(dim(pca.scores$sites)[2] < 3)
    stop('"pca" must have at least three eigenvectors.')
  
  # open 3d rgl device and plot box
  lim <- range(pca.scores) * 1.05
  plot3d(pca.scores$sites, type = type, axes=FALSE, size = size, col = col,
         main = main, xlab='', ylab='', zlab='', 
         xlim = lim, ylim = lim, zlim = lim)
  box3d(col = box.col)
  
  # plot grite do edge
  grid3d(side = grid.side, col = grid.col)
  
  if(!'n' %in% axes.edges){
    # plot axes to edge
    axes3d(edges = axes.edges, cex = axes.cex, lwd = axes.lwd, labels = TRUE)
    
    # plot label to edge
    if(is.null(xlab)) xlab <- colnames(pca.scores$sites)[1]
    if(is.null(ylab)) ylab <- colnames(pca.scores$sites)[2]
    if(is.null(zlab)) zlab <- colnames(pca.scores$sites)[3]
    
    mtext3d(edge = axes.edges[1], text = xlab, line = 2)
    mtext3d(edge = axes.edges[2], text = ylab, line = 2)
    mtext3d(edge = axes.edges[3], text = zlab, line = 2)
  }
  
  # plot sites projection
  if(!'n' %in% projection){
    for(i in 1:dim(pca.scores$sites)[1]){
      st <- pca.scores$sites[i, ]
      for(j in projection){
        axsig <- strsplit(j, split = '')[[1]]
        fn <- ifelse(axsig[2] == "+", max, min)
        
        if(axsig[1] == 'x') fi <- c(fn(lim),
                                    pca.scores$sites[i,2],
                                    pca.scores$sites[i,3])
        
        if(axsig[1] == 'y') fi <- c(pca.scores$sites[i,1],
                                    fn(lim),
                                    pca.scores$sites[i,3])
        
        if(axsig[1] == 'z') fi <- c(pca.scores$sites[i,1],
                                    pca.scores$sites[i,2],
                                    fn(lim))
        
        segments3d(rbind(st, fi), col = ifelse(length(segment.col) > 1, 
                                               segment.col[i], segment.col))
      }
    }
    rm(i, j, st, fi, axsig)
  }
  
  # plot site names
  if(sites.names)
    text3d(pca.scores$sites, texts = rownames(pca.scores$sites), col = col, adj = adj)
  
  # plot species names
  if(species.names)
    text3d(pca.scores$species, texts = rownames(pca.scores$species), 
           col = species.col, cex = species.cex, adj = species.adj)
  
  # plot species vectors
  if(species.vectors){
    for(i in 1:dim(pca.scores$species)[1]){
      lines3d(rbind(c(0,0,0), pca.scores$species[i,1:3]), col = species.col)
    }
    rm(i)
  }
  
}
