## # Working with phylogenetic data in R
knitr::opts_chunk$set(tidy=FALSE)

## Load in the `ape` package
library(ape)

## ## Reading in phylogenetic trees
## We'll use the Cyprinodon pufferfish dataset from [Martin and Wainwright 2011](http://fishlab.ucdavis.edu/Martin2011.pdf) 
tree <- read.tree("datasets/cyprinodon.tre")

## If file format is NEXUS, use `read.nexus()` rather than `read.tree()`
## read.nexus()

## Look at how trees are stored in ape's `phylo` format
## Let's you look at the structure of the object
str(tree)
## A vector containing all the taxa labels
tree$tip.label
## An "edge" matrix representing all nodes on the tree with their descendents. Representation of the topology.
tree$edge
## A vector containing all the branch lengths
tree$edge.length

## Some summary statistics for the tree:

## Number of tips
Ntip(tree)

## Total tree depth
max(branching.times(tree))

## We might want to change the elements of a tree. For example, for some analyses if we are only interested in relative divergence times, we may want to rescale the total tree depth to be one. This allows us to more easily compare the parameters of a trait model across different trees (e.g., the results of a Bayesian analysis)
tree$edge.length <- tree$edge.length/max(branching.times(tree))

## Now our tree has been rescaled
max(branching.times(tree))

## ## Plotting trees

plot.phylo(tree)

plot.phylo(tree, type="fan")

plot.phylo(tree, type="fan", edge.color = "blue", cex=0.5)

plot.phylo(tree, type="radial")

## Add a binary trait and plot it on the tree
plot.phylo(tree, show.tip.label = FALSE)
states <- sample(c(1,2), Ntip(tree), replace=TRUE)
col <- c("red", "blue")
tiplabels(col=col[states], pch=19)




