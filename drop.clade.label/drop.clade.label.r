drop.clade.label <- function(tree, node){
  # Removes tips from node prioritizing exclusion to deep nodes.
  
  if(!is.vector(node, mode = "character"))
    stop("'node' parameter must be a character vector")
  
  if(sum(node %in% tree$node.label) == 0)
    stop("tree has not node labels defined in 'node' parameter")
  
  for(i in node){
    # Location of node in tree. Valid only before drop
    nn <- which(tree$node.label %in% i)
    
    tree_node <- extract.clade(tree, i)
    tipn <- length(tree_node$tip.label)
    dt <- aggregate(list(edge=tree_node$edge[ ,1]), list(node=tree_node$edge[ ,1]), length)
    
    # Depth to node
    dt$depth <- nodedepth(tree_node, dt$node)
    
    dt$label <- tree_node$node.label[dt$node - tipn]
    dt <- dt[dt$edge > 1 & dt$depth > 0, ]
    dt <- dt[order(dt$depth, dt$edge, decreasing = TRUE), ]
    
    # Names nodes with no label
    if(sum(dt$label == "") > 0){
      idx <- dt$label == ""
      dt$label[idx] <- paste(paste(i, "Node", sep=""), dt$node[idx], sep="")
      
      # Names nodes with no label from defined node on tree
      tree$node.label[(dt$node[idx] - tipn) + (nn - 1)] <- dt$label[idx]
    }
    
    for(j in dt$label){
      tree <- drop.tip(tree, extract.clade(tree, j)$tip.label, trim.internal = FALSE)
    }
    
    # Drop final tips
    tree <- drop.tip(tree, extract.clade(tree, i)$tip.label, trim.internal = FALSE)
    if(sum(i %in% tree$node.label) > 0){
      while(sum(i %in% tree$node.label) > 0)
        tree <- drop.tip(tree, extract.clade(tree, i)$tip.label, trim.internal = FALSE)
    }
  }
  return(tree)
}
