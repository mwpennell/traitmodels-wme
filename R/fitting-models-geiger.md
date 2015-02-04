## Fitting models to trait data

Here we are going to do some simple examples of fitting models of continuous characte evolution to comparative data

We are going to use the `geiger` package for this

install.packages("geiger")

```r
library(geiger)
packageVersion("geiger")
```

```
## [1] '2.0.4'
```

In case geiger's package version is less than 1.9

```r
library(devtools)
install_github("mwpennell/geiger-v2")
```

```
## Downloading github repo mwpennell/geiger-v2@master
## Installing geiger
## '/usr/lib/R/bin/R' --vanilla CMD INSTALL  \
##   '/tmp/Rtmpswhy9y/devtools5b9178e11a91/mwpennell-geiger-v2-6d28b51'  \
##   --library='/usr/local/lib/R/site-library' --install-tests
```

```
## Error: Command failed (1)
```



```r
rm(list=ls())
```

Load the Cyprinodon tree and dataset

```r
cyp_phy <- read.tree("datasets/cyprinodon.tre")
```
Tip: Setting `row.names=1` assigns the rownames to be equal to the first column (in this case the species names)

```r
cyp_dat <- read.csv("datasets/cyprinodon.csv", row.names=1)

head(cyp_dat)
```

```
##                                 A1         A23  body.depth closing.lever
## Cyprinodon_albivelis    0.02798847  0.05233315  0.10385841    0.07847281
## Cyprinodon_alvarezi     0.00628198  0.01576924  0.01721441    0.06369799
## Cyprinodon_artifrons    0.02702148  0.06121726  0.10887262   -0.16395200
## Cyprinodon_atrorus      0.00235965  0.01087319  0.03061420   -0.16382930
## Cyprinodon_beltrani    -0.08306680 -0.00784860 -0.03041860   -0.21565530
## Cyprinodon_bifasciatus  0.00338178  0.02517095 -0.02424630   -0.12252760
##                              gape  jaw.length protrusion.distance
## Cyprinodon_albivelis    0.1067667  0.10995734          0.07577510
## Cyprinodon_alvarezi     0.2489257  0.04573827         -0.04893370
## Cyprinodon_artifrons   -0.1007200 -0.07247250         -0.04437980
## Cyprinodon_atrorus     -0.0392393 -0.04421680          0.14170828
## Cyprinodon_beltrani    -0.2130060 -0.17774750         -0.01997620
## Cyprinodon_bifasciatus -0.3093083 -0.01509750          0.00788962
##                        lower.premaxilla    maxilla maxillary.process
## Cyprinodon_albivelis         0.20329719  0.1587159        0.03742575
## Cyprinodon_alvarezi          0.11370293  0.1232416       -0.09776890
## Cyprinodon_artifrons        -0.08089660 -0.1379473       -0.07011640
## Cyprinodon_atrorus           0.03553484 -0.0135882       -0.08654130
## Cyprinodon_beltrani         -0.19863320 -0.2754654       -0.25740750
## Cyprinodon_bifasciatus      -0.16756890 -0.1267028       -0.14829150
##                        opening.lever       orbit cranial.width
## Cyprinodon_albivelis      0.15588157 -0.05378520    0.18654154
## Cyprinodon_alvarezi       0.22112680 -0.08367770    0.06386122
## Cyprinodon_artifrons     -0.10360530  0.06582620   -0.15708530
## Cyprinodon_atrorus        0.02886228 -0.04347350    0.07857652
## Cyprinodon_beltrani      -0.19188200  0.01898664   -0.19394700
## Cyprinodon_bifasciatus   -0.08165260  0.08687082    0.03303227
##                        tooth.number tooth.length upper.premaxilla
## Cyprinodon_albivelis    -0.07968100   0.17450435       0.09077204
## Cyprinodon_alvarezi     -0.00263750  -0.11585610      -0.02328730
## Cyprinodon_artifrons     0.03871055   0.05936087      -0.02612810
## Cyprinodon_atrorus      -0.07266750   0.01518795      -0.00106250
## Cyprinodon_beltrani     -0.04978080  -0.10276870      -0.12328210
## Cyprinodon_bifasciatus   0.03997953   0.18987733       0.07921030
```

For comparative analyses, we need to match the tree and the data. If data is in the form of a vector, names must match the tip labels of the tree. If data is a matrix or data.frame, then rownames need to match the tree. **N.B.:** geiger automatically checks and matches the names of the data and the tree but not all packages/functions do this. It is good practice to **always** do this manually to avoid non-sensical results

Use geiger's `treedata()` function for this

```r
cyp_td <- treedata(cyp_phy, cyp_dat)
str(cyp_td)
```

```
## List of 2
##  $ phy :List of 4
##   ..$ edge       : int [1:78, 1:2] 41 42 43 43 44 44 45 45 46 47 ...
##   ..$ Nnode      : int 39
##   ..$ tip.label  : chr [1:40] "Cyprinodon_alvarezi" "Cyprinodon_artifrons" "Cyprinodon_maya" "Cyprinodon_labiosus" ...
##   ..$ edge.length: num [1:78] 0.1115 0.0518 0.8367 0.7244 0.1123 ...
##   ..- attr(*, "class")= chr "phylo"
##   ..- attr(*, "order")= chr "cladewise"
##  $ data: num [1:40, 1:16] 0.02799 0.00628 0.02702 0.00236 -0.08307 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:40] "Cyprinodon_albivelis" "Cyprinodon_alvarezi" "Cyprinodon_artifrons" "Cyprinodon_atrorus" ...
##   .. ..$ : chr [1:16] "A1" "A23" "body.depth" "closing.lever" ...
```

```r
dummy_tree <- cyp_phy
head(dummy_tree$tip.label)
```

```
## [1] "Cyprinodon_alvarezi"   "Cyprinodon_artifrons"  "Cyprinodon_maya"      
## [4] "Cyprinodon_labiosus"   "Cyprinodon_beltrani"   "Cyprinodon_verecundus"
```

```r
dummy_tree_drop <- drop.tip(dummy_tree, tip="Cyprinodon_alvarezi")
dummy_tree_drop
```

```
## 
## Phylogenetic tree with 39 tips and 38 internal nodes.
## 
## Tip labels:
## 	Cyprinodon_artifrons, Cyprinodon_maya, Cyprinodon_labiosus, Cyprinodon_beltrani, Cyprinodon_verecundus, Cyprinodon_esconditus, ...
## 
## Rooted; includes branch lengths.
```


These match. But here is what happens when this is not the case

```r
data(geospiza)
geo_phy <- geospiza$phy
geo_dat <- geospiza$dat
geo_td <- treedata(geo_phy, geo_dat)
```

```
## Warning in treedata(geo_phy, geo_dat): The following tips were not found in 'data' and were dropped from 'phy':
## 	olivacea
```

To do this "by hand"

```r
geo_phy <- geospiza$phy
geo_dat <- geospiza$dat
to_drop <- geo_phy$tip.label[!geo_phy$tip.label %in% rownames(geo_dat)]
```
Drop the tips

```r
geo_phy_pr <- drop.tip(geo_phy, tip=to_drop)
geo_phy_pr
```

```
## 
## Phylogenetic tree with 13 tips and 12 internal nodes.
## 
## Tip labels:
## 	fuliginosa, fortis, magnirostris, conirostris, scandens, difficilis, ...
## 
## Rooted; includes branch lengths.
```
Trim down the dataset

```r
geo_dat_pr <- geo_dat[geo_phy_pr$tip.label,] ## Select all columns
geo_dat_pr
```

```
##                 wingL  tarsusL  culmenL    beakD   gonysW
## fuliginosa   4.132957 2.806514 2.094971 1.941157 1.845379
## fortis       4.244008 2.894717 2.407025 2.362658 2.221867
## magnirostris 4.404200 3.038950 2.724667 2.823767 2.675983
## conirostris  4.349867 2.984200 2.654400 2.513800 2.360167
## scandens     4.261222 2.929033 2.621789 2.144700 2.036944
## difficilis   4.224067 2.898917 2.277183 2.011100 1.929983
## pallida      4.265425 3.089450 2.430250 2.016350 1.949125
## parvulus     4.131600 2.973060 1.974420 1.873540 1.813340
## psittacula   4.235020 3.049120 2.259640 2.230040 2.073940
## pauper       4.232500 3.035900 2.187000 2.073400 1.962100
## Platyspiza   4.419686 3.270543 2.331471 2.347471 2.282443
## fusca        3.975393 2.936536 2.051843 1.191264 1.401186
## Pinaroloxias 4.188600 2.980200 2.311100 1.547500 1.630100
```


## Fitting models of trait evolution

Use "jaw.length" as the trait of interest. Use the `treedata` object because we know that the tips are already matched.

```r
states <- cyp_td$data[,"jaw.length"]
tree <- cyp_td$phy

states <- states[tree$tip.label]
```

Brownian motion

```r
fit_bm <- fitContinuous(tree, states, model="BM")
```

```
## Loading required package: parallel
```

Examine the model object

```r
fit_bm
```

```
## GEIGER-fitted comparative model of continuous data
##  fitted 'BM' model parameters:
## 	sigsq = 0.157240
## 	z0 = 0.014653
## 
##  model summary:
## 	log-likelihood = 8.739208
## 	AIC = -13.478415
## 	AICc = -13.154091
## 	free parameters = 2
## 
## Convergence diagnostics:
## 	optimization iterations = 100
## 	failed iterations = 0
## 	frequency of best fit = 1.00
## 
##  object summary:
## 	'lik' -- likelihood function
## 	'bnd' -- bounds for likelihood search
## 	'res' -- optimization iteration summary
## 	'opt' -- maximum likelihood parameter estimates
```

```r
fit_bm$opt
```

```
## $sigsq
## [1] 0.1572397
## 
## $z0
## [1] 0.01465335
## 
## $lnL
## [1] 8.739208
## 
## $method
## [1] "Brent"
## 
## $k
## [1] 2
## 
## $aic
## [1] -13.47842
## 
## $aicc
## [1] -13.15409
```

```r
fit_bm$opt$sigsq
```

```
## [1] 0.1572397
```

```r
fit_bm$opt$aic
```

```
## [1] -13.47842
```

Ornstein-Uhlenbeck

```r
fit_ou <- fitContinuous(tree, states, model="OU")
```

```
## Warning in fitContinuous(tree, states, model = "OU"): Parameter estimates appear at bounds:
## 	alpha
```

Early burst

```r
fit_eb <- fitContinuous(tree, states, model="EB")
```

```
## Warning in fitContinuous(tree, states, model = "EB"): Parameter estimates appear at bounds:
## 	a
```

Compare the models using AIC

```r
aic_bm <- fit_bm$opt$aic
aic_ou <- fit_ou$opt$aic
aic_eb <- fit_eb$opt$aic
```

Get the AIC weights
Create a named vector

```r
aic_all <- c(aic_bm, aic_ou, aic_eb)
names(aic_all) <- c("BM", "OU", "EB")
aicw(aic_all)
```

```
##          fit    delta            w
## BM -13.47842 20.05987 4.405847e-05
## OU -33.53828  0.00000 9.999397e-01
## EB -11.47841 22.05987 1.620816e-05
```
Almost all the AICw is on OU

Look at the parameter values of the OU model

```r
fit_ou$opt
```

```
## $alpha
## [1] 2.718282
## 
## $sigsq
## [1] 0.2012396
## 
## $z0
## [1] 0.01659888
## 
## $lnL
## [1] 19.76914
## 
## $method
## [1] "L-BFGS-B"
## 
## $k
## [1] 3
## 
## $aic
## [1] -33.53828
## 
## $aicc
## [1] -32.87161
```

Calculate the phylogenetic half-life -- how long does it take for half the infromation in the phylogeny to be erased

```r
phy_halflife <- log(2)/fit_ou$opt$alpha
phy_halflife
```

```
## [1] 0.2549946
```


Compare this to total tree depth

```r
phy_halflife / max(branching.times(tree))
```

```
## [1] 0.2549946
```

In one quarter of the tree height, half the information is lost


## Estimating phylogenetic signal (Pagel's lambda)

```r
fit_lambda <- fitContinuous(tree, states, model="lambda")
```

The estimate will be between 0 and 1

```r
fit_lambda$opt$lambda
```

```
## [1] 6.150775e-206
```


## Incorporating error
Simulate some data


```r
sim_phy <- sim.bdtree(b=1, d=0, stop="taxa",n=1000, seed=2)

sim_dat <- sim.char(sim_phy, par=1, model="BM")[,,]
```

Fit BM

```r
sim_fit <- fitContinuous(sim_phy, sim_dat, SE=0, model="BM")

sim_fit$opt$sigsq
```

```
## [1] 1.043964
```

Now add error to the data

```r
sim_dat_error <- sim_dat + rnorm(1000, 0, sd=0.1)

sim_fit_error <- fitContinuous(sim_phy, sim_dat_error, SE=0, model="BM")

sim_fit_error$opt$sigsq
```

```
## [1] 1.130594
```

```r
sim_fit_wse <- fitContinuous(sim_phy, sim_dat_error, SE=0.1, model="BM")

sim_fit_wse$opt$sigsq
```

```
## [1] 1.056451
```


## Discrete Characters
Simulate characters on Cyprinodon tree because we don't have discrete data available for this group

Make a Q matrix -- same as for molecular characters

```r
Q <- matrix(c(-0.3, 0.3, 0.1, -0.1), nrow=2, byrow = TRUE)
Q <- matrix(c(-0.3, 0.1, 0.3, -0.1), nrow=2)
states_dis <- sim.char(tree, par=Q, model="discrete")[,,]
```

### Fit discrete character models

Assume forward and backwards rates are equal ("ER" model)

```r
fit_sym <- fitDiscrete(tree, states_dis, model="ER")
```

Allow the forward and backward rates to be different ("ARD" model)

```r
fit_dif <- fitDiscrete(tree, states_dis, model="ARD")
```

Compare the models

```r
aic_sym <- fit_sym$opt$aic
aic_dif <- fit_dif$opt$aic
aic_dis <- c(aic_sym, aic_dif)

aic_dis <- c(fit_sym$opt$aic, fit_dif$opt$aic)
names(aic_dis) <- c("ER", "ARD")
aicw(aic_dis)
```

```
##          fit   delta         w
## ER  23.93739 0.00000 0.6651534
## ARD 25.31008 1.37269 0.3348466
```


## Exercise
Read in the Anolis data and fit and compare models of trait evolution

```r
anol_phy <- read.tree("datasets/anolis.tre")
anol_dat <- read.csv("datasets/anolis.csv", row.names=1)
```
