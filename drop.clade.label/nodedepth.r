nodedepth <- function(tree, node){
  depth <- c()
  for(i in node){
    ct <- 0
    nb <- tree$edge[tree$edge[ ,2] == i,1]
    if(length(nb) > 0) ct <- ct + 1
    while(length(nb) > 0){
      nb <- tree$edge[tree$edge[ ,2] == nb,1]
      if(length(nb) > 0) ct <- ct + 1
    }
    depth <- c(depth, ct)
  }
  return(depth)
}
