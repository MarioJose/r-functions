setwd("/home/mario/Git/r-functions/plot.pca.3d/")

data(varechem)

source("~/Git/r-functions/plot.pca.3d/plot.pca.3d.r")

plot.pca.3d(rda(varechem))
rgl.snapshot("varechem.png")


plot.pca.3d(rda(varechem), main = "PCA 3D", grid.side = 'n', projection = 'n', xlab='X', ylab='Y', zlab='Z', type="n", sites.names = FALSE, species.names = FALSE, species.vectors = FALSE)

rgl.snapshot("coord.png")

plot.pca.3d(rda(varechem), main = "PCA 3D", projection = 'n', xlab='X', ylab='Y', zlab='Z', type="n", sites.names = FALSE, species.names = FALSE, species.vectors = FALSE, grid.side=c('n'))

grid3d(side = 'y+', col='blue', lwd = 1.5)
grid3d(side = 'y-', col='red', lwd = 1.5)

rgl.snapshot("grid.png")


plot.pca.3d(rda(varechem), main = "PCA 3D", projection = 'n', xlab='X', ylab='Y', zlab='Z', type="n", sites.names = FALSE, species.names = FALSE, species.vectors = FALSE, grid.side=c('n'))

axes3d(edges = 'z+-', cex = 0.7, lwd = 2, labels = TRUE, col="red")

rgl.snapshot("axes.png")


plot.pca.3d(rda(varechem), type="s", sites.names = FALSE, species.names = FALSE, species.vectors = FALSE, grid.side=c('z'), projection='z')

rgl.snapshot("projection-z.png")

plot.pca.3d(rda(varechem), type="s", sites.names = FALSE, species.names = FALSE, species.vectors = FALSE, grid.side=c('z'), projection='y+')

rgl.snapshot("projection-z.png")

plot.pca.3d(rda(varechem), type="s", sites.names = FALSE, species.names = FALSE, species.vectors = FALSE, grid.side=c('z'), projection=c('z','y+'))

rgl.snapshot("projection-zy.png")

