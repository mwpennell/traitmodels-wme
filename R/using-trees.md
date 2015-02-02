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
An "edge" matrix representing all nodes on the tree with their descendents. Representation of the topology.

```r
tree$edge
```

```
##       [,1] [,2]
##  [1,]   41   42
##  [2,]   42   43
##  [3,]   43    1
##  [4,]   43   44
##  [5,]   44    2
##  [6,]   44   45
##  [7,]   45    3
##  [8,]   45   46
##  [9,]   46   47
## [10,]   47    4
## [11,]   47    5
## [12,]   46   48
## [13,]   48    6
## [14,]   48   49
## [15,]   49    7
## [16,]   49    8
## [17,]   42   50
## [18,]   50   51
## [19,]   51   52
## [20,]   52    9
## [21,]   52   53
## [22,]   53   10
## [23,]   53   11
## [24,]   51   54
## [25,]   54   55
## [26,]   55   12
## [27,]   55   13
## [28,]   54   56
## [29,]   56   14
## [30,]   56   15
## [31,]   50   57
## [32,]   57   16
## [33,]   57   58
## [34,]   58   59
## [35,]   59   60
## [36,]   60   17
## [37,]   60   18
## [38,]   59   19
## [39,]   58   61
## [40,]   61   20
## [41,]   61   62
## [42,]   62   21
## [43,]   62   63
## [44,]   63   22
## [45,]   63   23
## [46,]   41   64
## [47,]   64   65
## [48,]   65   24
## [49,]   65   66
## [50,]   66   25
## [51,]   66   67
## [52,]   67   26
## [53,]   67   27
## [54,]   64   68
## [55,]   68   69
## [56,]   69   28
## [57,]   69   29
## [58,]   68   70
## [59,]   70   71
## [60,]   71   30
## [61,]   71   72
## [62,]   72   31
## [63,]   72   32
## [64,]   70   73
## [65,]   73   33
## [66,]   73   74
## [67,]   74   34
## [68,]   74   75
## [69,]   75   76
## [70,]   76   35
## [71,]   76   77
## [72,]   77   36
## [73,]   77   37
## [74,]   75   78
## [75,]   78   38
## [76,]   78   79
## [77,]   79   39
## [78,]   79   40
```
A vector containing all the branch lengths

```r
tree$edge.length
```

```
##  [1] 0.111505760 0.051787667 0.836706573 0.724393022 0.112313551
##  [6] 0.044315589 0.067997962 0.020180328 0.035842316 0.011975318
## [11] 0.011975318 0.022490215 0.025327420 0.013397745 0.011929675
## [16] 0.011929675 0.032623714 0.110305493 0.290697523 0.454867510
## [21] 0.420722964 0.034144547 0.034144547 0.077513643 0.137316706
## [26] 0.530734684 0.530734684 0.655400484 0.012650906 0.012650906
## [31] 0.453679225 0.402191301 0.039436342 0.055525110 0.278948846
## [36] 0.028281003 0.028281003 0.307229849 0.070089687 0.292665272
## [41] 0.173314405 0.119350867 0.041746724 0.077604143 0.077604143
## [46] 0.230506569 0.177005509 0.592487921 0.209336171 0.383151750
## [51] 0.286078667 0.097073083 0.097073083 0.282348451 0.442609986
## [56] 0.044534994 0.044534994 0.054405108 0.317136006 0.115603865
## [61] 0.078370571 0.037233295 0.037233295 0.167538112 0.265201759
## [66] 0.035287247 0.229914511 0.029242847 0.144902781 0.055768883
## [71] 0.047459671 0.008309212 0.008309212 0.011394776 0.189276889
## [76] 0.080664798 0.108612090 0.108612090
```

Some summary statistics for the tree:

Number of tips

```r
Ntip(tree)
```

```
## [1] 40
```

Total tree depth

```r
max(branching.times(tree))
```

```
## [1] 1
```

We might want to change the elements of a tree. For example, for some analyses if we are only interested in relative divergence times, we may want to rescale the total tree depth to be one. This allows us to more easily compare the parameters of a trait model across different trees (e.g., the results of a Bayesian analysis)

```r
tree$edge.length <- tree$edge.length/max(branching.times(tree))
```

Now our tree has been rescaled

```r
max(branching.times(tree))
```

```
## [1] 1
```

## Plotting trees


```r
plot.phylo(tree)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png) 

```r
plot.phylo(tree, type="fan")
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-2.png) 

```r
plot.phylo(tree, type="fan", edge.color = "blue", cex=0.5)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-3.png) 

```r
plot.phylo(tree, type="radial")
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-4.png) 

Add a binary trait and plot it on the tree

```r
plot.phylo(tree, show.tip.label = FALSE)
states <- sample(c(1,2), Ntip(tree), replace=TRUE)
col <- c("red", "blue")
tiplabels(col=col[states], pch=19)
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13-1.png) 




