## ## Fitting models to trait data

## Here we are going to do some simple examples of fitting models of continuous characte evolution to comparative data

## We are going to use the `geiger` package for this
##
## install.packages("geiger")
library(geiger)
packageVersion("geiger")

## In case geiger's package version is less than 1.9
library(devtools)
install_github("mwpennell/geiger-v2")
##

rm(list=ls())

## Load the Cyprinodon tree and dataset
cyp_phy <- read.tree("datasets/cyprinodon.tre")
## Tip: Setting `row.names=1` assigns the rownames to be equal to the first column (in this case the species names)
cyp_dat <- read.csv("datasets/cyprinodon.csv", row.names=1)

head(cyp_dat)

## For comparative analyses, we need to match the tree and the data. If data is in the form of a vector, names must match the tip labels of the tree. If data is a matrix or data.frame, then rownames need to match the tree. **N.B.:** geiger automatically checks and matches the names of the data and the tree but not all packages/functions do this. It is good practice to **always** do this manually to avoid non-sensical results

## Use geiger's `treedata()` function for this
cyp_td <- treedata(cyp_phy, cyp_dat)
str(cyp_td)

dummy_tree <- cyp_phy
head(dummy_tree$tip.label)
dummy_tree_drop <- drop.tip(dummy_tree, tip="Cyprinodon_alvarezi")
dummy_tree_drop


## These match. But here is what happens when this is not the case
data(geospiza)
geo_phy <- geospiza$phy
geo_dat <- geospiza$dat
geo_td <- treedata(geo_phy, geo_dat)

## To do this "by hand"
geo_phy <- geospiza$phy
geo_dat <- geospiza$dat
to_drop <- geo_phy$tip.label[!geo_phy$tip.label %in% rownames(geo_dat)]
## Drop the tips
geo_phy_pr <- drop.tip(geo_phy, tip=to_drop)
geo_phy_pr
## Trim down the dataset
geo_dat_pr <- geo_dat[geo_phy_pr$tip.label,] ## Select all columns
geo_dat_pr


## ## Fitting models of trait evolution

## Use "jaw.length" as the trait of interest. Use the `treedata` object because we know that the tips are already matched.
states <- cyp_td$data[,"jaw.length"]
tree <- cyp_td$phy

states <- states[tree$tip.label]

## Brownian motion
fit_bm <- fitContinuous(tree, states, model="BM")

## Examine the model object
fit_bm
fit_bm$opt
fit_bm$opt$sigsq
fit_bm$opt$aic

## Ornstein-Uhlenbeck
fit_ou <- fitContinuous(tree, states, model="OU")

## Early burst
fit_eb <- fitContinuous(tree, states, model="EB")

## Compare the models using AIC
aic_bm <- fit_bm$opt$aic
aic_ou <- fit_ou$opt$aic
aic_eb <- fit_eb$opt$aic

## Get the AIC weights
## Create a named vector
aic_all <- c(aic_bm, aic_ou, aic_eb)
names(aic_all) <- c("BM", "OU", "EB")
aicw(aic_all)
## Almost all the AICw is on OU

## Look at the parameter values of the OU model
fit_ou$opt

## Calculate the phylogenetic half-life -- how long does it take for half the infromation in the phylogeny to be erased
phy_halflife <- log(2)/fit_ou$opt$alpha
phy_halflife


## Compare this to total tree depth
phy_halflife / max(branching.times(tree))

## In one quarter of the tree height, half the information is lost


## ## Estimating phylogenetic signal (Pagel's lambda)
fit_lambda <- fitContinuous(tree, states, model="lambda")

## The estimate will be between 0 and 1
fit_lambda$opt$lambda


## ## Incorporating error
## Simulate some data

sim_phy <- sim.bdtree(b=1, d=0, stop="taxa",n=1000, seed=2)

sim_dat <- sim.char(sim_phy, par=1, model="BM")[,,]

## Fit BM
sim_fit <- fitContinuous(sim_phy, sim_dat, SE=0, model="BM")

sim_fit$opt$sigsq

## Now add error to the data
sim_dat_error <- sim_dat + rnorm(1000, 0, sd=0.1)

sim_fit_error <- fitContinuous(sim_phy, sim_dat_error, SE=0, model="BM")

sim_fit_error$opt$sigsq

sim_fit_wse <- fitContinuous(sim_phy, sim_dat_error, SE=0.1, model="BM")

sim_fit_wse$opt$sigsq


## ## Discrete Characters
## Simulate characters on Cyprinodon tree because we don't have discrete data available for this group

## Make a Q matrix -- same as for molecular characters
Q <- matrix(c(-0.3, 0.3, 0.1, -0.1), nrow=2, byrow = TRUE)
Q <- matrix(c(-0.3, 0.1, 0.3, -0.1), nrow=2)
states_dis <- sim.char(tree, par=Q, model="discrete")[,,]

## ### Fit discrete character models

## Assume forward and backwards rates are equal ("ER" model)
fit_sym <- fitDiscrete(tree, states_dis, model="ER")

## Allow the forward and backward rates to be different ("ARD" model)
fit_dif <- fitDiscrete(tree, states_dis, model="ARD")

## Compare the models
aic_sym <- fit_sym$opt$aic
aic_dif <- fit_dif$opt$aic
aic_dis <- c(aic_sym, aic_dif)

aic_dis <- c(fit_sym$opt$aic, fit_dif$opt$aic)
names(aic_dis) <- c("ER", "ARD")
aicw(aic_dis)


## ## Exercise
## Read in the Anolis data and fit and compare models of trait evolution
anol_phy <- read.tree("datasets/anolis.tre")
anol_dat <- read.csv("datasets/anolis.csv", row.names=1)
