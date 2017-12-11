Slighty More Advanced R
================
Dana Seidel & Eric Dougherty
1/4/2018

In our earlier section, we discussed the basics of importing, manipulating, and visualizing vector data in R, specifically focused on using the "tidyverse". In this section we want to review some additional powerful tools that we will need as we dive into simulations in R later in the week. Fundamentals in coding such as functions, loops, creating/representing data in a `data.frame` / `tibble` objects, and random number generation will be covered here.

Random Number Generation
========================

For this section, instead of importing a data set, we are going to create our own example data set using random number generation. Knowing how to do this can be very powerful when you want to test your code, build reproducible examples, or most importantly for our case, build stochastic simulations.

The base functions necessary for random number generation in R are tied to probability distributions. The most commonly used distributions being:

-   Uniform
-   Normal (Guassian)
-   Binominal

R is built around, by, and for statistics professionals so there are many other distributions (e.g. Poisson, Weibull, Gamma, etc. ) built into the `stats` package. We're going to focus on the most basic distributions for now but should you need a specific obscure one, know that it's probably already built into R for your use.

To generate random numbers according to these distributions there are a set of functions, all with the prefix `r`, i.e. `runif()` `rnorm()`, `rbinom()`

Within these functions you can specify the necessary variables for the specific distribution you want to pull from. For example, if we want 10 numbers pulled randomly from between 0 and 2000:

``` r
runif(n = 10, min = 0, max = 2000)
```

    ##  [1] 1219.2204  942.3868 1569.1519  315.3799 1472.3385 1597.5341 1366.4249
    ##  [8] 1537.5394 1280.0860 1256.4942

Now you'll notice that this returns fractional values, if you want whole numbers, the `sample` function can handle this:

``` r
sample(0:2000, 10, replace=T)
```

    ##  [1] 1963 1272 1814  237  969 1205 1542  773  805  760

``` r
# this is the same as 
sample.int(2000, 10)
```

    ##  [1]  131 1049  889 1601 1652   26 1402 1530  592  700

**Keep in mind, `sample` is an especially powerful function because you can use it to randomly sample any empirical dataset you have.**

Often when we are simulating a process, we want to pull our numbers not from a uniform distribition but instead from a distribution that matches the process we are trying to siumulate. For example, if we wanted to simulate coin flips, all we have to do is generate "flips" from the Bernoulli distribution (otherwise known as a Binomial distribution with size = 1 and p = .5).

Let's flip this (even) coin 20 times:

``` r
rbinom(20, 1, .5)
```

    ##  [1] 1 0 1 1 0 0 1 1 1 0 0 0 1 0 0 0 1 0 1 1

Or perhaps we need to pull 10 samples from a process that due to the central limit theorem, probably has a normal distribution with a mean of 50 and a sd of 12, with the `rnorm` function that's simple!

``` r
rnorm(10, 50, 12)
```

    ##  [1] 47.72000 56.71438 36.73263 62.64726 36.50295 47.69972 56.55643
    ##  [8] 55.91117 56.41962 66.78236

``` r
# want those to be intergers?
round(rnorm(10,50,12))
```

    ##  [1] 42 66 41 51 50 41 64 51 36 37

Build some fake data:
---------------------

So, hopefully you get a sense of just how useful random numbers can be for simulations. Sometime we use random number generation, not for simulation but just to produce fake datasets to use for testing or reproducible examples.

As practice, let's try building a data frame of fake temperatures in HongKong through the 12 months of the year for 10 years from 2000-2010.

From a quick web search I can get the [mean temperatures through the year](http://www.holiday-weather.com/hong_kong/averages/) in Celsius:

        Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
        16  18  20  24  26  28  29  29  27  26  22  17

Using the normal distribution assuming 2 degrees deviation in all months, let's build a dataframe combining our tidyverse functions from earlier and by randomly generating 10 samples around these mean temperatures by month.

``` r
temp <- data.frame(YEAR = 2001:2010,
               JAN = rnorm(10, 16, 2), 
               FEB = rnorm(10, 18, 2),
               MAR = rnorm(10, 20, 2),
               APR = rnorm(10, 24, 2),
               MAY = rnorm(10, 26, 2),
               JUN = rnorm(10, 28, 2),
               JUL = rnorm(10, 29, 2),
               AUG = rnorm(10, 29, 2),
               SEP = rnorm(10, 27, 2),
               OCT = rnorm(10, 26, 2),
               NOV = rnorm(10, 22, 2),
               DEC = rnorm(10, 17, 2))

temp
```

|  YEAR|       JAN|       FEB|       MAR|       APR|       MAY|       JUN|       JUL|       AUG|       SEP|       OCT|       NOV|       DEC|
|-----:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|
|  2001|  15.33013|  17.32560|  18.12138|  21.44528|  27.34773|  26.42921|  25.87973|  29.39392|  26.58239|  25.50978|  23.07541|  14.29345|
|  2002|  13.06177|  17.85901|  20.51963|  23.98029|  23.34533|  28.51028|  26.04199|  31.45473|  24.51927|  26.90536|  24.57398|  12.43449|
|  2003|  16.13150|  14.99376|  16.71463|  23.39751|  28.64670|  26.99414|  27.52486|  26.74078|  23.22990|  25.37925|  23.31849|  16.89089|
|  2004|  15.88206|  18.64656|  20.70334|  23.62475|  24.37297|  28.24255|  28.67588|  33.12645|  26.76591|  26.23387|  20.87248|  17.35246|
|  2005|  17.36792|  21.65966|  18.72683|  26.52348|  23.14541|  27.09338|  28.58653|  30.98810|  27.29887|  24.35832|  19.95440|  16.02837|
|  2006|  15.91963|  21.02876|  19.97368|  24.99565|  26.36900|  28.42549|  28.27501|  25.77893|  26.39000|  28.56117|  21.43637|  16.76816|
|  2007|  18.71045|  18.63803|  19.75861|  24.56608|  27.73781|  28.15560|  25.63908|  26.43423|  27.46236|  27.27755|  21.26121|  22.04124|
|  2008|  12.69598|  20.02350|  19.44076|  25.40158|  25.58153|  27.47238|  27.98417|  27.85951|  23.44490|  26.00289|  20.15497|  20.93301|
|  2009|  17.48154|  18.04666|  20.09587|  23.70637|  23.12443|  26.91826|  25.60895|  31.08016|  24.79809|  28.06563|  24.22651|  17.68293|
|  2010|  15.22408|  14.05080|  16.57681|  22.84491|  24.11675|  28.38321|  31.79442|  30.08724|  26.89806|  26.67713|  21.47659|  16.05550|

Great! Now that we have some data to work with, let's get to building our own functions to play with it.

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

For instance if I need to convert every concentration in the `temp` dataframe from Celsius to Farenheight I might consider writing out the conversion equation:

*F* = 1.8 \* *C* + 32
 into a custom function of my own:

``` r
celsius_to_faren <- function(C){
1.8*C + 32
}
```

Rather than doing something repetitive like:

``` r
1.8*temp$JAN + 32
1.8*temp$FEB + 32
# all the way to...
1.8*temp$DEC + 32
```

Now obviously, this is a very simple example but is useful for showing us the guts of the R function environment. Notice 3 important things about the structure of our function:

1.  all custom functions should be assigned a **name** (i.e. celsius\_to\_faren). Keep in mind, your code has 2 audiences, the computer that needs to be able to run it, and the humans that need to be able to read it (your future self included!). Keep code clean and your naming style consistent to facilitate readbility.

2.  functions take flexibly named arguments (i.e. C) in the paratheses before the operation. Our function would run the exact same way if it was written as:

    ``` r
      celsius_to_faren <- function(x=15){
      1.8*x + 32
      }
    ```

    -   Note also that function arguments can be given defaults (e.g. x = 15), allowing them to run with or without that argument newly specified. For example:

    ``` r
    # it will revert to the default
    celsius_to_faren()
    ```

        ## [1] 59

    ``` r
    # or we can specify a different value to run the conversion on
    celsius_to_faren(50)
    ```

        ## [1] 122

3.  The guts of the function, the operation, goes in between two curly brackets, after the necessary arguments have been specified.

As you have seen above, to run our function we simply call it like any other function from R packages: `celsius_to_faren()`

Conditions
----------

Often when coding, especially in more complex function, we want to doing an operation only when a certain condition is met. This is when we need if and if/else statements!

Formal `if` statements have a very similar format to functions:

`if(condition){     operation   }`

`if` statements have lots of uses both in and outside of custom functions, but for now we are going to focus on how to incorporate them into our function writing.

For example we could adapt our above simple function to do something special when it encountered a missing value simply by including an `if` statement:

``` r
celsius_to_faren <- function(x = 15){
  if (is.na(x)){
    return(-999)  # telling the function to return -999 every time it encounters an NA
    }
  1.8*x + 32 # but to still do the regular conversion other times 
  }
```

Now let's throw in a missing value to our table, for testing! Maybe we didn't sample in January of 2002 for some reason:

``` r
temp[2,2] <- NA

# combine this function with the `mutate` function we learned earlier

temp %>% 
  rowwise %>% 
  mutate(JAN_F = celsius_to_faren(JAN)) %>% 
  select(YEAR, JAN, JAN_F)
```

    ## Source: local data frame [10 x 3]
    ## Groups: <by row>
    ## 
    ## # A tibble: 10 x 3
    ##     YEAR      JAN      JAN_F
    ##    <int>    <dbl>      <dbl>
    ##  1  2001 15.33013   59.59423
    ##  2  2002       NA -999.00000
    ##  3  2003 16.13150   61.03669
    ##  4  2004 15.88206   60.58771
    ##  5  2005 17.36792   63.26225
    ##  6  2006 15.91963   60.65534
    ##  7  2007 18.71045   65.67881
    ##  8  2008 12.69598   54.85277
    ##  9  2009 17.48154   63.46677
    ## 10  2010 15.22408   59.40334

``` r
# note! the `rowwise` command works to group the dataframe by each row. 
# because our function is written to take a single value, not a full vector, 
# we need to pass our dataframe through `rowwise` first. 

# 2nd note! breaking up your code at each pipe helps with readability of each step.
```

One can string a bunch of `if` statements together using the nested `if/else` structure:

``` r
if (test_expression1) {
   statement1
} else if (test_expression2) {
   statement2
} else if (test_expression3) {
   statement3
} else
   statement4
```

Alternatively, R has a nifty `ifelse()` function that simplifies this into one line.

`ifelse(test, yes, no)`

For instance, adapting our above function directly into a mutate command:

``` r
temp %>% 
  mutate(JAN_F = ifelse(is.na(JAN), -999, JAN*1.8 + 32)) %>% 
  select(YEAR, JAN, JAN_F) 
```

|  YEAR|       JAN|      JAN\_F|
|-----:|---------:|-----------:|
|  2001|  15.33013|    59.59423|
|  2002|        NA|  -999.00000|
|  2003|  16.13150|    61.03669|
|  2004|  15.88206|    60.58771|
|  2005|  17.36792|    63.26225|
|  2006|  15.91963|    60.65534|
|  2007|  18.71045|    65.67881|
|  2008|  12.69598|    54.85276|
|  2009|  17.48154|    63.46677|
|  2010|  15.22408|    59.40334|

Loops
=====

*Much of this section is modelled after the iteration chapter of R for Data Science. Read more in [**Supplemental Reading**](http://r4ds.had.co.nz/iteration.html)*

Loops are used in programming to repeat a specific block of code. Though loops are used less often in R than many other programming languages, the loops we cover today are very important for learning to simulate movement paths later in the workshop.

For loops
---------

In R, For loops are used to repeat a chunk of code, over all the values held inside the given vector.

There are 3 parts to a simple for loop:

1.  The **initialization**: before you start the loop, you need a place to put the results.
2.  The **iteration** vector: this part, i.e. `(i in 1:10)` determines what values we loop over. In this case, the loop would run over 10 different values, 1,2,3,4,5,6,7,8,9,10
3.  The **body** of the loop: the meat of it - the code that actually does the work. Whatever we want to calculate over all those different numbers, goes here.

So for instance, maybe we want to calculate the annual mean temperature for each of our years of data. We can do this with a for loop!

``` r
# first we initialize!
averages  <- vector()      # an empty vector for our averages to go

# the we iterate:
for(i in 1:10){                 # take the mean of row i of temp dataframe and put it the averages vector
  averages[i] <- mean(as.numeric(temp[i,2:13]), na.rm=TRUE)       #drop Nas, and drop column 1 to leave out year.
}                                             

# Now we can read out results
averages
```

    ##  [1] 22.56117 23.64949 22.49687 23.70827 23.47761 23.66015 23.97352
    ##  [8] 23.08293 23.40295 22.84879

Once you understand the basic for loop it's useful to consider some important variations, namely:

1.  Modifying an existing object, instead of creating a new object.
2.  Looping over names or values, instead of indices.
3.  Handling sequences of unknown length ("while" loops, covered in the next section)

Consider the following loops and their outputs for examples of these variations, for more information see the readings. Note the consitent syntax of these loops.

``` r
# Modifying an existing object

jan <- as.vector(temp$JAN)  # make a simple vector of January column

for(i in seq(1,5,1)){
  jan <- append(jan, rnorm(1,16,2))     # add 5 more years temperatures, 1 at a time. 
}

jan
```

    ##  [1] 15.33013       NA 16.13150 15.88206 17.36792 15.91963 18.71045
    ##  [8] 12.69598 17.48154 15.22408 16.30392 16.49026 15.74810 18.19010
    ## [15] 15.31277

``` r
# Or maybe we want to round every column to integers

for(i in 1:length(temp)){
  temp[i] <- round(temp[i])
}

temp
```

|  YEAR|  JAN|  FEB|  MAR|  APR|  MAY|  JUN|  JUL|  AUG|  SEP|  OCT|  NOV|  DEC|
|-----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|
|  2001|   15|   17|   18|   21|   27|   26|   26|   29|   27|   26|   23|   14|
|  2002|   NA|   18|   21|   24|   23|   29|   26|   31|   25|   27|   25|   12|
|  2003|   16|   15|   17|   23|   29|   27|   28|   27|   23|   25|   23|   17|
|  2004|   16|   19|   21|   24|   24|   28|   29|   33|   27|   26|   21|   17|
|  2005|   17|   22|   19|   27|   23|   27|   29|   31|   27|   24|   20|   16|
|  2006|   16|   21|   20|   25|   26|   28|   28|   26|   26|   29|   21|   17|
|  2007|   19|   19|   20|   25|   28|   28|   26|   26|   27|   27|   21|   22|
|  2008|   13|   20|   19|   25|   26|   27|   28|   28|   23|   26|   20|   21|
|  2009|   17|   18|   20|   24|   23|   27|   26|   31|   25|   28|   24|   18|
|  2010|   15|   14|   17|   23|   24|   28|   32|   30|   27|   27|   21|   16|

``` r
# Looping over names or indices rather than sequences.

# print the 5th row of just a few specific columns
months <- c("JAN", "MAY", "SEP")
for (i in months){
 print(mean(temp[,i]), na.rm=TRUE)
}
```

    ## [1] NA
    ## [1] 25.3
    ## [1] 25.7

While loops
-----------

In a combination of the conditionals introduced earlier and the for loops we saw above, in R programming, while loops are used to loop until a specific condition is met. These can be especially useful if you don't know the length of the input sequence needed for you task: a common occurence when doing simulations.

For example, you might want to loop until you get three heads in a row. You can’t do that sort of iteration with the for loop. Instead, you can use a while loop. A while loop is simpler than for loop because it only has two components, a condition and a body:

The syntax of a while expression is as follows:

``` r
while (condition)
{
   body
}
```

Here, `condition` is evaluated first. If the condition is TRUE, than the body of the loop is entered and the calculations inside the loop are executed. Once executed, the flow returns to evaluate the `condition` for the next element. This is repeated each time until the `condition` evaluates to FALSE, in which case, the loop exits.

So, for example, a while loop using a random number generator to simulate flips of an even coin:

How many flips does it take to get 3 heads in a row?

``` r
flip <- function(){ # randomly sample 1 "flip" from a bernoulli dist. 
  rbinom(1, 1, .5)
  } 

flips <- 0        # intialize
nheads <- 0

while (nheads < 3) {  # continue loop until nheads is 3. 
  if (flip() == 1) {  # conditional if else statement.
    nheads <- nheads + 1  # IF the flip is a 1 (head) add it to the nheads vector
  } else {            #  If NOT, reset the nheads vector to 0
    nheads <- 0
  }
  flips <- flips + 1  # track the number of flips by adding each iteration to flip vector
}

flips
```

    ## [1] 24

The `apply` and `map` functions
-------------------------------

This same pattern of looping over a vector, in other words, implementing some computation or function over many elements is so common both baseR and tidyverse have families of functions to do it for you: the apply family of functions (baseR) or the map family of functions from the purrr library in (baseR)

These functions make iteration much simpler and your code a lot more concise and readable but may take some time to wrap your head around. We introduce them here just for you to be aware of but if you're just starting out, you may find that for loops are easier for you to understand. That's okay! Loops work just as well, they just take more time and text to code.

### Apply: Base R

`lapply()` takes arguments `x`, and `FUN` as inputs. `x` is equivalent to the vector you would iterate over in a for loop and `FUN` is equivalent to whatever you would put into the body of the for loop. `lapply` always returns a list.

So for instance, let's try applying a custom function using `lapply` to take our temp back to celsius. Note that the output is a list.

``` r
 celsius_to_faren <- function(x=15){
      1.8*x + 32
 }

lapply(temp[,2:13], celsius_to_faren)
```

    ## $JAN
    ##  [1] 59.0   NA 60.8 60.8 62.6 60.8 66.2 55.4 62.6 59.0
    ## 
    ## $FEB
    ##  [1] 62.6 64.4 59.0 66.2 71.6 69.8 66.2 68.0 64.4 57.2
    ## 
    ## $MAR
    ##  [1] 64.4 69.8 62.6 69.8 66.2 68.0 68.0 66.2 68.0 62.6
    ## 
    ## $APR
    ##  [1] 69.8 75.2 73.4 75.2 80.6 77.0 77.0 77.0 75.2 73.4
    ## 
    ## $MAY
    ##  [1] 80.6 73.4 84.2 75.2 73.4 78.8 82.4 78.8 73.4 75.2
    ## 
    ## $JUN
    ##  [1] 78.8 84.2 80.6 82.4 80.6 82.4 82.4 80.6 80.6 82.4
    ## 
    ## $JUL
    ##  [1] 78.8 78.8 82.4 84.2 84.2 82.4 78.8 82.4 78.8 89.6
    ## 
    ## $AUG
    ##  [1] 84.2 87.8 80.6 91.4 87.8 78.8 78.8 82.4 87.8 86.0
    ## 
    ## $SEP
    ##  [1] 80.6 77.0 73.4 80.6 80.6 78.8 80.6 73.4 77.0 80.6
    ## 
    ## $OCT
    ##  [1] 78.8 80.6 77.0 78.8 75.2 84.2 80.6 78.8 82.4 80.6
    ## 
    ## $NOV
    ##  [1] 73.4 77.0 73.4 69.8 68.0 69.8 69.8 68.0 75.2 69.8
    ## 
    ## $DEC
    ##  [1] 57.2 53.6 62.6 62.6 60.8 62.6 71.6 69.8 64.4 60.8

``` r
# we can use bind_rows(), to bind this list to a dataframe
lapply(temp[,2:13], celsius_to_faren) %>% bind_rows()
```

|   JAN|   FEB|   MAR|   APR|   MAY|   JUN|   JUL|   AUG|   SEP|   OCT|   NOV|   DEC|
|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|  59.0|  62.6|  64.4|  69.8|  80.6|  78.8|  78.8|  84.2|  80.6|  78.8|  73.4|  57.2|
|    NA|  64.4|  69.8|  75.2|  73.4|  84.2|  78.8|  87.8|  77.0|  80.6|  77.0|  53.6|
|  60.8|  59.0|  62.6|  73.4|  84.2|  80.6|  82.4|  80.6|  73.4|  77.0|  73.4|  62.6|
|  60.8|  66.2|  69.8|  75.2|  75.2|  82.4|  84.2|  91.4|  80.6|  78.8|  69.8|  62.6|
|  62.6|  71.6|  66.2|  80.6|  73.4|  80.6|  84.2|  87.8|  80.6|  75.2|  68.0|  60.8|
|  60.8|  69.8|  68.0|  77.0|  78.8|  82.4|  82.4|  78.8|  78.8|  84.2|  69.8|  62.6|
|  66.2|  66.2|  68.0|  77.0|  82.4|  82.4|  78.8|  78.8|  80.6|  80.6|  69.8|  71.6|
|  55.4|  68.0|  66.2|  77.0|  78.8|  80.6|  82.4|  82.4|  73.4|  78.8|  68.0|  69.8|
|  62.6|  64.4|  68.0|  75.2|  73.4|  80.6|  78.8|  87.8|  77.0|  82.4|  75.2|  64.4|
|  59.0|  57.2|  62.6|  73.4|  75.2|  82.4|  89.6|  86.0|  80.6|  80.6|  69.8|  60.8|

You may also see, `sapply()` or `vapply()`, these do the same thing but return the output in different formats.

In a slightly different flavor, `apply()` takes the additional `MARGIN` argument, which allows you to specify, when x is a matrix or dataframe, wether you want a function to be run over just the rows, `1`, just the columns, `2`, or both, `c(1,2)`.

For example, maybe we want the mean temperature of each year:

``` r
apply(temp[2:13], 1, mean, na.rm=TRUE)  #drop Nas, and drop column 1 to leave out year. 
```

    ##  [1] 22.41667 23.72727 22.50000 23.75000 23.50000 23.58333 24.00000
    ##  [8] 23.00000 23.41667 22.83333

Or instead the average by month:

``` r
apply(temp[2:13], 2, mean, na.rm=TRUE)  #drop Nas, and drop column 1 to leave out year. 
```

    ##  JAN  FEB  MAR  APR  MAY  JUN  JUL  AUG  SEP  OCT  NOV  DEC 
    ## 16.0 18.3 19.2 24.1 25.3 27.5 27.8 29.2 25.7 26.5 21.9 17.0

### Map: tidyverse and the purrr package

The `purrr` package provides a similar family of functions to do this same iterative computation with the added clarity of providing one funtion each type of output and the benefit of playing nicely with all the other tidyverse functions we introduced earlier e.g. `group_by` & the pipe operator `%>%`.

Just as before, each function takes a vector as input, applies a function to each piece, and then returns a new vector that’s the same length (and has the same names) as the input. The type of the vector is determined by the suffix to the map function.

-   map() makes a list. (equivalent to `lapply`)
-   map\_df() makes a dataframe.
-   map\_lgl() makes a logical vector.
-   map\_int() makes an integer vector.
-   map\_dbl() makes a double vector.
-   map\_chr() makes a character vector.

Take for example the same operation using between `map`, `lapply`, & `map_df`

``` r
lapply(temp[,2:13], celsius_to_faren)
```

    ## $JAN
    ##  [1] 59.0   NA 60.8 60.8 62.6 60.8 66.2 55.4 62.6 59.0
    ## 
    ## $FEB
    ##  [1] 62.6 64.4 59.0 66.2 71.6 69.8 66.2 68.0 64.4 57.2
    ## 
    ## $MAR
    ##  [1] 64.4 69.8 62.6 69.8 66.2 68.0 68.0 66.2 68.0 62.6
    ## 
    ## $APR
    ##  [1] 69.8 75.2 73.4 75.2 80.6 77.0 77.0 77.0 75.2 73.4
    ## 
    ## $MAY
    ##  [1] 80.6 73.4 84.2 75.2 73.4 78.8 82.4 78.8 73.4 75.2
    ## 
    ## $JUN
    ##  [1] 78.8 84.2 80.6 82.4 80.6 82.4 82.4 80.6 80.6 82.4
    ## 
    ## $JUL
    ##  [1] 78.8 78.8 82.4 84.2 84.2 82.4 78.8 82.4 78.8 89.6
    ## 
    ## $AUG
    ##  [1] 84.2 87.8 80.6 91.4 87.8 78.8 78.8 82.4 87.8 86.0
    ## 
    ## $SEP
    ##  [1] 80.6 77.0 73.4 80.6 80.6 78.8 80.6 73.4 77.0 80.6
    ## 
    ## $OCT
    ##  [1] 78.8 80.6 77.0 78.8 75.2 84.2 80.6 78.8 82.4 80.6
    ## 
    ## $NOV
    ##  [1] 73.4 77.0 73.4 69.8 68.0 69.8 69.8 68.0 75.2 69.8
    ## 
    ## $DEC
    ##  [1] 57.2 53.6 62.6 62.6 60.8 62.6 71.6 69.8 64.4 60.8

``` r
map(temp[,2:13], celsius_to_faren)
```

    ## $JAN
    ##  [1] 59.0   NA 60.8 60.8 62.6 60.8 66.2 55.4 62.6 59.0
    ## 
    ## $FEB
    ##  [1] 62.6 64.4 59.0 66.2 71.6 69.8 66.2 68.0 64.4 57.2
    ## 
    ## $MAR
    ##  [1] 64.4 69.8 62.6 69.8 66.2 68.0 68.0 66.2 68.0 62.6
    ## 
    ## $APR
    ##  [1] 69.8 75.2 73.4 75.2 80.6 77.0 77.0 77.0 75.2 73.4
    ## 
    ## $MAY
    ##  [1] 80.6 73.4 84.2 75.2 73.4 78.8 82.4 78.8 73.4 75.2
    ## 
    ## $JUN
    ##  [1] 78.8 84.2 80.6 82.4 80.6 82.4 82.4 80.6 80.6 82.4
    ## 
    ## $JUL
    ##  [1] 78.8 78.8 82.4 84.2 84.2 82.4 78.8 82.4 78.8 89.6
    ## 
    ## $AUG
    ##  [1] 84.2 87.8 80.6 91.4 87.8 78.8 78.8 82.4 87.8 86.0
    ## 
    ## $SEP
    ##  [1] 80.6 77.0 73.4 80.6 80.6 78.8 80.6 73.4 77.0 80.6
    ## 
    ## $OCT
    ##  [1] 78.8 80.6 77.0 78.8 75.2 84.2 80.6 78.8 82.4 80.6
    ## 
    ## $NOV
    ##  [1] 73.4 77.0 73.4 69.8 68.0 69.8 69.8 68.0 75.2 69.8
    ## 
    ## $DEC
    ##  [1] 57.2 53.6 62.6 62.6 60.8 62.6 71.6 69.8 64.4 60.8

``` r
map_df(temp[,2:13], celsius_to_faren)
```

|   JAN|   FEB|   MAR|   APR|   MAY|   JUN|   JUL|   AUG|   SEP|   OCT|   NOV|   DEC|
|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|  59.0|  62.6|  64.4|  69.8|  80.6|  78.8|  78.8|  84.2|  80.6|  78.8|  73.4|  57.2|
|    NA|  64.4|  69.8|  75.2|  73.4|  84.2|  78.8|  87.8|  77.0|  80.6|  77.0|  53.6|
|  60.8|  59.0|  62.6|  73.4|  84.2|  80.6|  82.4|  80.6|  73.4|  77.0|  73.4|  62.6|
|  60.8|  66.2|  69.8|  75.2|  75.2|  82.4|  84.2|  91.4|  80.6|  78.8|  69.8|  62.6|
|  62.6|  71.6|  66.2|  80.6|  73.4|  80.6|  84.2|  87.8|  80.6|  75.2|  68.0|  60.8|
|  60.8|  69.8|  68.0|  77.0|  78.8|  82.4|  82.4|  78.8|  78.8|  84.2|  69.8|  62.6|
|  66.2|  66.2|  68.0|  77.0|  82.4|  82.4|  78.8|  78.8|  80.6|  80.6|  69.8|  71.6|
|  55.4|  68.0|  66.2|  77.0|  78.8|  80.6|  82.4|  82.4|  73.4|  78.8|  68.0|  69.8|
|  62.6|  64.4|  68.0|  75.2|  73.4|  80.6|  78.8|  87.8|  77.0|  82.4|  75.2|  64.4|
|  59.0|  57.2|  62.6|  73.4|  75.2|  82.4|  89.6|  86.0|  80.6|  80.6|  69.8|  60.8|

To do the same thing with for loops requires the following code (& nesting!):

``` r
faren <- data_frame()
for (i in 2:length(temp)){
  for (j in 1:nrow(temp)){
    faren[j,i-1] <- celsius_to_faren(temp[j,i])
  }
}

names(faren) <- names(temp)[2:13]
faren
```

|   JAN|   FEB|   MAR|   APR|   MAY|   JUN|   JUL|   AUG|   SEP|   OCT|   NOV|   DEC|
|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|  59.0|  62.6|  64.4|  69.8|  80.6|  78.8|  78.8|  84.2|  80.6|  78.8|  73.4|  57.2|
|    NA|  64.4|  69.8|  75.2|  73.4|  84.2|  78.8|  87.8|  77.0|  80.6|  77.0|  53.6|
|  60.8|  59.0|  62.6|  73.4|  84.2|  80.6|  82.4|  80.6|  73.4|  77.0|  73.4|  62.6|
|  60.8|  66.2|  69.8|  75.2|  75.2|  82.4|  84.2|  91.4|  80.6|  78.8|  69.8|  62.6|
|  62.6|  71.6|  66.2|  80.6|  73.4|  80.6|  84.2|  87.8|  80.6|  75.2|  68.0|  60.8|
|  60.8|  69.8|  68.0|  77.0|  78.8|  82.4|  82.4|  78.8|  78.8|  84.2|  69.8|  62.6|
|  66.2|  66.2|  68.0|  77.0|  82.4|  82.4|  78.8|  78.8|  80.6|  80.6|  69.8|  71.6|
|  55.4|  68.0|  66.2|  77.0|  78.8|  80.6|  82.4|  82.4|  73.4|  78.8|  68.0|  69.8|
|  62.6|  64.4|  68.0|  75.2|  73.4|  80.6|  78.8|  87.8|  77.0|  82.4|  75.2|  64.4|
|  59.0|  57.2|  62.6|  73.4|  75.2|  82.4|  89.6|  86.0|  80.6|  80.6|  69.8|  60.8|

Makes `map_df` seem pretty handy right?!
