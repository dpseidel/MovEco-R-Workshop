---
layout: page
title: Basics in R
subtitle: Part 1
use-site-title: true
---
Introducing Rstudio (live demo)
===============================

-   What is the console?
-   What is the source?
-   What is your environment?
-   Using git within Rstudio

SideNote: What is an .Rmd file? What about .r file?
---------------------------------------------------

This is an R Markdown document (.Rmd). Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. It facilitates the easy combination of both code and text. Everything you see in the grey chunks will run as R code. Everything outside a code chunk is treated as plain text.

For complete formatting with plots and code output and the text, one must `knit` a .Rmd file into their final file formats (generally html, pdf, md, or doc). Which is why you may see "duplicate" files in our github repo.

For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

Comparatively, a simple R script saves as a .r file. Everything inside a .r file is treated (and run) as code unless commented out with a `#` sign.

The TidyVerse
=============

The tidyverse is a collection of R packages designed for data science. All packages share an underlying philosophy and common APIs.

Install the packages: `install.packages("tidyverse")`

Load the packages each time you open a new session:

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1.9000     ✔ purrr   0.2.4     
    ## ✔ tibble  1.3.4          ✔ dplyr   0.7.4     
    ## ✔ tidyr   0.7.2          ✔ stringr 1.2.0     
    ## ✔ readr   1.1.1          ✔ forcats 0.2.0

    ## ── Conflicts ────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

Access the book! [R for Data Science](http://r4ds.had.co.nz/)

Other Resources:

-   [Cheat sheets!](https://www.rstudio.com/resources/cheatsheets/)

-   [More Books & online courses](https://www.tidyverse.org/learn/)

Importing Data
==============

> In Data Science, 80% of time spent prepare data, 20% of time spent complain about need for prepare data.

Big Data Borat [@BigDataBorat](https://twitter.com/BigDataBorat/status/306596352991830016), February 27, 2013

Parsing
-------

Our first task is to read this data into our R environment. To this, we will use the `read_table` function. Reading in a data file is called *parsing*, which sounds much more sophisticated. For good reason too -- parsing different data files and formats is a cornerstone of all pratical data science research, and can often be the hardest step.

#### So what do we need to know about this file in order to read it into R?

[First let's take a look at it](ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt)

The first thing we should notice is that there is a large comment block of documentation. This can be ignored when parsing by using the `comment` arg.

``` r
## Let's try:
co2 <- read.table("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt", comment='#')
head(co2)
```

    ##     V1 V2       V3     V4     V5     V6 V7
    ## 1 1958  3 1958.208 315.71 315.71 314.62 -1
    ## 2 1958  4 1958.292 317.45 317.45 315.29 -1
    ## 3 1958  5 1958.375 317.50 317.50 314.71 -1
    ## 4 1958  6 1958.458 -99.99 317.10 314.85 -1
    ## 5 1958  7 1958.542 315.86 315.86 314.98 -1
    ## 6 1958  8 1958.625 314.93 314.93 315.94 -1

``` r
#or if the ftp causes problems, use local:
#co2 <- read_csv("NOAA_CO2.csv")
# parsing required may be slightly different
```

Almost there, but things are still a bit messy. Our first row is being interpreted as column names.
The documentation also notes that certain values are used to indicate missing data, which we would be better off converting to explicitly missing so we don't get confused.

``` r
co2 <- read.table("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt",
                  sep = "", comment = "#",
                  col.names = c("year", "month", "decimal_date", 
                                "average", "interpolated", 
                                "trend", "days"),
                  na.strings = c("-1", "-99.99"))
head(co2)
```

    ##   year month decimal_date average interpolated  trend days
    ## 1 1958     3     1958.208  315.71       315.71 314.62   NA
    ## 2 1958     4     1958.292  317.45       317.45 315.29   NA
    ## 3 1958     5     1958.375  317.50       317.50 314.71   NA
    ## 4 1958     6     1958.458      NA       317.10 314.85   NA
    ## 5 1958     7     1958.542  315.86       315.86 314.98   NA
    ## 6 1958     8     1958.625  314.93       314.93 315.94   NA

Importing Data with tidyverse
-----------------------------

Alternately, with `readr::read_table` from `tidyverse`

It seems that `comment` arg is not yet fully implemented in CRAN version of `readr` so we must rely on `skip` to avoid the documentation block:

``` r
co2 <- read_table("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt",
                  col_names = c("year", "month", "decimal_date", 
                                "average", "interpolated", "trend", "days"),
                  col_types = c("iiddddi"),
                  na = c("-1", "-99.99"),
                  skip = 72)

co2
```

    ## # A tibble: 717 x 7
    ##     year month decimal_date average interpolated  trend  days
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ##  1  1958     3     1958.208  315.71       315.71 314.62    NA
    ##  2  1958     4     1958.292  317.45       317.45 315.29    NA
    ##  3  1958     5     1958.375  317.50       317.50 314.71    NA
    ##  4  1958     6     1958.458      NA       317.10 314.85    NA
    ##  5  1958     7     1958.542  315.86       315.86 314.98    NA
    ##  6  1958     8     1958.625  314.93       314.93 315.94    NA
    ##  7  1958     9     1958.708  313.20       313.20 315.91    NA
    ##  8  1958    10     1958.792      NA       312.66 315.61    NA
    ##  9  1958    11     1958.875  313.33       313.33 315.31    NA
    ## 10  1958    12     1958.958  314.67       314.67 315.61    NA
    ## # ... with 707 more rows

Success! We have read in the data. Now we're ready to rock and roll.

Viewing data
============

Once parsed and imported, it's a good idea to take a look at your data, both to get a sense of it's size, names, and shape but also to keep an eye out for missing value or errors.

For this stage, using a combination of `str`, `names`, `summar`, `View`, `head` and `tail` functions can be helpful.

``` r
# to get the names of the columns
names(co2)
```

    ## [1] "year"         "month"        "decimal_date" "average"     
    ## [5] "interpolated" "trend"        "days"

``` r
# to check out the full structure of the R object
str(co2)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    717 obs. of  7 variables:
    ##  $ year        : int  1958 1958 1958 1958 1958 1958 1958 1958 1958 1958 ...
    ##  $ month       : int  3 4 5 6 7 8 9 10 11 12 ...
    ##  $ decimal_date: num  1958 1958 1958 1958 1959 ...
    ##  $ average     : num  316 317 318 NA 316 ...
    ##  $ interpolated: num  316 317 318 317 316 ...
    ##  $ trend       : num  315 315 315 315 315 ...
    ##  $ days        : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  - attr(*, "spec")=List of 2
    ##   ..$ cols   :List of 7
    ##   .. ..$ year        : list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_integer" "collector"
    ##   .. ..$ month       : list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_integer" "collector"
    ##   .. ..$ decimal_date: list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
    ##   .. ..$ average     : list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
    ##   .. ..$ interpolated: list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
    ##   .. ..$ trend       : list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
    ##   .. ..$ days        : list()
    ##   .. .. ..- attr(*, "class")= chr  "collector_integer" "collector"
    ##   ..$ default: list()
    ##   .. ..- attr(*, "class")= chr  "collector_guess" "collector"
    ##   ..- attr(*, "class")= chr "col_spec"

``` r
nrow(co2)
```

    ## [1] 717

``` r
ncol(co2)
```

    ## [1] 7

``` r
# to get a summary of the object
summary(co2)  # here we can get a good sense of the missing values in the days column and average column. 
```

    ##       year          month         decimal_date     average     
    ##  Min.   :1958   Min.   : 1.000   Min.   :1958   Min.   :313.2  
    ##  1st Qu.:1973   1st Qu.: 4.000   1st Qu.:1973   1st Qu.:328.6  
    ##  Median :1988   Median : 7.000   Median :1988   Median :350.9  
    ##  Mean   :1988   Mean   : 6.506   Mean   :1988   Mean   :353.2  
    ##  3rd Qu.:2002   3rd Qu.: 9.000   3rd Qu.:2003   3rd Qu.:374.4  
    ##  Max.   :2017   Max.   :12.000   Max.   :2018   Max.   :409.6  
    ##                                                 NA's   :7      
    ##   interpolated       trend            days      
    ##  Min.   :312.7   Min.   :314.6   Min.   : 0.00  
    ##  1st Qu.:328.3   1st Qu.:328.9   1st Qu.:24.00  
    ##  Median :350.2   Median :350.4   Median :26.00  
    ##  Mean   :352.9   Mean   :352.9   Mean   :25.34  
    ##  3rd Qu.:374.2   3rd Qu.:374.5   3rd Qu.:28.00  
    ##  Max.   :409.6   Max.   :407.2   Max.   :31.00  
    ##                                  NA's   :194

``` r
# for the first or last `n` lines of the data frame
head(co2) # check out r help - shows us that the default argument is 10 lines
```

    ## # A tibble: 6 x 7
    ##    year month decimal_date average interpolated  trend  days
    ##   <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ## 1  1958     3     1958.208  315.71       315.71 314.62    NA
    ## 2  1958     4     1958.292  317.45       317.45 315.29    NA
    ## 3  1958     5     1958.375  317.50       317.50 314.71    NA
    ## 4  1958     6     1958.458      NA       317.10 314.85    NA
    ## 5  1958     7     1958.542  315.86       315.86 314.98    NA
    ## 6  1958     8     1958.625  314.93       314.93 315.94    NA

``` r
tail(co2, 20)
```

    ## # A tibble: 20 x 7
    ##     year month decimal_date average interpolated  trend  days
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ##  1  2016     4     2016.292  407.42       407.42 404.52    25
    ##  2  2016     5     2016.375  407.70       407.70 404.30    29
    ##  3  2016     6     2016.458  406.81       406.81 404.48    26
    ##  4  2016     7     2016.542  404.39       404.39 403.97    28
    ##  5  2016     8     2016.625  402.25       402.25 404.13    23
    ##  6  2016     9     2016.708  401.03       401.03 404.57    24
    ##  7  2016    10     2016.792  401.57       401.57 404.95    29
    ##  8  2016    11     2016.875  403.53       403.53 405.62    27
    ##  9  2016    12     2016.958  404.42       404.42 405.20    29
    ## 10  2017     1     2017.042  406.13       406.13 405.89    26
    ## 11  2017     2     2017.125  406.42       406.42 405.61    26
    ## 12  2017     3     2017.208  407.18       407.18 405.61    23
    ## 13  2017     4     2017.292  409.00       409.00 406.10    25
    ## 14  2017     5     2017.375  409.65       409.65 406.24    27
    ## 15  2017     6     2017.458  408.84       408.84 406.51    26
    ## 16  2017     7     2017.542  407.07       407.07 406.65    28
    ## 17  2017     8     2017.625  405.07       405.07 406.94    29
    ## 18  2017     9     2017.708  403.38       403.38 406.93    26
    ## 19  2017    10     2017.792  403.64       403.64 407.03    27
    ## 20  2017    11     2017.875  405.14       405.14 407.22    26

``` r
# to see the whole table in a Rstudio window, run the following line, uncommented. 
# View(co2)
# also double click from the environment
```

Subsetting data
===============

Subsetting can be done a variety of ways through baseR and tidyverse. Here we are going to cover the following ways: - `select()`, tidyverse - `filter()` , tidyverse - bracket `[]` notation, baseR - dollar sign `$` notation, baseR - subset function, baseR

``` r
co2[,"year"] 
```

    ## # A tibble: 717 x 1
    ##     year
    ##    <int>
    ##  1  1958
    ##  2  1958
    ##  3  1958
    ##  4  1958
    ##  5  1958
    ##  6  1958
    ##  7  1958
    ##  8  1958
    ##  9  1958
    ## 10  1958
    ## # ... with 707 more rows

``` r
co2[,1]
```

    ## # A tibble: 717 x 1
    ##     year
    ##    <int>
    ##  1  1958
    ##  2  1958
    ##  3  1958
    ##  4  1958
    ##  5  1958
    ##  6  1958
    ##  7  1958
    ##  8  1958
    ##  9  1958
    ## 10  1958
    ## # ... with 707 more rows

``` r
co2$year  # what's the difference here?
```

    ##   [1] 1958 1958 1958 1958 1958 1958 1958 1958 1958 1958 1959 1959 1959 1959
    ##  [15] 1959 1959 1959 1959 1959 1959 1959 1959 1960 1960 1960 1960 1960 1960
    ##  [29] 1960 1960 1960 1960 1960 1960 1961 1961 1961 1961 1961 1961 1961 1961
    ##  [43] 1961 1961 1961 1961 1962 1962 1962 1962 1962 1962 1962 1962 1962 1962
    ##  [57] 1962 1962 1963 1963 1963 1963 1963 1963 1963 1963 1963 1963 1963 1963
    ##  [71] 1964 1964 1964 1964 1964 1964 1964 1964 1964 1964 1964 1964 1965 1965
    ##  [85] 1965 1965 1965 1965 1965 1965 1965 1965 1965 1965 1966 1966 1966 1966
    ##  [99] 1966 1966 1966 1966 1966 1966 1966 1966 1967 1967 1967 1967 1967 1967
    ## [113] 1967 1967 1967 1967 1967 1967 1968 1968 1968 1968 1968 1968 1968 1968
    ## [127] 1968 1968 1968 1968 1969 1969 1969 1969 1969 1969 1969 1969 1969 1969
    ## [141] 1969 1969 1970 1970 1970 1970 1970 1970 1970 1970 1970 1970 1970 1970
    ## [155] 1971 1971 1971 1971 1971 1971 1971 1971 1971 1971 1971 1971 1972 1972
    ## [169] 1972 1972 1972 1972 1972 1972 1972 1972 1972 1972 1973 1973 1973 1973
    ## [183] 1973 1973 1973 1973 1973 1973 1973 1973 1974 1974 1974 1974 1974 1974
    ## [197] 1974 1974 1974 1974 1974 1974 1975 1975 1975 1975 1975 1975 1975 1975
    ## [211] 1975 1975 1975 1975 1976 1976 1976 1976 1976 1976 1976 1976 1976 1976
    ## [225] 1976 1976 1977 1977 1977 1977 1977 1977 1977 1977 1977 1977 1977 1977
    ## [239] 1978 1978 1978 1978 1978 1978 1978 1978 1978 1978 1978 1978 1979 1979
    ## [253] 1979 1979 1979 1979 1979 1979 1979 1979 1979 1979 1980 1980 1980 1980
    ## [267] 1980 1980 1980 1980 1980 1980 1980 1980 1981 1981 1981 1981 1981 1981
    ## [281] 1981 1981 1981 1981 1981 1981 1982 1982 1982 1982 1982 1982 1982 1982
    ## [295] 1982 1982 1982 1982 1983 1983 1983 1983 1983 1983 1983 1983 1983 1983
    ## [309] 1983 1983 1984 1984 1984 1984 1984 1984 1984 1984 1984 1984 1984 1984
    ## [323] 1985 1985 1985 1985 1985 1985 1985 1985 1985 1985 1985 1985 1986 1986
    ## [337] 1986 1986 1986 1986 1986 1986 1986 1986 1986 1986 1987 1987 1987 1987
    ## [351] 1987 1987 1987 1987 1987 1987 1987 1987 1988 1988 1988 1988 1988 1988
    ## [365] 1988 1988 1988 1988 1988 1988 1989 1989 1989 1989 1989 1989 1989 1989
    ## [379] 1989 1989 1989 1989 1990 1990 1990 1990 1990 1990 1990 1990 1990 1990
    ## [393] 1990 1990 1991 1991 1991 1991 1991 1991 1991 1991 1991 1991 1991 1991
    ## [407] 1992 1992 1992 1992 1992 1992 1992 1992 1992 1992 1992 1992 1993 1993
    ## [421] 1993 1993 1993 1993 1993 1993 1993 1993 1993 1993 1994 1994 1994 1994
    ## [435] 1994 1994 1994 1994 1994 1994 1994 1994 1995 1995 1995 1995 1995 1995
    ## [449] 1995 1995 1995 1995 1995 1995 1996 1996 1996 1996 1996 1996 1996 1996
    ## [463] 1996 1996 1996 1996 1997 1997 1997 1997 1997 1997 1997 1997 1997 1997
    ## [477] 1997 1997 1998 1998 1998 1998 1998 1998 1998 1998 1998 1998 1998 1998
    ## [491] 1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 2000 2000
    ## [505] 2000 2000 2000 2000 2000 2000 2000 2000 2000 2000 2001 2001 2001 2001
    ## [519] 2001 2001 2001 2001 2001 2001 2001 2001 2002 2002 2002 2002 2002 2002
    ## [533] 2002 2002 2002 2002 2002 2002 2003 2003 2003 2003 2003 2003 2003 2003
    ## [547] 2003 2003 2003 2003 2004 2004 2004 2004 2004 2004 2004 2004 2004 2004
    ## [561] 2004 2004 2005 2005 2005 2005 2005 2005 2005 2005 2005 2005 2005 2005
    ## [575] 2006 2006 2006 2006 2006 2006 2006 2006 2006 2006 2006 2006 2007 2007
    ## [589] 2007 2007 2007 2007 2007 2007 2007 2007 2007 2007 2008 2008 2008 2008
    ## [603] 2008 2008 2008 2008 2008 2008 2008 2008 2009 2009 2009 2009 2009 2009
    ## [617] 2009 2009 2009 2009 2009 2009 2010 2010 2010 2010 2010 2010 2010 2010
    ## [631] 2010 2010 2010 2010 2011 2011 2011 2011 2011 2011 2011 2011 2011 2011
    ## [645] 2011 2011 2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 2012
    ## [659] 2013 2013 2013 2013 2013 2013 2013 2013 2013 2013 2013 2013 2014 2014
    ## [673] 2014 2014 2014 2014 2014 2014 2014 2014 2014 2014 2015 2015 2015 2015
    ## [687] 2015 2015 2015 2015 2015 2015 2015 2015 2016 2016 2016 2016 2016 2016
    ## [701] 2016 2016 2016 2016 2016 2016 2017 2017 2017 2017 2017 2017 2017 2017
    ## [715] 2017 2017 2017

``` r
co2 %>% select(year, average) 
```

    ## # A tibble: 717 x 2
    ##     year average
    ##    <int>   <dbl>
    ##  1  1958  315.71
    ##  2  1958  317.45
    ##  3  1958  317.50
    ##  4  1958      NA
    ##  5  1958  315.86
    ##  6  1958  314.93
    ##  7  1958  313.20
    ##  8  1958      NA
    ##  9  1958  313.33
    ## 10  1958  314.67
    ## # ... with 707 more rows

``` r
co2[, c("year", "average")] 
```

    ## # A tibble: 717 x 2
    ##     year average
    ##    <int>   <dbl>
    ##  1  1958  315.71
    ##  2  1958  317.45
    ##  3  1958  317.50
    ##  4  1958      NA
    ##  5  1958  315.86
    ##  6  1958  314.93
    ##  7  1958  313.20
    ##  8  1958      NA
    ##  9  1958  313.33
    ## 10  1958  314.67
    ## # ... with 707 more rows

``` r
co2[, c(1,4)]
```

    ## # A tibble: 717 x 2
    ##     year average
    ##    <int>   <dbl>
    ##  1  1958  315.71
    ##  2  1958  317.45
    ##  3  1958  317.50
    ##  4  1958      NA
    ##  5  1958  315.86
    ##  6  1958  314.93
    ##  7  1958  313.20
    ##  8  1958      NA
    ##  9  1958  313.33
    ## 10  1958  314.67
    ## # ... with 707 more rows

``` r
co2 %>% select(-days)# select all columns except year
```

    ## # A tibble: 717 x 6
    ##     year month decimal_date average interpolated  trend
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl>
    ##  1  1958     3     1958.208  315.71       315.71 314.62
    ##  2  1958     4     1958.292  317.45       317.45 315.29
    ##  3  1958     5     1958.375  317.50       317.50 314.71
    ##  4  1958     6     1958.458      NA       317.10 314.85
    ##  5  1958     7     1958.542  315.86       315.86 314.98
    ##  6  1958     8     1958.625  314.93       314.93 315.94
    ##  7  1958     9     1958.708  313.20       313.20 315.91
    ##  8  1958    10     1958.792      NA       312.66 315.61
    ##  9  1958    11     1958.875  313.33       313.33 315.31
    ## 10  1958    12     1958.958  314.67       314.67 315.61
    ## # ... with 707 more rows

``` r
co2[,-7]
```

    ## # A tibble: 717 x 6
    ##     year month decimal_date average interpolated  trend
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl>
    ##  1  1958     3     1958.208  315.71       315.71 314.62
    ##  2  1958     4     1958.292  317.45       317.45 315.29
    ##  3  1958     5     1958.375  317.50       317.50 314.71
    ##  4  1958     6     1958.458      NA       317.10 314.85
    ##  5  1958     7     1958.542  315.86       315.86 314.98
    ##  6  1958     8     1958.625  314.93       314.93 315.94
    ##  7  1958     9     1958.708  313.20       313.20 315.91
    ##  8  1958    10     1958.792      NA       312.66 315.61
    ##  9  1958    11     1958.875  313.33       313.33 315.31
    ## 10  1958    12     1958.958  314.67       314.67 315.61
    ## # ... with 707 more rows

``` r
co2 %>% filter(year >= 1980, month == 12) # comma functions as "and" in the filter function
```

    ## # A tibble: 37 x 7
    ##     year month decimal_date average interpolated  trend  days
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ##  1  1980    12     1980.958  338.32       338.32 339.26    19
    ##  2  1981    12     1981.958  339.88       339.88 340.79    19
    ##  3  1982    12     1982.958  340.90       340.90 341.79    26
    ##  4  1983    12     1983.958  343.05       343.05 343.96    19
    ##  5  1984    12     1984.958  344.70       344.70 345.57    12
    ##  6  1985    12     1985.958  345.88       345.88 346.81    25
    ##  7  1986    12     1986.958  347.21       347.21 348.12    24
    ##  8  1987    12     1987.958  349.16       349.16 350.05    27
    ##  9  1988    12     1988.958  351.41       351.41 352.34    28
    ## 10  1989    12     1989.958  352.85       352.85 353.80    27
    ## # ... with 27 more rows

``` r
co2 %>% subset(year >= 1980 & month == 12)  # but and must be explicit in the subset function
```

    ## # A tibble: 37 x 7
    ##     year month decimal_date average interpolated  trend  days
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ##  1  1980    12     1980.958  338.32       338.32 339.26    19
    ##  2  1981    12     1981.958  339.88       339.88 340.79    19
    ##  3  1982    12     1982.958  340.90       340.90 341.79    26
    ##  4  1983    12     1983.958  343.05       343.05 343.96    19
    ##  5  1984    12     1984.958  344.70       344.70 345.57    12
    ##  6  1985    12     1985.958  345.88       345.88 346.81    25
    ##  7  1986    12     1986.958  347.21       347.21 348.12    24
    ##  8  1987    12     1987.958  349.16       349.16 350.05    27
    ##  9  1988    12     1988.958  351.41       351.41 352.34    28
    ## 10  1989    12     1989.958  352.85       352.85 353.80    27
    ## # ... with 27 more rows

``` r
co2 %>% filter(month == 11 | month == 11) # | is equivalent to "or"
```

    ## # A tibble: 60 x 7
    ##     year month decimal_date average interpolated  trend  days
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ##  1  1958    11     1958.875  313.33       313.33 315.31    NA
    ##  2  1959    11     1959.875  314.80       314.80 316.78    NA
    ##  3  1960    11     1960.875  315.00       315.00 316.98    NA
    ##  4  1961    11     1961.875  316.10       316.10 318.13    NA
    ##  5  1962    11     1962.875  316.69       316.69 318.62    NA
    ##  6  1963    11     1963.875  317.12       317.12 319.10    NA
    ##  7  1964    11     1964.875  317.79       317.79 319.72    NA
    ##  8  1965    11     1965.875  318.87       318.87 320.87    NA
    ##  9  1966    11     1966.875  319.79       319.79 321.84    NA
    ## 10  1967    11     1967.875  320.72       320.72 322.78    NA
    ## # ... with 50 more rows

``` r
co2[co2$month==12,] 
```

    ## # A tibble: 59 x 7
    ##     year month decimal_date average interpolated  trend  days
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ##  1  1958    12     1958.958  314.67       314.67 315.61    NA
    ##  2  1959    12     1959.958  315.58       315.58 316.52    NA
    ##  3  1960    12     1960.958  316.19       316.19 317.13    NA
    ##  4  1961    12     1961.958  317.01       317.01 317.94    NA
    ##  5  1962    12     1962.958  317.69       317.69 318.61    NA
    ##  6  1963    12     1963.958  318.31       318.31 319.25    NA
    ##  7  1964    12     1964.958  318.71       318.71 319.59    NA
    ##  8  1965    12     1965.958  319.42       319.42 320.26    NA
    ##  9  1966    12     1966.958  321.08       321.08 321.95    NA
    ## 10  1967    12     1967.958  321.96       321.96 322.86    NA
    ## # ... with 49 more rows

``` r
co2[co2$year>=1980 & co2$month==12,]
```

    ## # A tibble: 37 x 7
    ##     year month decimal_date average interpolated  trend  days
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ##  1  1980    12     1980.958  338.32       338.32 339.26    19
    ##  2  1981    12     1981.958  339.88       339.88 340.79    19
    ##  3  1982    12     1982.958  340.90       340.90 341.79    26
    ##  4  1983    12     1983.958  343.05       343.05 343.96    19
    ##  5  1984    12     1984.958  344.70       344.70 345.57    12
    ##  6  1985    12     1985.958  345.88       345.88 346.81    25
    ##  7  1986    12     1986.958  347.21       347.21 348.12    24
    ##  8  1987    12     1987.958  349.16       349.16 350.05    27
    ##  9  1988    12     1988.958  351.41       351.41 352.34    28
    ## 10  1989    12     1989.958  352.85       352.85 353.80    27
    ## # ... with 27 more rows

``` r
co2[co2$month==12 | co2$month==11,] 
```

    ## # A tibble: 119 x 7
    ##     year month decimal_date average interpolated  trend  days
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ##  1  1958    11     1958.875  313.33       313.33 315.31    NA
    ##  2  1958    12     1958.958  314.67       314.67 315.61    NA
    ##  3  1959    11     1959.875  314.80       314.80 316.78    NA
    ##  4  1959    12     1959.958  315.58       315.58 316.52    NA
    ##  5  1960    11     1960.875  315.00       315.00 316.98    NA
    ##  6  1960    12     1960.958  316.19       316.19 317.13    NA
    ##  7  1961    11     1961.875  316.10       316.10 318.13    NA
    ##  8  1961    12     1961.958  317.01       317.01 317.94    NA
    ##  9  1962    11     1962.875  316.69       316.69 318.62    NA
    ## 10  1962    12     1962.958  317.69       317.69 318.61    NA
    ## # ... with 109 more rows

``` r
# Note: logical operations (those that produce True or False) require the double equal sign `==`
```

### SideNote: Whats that little `c()` do?

Try running `?c` in your R console to find out. We use this function regularly to create vectors or lists of objects.

### SideNote: The Power of the Pipe `%>%`

You might be thinking what is that weird symbol we just used? This is a pipe, a function in the `magittr` package loaded in the tidyverse, Pipes are a powerful way to perform sequential operations on an R object. Using the pipe, allows use to push the output of our first operation into our next operation seamlessly, without using intermediate objects or overwriting our original object.

``` r
co2 %>% 
  filter(year >= 1980, month == 12) %>%
  select(year, average)
```

    ## # A tibble: 37 x 2
    ##     year average
    ##    <int>   <dbl>
    ##  1  1980  338.32
    ##  2  1981  339.88
    ##  3  1982  340.90
    ##  4  1983  343.05
    ##  5  1984  344.70
    ##  6  1985  345.88
    ##  7  1986  347.21
    ##  8  1987  349.16
    ##  9  1988  351.41
    ## 10  1989  352.85
    ## # ... with 27 more rows

``` r
# This is the same but much more readable and much cleaner than the following:

co2_filter <- filter(co2, year >= 1980, month == 12)
co2_subset <- select(co2_filter, year, average)
co2_subset
```

    ## # A tibble: 37 x 2
    ##     year average
    ##    <int>   <dbl>
    ##  1  1980  338.32
    ##  2  1981  339.88
    ##  3  1982  340.90
    ##  4  1983  343.05
    ##  5  1984  344.70
    ##  6  1985  345.88
    ##  7  1986  347.21
    ##  8  1987  349.16
    ##  9  1988  351.41
    ## 10  1989  352.85
    ## # ... with 27 more rows

It's also worth noting that the piped version does not create an additional object unless you ask it to. This is super useful in the early stages of exploring and visualizing your data.

More information about pipes and the alternatives found [here](http://r4ds.had.co.nz/pipes.html)

Sorting data
============

Often data is not in the exact form we want or we need additional information from our data. When this is the case, the tidyverse library has some helpful functions that, when combined, are powerful tools for rearranging and summarizing our data.

Group By & Summarise
--------------------

`group_by` allows us to invisibly partition our data into groups which can be powerful when we later want to applied functions or look at statistics on groups together. Take a look, you'll notice the only thing that changes when group\_by years in the co2 dataframe, is the addition of a small line in the tibble header: "\# Groups: year \[60\]"

``` r
co2 %>% group_by(year)
```

    ## # A tibble: 717 x 7
    ## # Groups:   year [60]
    ##     year month decimal_date average interpolated  trend  days
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>
    ##  1  1958     3     1958.208  315.71       315.71 314.62    NA
    ##  2  1958     4     1958.292  317.45       317.45 315.29    NA
    ##  3  1958     5     1958.375  317.50       317.50 314.71    NA
    ##  4  1958     6     1958.458      NA       317.10 314.85    NA
    ##  5  1958     7     1958.542  315.86       315.86 314.98    NA
    ##  6  1958     8     1958.625  314.93       314.93 315.94    NA
    ##  7  1958     9     1958.708  313.20       313.20 315.91    NA
    ##  8  1958    10     1958.792      NA       312.66 315.61    NA
    ##  9  1958    11     1958.875  313.33       313.33 315.31    NA
    ## 10  1958    12     1958.958  314.67       314.67 315.61    NA
    ## # ... with 707 more rows

Everything else appears the same! We still have 716 rows and 10 columns. All the names are the same. BUT.... if we pass this new grouped dataframe into another function like `summarise`, check out what happens:

``` r
co2 %>% group_by(year) %>% summarise(`Number of measurements` = n(), `Average year's trend` = mean(trend))
```

    ## # A tibble: 60 x 3
    ##     year `Number of measurements` `Average year's trend`
    ##    <int>                    <int>                  <dbl>
    ##  1  1958                       10               315.2830
    ##  2  1959                       12               315.9742
    ##  3  1960                       12               316.9075
    ##  4  1961                       12               317.6367
    ##  5  1962                       12               318.4500
    ##  6  1963                       12               318.9942
    ##  7  1964                       12               319.6217
    ##  8  1965                       12               320.0433
    ##  9  1966                       12               321.3833
    ## 10  1967                       12               322.1567
    ## # ... with 50 more rows

The `summarise` function allows you to build a new table with completely new columns, based upon any operations you want to run on your original table. Without the group by, this same `summarise` command would return only 1 line:

``` r
co2 %>% summarise(`Number of measurements` = n(), `Average trend` = mean(trend))
```

    ## # A tibble: 1 x 2
    ##   `Number of measurements` `Average trend`
    ##                      <int>           <dbl>
    ## 1                      717        352.8727

But once we "group" the dataframe, R knows to compute our functions across the groups we specify.

Mutating
--------

The `mutate` function is similar to `summarise` in that it allows you to take values from within a data table, compute something new, but in this case, the R will append it as a new column to the original dataframe. For instance, perhaps we wanted to make a column combining the year and month for our dataset

``` r
co2 %>% mutate(month_year = paste0(month,"/", year))
```

    ## # A tibble: 717 x 8
    ##     year month decimal_date average interpolated  trend  days month_year
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>      <chr>
    ##  1  1958     3     1958.208  315.71       315.71 314.62    NA     3/1958
    ##  2  1958     4     1958.292  317.45       317.45 315.29    NA     4/1958
    ##  3  1958     5     1958.375  317.50       317.50 314.71    NA     5/1958
    ##  4  1958     6     1958.458      NA       317.10 314.85    NA     6/1958
    ##  5  1958     7     1958.542  315.86       315.86 314.98    NA     7/1958
    ##  6  1958     8     1958.625  314.93       314.93 315.94    NA     8/1958
    ##  7  1958     9     1958.708  313.20       313.20 315.91    NA     9/1958
    ##  8  1958    10     1958.792      NA       312.66 315.61    NA    10/1958
    ##  9  1958    11     1958.875  313.33       313.33 315.31    NA    11/1958
    ## 10  1958    12     1958.958  314.67       314.67 315.61    NA    12/1958
    ## # ... with 707 more rows

`group by` functions also work to group things before`mutate` functions. FOr instance, if we wanted a column that averaged the temperature across each year?

``` r
co2 %>% group_by(year) %>% mutate(year_average= mean(average, na.rm=TRUE))
```

    ## # A tibble: 717 x 8
    ## # Groups:   year [60]
    ##     year month decimal_date average interpolated  trend  days year_average
    ##    <int> <int>        <dbl>   <dbl>        <dbl>  <dbl> <int>        <dbl>
    ##  1  1958     3     1958.208  315.71       315.71 314.62    NA     315.3313
    ##  2  1958     4     1958.292  317.45       317.45 315.29    NA     315.3313
    ##  3  1958     5     1958.375  317.50       317.50 314.71    NA     315.3313
    ##  4  1958     6     1958.458      NA       317.10 314.85    NA     315.3313
    ##  5  1958     7     1958.542  315.86       315.86 314.98    NA     315.3313
    ##  6  1958     8     1958.625  314.93       314.93 315.94    NA     315.3313
    ##  7  1958     9     1958.708  313.20       313.20 315.91    NA     315.3313
    ##  8  1958    10     1958.792      NA       312.66 315.61    NA     315.3313
    ##  9  1958    11     1958.875  313.33       313.33 315.31    NA     315.3313
    ## 10  1958    12     1958.958  314.67       314.67 315.61    NA     315.3313
    ## # ... with 707 more rows

Together, group\_by, mutate, and summarise are some of your most powerful tools for data manipulation.

Plotting data
=============

Plotting Data with `ggplot`
---------------------------

Effective visualizations are an integral part of data science, poorly organized or poorly labelled figures can be as much a source of peril as understanding. Nevertheless, the ability to generate plots quickly with minimal tinkering is an essential skill. As standards for visualizations have increased, too often visualization is seen as an ends rather than a means of data analysis. See [Fox & Hendler (2011)](http://science.sciencemag.org/content/331/6018/705.short) for more discussion of this.

Plotting Data with `ggplot`
---------------------------

``` r
ggplot(co2, aes(decimal_date, average)) + geom_line()
```

![](../Basics_in_R_files/figure-markdown_github/unnamed-chunk-14-1.png)

Plotting multiple series
------------------------

We often would like to plot several data values together for comparison, for example the average, interpolated and trend co2 data. We can do this in three steps:

1.  subsetting the dataset to the columns desired for plotting

    ``` r
    co2_sub <- co2 %>%
    select(decimal_date, average, interpolated, trend)
    co2_sub %>% head()
    ```

        ## # A tibble: 6 x 4
        ##   decimal_date average interpolated  trend
        ##          <dbl>   <dbl>        <dbl>  <dbl>
        ## 1     1958.208  315.71       315.71 314.62
        ## 2     1958.292  317.45       317.45 315.29
        ## 3     1958.375  317.50       317.50 314.71
        ## 4     1958.458      NA       317.10 314.85
        ## 5     1958.542  315.86       315.86 314.98
        ## 6     1958.625  314.93       314.93 315.94

2.  rearranging the data into a "long" data table where the data values are stacked together in one column and there is a separate column that keeps track of the whether the data came from the average, interpolated, or trend column. Notice by using the same name, we overwrite the original co2\_sub

    ``` r
    co2_sub <- co2_sub %>%
    gather(series, ppmv, -decimal_date)
    co2_sub %>% head()
    ```

        ## # A tibble: 6 x 3
        ##   decimal_date  series   ppmv
        ##          <dbl>   <chr>  <dbl>
        ## 1     1958.208 average 315.71
        ## 2     1958.292 average 317.45
        ## 3     1958.375 average 317.50
        ## 4     1958.458 average     NA
        ## 5     1958.542 average 315.86
        ## 6     1958.625 average 314.93

3.  plotting

    ``` r
    co2_sub %>%
     ggplot(aes(decimal_date, ppmv, col = series)) + 
      geom_line()
    ```

    ![](../Basics_in_R_files/figure-markdown_github/unnamed-chunk-17-1.png)

Plotting multiple series
------------------------

Or, even better, we can take advantage of dplyr's nifty pipping abilities and accomplish all of these steps in one block of code. Beyond being more succinct, this has the added benefit of avoiding creating a new object for the subsetted data.

``` r
co2 %>%
  select(decimal_date, average, interpolated, trend) %>%
  gather(series, ppmv, -decimal_date) %>%
  ggplot(aes(decimal_date, ppmv, col = series)) +  geom_line()
```

![](../Basics_in_R_files/figure-markdown_github/unnamed-chunk-18-1.png)

Writing out Data or objects
===========================

Often after doing all the work to clean up your data you want to write out the clean file, this is simple with the `write_*` functions.

``` r
write_csv(co2_sub, "co2clean")
```

We can even write out our ggplot images:

``` r
# defaults to saving your last plot. can be specified
ggsave("plot1", device = "png")
```

    ## Saving 7 x 5 in image
