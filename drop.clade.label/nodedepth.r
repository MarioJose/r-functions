nodedepth <- function(tree, node){
  # Count number of nodes of each 'node' to root of 'tree'
  
  depth <- c()
  for(i in node){
    ct <- 0
    nb <- tree$edge[tree$edge[ ,2] == i,1]
    if(length(nb) > 0) ct <- 1
    while(length(nb) > 0){
      nb <- tree$edge[tree$edge[ ,2] %in% nb,1]
      if(length(nb) > 0) ct <- ct + 1
    }
    depth <- c(depth, ct)
  }
  return(depth)
}
