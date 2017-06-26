get.ancestry.structure <- function(node, edge){
  if(!is.vector(node))
    stop("'node' must be a vector with length 1 or more")
    
  if(!is.numeric(node) | !is.numeric(edge))
    stop("'node' and 'edge' must be numeric")
  
  if(!is.matrix(edge))
    stop("'edge' must be a matrix")
  
  if(sum(node %in% edge) == 0)
    stop("'node' is not in 'edge'")
  
  # descendants
  desc <- c()
  
  # node with multiples descendants
  nwmd <- matrix(NA, nrow = length(node), ncol = 2,
                 dimnames = list(1:length(node), c('node', 'nwmd')))
  nwmd[ ,1] <- node
  
  for(i in node){
    # descendant node
    dn <- edge[edge[ ,2] %in% i,1]
    # number of descendants
    nod <- edge[edge[ ,1] %in% dn,1]
    while(length(nod)){
      if(length(nod) < 2){
        desc <- c(desc, dn)
        dn <- edge[edge[ ,2] %in% dn,1]
        nod <- edge[edge[ ,1] %in% dn,1]
      } else {
        nwmd[nwmd[ ,1] %in% i,2] <- dn
        break
      }
    }
  }

  return(list(u_desc = desc,
              m_desc = nwmd))
}
