get.descendants <- function(tree, node){
  if(length(node) > 1 | !is.numeric(node))
    stop("'node' must be a numeric vector of length 1")
 
  # number of tips
  not <- length(tree$tip.label)
  
  edge <- tree$edge
  
  # nodes descendants
  nd <- tmp <- edge[edge[ ,1] %in% node , 2]
  while(length(tmp) > 0){
    tmp <- edge[edge[ ,1] %in% tmp , 2]
    if(length(tmp) > 0) nd <- c(nd, tmp)
  }
  # tips descendants
  td <- nd[nd <= not]
  # only nodes descendants
  nd <- nd[nd > not] 
  
  return(list(tip_desc = td,
              node_desc = nd))
}
