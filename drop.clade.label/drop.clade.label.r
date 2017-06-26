drop.clade.label <- function(tree, node){
  # Remove all tips from 'node', keeping 'node' label as a tip
  
  if(!is.vector(node, mode = "character") | length(node) > 1)
    stop("'node' parameter must be a character vector of length 1")
  
  if(sum(node %in% tree$node.label) == 0)
    stop("tree has not node labels defined in 'node' parameter")
  
  if(!is.rooted(tree))
    stop("tree must be rooted")
  
  if(!is.null(tree$edge.length))
    stop("tree must not have edge length")
  
  # Solve bug reading newick in phytools 0.6
  if(tree$Nnode > length(tree$node.label))
    tree$node.label <- c(tree$node.label, rep('', tree$Nnode - length(tree$node.label)))
  
  # Reorder tree
  tree <- reorder(tree)
  
  # number of tips
  not <- length(tree$tip.label)
  # node number
  nn <- which(tree$node.label %in% node) + not
  
  # 'node' tree extracted
  extr <- extract.clade.label(tree, node)
  # number of tips of extracted 'node' tree
  extrnot <- length(extr$tip.label)

  # new number of tips
  nnot <- not - extrnot
  
  edge <- tree$edge
  
  # nodes descendants
  nd <- tmp <- edge[edge[ ,1] %in% nn , 2]
  while(length(tmp) > 0){
    tmp <- edge[edge[ ,1] %in% tmp , 2]
    if(length(tmp) > 0) nd <- c(nd, tmp)
  }
  # tips desdendants
  td <- nd[nd <= not]
  # only nodes descendats
  nd <- nd[nd > not] 
  
  # New tips positions
  newt <- matrix(NA, nrow = not, ncol = 2, 
                 dimnames = list(1:not, c('tips', 'new')))
  newt[ ,1] <- 1:not
  newt <- newt[!(newt[ ,1] %in% td), ]
  newt[ ,2] <- rank(newt[ ,1])
  
  # New nodes positions
  newn <- matrix(NA, nrow = tree$Nnode, ncol = 2, 
                 dimnames = list(1:tree$Nnode, c('nodes', 'new')))
  newn [ ,1] <- 1:tree$Nnode + not
  newn <- newn[!(newn[ ,1] %in% c(nd, nn)), ]
  # 'nnot' plus 1L to new tip 'node'
  newn [ ,2] <- rank(newn[ ,1]) + nnot + 1L
  
  # Reference table to new nodes positions
  refedge <- rbind(newt, newn, matrix(c(nn, (nnot + 1)), nrow = 1))
  
  newedge <- edge[!(edge[ ,1] %in% c(nd, nn)), ]
  newedge[ ,1] <- refedge[match(newedge[ ,1], refedge[ ,1]) ,2]
  newedge[ ,2] <- refedge[match(newedge[ ,2], refedge[ ,1]) ,2]

  # Update tree  
  tree$edge <- newedge
  tree$tip.label <- c(tree$tip.label[newt[ ,1]], node)
  tree$node.label <- tree$node.label[newn[ ,1] - not]
  tree$Nnode <- length(tree$node.label)
  
  return(tree)
}
