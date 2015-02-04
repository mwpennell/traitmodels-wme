## # Working with phylogenetic data in R
knitr::opts_chunk$set(tidy=FALSE)

## Load in the `ape` package
library(ape)

## ## Reading in phylogenetic trees
## We'll use the Cyprinodon pufferfish dataset from [Martin and Wainwright 2011](http://fishlab.ucdavis.edu/Martin2011.pdf) 
tree <- read.tree("datasets/cyprinodon.tre")

## If file format is NEXUS, use `read.nexus()` rather than `read.tree()`
## read.nexus()

is.ultrametric(tree)
is.rooted(tree)

## Look at how trees are stored in ape's `phylo` format
## Let's you look at the structure of the object
str(tree)
## A vector containing all the taxa labels
tree$tip.label
head(tree$tip.label)

tree2 <- tree

tree2$tip.label[1] <- "Mynew_species"

head(tree2$tip.label)
## An "edge" matrix representing all nodes on the tree with their descendents. Representation of the topology.
head(tree$edge)
## A vector containing all the branch lengths
head(tree$edge.length)

## Some summary statistics for the tree:

## Number of tips
Ntip(tree)
## Number of nodes
Nnode(tree)

## Total tree depth
bt <- branching.times(tree)
head(bt)
max(bt)

## We might want to change the elements of a tree. For example, for some analyses if we are only interested in relative divergence times, we may want to rescale the total tree depth to be one. This allows us to more easily compare the parameters of a trait model across different trees (e.g., the results of a Bayesian analysis)
head(tree$edge.length)
tree$edge.length <- tree$edge.length * 2
head(tree$edge.length)

## Now our tree has been rescaled
max(branching.times(tree))

## ## Plotting trees

## You can plot the tree by calling `plot.phylo`. Note that simply using `plot` will work just as well but I always use `plot.phylo` because a) it is more transparent and readable; and b) you can see the options
plot.phylo(tree)
help(plot.phylo)


## There are lots of options. Try typing `help(plot.phylo)`

## Default is to plot right facing trees but you can do plot "radial", "fan", "cladogram" or "unrooted". For example, a "fan" phylogeny
plot.phylo(tree, type="fan")
## and a radial one
plot.phylo(tree, type="radial")

## You can change the color of branches and the size of tip labels
plot.phylo(tree, type="fan", edge.color = "blue", cex=0.5)


## Add a binary trait and plot it on the tree
plot.phylo(tree, show.tip.label = FALSE)
states <- sample(c(1,2), Ntip(tree), replace=TRUE)
col <- c("red", "blue")
tiplabels(col=col[states], pch=19)

## Add nodelabels
nodelabels(1:(Ntip(tree)-1))

## Exercise: Generate different plots


