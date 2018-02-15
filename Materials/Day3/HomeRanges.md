---
layout: page
title: MCP & Kernel Density estimation
use-site-title: true
---

``` r
library(tidyverse)
library(sf)
library(adehabitatHR)
library(move)
```

Today we are going to explore 2 of 3 main methods for home range estimation in R. Eric will touch on the 3rd - convex hull methods - on Tuesday. Today, we will again work primarily with the adehabitatHR library and the move library. Most of this code and text is an adaptation of the extensive adehabitatHR vignettes, which we encourange you to consult for further detail and references.

Minimum Convex Polygon
======================

As dicussed in lecture, the simplest delineation of a home range is an MCP, creating the polygon of minimum area around a certain percentage of relocation points. The MCP is simple and used widely in ecology.

If you are curious to estimate the overall area of your animal's home range the `move` package includes a function to bootstrap the mcp estimation:

``` r
data(leroy) # a package moveobject
hrBootstrap(x=leroy, rep=25, unin='km', unout='km2')
```

    ## 5 6 8 10 13 16 20 25 32 40 50 63 79 100 126 158 199 251 315 397 500 629 792

![](../HomeRanges_files/figure-markdown_github/unnamed-chunk-2-1.png)

    ##               0%          25%          50%          75%         100%
    ## 5   2.856609e-05 7.884089e-05 0.0001588235 0.0003846557 0.0007238132
    ## 6   1.972186e-05 1.736629e-04 0.0002918033 0.0003477340 0.0005503787
    ## 8   6.789232e-05 3.862260e-04 0.0005050277 0.0005388766 0.0008671388
    ## 10  1.515316e-04 3.929470e-04 0.0006227172 0.0007252085 0.0010169951
    ## 13  2.328876e-04 5.742825e-04 0.0008570206 0.0010471985 0.0013157910
    ## 16  6.341405e-04 7.989624e-04 0.0009012445 0.0010477682 0.0014269845
    ## 20  5.784779e-04 8.731570e-04 0.0009777581 0.0010566575 0.0016268845
    ## 25  6.908908e-04 8.618173e-04 0.0010380818 0.0013321984 0.0015402082
    ## 32  9.417876e-04 1.231098e-03 0.0013335048 0.0014182607 0.0015754012
    ## 40  9.446279e-04 1.261352e-03 0.0013871275 0.0014941349 0.0018566874
    ## 50  1.036631e-03 1.368461e-03 0.0014582292 0.0015563905 0.0017270491
    ## 63  1.219163e-03 1.395248e-03 0.0014652890 0.0015890994 0.0017642617
    ## 79  1.328388e-03 1.519514e-03 0.0015716122 0.0016204821 0.0017948463
    ## 100 1.432152e-03 1.629615e-03 0.0016883163 0.0017383434 0.0019728908
    ## 126 1.422793e-03 1.612736e-03 0.0016921294 0.0017205430 0.0018578881
    ## 158 1.606872e-03 1.724501e-03 0.0018482414 0.0019013633 0.0020094346
    ## 199 1.585017e-03 1.777313e-03 0.0018239528 0.0018850979 0.0020070971
    ## 251 1.742653e-03 1.854303e-03 0.0019030180 0.0019440192 0.0020472782
    ## 315 1.728135e-03 1.850187e-03 0.0018886975 0.0019663051 0.0020099244
    ## 397 1.864262e-03 1.919151e-03 0.0019570669 0.0020205168 0.0020627947
    ## 500 1.714421e-03 1.890574e-03 0.0019318793 0.0020120750 0.0021085296
    ## 629 1.811784e-03 1.948667e-03 0.0019976107 0.0020817540 0.0021233812
    ## 792 1.923435e-03 2.000142e-03 0.0020321390 0.0020686457 0.0021097437

The resulting table and plot can give you a fairly quick estimate of your animals stable home range. Note that this method works especially well for a territorial animal like a fisher, but might appear much less stable for a migratory or nomadic individual.

If, however, you need to delineate the boundaries of the MCP, the adehabitatHR library has more options for you. The `mcp` function allows you to specify the percentage of coordinates to be included and works on any two column dataframe specifying the coordinates of animal relocations:

``` r
data(bear)
xy <- SpatialPoints(na.omit(ld(bear)[,1:2]))

mcp <- mcp(xy, percent=90)

ggplot() + geom_sf(data = st_as_sf(mcp)) + geom_sf(data=st_as_sf(xy))
```

![](../HomeRanges_files/figure-markdown_github/unnamed-chunk-3-1.png)

Yikes! look at all that "unused" space contained within even a 90% mcp!

We'll get to better metrics shortly but if you want to compare the area of your mcp across percentages, the `mcp.area` function works well:

``` r
mcp.area(xy, percent = seq(20,100, by = 5),
         unin = c("m", "km"),
         unout = c("ha", "km2", "m2"), plotit = TRUE)
```

![](../HomeRanges_files/figure-markdown_github/unnamed-chunk-4-1.png)

    ##             a
    ## 20   103.1981
    ## 25   133.9152
    ## 30   157.8969
    ## 35   330.6820
    ## 40   536.9781
    ## 45   788.9646
    ## 50   942.7685
    ## 55  1326.5800
    ## 60  1627.3274
    ## 65  1667.6074
    ## 70  1924.5011
    ## 75  1928.3710
    ## 80  2035.2868
    ## 85  2353.3132
    ## 90  2985.5309
    ## 95  3654.5171
    ## 100 3743.5210

If you are curious to see, what's going on under the hood of the adehabitatHR mcp functions, I recommend checking out [this blog post](https://www.r-bloggers.com/home-range-estimation-mcp) on the subject by Mitchell Gritts.

Kernel Density Estimation
=========================

Worton Kernel UD
----------------

The "classical" utilization distribution: Worton (1995)

> The Utilization Distribution (UD) is the bivariate function giving the probability density that an animal is found at a point according to its geographical coordinates. Using this model, one can define the home range as the minimum area in which an animal has some specified probability of being located.

``` r
kud <- kernelUD(xy)  # h = href is the default - ad hoc method for determining h
image(kud) + title("Bear UD")
```

![](../HomeRanges_files/figure-markdown_github/unnamed-chunk-5-1.png)


``` r
## Kernel home range
jj <- kernel.area(kud)                  ## home range size
plot(jj)                                   ## Plots home range size
```

![](../HomeRanges_files/figure-markdown_github/unnamed-chunk-5-2.png)

``` r
ver95 <- getverticeshr(kud) ## home-range contours
ver80  <- getverticeshr(kud, percent = 80)
plot(ver95)  + plot(ver80, add=TRUE, col="green")  +  points(xy)   ## Plots contours
```

![](../HomeRanges_files/figure-markdown_github/unnamed-chunk-5-3.png)


Additional Resources/Methods:
=============================

The above is only one of the many methods adehabitatHR library contains to calculate home ranges, complete list below:

1.  The Minimum Convex Polygon (Mohr, 1947)

2.  Several kernel home range methods:

-   The “classical” kernel method (Worton, 1989)
-   the Brownian bridge kernel method (Bullard, 1999, Horne et al. **the only temporal kernel method included in adehabitatHR**
-   The Biased random bridge kernel method, also called “movementbased kernel estimation” (Benhamou and Cornelis, 2010, Benhamou, 2011)
-   the product kernel algorithm (Keating and Cherry, 2009)

3.  Several home-range estimation methods relying on the calculation of convex hulls:

-   The modification by Kenward et al. (2001) of the single-linkage clustering algorithm
-   The three LoCoH (Local Convex Hull) methods developed by Getz et al. (2007)
-   The characteristic hull method of Downs and Horner (2009)

Temporal Kernel Methods
-----------------------

-   Autocorrelated Kernel Density Estimation <https://cran.r-project.org/web/packages/ctmm/vignettes/akde.html>
