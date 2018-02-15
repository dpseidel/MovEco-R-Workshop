Introduction to working with Spatial Data in R
================

Today we are going to get our first taste of working with movement data in R, but we will begin by introducing you to spatial data analysis in R more generally. In this section we will review some of the R packages available for handling spatial data, discuss the format of different spatial data types, and explore how we can manipulate and visualize these in R.

Much of the content and structure of this tutorial was inspired by Jamie Afflerbach's own introduction to the `sf` library and spatial analysis in R (see her [spatial-analysis-R repo](https://github.com/jafflerbach/spatial-analysis-R)). I have adapted it here for the specific purposes of our workshop.

Packages
--------

Primarily we will be introducing the **sf** ("simple features") package for working with simple spatial data.

The **sf** library is an R implementation of:
- a new spatial data class system in R
- functions for reading and writing spatial data
- tools for spatial operations on vectors

Ultimately this seeks to replace the older **sp**, **rgdal**, **rgeos** packages which formed the original toolset for working with spatial data in R. The **sf** library replaces the S4 class structure used in **sp** with simple feature access - the current standard across industry for organizing spatial data -- extending R's data.frame structure directly to accept spatial geometry attributes and making it easier to manipulate spatial datasets using tools like dplyr and the tidyverse. However, as this package is new and under developement there are times were we will switch back to the S4 class structure to play nice with our movement packages.

More information regarding this shift [here](https://www.r-consortium.org/blog/2017/01/03/simple-features-now-on-cran)

Spatial data comes in two forms:

1.  Vector data
2.  Raster data

With important differences across classes.

Vector Data
-----------

Vector models are a representation of the world using points, lines, and polygons. This class is useful for storing data that has discrete boundaries, such as country borders, land parcels, and streets.

Often, vector data is stored as "shapefiles" (.shp)

![GPS points from an albatross trajectory are an example of vector data](../../../images/albatross2.png)

Raster Data
-----------

Raster models are a representation of the world as a surface divided into a regular grid of cells.

![Rasters divide the world into a regular grid](../../../images/raster_concept.png)

These are useful for storing data that varies continuously, as in an aerial photograph, a satellite image, a surface of chemical concentrations, or an elevation surface

![Rasters are better used for continuous data like temperature, elevation, or landcover type](../../../images/examples.png)

Often, Rasters are stored as "GeoTIFFs" (.tif)

The **sf** library is used to store vector data but when working with raster data we will use operations from packages **raster** and **velox**.

Later when we work with movement data we may find a need for other spatial packages in R such as: **spatial**, the **adehabitat** packages, **maptools**, **mapview**, and the developers version of **ggplot2**.

Reading, Visualizaing, and Manipulating Spatial Data in R
=========================================================

To begin today, we are going to demonstrate how to **sf** and **tidyverse** libraries together to manipulate spatial *vector* data.

Step 1. Set up our environment and read in the data
---------------------------------------------------

``` r
#install.packages(c("sf", "mapview"))
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1.9000     ✔ purrr   0.2.4     
    ## ✔ tibble  1.3.4          ✔ dplyr   0.7.4     
    ## ✔ tidyr   0.7.2          ✔ stringr 1.2.0     
    ## ✔ readr   1.1.1          ✔ forcats 0.2.0

    ## ── Conflicts ────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(sf)
```

    ## Linking to GEOS 3.6.2, GDAL 2.2.3, proj.4 4.9.3

``` r
library(mapview)
```

    ## Loading required package: leaflet

**sf** objects usually have two classes - `sf` and `data.frame`. Two main differences comparing to a regular `data.frame` object are spatial metadata (`geometry type`, `dimension`, `bbox`, `epsg (SRID)`, `proj4string`) and additional column - typically named `geom` or `geometry`.

Today we are going to play with a shapfiles of Hong Kong's administrative boundaries downloaded from the [global administrative areas database](http://www.gadm.org/download) and provided for you in the `shapefiles` directory.

Now let's use the `st_read` function to read both files in separately. Note that within the `sf` library most commands begin with the "st" prefix.

``` r
HK_boundary <- st_read("data_files/HK_boundary.shp")
```

    ## Reading layer `HK_boundary' from data source `/Users/dseidel/Desktop/HongKong/Materials/Day2/data_files/HK_boundary.shp' using driver `ESRI Shapefile'
    ## Simple feature collection with 1 feature and 69 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 113.8346 ymin: 22.15319 xmax: 114.441 ymax: 22.56209
    ## epsg (SRID):    4326
    ## proj4string:    +proj=longlat +datum=WGS84 +no_defs

``` r
HK_districts <- st_read("data_files/HK_districts.shp")
```

    ## Reading layer `HK_districts' from data source `/Users/dseidel/Desktop/HongKong/Materials/Day2/data_files/HK_districts.shp' using driver `ESRI Shapefile'
    ## Simple feature collection with 18 features and 14 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 113.8346 ymin: 22.15319 xmax: 114.441 ymax: 22.56209
    ## epsg (SRID):    4326
    ## proj4string:    +proj=longlat +datum=WGS84 +no_defs

### Attributes of `sf` objects

Just for kicks, prove to yourself that a sf object is just a fancy data.frame: check out the class structure of "sf" objects

``` r
class(HK_boundary)
```

    ## [1] "sf"         "data.frame"

Because of their dual class structure: **sf** objects can be used as a regular `data.frame` object in many operations. For instance, we can call simple data.frame operations like `nrow` or `names` on these objects with ease

``` r
nrow(HK_districts)
```

    ## [1] 18

``` r
ncol(HK_districts)
```

    ## [1] 15

``` r
names(HK_districts)
```

    ##  [1] "ID_0"     "ISO"      "NAME_0"   "ID_1"     "NAME_1"   "HASC_1"  
    ##  [7] "CCN_1"    "CCA_1"    "TYPE_1"   "ENGTYPE"  "NL_NAME"  "VARNAME" 
    ## [13] "Shp_Lng"  "Shap_Ar"  "geometry"

If we are ever curious about just the dataframe or just the geometry separately, we can use `st_geometry` commands. By setting the geometry to 'NULL' using `st_set_geometry`, a `sf` object returns to a simple data.frame. Calling the `st_geometry` from an sf object would extract just the spatial attributes turning this into a "simple feature collection" or "sfc". To turn an `sfc` object back into an `sf` object use `st_sf()`.

``` r
HK_boundary %>% class # complete sf object
```

    ## [1] "sf"         "data.frame"

``` r
HK_boundary %>% st_set_geometry(NULL) %>% class  # force to data.frame
```

    ## [1] "data.frame"

``` r
HK_boundary %>% st_geometry() %>% class  # extract only the spatial info, force to "sfc"
```

    ## [1] "sfc_MULTIPOLYGON" "sfc"

Step 2: Visualize
-----------------

Let's take a look at our shapefiles, make sure they look like we expect.

### sf objects and BaseR

``` r
# look what happens when we use generic plot on the whole dataframe
HK_districts %>% plot
```

    ## Warning: plotting the first 9 out of 14 attributes; use max.plot = 14 to
    ## plot all

    ## Warning in min(x): no non-missing arguments to min; returning Inf

    ## Warning in max(x): no non-missing arguments to max; returning -Inf

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
# pull just the geometry
HK_boundary %>% st_geometry() %>% plot
```

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-6-2.png)

``` r
HK_districts %>% st_geometry() %>% plot
```

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-6-3.png)

``` r
# or pull just one column
plot(HK_districts["NAME_1"])
```

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-6-4.png)

### With ggplot

`ggplot2` now has integrated functionality to plot sf objects using `geom_sf()`. If the following code isn't working, check to make sure you are using the developer's version, `devtools::install_github("tidyverse/ggplot2")`.

``` r
#simplest plot
ggplot(HK_districts) + geom_sf()
```

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-7-1.png)

This is useful to make sure your file looks correct but doesn't display any information about the data. We can plot these regions and fill each polygon based on the rgn\_id.

``` r
ggplot(HK_districts) + geom_sf(aes(fill = NAME_1))
```

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-8-1.png)

ggplot gives us useful defaults like Latitude and Longitude labels and cleaner legends but there are even fancier things we can do with maps... we'll introduce you to one in the `mapview` library below.

### Getting fancy with Mapview

`mapview` is a wrapper for the `leaflet` package for R. Leaflet is a visualization engine written in javascript that is widely used to make and embed interactive plots.

``` r
map <- mapview(HK_districts)
st_sample(HK_districts, 25) -> points
```

    ## although coordinates are longitude/latitude, st_intersects assumes that they are planar

``` r
#icon: http://leafletjs.com/examples/custom-icons/
#fishIcon <- makeIcon("images/lumpsucker.jpg", 18,18)
#mapview(HK_regions)@map %>% addTiles %>%  addMarkers(data = points, icon=fishIcon)

mapview(points, map, cex=3, color="red")
```

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-9-1.png)

Step 3: Mainuplate!
-------------------

An important advantage of simple features in R is that their structure makes it easy to use the **dplyr** package on `sf` objects:

For instance, taking standard examples introduced yesterday:

`select()`

``` r
HK_boundary %>%
  select(ID_0, ISO, NAME_LO, SOVEREI, FIPS, ISON, POP2000, SQKM) -> HK_trim

HK_trim
```

    ## Simple feature collection with 1 feature and 8 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 113.8346 ymin: 22.15319 xmax: 114.441 ymax: 22.56209
    ## epsg (SRID):    4326
    ## proj4string:    +proj=longlat +datum=WGS84 +no_defs
    ##   ID_0 ISO   NAME_LO SOVEREI FIPS ISON POP2000 SQKM
    ## 1  102 HKG Hong Kong   China   HK  344 6859822 1092
    ##                         geometry
    ## 1 MULTIPOLYGON (((113.9240264...

`mutate()` & `pull()`

``` r
HK_trim %>%
  mutate(POP_per_SQKM = POP2000/SQKM) %>% pull(POP_per_SQKM)
```

    ## [1] 6281.888

`filter()`

``` r
HK_districts %>%
  filter(NAME_1 %in% c("Eastern", "North", "Islands"))
```

    ## Simple feature collection with 3 features and 14 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 113.8346 ymin: 22.15319 xmax: 114.3346 ymax: 22.56209
    ## epsg (SRID):    4326
    ## proj4string:    +proj=longlat +datum=WGS84 +no_defs
    ##   ID_0 ISO    NAME_0 ID_1  NAME_1 HASC_1 CCN_1 CCA_1   TYPE_1  ENGTYPE
    ## 1  102 HKG Hong Kong    2 Eastern  HK.EA    NA  <NA> District District
    ## 2  102 HKG Hong Kong    3 Islands  HK.IS    NA  <NA> District District
    ## 3  102 HKG Hong Kong    7   North  HK.NO    NA  <NA> District District
    ##   NL_NAME VARNAME   Shp_Lng     Shap_Ar                       geometry
    ## 1    <NA>    <NA> 0.2929576 0.001657421 MULTIPOLYGON (((114.1779174...
    ## 2    <NA>    <NA> 2.7542074 0.015733596 MULTIPOLYGON (((113.9337463...
    ## 3    <NA>    <NA> 1.4650372 0.012136878 MULTIPOLYGON (((114.2356948...

``` r
HK_districts %>%
  filter(NAME_1 %in% c("Eastern", "North", "Islands")) %>% 
  ggplot(.) + geom_sf(aes(fill = NAME_1))
```

![](../Spatial_Data_in_R_files/figure-markdown_github/filter-1.png)

Spatial operations
------------------

### Union

You can merge all polygons into one using `st_union()`.

``` r
full_rgn  <- st_union(HK_districts)

plot(full_rgn)
```

![](../Spatial_Data_in_R_files/figure-markdown_github/st_union-1.png)

### Joins

Perhaps we had some points -- locations of animal observations maybe -- and we wanted to join them to data in a different layer -- the sf library and dplyr make this readily doable.

Below we join the randomly sampled points from above to the HK\_districts layer, to pull the relevant district information for each point.

``` r
st_sf(points) %>% st_join(., HK_districts)
```

    ## although coordinates are longitude/latitude, st_intersects assumes that they are planar

    ## Simple feature collection with 35 features and 14 fields
    ## geometry type:  POINT
    ## dimension:      XY
    ## bbox:           xmin: 113.8563 ymin: 22.22863 xmax: 114.3869 ymax: 22.53628
    ## epsg (SRID):    4326
    ## proj4string:    +proj=longlat +datum=WGS84 +no_defs
    ## First 10 features:
    ##    ID_0 ISO    NAME_0 ID_1       NAME_1 HASC_1 CCN_1 CCA_1   TYPE_1
    ## 1   102 HKG Hong Kong   14     Tuen Mun  HK.TM    NA  <NA> District
    ## 2   102 HKG Hong Kong    8     Sai Kung  HK.SK    NA  <NA> District
    ## 3   102 HKG Hong Kong   18    Yuen Long  HK.YL    NA  <NA> District
    ## 4   102 HKG Hong Kong    3      Islands  HK.IS    NA  <NA> District
    ## 5   102 HKG Hong Kong   14     Tuen Mun  HK.TM    NA  <NA> District
    ## 6   102 HKG Hong Kong    4 Kowloon City  HK.KC    NA  <NA> District
    ## 7   102 HKG Hong Kong    3      Islands  HK.IS    NA  <NA> District
    ## 8   102 HKG Hong Kong    9      Sha Tin  HK.ST    NA  <NA> District
    ## 9   102 HKG Hong Kong    3      Islands  HK.IS    NA  <NA> District
    ## 10  102 HKG Hong Kong    8     Sai Kung  HK.SK    NA  <NA> District
    ##     ENGTYPE NL_NAME VARNAME   Shp_Lng      Shap_Ar
    ## 1  District    <NA>    <NA> 0.7959588 0.0079396304
    ## 2  District    <NA>    <NA> 2.5614897 0.0125822680
    ## 3  District    <NA>    <NA> 0.8802538 0.0121403618
    ## 4  District    <NA>    <NA> 2.7542074 0.0157335956
    ## 5  District    <NA>    <NA> 0.7959588 0.0079396304
    ## 6  District    <NA>    <NA> 0.2588975 0.0009319862
    ## 7  District    <NA>    <NA> 2.7542074 0.0157335956
    ## 8  District    <NA>    <NA> 0.5821248 0.0058956100
    ## 9  District    <NA>    <NA> 2.7542074 0.0157335956
    ## 10 District    <NA>    <NA> 2.5614897 0.0125822680
    ##                          geometry
    ## 1  POINT (113.925868417528 22....
    ## 2  POINT (114.349924911183 22....
    ## 3  POINT (114.077785925781 22....
    ## 4  POINT (113.930414136978 22....
    ## 5  POINT (113.952787107826 22....
    ## 6  POINT (114.175931830609 22....
    ## 7  POINT (114.112771992756 22....
    ## 8  POINT (114.243565141369 22....
    ## 9  POINT (113.856258161929 22....
    ## 10 POINT (114.386890085383 22....

``` r
# Similar functions are available in other libraries:
# adehabitatMA::join()
# rgeos::over
```

From there it is simple to use `group_by` and `tally` (a wrapper for the more general `summarise` function) to count how many points we sampled in each district:

``` r
st_sf(points) %>% 
  st_join(., HK_districts) %>%
  group_by(NAME_1) %>% 
  tally()
```

    ## although coordinates are longitude/latitude, st_intersects assumes that they are planar

    ## Simple feature collection with 11 features and 2 fields
    ## geometry type:  GEOMETRY
    ## dimension:      XY
    ## bbox:           xmin: 113.8563 ymin: 22.22863 xmax: 114.3869 ymax: 22.53628
    ## epsg (SRID):    4326
    ## proj4string:    +proj=longlat +datum=WGS84 +no_defs
    ## # A tibble: 11 x 3
    ##          NAME_1     n          geometry
    ##          <fctr> <int>  <simple_feature>
    ##  1      Islands     5 <MULTIPOINT (...>
    ##  2 Kowloon City     1 <POINT (114.1...>
    ##  3   Kwai Tsing     2 <MULTIPOINT (...>
    ##  4        North     4 <MULTIPOINT (...>
    ##  5     Sai Kung     5 <MULTIPOINT (...>
    ##  6      Sha Tin     2 <MULTIPOINT (...>
    ##  7 Sham Shui Po     1 <POINT (114.1...>
    ##  8       Tai Po     5 <MULTIPOINT (...>
    ##  9    Tsuen Wan     1 <POINT (114.1...>
    ## 10     Tuen Mun     4 <MULTIPOINT (...>
    ## 11    Yuen Long     5 <MULTIPOINT (...>

``` r
# all while retaining the spatial geometry associated with each point. 
```

### Projections & transformations with vectors and rasters

Above we have sometimes encountered warnings like this one: &gt; although coordinates are longitude/latitude, st\_intersects assumes that they are planar

This has to do with our coordinate system. Geographic coordinate systems give coordinates which are spherical (i.e. measured from the earth's center) or planimetric (in which the earth's coordinates are projected onto a two-dimensional planar surface). Most spatial operations in the sf library assume coordinates are projected into a planar surface which typically lend themselves to more interpretable measurements e.g meters or kilometers.

Above, all our vector data have been in the WGS84 spherical coordinate reference system, which uses longitude and latitude with units in degrees. An example of this projection can be seen in the lower right depication of the US in the image below.

![](../../../images/crs.png)

It is crucial when doing spatial analyses to know and match the coordinate systems across all of your datasets and ensure everything is properly projected, or your results may be incorrect or your analysis may fail. This is true whether you are working with raster or vector data.

``` r
library(raster)
```

    ## Loading required package: sp

    ## 
    ## Attaching package: 'raster'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     select

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     extract

    ## The following object is masked from 'package:ggplot2':
    ## 
    ##     calc

``` r
# https://landcover.usgs.gov/global_climatology.php
# download.file("https://landcover.usgs.gov/documents/GlobalLandCover_tif.zip", "data_files/Landcover.zip") 
# unzip("data_files/Landcover.zip", "data_files/")
land_cover <- raster("data_files/LCType.tif")

plot(land_cover)
```

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-12-1.png)

``` r
crs(land_cover)
```

    ## CRS arguments:
    ##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0

Perhaps we want to work with both our HK\_districts and the landcover dataset but in a planar coordinate system. To do this with an `sf` object we use `st_transform`, with a raster object, `projectRaster`.

Let's crop and transform these data into the [World Azimuthal Equidistant](https://epsg.io/54032) projection to compare.

``` r
# to save time on the projection, let's trim the extent before projecting. 
# We can do this because they are already in the same geographic crs. 
# however, the extent call doesn't recognize sf objects yet so let's temporarily switch it back to `sp` format
HK_landcover <- crop(land_cover, extent(as(HK_boundary, "Spatial")))

HK_lc_proj <- projectRaster(HK_landcover, method= 'ngb', NAflag = 0,
                                crs = "+proj=aeqd +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")
```

By plotting these side by side, you can really see how different projections can be!

``` r
plot(HK_landcover)
```

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-14-1.png)

``` r
plot(HK_lc_proj)
```

![](../Spatial_Data_in_R_files/figure-markdown_github/unnamed-chunk-14-2.png)

### Intersections & Extractions

Commonly in movement ecology, we need to extract values from rasters across our vector data be it points where an animal walked or polygons like their home range or breeding sites for instance.

There are a number of functions to do this sort of spatial intersect and extraction in the rgeos and raster libraries e.g `gIntersection` and `extract` but they can be very inefficient in R - especially for large rasters. New libraries like `fasterize` and `velox` have been built to make these functions significantly faster. Below I will introduce `velox` but you can find more information about both by exploring their github pages.

Say we want to know the percentage of each landcover class each district is made up of. We can convert to a velox object to quickly and easily extract this information and use dplyr and purrr verbs to make a clean table of percentages by landcover class.

``` r
library(velox)
vx <- velox(HK_landcover) # makes a velox object from our raster

# lets give our classes names
landcover <- c("Water",
 "Evergreen Needle leaf Forest",
 "Evergreen Broadleaf Forest",
 "Deciduous Needle leaf Forest",
 "Deciduous Broadleaf Forest",  
 "Mixed Forests",
 "Closed Shrublands", 
 "Open Shrublands",
 "Woody Savannas",
 "Savannas", 
 "Grasslands", 
 "Permanent Wetland", 
 "Croplands", 
 "Urban and Built-Up",
 "Cropland/Natural Vegetation Mosaic", # #15 snow and ice not encountered
 "Barren or Sparsely Vegetated")

landcover_by_district <- vx$extract(HK_districts) %>% #extracts the raster cells in each district
  map(., plyr::count) %>%  #counts each category
  reduce(., function(dtf1,dtf2) full_join(dtf1,dtf2, by="x")) %>%  # reduces to a dataframe
  arrange(x) # orders

head(landcover_by_district)
```

    ##   x freq.x freq.y freq.x.x freq.y.y freq.x.x.x freq.y.y.y freq.x.x.x.x
    ## 1 0     15      4      132        2         16         NA           10
    ## 2 1     NA     NA       NA       NA         NA         NA           NA
    ## 3 2      8     31      182       NA         NA         NA          203
    ## 4 3      1     NA       10       NA         NA         NA           NA
    ## 5 4     NA     NA        1       NA         NA         NA           NA
    ## 6 5      7      5      134       NA          5         NA           25
    ##   freq.y.y.y.y freq.x.x.x.x.x freq.y.y.y.y.y freq.x.x.x.x.x.x
    ## 1           36             NA              5               28
    ## 2            1             NA             NA               NA
    ## 3          216             99             NA               73
    ## 4            3             NA             NA                6
    ## 5            1             NA             NA               NA
    ## 6           36             24             NA                7
    ##   freq.y.y.y.y.y.y freq.x.x.x.x.x.x.x freq.y.y.y.y.y.y.y
    ## 1               47                 18                 52
    ## 2                1                 NA                 NA
    ## 3              334                 95                 12
    ## 4               NA                  1                  4
    ## 5               NA                 NA                 NA
    ## 6               58                 23                 15
    ##   freq.x.x.x.x.x.x.x.x freq.y.y.y.y.y.y.y.y freq.x.x.x.x.x.x.x.x.x
    ## 1                    4                   NA                     17
    ## 2                   NA                   NA                     NA
    ## 3                    7                    5                     NA
    ## 4                   NA                   NA                     NA
    ## 5                   NA                   NA                     NA
    ## 6                    1                   NA                     NA
    ##   freq.y.y.y.y.y.y.y.y.y
    ## 1                     26
    ## 2                     NA
    ## 3                     74
    ## 4                     NA
    ## 5                     NA
    ## 6                     16

``` r
landcover_by_district[is.na(landcover_by_district)] <- 0 # make NAs 0
names(landcover_by_district) <- c("Class_No", seq(1,18,1)) # improve column names
landcover_by_district$Class <- landcover # add a column including each landover class name

head(landcover_by_district)
```

    ##   Class_No  1  2   3 4  5 6   7   8  9 10 11  12 13 14 15 16 17 18
    ## 1        0 15  4 132 2 16 0  10  36  0  5 28  47 18 52  4  0 17 26
    ## 2        1  0  0   0 0  0 0   0   1  0  0  0   1  0  0  0  0  0  0
    ## 3        2  8 31 182 0  0 0 203 216 99  0 73 334 95 12  7  5  0 74
    ## 4        3  1  0  10 0  0 0   0   3  0  0  6   0  1  4  0  0  0  0
    ## 5        4  0  0   1 0  0 0   0   1  0  0  0   0  0  0  0  0  0  0
    ## 6        5  7  5 134 0  5 0  25  36 24  0  7  58 23 15  1  0  0 16
    ##                          Class
    ## 1                        Water
    ## 2 Evergreen Needle leaf Forest
    ## 3   Evergreen Broadleaf Forest
    ## 4 Deciduous Needle leaf Forest
    ## 5   Deciduous Broadleaf Forest
    ## 6                Mixed Forests

``` r
district_totals <- map_dbl(landcover_by_district[,2:19], sum) #sum for each district, i.e. column
district_totals
```

    ##   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18 
    ##  65  93 894  54 120  59 692 729 341  46 212 771 321 451  52  46  42 707

``` r
for (i in 1:18){ # convert to percentages
  landcover_by_district[,i+1] <- round((landcover_by_district[,i+1]/district_totals[i])*100,2)
}

# transpose things a little
landcover_by_district %>%
  dplyr::select(-Class_No) %>% 
  gather(key = District_No, value = value, 1:18) %>% 
  spread(key = names(.)[1], value = 'value') %>% 
  arrange(as.numeric(District_No))  -> district_LC

head(district_LC)
```

    ##   District_No Barren or Sparsely Vegetated Closed Shrublands
    ## 1           1                         3.08              0.00
    ## 2           2                         2.15              1.08
    ## 3           3                         0.34              0.00
    ## 4           4                         1.85              0.00
    ## 5           5                         2.50              0.83
    ## 6           6                         0.00              0.00
    ##   Cropland/Natural Vegetation Mosaic Croplands Deciduous Broadleaf Forest
    ## 1                               0.00      1.54                       0.00
    ## 2                               0.00      7.53                       0.00
    ## 3                               2.91      3.47                       0.11
    ## 4                               0.00      5.56                       0.00
    ## 5                               0.00     10.00                       0.00
    ## 6                               0.00      1.69                       0.00
    ##   Deciduous Needle leaf Forest Evergreen Broadleaf Forest
    ## 1                         1.54                      12.31
    ## 2                         0.00                      33.33
    ## 3                         1.12                      20.36
    ## 4                         0.00                       0.00
    ## 5                         0.00                       0.00
    ## 6                         0.00                       0.00
    ##   Evergreen Needle leaf Forest Grasslands Mixed Forests Open Shrublands
    ## 1                            0       4.62         10.77            0.00
    ## 2                            0       0.00          5.38            0.00
    ## 3                            0       0.34         14.99            1.34
    ## 4                            0       1.85          0.00            0.00
    ## 5                            0       2.50          4.17            2.50
    ## 6                            0       6.78          0.00            1.69
    ##   Permanent Wetland Savannas Urban and Built-Up Water Woody Savannas
    ## 1             18.46     0.00              20.00 23.08           4.62
    ## 2             21.51     0.00              20.43  4.30           4.30
    ## 3             27.18     0.78               4.14 14.77           8.17
    ## 4              0.00     0.00              87.04  3.70           0.00
    ## 5              7.50     0.00              55.83 13.33           0.83
    ## 6              3.39     0.00              86.44  0.00           0.00

In this format it's easy to pull out districts by their landcover characteristics.

For instance, perhaps we want to know which districts are more than 80% Urban:

``` r
district_LC %>% filter(`Urban and Built-Up` > 80) %>% pull(District_No)
```

    ## [1] "4"  "6"  "16"

We will continue to see how useful extraction in this afternoon's activity and we get to RSFs tomorrow.
