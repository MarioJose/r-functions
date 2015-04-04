# drop.clade.label

## Function for drop clade from tree using clade label.

### Usage

`drop.clade.label(tree, node)`

* `tree`: Tree of class 'phylo'.

* `node`: Character vector with name(s) of node(s).

### Values

Tree of class 'phylo' with defined node dropped.

### Details

All tips from node will be deleted and node label will be a tip on tree. This function removes tips from node prioritizing exclusion to deep nodes for do not lose node label when root has polytomies.

### Require
Function: `nodedepth`.
Packages: `ape`, `phytools`.

***

# nodedepth

## Node depth from specified node to root.

### Usage

`nodedepth(tree, node)`

* `tree`: Tree of class 'phylo'.

* `node`: Numeric value with node number.

### Details

Counting number of nodes from specified node, that maybe a tip number, to the root of tree.
