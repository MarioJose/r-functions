# drop.clade.label

## Function for drop clade from tree using clade label.

### Usage

`drop.clade.label(tree, node)`

* `tree`: Tree of class 'phylo'.

* `node`: Character vector with name(s) of node(s).

### Values

Tree of class 'phylo' with defined node dropped.

### Details

All tips from node will be deleted and node label will be a tip on tree. This function is independent of `drop.tip` and `extract.clade` functions of 'ape' package. It can handle 'tree' with or without singletons.

### Require
Packages: `ape`, `phytools`.

Functions: `extract.clade.label`.

### Example
See example [here](example.md).

***

# extract.clade.label

## Function for extract clade from tree using clade label.

### Usage

`extract.clade.label(tree, node)`

* `tree`: Tree of class 'phylo'.

* `node`: Character vector with name(s) of node(s).

### Values

Tree of class 'phylo' with defined node extracted.

### Details

All tips from node will be kept and all the others tips will be removed. This function is independent of `drop.tip` function of 'ape' package. It can handle 'tree' with or without singletons.

### Require
Packages: `ape`, `phytools`.

### Example
See example [here](example.md).

***

# nodedepth

## Node depth to root 'tree'.

### Usage

`nodedepth(tree, node)`

* `tree`: Tree of class 'phylo'.

* `node`: Numeric value with node number.

### Details

Count number of nodes of each 'node' to root of 'tree'.

### Example

```r
tree <- read.newick(text = '((((a,b)AB,c)ABC,(d,e,f)DEF)G,h)I;')

par(mar=c(1,1,1,1))
plot(tree)
nodelabels()
```

![](example_figs/nodedepth.png)

```r
nodedepth(tree, 11)
```

```
3
```

