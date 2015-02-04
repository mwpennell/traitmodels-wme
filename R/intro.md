# Introduction to working in R

```r
knitr::opts_chunk$set(tidy=FALSE)
```

https://github.com/mwpennell/traitmodels-wme/R

In this tutorial, I will briefly go over the basics of working in R. For many people this may be review and for those who are just starting out, there are many, much more comprehensive introductions to R available on the web. The purpose of this exercise is simply to make sure that everyone is on the same page so we can dive into the more interesting things.

### Packages/Getting started
R has a tremendous ecosystem of packages -- this is the its "killer app"

To install a package directly from CRAN, use the function `install.packages()`
```
install.packages("ape")
```

To load the package into the **NAMESPACE**

```r
library(ape)
```

Many packages are not available on CRAN and exist only on github/bitbucket/some other other repo. Fortunately it is possible to install these directly into R with the `devtools` package
```
install.packages("devtools")
```

For example, my own package `arbutus` for assessing the adequacy of phylogenetic modesl of trait evolution is only on GitHub. To load this in to R, type
```
library(devtools)
install_github("mwpennell/arbutus")
```

You will note that in R the naming convention for functions is not consistent. It is often to difficult to remember precisely what functions are called. Luckily, for every package there is a help page. These vary greatly in how helpful they actually are

```r
help("ape")
```
or

```r
?ape
```

You can also query for specific topics using `??`

```r
??"ancestral state"
```

### Types of objects
In R, there are several common types of objects

1. Vectors
This can be numeric or character

```r
x <- c(1,2,3)
x
```

```
## [1] 1 2 3
```

```r
y <- c("trees", "are", "cool")
y
```

```
## [1] "trees" "are"   "cool"
```
But combining the types will default to characters. This is a common source of error when dealing with phylogenetic data (particularly if there are comments in the data alongside measured values)

```r
z <- c(1,"trees")
z
```

```
## [1] "1"     "trees"
```
You can subset a vector

```r
x[1]
```

```
## [1] 1
```
Or give the objects names. This is particularly improtant for phylogenetic comparative analyses when you want to associate a measurement with a species

```r
names(x) <- c("sp1", "sp2", "sp3")
x["sp2"]
```

```
## sp2 
##   2
```

2. Matrices
Like vectors, matrices can only contain one type of object (character or numeric)

```r
m <- matrix(c(1,2,3,4), nrow=2, ncol=2)
```
To subset a matrix we can use

```r
m[,1]
```

```
## [1] 1 2
```
to get the first column, or

```r
m[1,1]
```

```
## [1] 1
```
to get a particular entry

Like vectors we can attach column and rownames

```r
colnames(m) <- c("trait1","trait2")
```
and subset by the column name

```r
m[,"trait1"]
```

```
## [1] 1 2
```

3. Data.frames and Lists

```r
d <- data.frame(a=c(1,2), b=c(3,4))
d
```

```
##   a b
## 1 1 3
## 2 2 4
```

```r
l <- list(a=c(1,2), b=c(3,4))
l
```

```
## $a
## [1] 1 2
## 
## $b
## [1] 3 4
```

We can use the `$` operator to pull out one element of interest

```r
d$a
```

```
## [1] 1 2
```

```r
l$a
```

```
## [1] 1 2
```

