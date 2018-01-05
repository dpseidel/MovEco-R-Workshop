Day 3 - MCP & Kernel Density estimatiopn
================
Dana Seidel & Eric Dougherty
January 5, 2018

``` r
library(tidyverse)
```

    ## ── Attaching packages ───────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1.9000     ✔ purrr   0.2.4     
    ## ✔ tibble  1.4.1          ✔ dplyr   0.7.4     
    ## ✔ tidyr   0.7.2          ✔ stringr 1.2.0     
    ## ✔ readr   1.1.1          ✔ forcats 0.2.0

    ## ── Conflicts ──────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(sf)
```

    ## Linking to GEOS 3.6.1, GDAL 2.1.3, proj.4 4.9.3

``` r
library(adehabitatHR)
```

    ## Loading required package: sp

    ## Loading required package: deldir

    ## deldir 0.1-14

    ## Loading required package: ade4

    ## Loading required package: adehabitatMA

    ## Loading required package: adehabitatLT

    ## Loading required package: CircStats

    ## Loading required package: MASS

    ## 
    ## Attaching package: 'MASS'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     select

    ## Loading required package: boot

    ## 
    ## Attaching package: 'adehabitatLT'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     id

``` r
library(move)
```

    ## Loading required package: geosphere

    ## Loading required package: raster

    ## 
    ## Attaching package: 'raster'

    ## The following objects are masked from 'package:MASS':
    ## 
    ##     area, select

    ## The following object is masked from 'package:adehabitatMA':
    ## 
    ##     buffer

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     select

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     extract

    ## The following object is masked from 'package:ggplot2':
    ## 
    ##     calc

    ## Loading required package: rgdal

    ## rgdal: version: 1.2-16, (SVN revision 701)
    ##  Geospatial Data Abstraction Library extensions to R successfully loaded
    ##  Loaded GDAL runtime: GDAL 2.1.3, released 2017/20/01
    ##  Path to GDAL shared files: /Users/ericdougherty/Library/R/3.4/library/rgdal/gdal
    ##  GDAL binary built with GEOS: FALSE 
    ##  Loaded PROJ.4 runtime: Rel. 4.9.3, 15 August 2016, [PJ_VERSION: 493]
    ##  Path to PROJ.4 shared files: /Users/ericdougherty/Library/R/3.4/library/rgdal/proj
    ##  Linking to sp version: 1.2-5

    ## 
    ## Attaching package: 'move'

    ## The following object is masked from 'package:adehabitatLT':
    ## 
    ##     burst

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

![](HomeRanges_files/figure-markdown_github/unnamed-chunk-2-1.png)

    ##               0%          25%          50%          75%         100%
    ## 5   4.755286e-07 6.163582e-05 0.0001984524 0.0002841505 0.0004735062
    ## 6   4.669731e-05 2.213831e-04 0.0002573400 0.0004674645 0.0006558646
    ## 8   9.311555e-05 3.652873e-04 0.0004754356 0.0005733618 0.0011052751
    ## 10  2.757605e-04 4.548238e-04 0.0006342312 0.0007802921 0.0011641285
    ## 13  3.471467e-04 6.567920e-04 0.0008326867 0.0009379171 0.0012340096
    ## 16  2.896771e-04 8.330837e-04 0.0009367388 0.0011558690 0.0013052662
    ## 20  7.357912e-04 9.482954e-04 0.0010664975 0.0012455478 0.0015388483
    ## 25  7.600985e-04 1.007871e-03 0.0011094594 0.0012396106 0.0016581844
    ## 32  6.462124e-04 1.139390e-03 0.0013297201 0.0014401374 0.0016847220
    ## 40  9.250862e-04 1.272369e-03 0.0014095988 0.0015280312 0.0017081122
    ## 50  9.008527e-04 1.276528e-03 0.0014586567 0.0015743662 0.0017129034
    ## 63  1.077056e-03 1.440007e-03 0.0015270428 0.0016467979 0.0017508463
    ## 79  1.389337e-03 1.549191e-03 0.0016334527 0.0017263594 0.0019159030
    ## 100 1.368540e-03 1.589138e-03 0.0016588360 0.0017455252 0.0019443647
    ## 126 1.509921e-03 1.677782e-03 0.0017592313 0.0018539860 0.0020169252
    ## 158 1.654282e-03 1.736197e-03 0.0018142266 0.0019442749 0.0020172788
    ## 199 1.694218e-03 1.815816e-03 0.0018650155 0.0019372332 0.0020606397
    ## 251 1.725797e-03 1.840777e-03 0.0018685218 0.0019319910 0.0020723201
    ## 315 1.700512e-03 1.840503e-03 0.0019241319 0.0019848654 0.0021204291
    ## 397 1.755678e-03 1.914498e-03 0.0019581038 0.0020027070 0.0021108374
    ## 500 1.861728e-03 1.969729e-03 0.0019926660 0.0020386849 0.0021480324
    ## 629 1.888118e-03 1.964952e-03 0.0019916542 0.0020287637 0.0021019362
    ## 792 1.971349e-03 2.035931e-03 0.0020789634 0.0020954987 0.0021524295

The resulting table and plot can give you a fairly quick estimate of your animals stable home range. Note that this method works especially well for a territorial animal like a fisher, but might appear much less stable for a migratory or nomadic individual.

If, however, you need to delineate the boundaries of the MCP, the adehabitatHR library has more options for you. The `mcp` function allows you to specify the percentage of coordinates to be included and works on any two column dataframe specifying the coordinates of animal relocations:

``` r
data(bear)
xy <- SpatialPoints(na.omit(ld(bear)[,1:2]))

mcp <- mcp(xy, percent=90)

ggplot() + geom_sf(data = st_as_sf(mcp)) + geom_sf(data=st_as_sf(xy))
```

![](HomeRanges_files/figure-markdown_github/unnamed-chunk-3-1.png)

Yikes! look at all that "unused" space contained within even a 90% mcp!

We'll get to better metrics shortly but if you want to compare the area of your mcp across percentages, the `mcp.area` function works well:

``` r
mcp.area(xy, percent = seq(20,100, by = 5),
         unin = c("m", "km"),
         unout = c("ha", "km2", "m2"), plotit = TRUE)
```

![](HomeRanges_files/figure-markdown_github/unnamed-chunk-4-1.png)

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

![](HomeRanges_files/figure-markdown_github/unnamed-chunk-5-1.png)

    ## integer(0)

``` r
## Kernel home range
jj <- kernel.area(kud)                  ## home range size
plot(jj)                                   ## Plots home range size
```

![](HomeRanges_files/figure-markdown_github/unnamed-chunk-5-2.png)

``` r
ver95 <- getverticeshr(kud) ## home-range contours
ver80  <- getverticeshr(kud, percent = 80)
plot(ver95)  + plot(ver80, add=TRUE, col="green")  +  points(xy)   ## Plots contours
```

![](HomeRanges_files/figure-markdown_github/unnamed-chunk-5-3.png)

    ## integer(0)

Additional Resources/Methods:
=============================

The above is only one of the many methods adehabitatHR library contains to calculate home ranges, complete list below:

1.  The Minimum Convex Polygon (Mohr, 1947)

2.  Several kernel home range methods:

-   The “classical” kernel method (Worton, 1989)
-   the Brownian bridge kernel method (Bullard, 1999, Horne et al.

1.  **the only temporal kernel method included in adehabitatHR**

-   The Biased random bridge kernel method, also called “movementbased kernel estimation” (Benhamou and Cornelis, 2010, Benhamou,

1.  

-   the product kernel algorithm (Keating and Cherry, 2009).

1.  Several home-range estimation methods relying on the calculation of convex hulls:

-   The modification by Kenward et al. (2001) of the single-linkage clustering algorithm
-   The three LoCoH (Local Convex Hull) methods developed by Getz et al. (2007)
-   The characteristic hull method of Downs and Horner (2009)

Temporal Kernel Methods
-----------------------

-   Autocorrelated Kernel Density Estimation <https://cran.r-project.org/web/packages/ctmm/vignettes/akde.html>
