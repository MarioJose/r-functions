# plot.pca.3d

## Function for plot PCA in interactive 3D mode.

### Usage:

`plot.pca.3d(pca, x = 1, y = 2, z = 3, type = 's', size = 1, scaling = 2, col = 'black', box.col = 'grey', adj = c(0.5, -1), main = NULL, xlab = NULL, ylab = NULL, zlab = NULL, axes.edges = c('x', 'y', 'z-+'), axes.cex = 0.7, axes.lwd = 2, projection = 'z', segment.col = 'black', grid.side = c('z'), grid.col = 'grey', sites.names = TRUE, species.names = TRUE, species.vectors = TRUE, species.col = 'red', species.cex = 0.8, species.adj = c(0.5, 0))`

  * `pca`: Object class "rda" from `rda` function of 'vegan' package;
  
  * `x, y, z`: Numeric value informing the number of eigenvector to plot;
  
  * `type`: Character value informing the type of item plot. Options are: 'p'
    for points, 's' for spheres, 'l', for line and 'n' for nothing; For more
    information see `plot3d` help from *rgl* package;
  
  * `size` Numeric value informing the size of the item plot;
  
  * `scaling`: Numeric informing if scores are scaled by site (1) or species
    (2). The scores unscaled (0) or scaled symmetrically (3) can be
    informed. For more information see `scores` help from *vegan* package;
  
  * `col`: Numeric or character value informing the colour of item plot;
  
  * `box.col`: Numeric or character value informing the colour of the 3D box;
  
  * `adj`: Numeric vector of length two informing horizontal and vertical
    adjustment respectively;
    
  * `main, xlab, ylab, zlab`: Character value informing label of main plot
    and edges. If `NULL` main label will be the scaling type and edges the names
    of eigenvector.
    
  * `axes.edges`: Character vector of length one to three informing which
    edge(s) of the box will used to plot axes. Se 'Details' for more
    information;
  
  * `axes.cex`: Numeric value informing amount of magnification of plotting text
    and symbols;
  
  * `axes.lwd`: Numeric value informing the axes line width;
  
  * `projection`: Character vector of length one to three informing the side of
    the item projection line. See 'Details' for more information;
  
  * `segment.col`: Character or numeric value or vector informing the colour of
    each projection segment;
    
  * `grid.side`: Character vector of length one to three informing which side
    the grid will be plotted. See 'Details' for more information;
    
  * `grid.col`: Character or numeric informing the grid colour;
  
  * `sites.names, species.names, species.vectors`: Logical value informing if
    names of sites, species and vectors of species will be plotted;
  
  * `species.col`: Character or numeric vector of length one to three informing
    the colour of the species items name and arrows. See 'Details' for more
    information;
  
  * `species.cex`: Numeric value informing the magnification of species items
    names and arrows. See 'Details' for more information;
  
  * `species.adj`: Numeric vector of length two informing horizontal and
    vertical adjustment, respectively, of species items name. See 'Details' for
    more information;


**Details:** `plot.pca.3d` function requires the packages
[*rgl*](https://cran.r-project.org/web/packages/rgl/index.html) and
[*vegan*](https://cran.r-project.org/web/packages/vegan/index.html). The names
of sites and species (variables) follow *vegan* nomenclature. Sites are
localities and species are variables measures for each localities. The dimension
names used in *rgl* are: "x" as horizontal, "y" as depth and "z" as vertical
(Figure. 1).

![Coordinates](images/coord.png 'Coordinates')
*Figure. 1 Box coordinates*


There are 12 edges to plot axes and they are identified by character 'x', 'y', 
and 'z' with signal '+' and '-' (For more detail see `plot3d` help from *grl*
package). When signal is omitted, the default is '-'. For instance, if is
informed 'x', then this is interpreted as 'x--'. Signal inform at which side
of the other axes the informed axis will be plotted. Figure 2 show three black
axes (default plot) and one red. The 'x' axis is plotted in front of the box
at negative site of 'y' axis and negative side of 'z' axis ('x--'). The same
for 'y' axis that was plotted at negative side of 'x' axis and negative side
of 'z' axis ('y--'). The 'z' axis was plotted at negative side of 'y' axis 
and positive side of 'z' axis ('z-+'). The black axes were plotted informing
the parameter `axes.edges = c('x', 'y', 'z-+')`. Remember that if is informed
only the letter the function will interpret as 'x--', for instance. The red
'z' axis was plotted at positive side of 'x' axis and negative side of 'y' 
axis ('z+-').

![Axes](images/axes.png 'Axes')
*Figure. 2 Specifying location of axes*


The grid and projections follow the same structure, but with only one signal.
Figure 3 show two grids plotted at opposite faces. The red grid is plotted at
box face of negative side of 'y' axis ('y-'). The blue one was plotted at box
face of positive side of 'y' axis ('y+').

![Grid](images/grid.png 'Grid')
*Figure. 3 Specifying location of grid*


The Figure 4 show projections lines of the items at the box face of negative 
side of 'z' axis ('z-').

![Projection](images/projection-z.png 'Projection')
*Figure. 4 Specifying face of projection*


It is possible to inform more then one face to projection items like 
Figure 5. For this, inform `projection=c('z','y+')`, for instance, to plot
projection lines at the box face of negative side of 'z' axis and at box 
face of positive side of 'y' axis.

![Double projection](images/projection-zy.png 'Double projection')
*Figure. 5 Projection of items at two faces*


**Example:** 

```r
# Load example data from vegan
data(varechem)

my.pca <- rda(varechem)

# Plot the result
plot.pca.3d(my.pca)

# Save a snapshot of the graphic
rgl.snapshot("varechem.png")
```
![3D plot of vegan 'varechem' data](images/varechem.png '3D plot of vegan "varechem"" data')
