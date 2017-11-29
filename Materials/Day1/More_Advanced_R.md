Slighty More Advanced R
================
Dana Seidel & Eric Dougherty
1/3/2018

In our earlier section, we discussed the basics of importing, manipulating, and visualizing vector data in R, specifically focused on using the "tidyverse". In this section we want to review some additional powerful tools that we will need as we dive into simulations in R later in the week. Fundamentals in coding such as functions, loops, creating/representing data in a `data.frame` / `tibble` objects, and random number generation will be covered here.

During this activity we will use the following [temperature dataset](https://data.giss.nasa.gov/cgi-bin/gistemp/stdata_show.cgi?id=403718030000&dt=1&ds=5):

``` r
temp <- read_csv("station.csv", na = "999.90")
```

Custom functions
================

[**Supplemental Reading**](http://r4ds.had.co.nz/functions.html)

Writing your own functions is one way to reduce duplication in your code or to create custom models for simulation.

From the Data Science for R Chapter 19:

      Functions allow you to automate common tasks in a more powerful and general way
      than copy-and-pasting. Writing a function has three big advantages over using copy-and-paste:

      1. You can give a function an evocative name that makes your code easier to understand.

      2. As requirements change, you only need to update code in one place, instead of many.

      3. You eliminate the chance of making incidental mistakes when you copy and paste 
      (i.e. updating a variable name in one place, but not in another).

As a general rule of thumb, you should consider writing a function if you need to run the same operations more than twice. I.e. don't go copying and pasting things 3 or more times.

For instance if I need to convert every concentration in the `co2` dataframe from ppm to mg/m3, I might consider writing out the conversion equation:

*K* = *C* + 273.15
 into a custom function of my own:

``` r
celsius_to_kelvin <- function(C){
C + 273.15
}
```

Rather than doing something repetitive like:

``` r
temp$JAN + 273.15
temp$FEB + 273.15
# all the way to...
temp$metANN + 273.15
```

Now obviously, this is a very simple example but is useful for showing us the guts of the R function environment. Notice 3 important things about the structure of our function:

1.  all custom functions should be assigned a **name** (i.e. kelvin\_to\_celsius). Keep in mind, your code has 2 audiences, the computer that needs to be able to run it, and the humans that need to be able to read it (your future self included!). Keep code clean and your naming style consistent to facilitate readbility.

2.  functions take flexibly named arguments (i.e. K) in the paratheses before the operation. Our function would run the exact same way if it was written as:

    ``` r
      celsius_to_kelvin <- function(x = 35){
        x + 273.15
        }
    ```

    -   Note also that function arguments can be given defaults (e.g. x = 35), allowing them to run with or without that argument newly specified. For example:

    ``` r
    # it will revert to the default
    celsius_to_kelvin()
    ```

        ## [1] 308.15

    ``` r
    # or we can specify a different value to run the conversion on
    celsius_to_kelvin(50)
    ```

        ## [1] 323.15

3.  The guts of the function, the operation, goes in between two curly brackets, after the necessary arguments have been specified.

As you have seen above, to run our function we simply call it like any other function from R packages: `celsius_to_kelvin()`

Conditions
----------

Often when coding, especially in more complex function, we want to doing an operation only when a certain condition is met. This is when we need if and if/else statements!

Formal `if` statements have a very similar format to functions:

`if(condition){     operation   }`

`if` statements have lots of uses both in and outside of custom functions, but for now we are going to focus on how to incorporate them into our function writing.

For example we could adapt our above simple function to do something special when it encountered a missing value simply by including an `if` statement:

``` r
celsius_to_kelvin <- function(x = 35){
  if(is.na(x)){
    return(-999)  # telling the function to return -999 every time it encounters an NA
    }
  x + 273.15 # but to still do the regular conversion other times 
  }

# combine this function with the `mutate` function we learned earlier

temp %>% 
  rowwise %>% 
  mutate(JAN_kelvin = celsius_to_kelvin(JAN)) %>% 
  select(YEAR, JAN, JAN_kelvin)
```

    ## Source: local data frame [81 x 3]
    ## Groups: <by row>
    ## 
    ## # A tibble: 81 x 3
    ##     YEAR   JAN JAN_kelvin
    ##    <int> <dbl>      <dbl>
    ##  1  1937    NA    -999.00
    ##  2  1938 -8.68     264.47
    ##  3  1939 -7.77     265.38
    ##  4  1940 -6.76     266.39
    ##  5  1941 -7.25     265.90
    ##  6  1942 -7.35     265.80
    ##  7  1943 -9.74     263.41
    ##  8  1944 -7.53     265.62
    ##  9  1945 -4.02     269.13
    ## 10  1946 -8.61     264.54
    ## # ... with 71 more rows

``` r
# note! the `rowwise` command works to group the dataframe by each row. 
# because our function is written to take a single value, not a full vector, 
# we need to pass our dataframe through `rowwise` first. 

# 2nd note! breaking up your code at each pipe helps with readability of each step.
```

One can string a bunch of `if` statements together using the nested `if/else` structure:

``` r
if ( test_expression1) {
   statement1
} else if ( test_expression2) {
   statement2
} else if ( test_expression3) {
   statement3
} else
   statement4
```

Alternatively, R has a nifty `ifelse()` function that simplifies this into one line.

`ifelse(test, yes, no)`

For instance, adapting our above function directly into a mutate command:

``` r
temp %>% 
  mutate(JAN_kelvin = ifelse(is.na(JAN), -999, JAN + 273)) %>% 
  select(YEAR, JAN, JAN_kelvin) 
```

    ## # A tibble: 81 x 3
    ##     YEAR   JAN JAN_kelvin
    ##    <int> <dbl>      <dbl>
    ##  1  1937    NA    -999.00
    ##  2  1938 -8.68     264.32
    ##  3  1939 -7.77     265.23
    ##  4  1940 -6.76     266.24
    ##  5  1941 -7.25     265.75
    ##  6  1942 -7.35     265.65
    ##  7  1943 -9.74     263.26
    ##  8  1944 -7.53     265.47
    ##  9  1945 -4.02     268.98
    ## 10  1946 -8.61     264.39
    ## # ... with 71 more rows

For Loops
=========

[**Supplemental Reading**](http://r4ds.had.co.nz/iteration.html)

Often

the `apply` functions
---------------------

Simulation
----------

### Initialize

### Simulate

### Return
