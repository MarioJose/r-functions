collapse.unlabelled.singleton <- function(tree){
  if(!is.rooted(tree))
    stop("tree must be rooted")
  
  if(!is.null(tree$edge.length))
    stop("tree must not have edge length")
  
  # Solve bug reading newick in phytools 0.6
  if(tree$Nnode > length(tree$node.label))
    tree$node.label <- c(tree$node.label, rep('', tree$Nnode - length(tree$node.label)))
  
  # number of tips
  not <- length(tree$tip.label)
  
  edge <- tree$edge
  
  # unlabelled nodes
  un <- which(tree$node.label %in% '') + not

  # descendants number of unlabelled node
  dnoun <- sapply(un, function(x,y){length(y[y[ ,1] %in% x,1])}, y = edge)
  
  if(sum(dnoun == 1) > 0){
    # node to drop
    ntd <- un[dnoun == 1]
    
    # node to tip
    ntt <- edge[edge[ ,2] %in% (1:not),1]
    # common node to tip
    cntt <- edge[edge[ ,2] %in% ntt,1]
    
    newedge <- edge
    
    # relink nodes
    for(i in ntd){
      nn <- newedge[newedge[ ,1] %in% i,2]
      newedge <- newedge[!(newedge[ ,1] %in% i), ]
      newedge[newedge[ ,2] %in% i,2] <- nn
    }
    
    # relink root node
    root <- not + 1
    rd <- newedge[newedge[ ,1] == root,2]
    if(length(rd) == 1){
      if(rd %in% un){
        newedge <- newedge[newedge[ ,1] != root, ]
        newedge[newedge[ ,1] %in% rd,1] <- root
      }
    }
    
    # New nodes positions
    newn <- matrix(NA, nrow = tree$Nnode, ncol = 2, 
                   dimnames = list(1:tree$Nnode, c('nodes', 'new')))
    newn [ ,1] <- 1:tree$Nnode + not
    newn <- newn[!(newn[ ,1] %in% ntd), ]
    newn [ ,2] <- rank(newn[ ,1]) + not
    
    # Reference table to new nodes positions
    refedge <- rbind(newn, matrix(rep(1:not, each = 2), ncol = 2, byrow = TRUE))
    newedge[ ,1] <- refedge[match(newedge[ ,1], refedge[ ,1]) ,2]
    newedge[ ,2] <- refedge[match(newedge[ ,2], refedge[ ,1]) ,2]
    
    # update tree
    tree$edge <- newedge
    tree$node.label <- tree$node.label[-(ntd - not)]
    tree$Nnode <- tree$Nnode - length(ntd)
  }
  
  return(tree)
}
