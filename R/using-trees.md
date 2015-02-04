# Working with phylogenetic data in R

```r
knitr::opts_chunk$set(tidy=FALSE)
```

Load in the `ape` package

```r
library(ape)
```

## Reading in phylogenetic trees
We'll use the Cyprinodon pufferfish dataset from [Martin and Wainwright 2011](http://fishlab.ucdavis.edu/Martin2011.pdf) 

```r
tree <- read.tree("datasets/cyprinodon.tre")
```

If file format is NEXUS, use `read.nexus()` rather than `read.tree()`
read.nexus()


```r
is.ultrametric(tree)
```

```
## [1] TRUE
```

```r
is.rooted(tree)
```

```
## [1] TRUE
```

Look at how trees are stored in ape's `phylo` format
Let's you look at the structure of the object

```r
str(tree)
```

```
## List of 4
##  $ edge       : int [1:78, 1:2] 41 42 43 43 44 44 45 45 46 47 ...
##  $ Nnode      : int 39
##  $ tip.label  : chr [1:40] "Cyprinodon_alvarezi" "Cyprinodon_artifrons" "Cyprinodon_maya" "Cyprinodon_labiosus" ...
##  $ edge.length: num [1:78] 0.1115 0.0518 0.8367 0.7244 0.1123 ...
##  - attr(*, "class")= chr "phylo"
##  - attr(*, "order")= chr "cladewise"
```
A vector containing all the taxa labels

```r
tree$tip.label
```

```
##  [1] "Cyprinodon_alvarezi"                      
##  [2] "Cyprinodon_artifrons"                     
##  [3] "Cyprinodon_maya"                          
##  [4] "Cyprinodon_labiosus"                      
##  [5] "Cyprinodon_beltrani"                      
##  [6] "Cyprinodon_verecundus"                    
##  [7] "Cyprinodon_esconditus"                    
##  [8] "Cyprinodon_simus"                         
##  [9] "Cyprinodon_macrolepis"                    
## [10] "Cyprinodon_pachycephalus"                 
## [11] "Cyprinodon_eximius"                       
## [12] "Cyprinodon_nazas"                         
## [13] "Cyprinodon_meeki"                         
## [14] "Cyprinodon_bifasciatus"                   
## [15] "Cyprinodon_atrorus"                       
## [16] "Cyprinodon_radiosus"                      
## [17] "Cyprinodon_pisteri"                       
## [18] "Cyprinodon_albivelis"                     
## [19] "Cyprinodon_macularius_macularius"         
## [20] "Cyprinodon_fontinalis"                    
## [21] "Cyprinodon_salinus"                       
## [22] "Cyprinodon_diabolis"                      
## [23] "Cyprinodon_nevadensis_mionectes"          
## [24] "Cyprinodon_rubrofluviatilis_Brazos_River" 
## [25] "Cyprinodon_elegans"                       
## [26] "Cyprinodon_bovinus"                       
## [27] "Cyprinodon_pecosensis"                    
## [28] "Cyprinodon_bondi"                         
## [29] "Cyprinodon_nichollsi"                     
## [30] "Cyprinodon_variegatus_SC"                 
## [31] "Cyprinodon_variegatus_RI"                 
## [32] "Cyprinodon_variegatus_York_VA"            
## [33] "Cyprinodon_dearborni"                     
## [34] "Cyprinodon_variegatus_Grand_Cayman_Island"
## [35] "Cyprinodon_bulldog"                       
## [36] "Cyprinodon_bozo"                          
## [37] "Cyprinodon_normal_Crescent_Pond"          
## [38] "Cyprinodon_variegatus_LA"                 
## [39] "Cyprinodon_variegatus_EdinburgTX"         
## [40] "Cyprinodon_variegatus_FL_gulf"
```

```r
head(tree$tip.label)
```

```
## [1] "Cyprinodon_alvarezi"   "Cyprinodon_artifrons"  "Cyprinodon_maya"      
## [4] "Cyprinodon_labiosus"   "Cyprinodon_beltrani"   "Cyprinodon_verecundus"
```

```r
tree2 <- tree

tree2$tip.label[1] <- "Mynew_species"

head(tree2$tip.label)
```

```
## [1] "Mynew_species"         "Cyprinodon_artifrons"  "Cyprinodon_maya"      
## [4] "Cyprinodon_labiosus"   "Cyprinodon_beltrani"   "Cyprinodon_verecundus"
```
An "edge" matrix representing all nodes on the tree with their descendents. Representation of the topology.

```r
head(tree$edge)
```

```
##      [,1] [,2]
## [1,]   41   42
## [2,]   42   43
## [3,]   43    1
## [4,]   43   44
## [5,]   44    2
## [6,]   44   45
```
A vector containing all the branch lengths

```r
head(tree$edge.length)
```

```
## [1] 0.11150576 0.05178767 0.83670657 0.72439302 0.11231355 0.04431559
```

Some summary statistics for the tree:

Number of tips

```r
Ntip(tree)
```

```
## [1] 40
```
Number of nodes

```r
Nnode(tree)
```

```
## [1] 39
```

Total tree depth

```r
bt <- branching.times(tree)
head(bt)
```

```
##         41         42         43         44         45         46 
## 1.00000000 0.88849424 0.83670657 0.11231355 0.06799796 0.04781763
```

```r
max(bt)
```

```
## [1] 1
```

We might want to change the elements of a tree. For example, for some analyses if we are only interested in relative divergence times, we may want to rescale the total tree depth to be one. This allows us to more easily compare the parameters of a trait model across different trees (e.g., the results of a Bayesian analysis)

```r
head(tree$edge.length)
```

```
## [1] 0.11150576 0.05178767 0.83670657 0.72439302 0.11231355 0.04431559
```

```r
tree$edge.length <- tree$edge.length * 2
head(tree$edge.length)
```

```
## [1] 0.22301152 0.10357533 1.67341315 1.44878604 0.22462710 0.08863118
```

Now our tree has been rescaled

```r
max(branching.times(tree))
```

```
## [1] 2
```

## Plotting trees

You can plot the tree by calling `plot.phylo`. Note that simply using `plot` will work just as well but I always use `plot.phylo` because a) it is more transparent and readable; and b) you can see the options

```r
plot.phylo(tree)
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14-1.png) 

```r
help(plot.phylo)
```


There are lots of options. Try typing `help(plot.phylo)`

Default is to plot right facing trees but you can do plot "radial", "fan", "cladogram" or "unrooted". For example, a "fan" phylogeny

```r
plot.phylo(tree, type="fan")
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15-1.png) 
and a radial one

```r
plot.phylo(tree, type="radial")
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16-1.png) 

You can change the color of branches and the size of tip labels

```r
plot.phylo(tree, type="fan", edge.color = "blue", cex=0.5)
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17-1.png) 


Add a binary trait and plot it on the tree

```r
plot.phylo(tree, show.tip.label = FALSE)
states <- sample(c(1,2), Ntip(tree), replace=TRUE)
col <- c("red", "blue")
tiplabels(col=col[states], pch=19)
```

![plot of chunk unnamed-chunk-18](figure/unnamed-chunk-18-1.png) 

Add nodelabels

```r
nodelabels(1:(Ntip(tree)-1))
```

```
## Error in rect(xl, yb, xr, yt, col = bg): plot.new has not been called yet
```

Exercise: Generate different plots


