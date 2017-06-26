drop.tip.label <- function(tree, tip){
  if(!is.vector(tip, mode = "character"))
    stop("'node' parameter must be a character vector")
  
  if(sum(tip %in% tree$tip.label) == 0)
    stop("tree has not tip labels defined in 'tip' parameter")
  
  if(!is.rooted(tree))
    stop("tree must be rooted")
  
  if(!is.null(tree$edge.length))
    stop("tree must not have edge length")

  # Solve bug reading newick in phytools 0.6
  if(tree$Nnode > length(tree$node.label))
    tree$node.label <- c(tree$node.label, rep('', tree$Nnode - length(tree$node.label)))
  
  # Reorder tree
  tree <- reorder(tree)
  
  # tip to drop
  ttd <- which(tree$tip.label %in% tip)
  
  # number of tips
  not <- length(tree$tip.label)
  
  edge <- tree$edge
  
  # node to drop
  ntd <- c()
  
  # descendants structure
  ds <- get.ancestry.structure(ttd, edge)
  while(!is.null(ds$u_desc) | dim(ds$m_desc)[1] > 0){
    # table multiples descendants
    tmd <- table(ds$m_desc[ ,2])
    tmd <- tmd[order(as.integer(names(tmd)), decreasing = TRUE)]
    ntd <- c(ntd, ds$u_desc)
    
    # additional node to drop
    antd <- c()
    for(i in 1:length(tmd)){
      nn <- as.integer(names(tmd[i]))
      desc <- get.descendants(tree, nn)
      if( length(desc$node_desc) > 0 ){
        if( length(desc$node_desc) == sum(desc$node_desc %in% ntd) )
          antd <- c(antd, nn)
      } else {
        if( length(desc$tip_desc) == sum(desc$tip_desc %in% ttd) )
          antd <- c(antd, nn)
      }
    }
    
    if(!is.null(antd)){
      ntd <- c(ntd, antd)
      ds <- get.ancestry.structure(antd, edge)
    } else break
  } 
  
  # New tips positions
  newt <- matrix(NA, nrow = not, ncol = 2, 
                 dimnames = list(1:not, c('tips', 'new')))
  newt[ ,1] <- 1:not
  newt <- newt[!(newt[ ,1] %in% ttd), ]
  newt[ ,2] <- rank(newt[ ,1])
  
  # New nodes positions
  newn <- matrix(NA, nrow = tree$Nnode, ncol = 2, 
                 dimnames = list(1:tree$Nnode, c('nodes', 'new')))
  newn [ ,1] <- 1:tree$Nnode + not
  newn <- newn[!(newn[ ,1] %in% ntd), ]
  newn [ ,2] <- rank(newn[ ,1]) + (not - length(ttd))
  
  # Reference table to new nodes positions
  refedge <- rbind(newt, newn)
  
  newedge <- edge[!(edge[ ,1] %in% ntd | edge[ ,2] %in% c(ttd, ntd)), ]
  newedge[ ,1] <- refedge[match(newedge[ ,1], refedge[ ,1]) ,2]
  newedge[ ,2] <- refedge[match(newedge[ ,2], refedge[ ,1]) ,2]
  
  # Update tree  
  tree$edge <- newedge
  tree$tip.label <- tree$tip.label[newt[ ,1]]
  tree$node.label <- tree$node.label[newn[ ,1] - not]
  tree$Nnode <- tree$Nnode - length(ntd)
  
  return(tree)
}
