Basics in R
================
Dana Seidel & Eric Dougherty
1/3/2018

Introducing R studio
====================

-   What is the console?
-   What is the source?
-   what is your environment?
-   Using git within Rstudio

The TidyVerse
=============

The tidyverse is an opinionated collection of R packages designed for data science. All packages share an underlying philosophy and common APIs.

Install the packages: `install.packages("tidyverse")`

Access the book! [R for Data Science](http://r4ds.had.co.nz/)

Importing Data
==============

> In Data Science, 80% of time spent prepare data, 20% of time spent complain about need for prepare data.

Big Data Borat \[@BigDataBorat\](<https://twitter.com/BigDataBorat/status/306596352991830016>), February 27, 2013

Parsing
-------

Our first task is to read this data into our R environment. To this, we will use the `read_csv` function. Reading in a data file is called *parsing*, which sounds much more sophisticated. For good reason too -- parsing different data files and formats is a cornerstone of all pratical data science research, and can often be the hardest step.

#### So what do we need to know about this file in order to read it into R?

``` r
library("tidyverse")
```

``` r
## Let's try:
co2 <- read_table("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt")
```

    ## Parsed with column specification:
    ## cols(
    ##   `# --------------------------------------------------------------------` = col_character()
    ## )

``` r
co2
```

    ## # A tibble: 787 x 1
    ##    `# --------------------------------------------------------------------`
    ##                                                                       <chr>
    ##  1                                                  # USE OF NOAA ESRL DATA
    ##  2                                                                        #
    ##  3             # These data are made freely available to the public and the
    ##  4       # scientific community in the belief that their wide dissemination
    ##  5        # will lead to greater understanding and new scientific insights.
    ##  6         # The availability of these data does not constitute publication
    ##  7   # of the data.  NOAA relies on the ethics and integrity of the user to
    ##  8     # insure that ESRL receives fair credit for their work.  If the data
    ##  9       # are obtained for potential use in a publication or presentation,
    ## 10      # ESRL should be informed at the outset of the nature of this work.
    ## # ... with 777 more rows

**hmm... no luck. Let's try defining the comment symbol:**

``` r
co2 <- read_tsv("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt",
                comment = "#")
```

    ## Parsed with column specification:
    ## cols(
    ##   `1958   3    1958.208      315.71      315.71      314.62     -1` = col_character()
    ## )

``` r
co2
```

    ## # A tibble: 715 x 1
    ##    `1958   3    1958.208      315.71      315.71      314.62     -1`
    ##                                                                <chr>
    ##  1   1958   4    1958.292      317.45      317.45      315.29     -1
    ##  2   1958   5    1958.375      317.50      317.50      314.71     -1
    ##  3   1958   6    1958.458      -99.99      317.10      314.85     -1
    ##  4   1958   7    1958.542      315.86      315.86      314.98     -1
    ##  5   1958   8    1958.625      314.93      314.93      315.94     -1
    ##  6   1958   9    1958.708      313.20      313.20      315.91     -1
    ##  7   1958  10    1958.792      -99.99      312.66      315.61     -1
    ##  8   1958  11    1958.875      313.33      313.33      315.31     -1
    ##  9   1958  12    1958.958      314.67      314.67      315.61     -1
    ## 10   1959   1    1959.042      315.62      315.62      315.70     -1
    ## # ... with 705 more rows

Getting there, but not quite done. Our first row is being interpreted as column names. The documentation also notes that certain values are used to indicate missing data, which we would be better off converting to explicitly missing so we don't get confused.

``` r
co2 <- read.table("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt",
                  sep = "", comment = "#",
                  col.names = c("year", "month", "decimal_date", 
                                "average", "interpolated", 
                                "trend", "days"),
                  na.strings = c("-1", "-99.99"))
co2 %>% head()
```

|  year|  month|  decimal\_date|  average|  interpolated|   trend|  days|
|-----:|------:|--------------:|--------:|-------------:|-------:|-----:|
|  1958|      3|       1958.208|   315.71|        315.71|  314.62|    NA|
|  1958|      4|       1958.292|   317.45|        317.45|  315.29|    NA|
|  1958|      5|       1958.375|   317.50|        317.50|  314.71|    NA|
|  1958|      6|       1958.458|       NA|        317.10|  314.85|    NA|
|  1958|      7|       1958.542|   315.86|        315.86|  314.98|    NA|
|  1958|      8|       1958.625|   314.93|        314.93|  315.94|    NA|

Importing Data with tidyverse
-----------------------------

Alternately, with `readr::read_table` from `tidyverse`

It seems that `comment` arg is not fully implemented in CRAN version of `readr` so we must rely on `skip` to avoid the comment block:

``` r
co2 <- read_table("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt",
                  col_names = c("year", "month", "decimal_date", 
                                "average", "interpolated", "trend", "days"),
                  col_types = c("iiddddi"),
                  na = c("-1", "-99.99"),
                  skip = 72)

head(co2) 
```

|  year|  month|  decimal\_date|  average|  interpolated|   trend|  days|
|-----:|------:|--------------:|--------:|-------------:|-------:|-----:|
|  1958|      3|       1958.208|   315.71|        315.71|  314.62|    NA|
|  1958|      4|       1958.292|   317.45|        317.45|  315.29|    NA|
|  1958|      5|       1958.375|   317.50|        317.50|  314.71|    NA|
|  1958|      6|       1958.458|       NA|        317.10|  314.85|    NA|
|  1958|      7|       1958.542|   315.86|        315.86|  314.98|    NA|
|  1958|      8|       1958.625|   314.93|        314.93|  315.94|    NA|

Success! We have read in the data. Now we're ready to rock and roll.

Viewing data
------------

Subsetting data
---------------

Sorting data
------------

### Mutating

### GroupBy

### summarizing data

Writing Out Data
----------------

Plotting data
-------------

Plotting Data with `ggplot`
---------------------------

Effective visualizations are an integral part of data science, poorly organized or poorly labelled figures can be as much a source of peril as understanding. Nevertheless, the ability to generate plots quickly with minimal tinkering is an essential skill. As standards for visualizations have increased, too often visualization is seen as an ends rather than a means of data analysis. See [Fox & Hendler (2011)](http://science.sciencemag.org/content/331/6018/705.short) for more discussion of this.

Plotting Data with `ggplot`
---------------------------

``` r
ggplot(co2, aes(decimal_date, average)) + geom_line()
```

![](Basics_in_R_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-6-1.png)

Plotting multiple series
------------------------

We often would like to plot several data values together for comparison, for example the average, interpolated and trend co2 data. We can do this in three steps:

1.  subsetting the dataset to the columns desired for plotting

``` r
co2_sub <- co2 %>%
    select(decimal_date, average, interpolated, trend)
co2_sub %>% head()
```

|  decimal\_date|  average|  interpolated|   trend|
|--------------:|--------:|-------------:|-------:|
|       1958.208|   315.71|        315.71|  314.62|
|       1958.292|   317.45|        317.45|  315.29|
|       1958.375|   317.50|        317.50|  314.71|
|       1958.458|       NA|        317.10|  314.85|
|       1958.542|   315.86|        315.86|  314.98|
|       1958.625|   314.93|        314.93|  315.94|

Plotting multiple series
------------------------

1.  rearranging the data into a "long" data table where the data values are stacked together in one column and there is a separate column that keeps track of the whether the data came from the average, interpolated, or trend column. Notice by using the same name, we overwrite the original co2\_sub

``` r
co2_sub <- co2_sub %>%
    gather(series, ppmv, -decimal_date)
co2_sub %>% head()
```

|  decimal\_date| series  |    ppmv|
|--------------:|:--------|-------:|
|       1958.208| average |  315.71|
|       1958.292| average |  317.45|
|       1958.375| average |  317.50|
|       1958.458| average |      NA|
|       1958.542| average |  315.86|
|       1958.625| average |  314.93|
