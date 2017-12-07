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

    ##  [1]  309.6632 1097.1534 1418.4803 1915.7755  663.6806  351.1843 1459.0878
    ##  [8]  882.4543  529.1342 1859.5464

Now you'll notice that this returns fractional values, if you want whole numbers, the `sample` function can handle this:

``` r
sample(0:2000, 10, replace=T)
```

    ##  [1] 1185  364  192  120 1106 1541  629  259 1554 1045

``` r
# this is the same as 
sample.int(2000, 10)
```

    ##  [1]  401 1980  549  182 1454  391 1104  505 1564  290

**Keep in mind, `sample` is an especially powerful function because you can use it to randomly sample any empirical dataset you have.**

Often when we are simulating a process, we want to pull our numbers not from a uniform distribition but instead from a distribution that matches the process we are trying to siumulate. For example, if we wanted to simulate coin flips, all we have to do is generate "flips" from the Bernoulli distribution (otherwise known as a Binomial distribution with size = 1 and p = .5).

Let's flip this (even) coin 20 times:

``` r
rbinom(20, 1, .5)
```

    ##  [1] 1 0 0 1 1 0 1 1 1 0 0 1 1 1 1 1 1 1 1 0

Or perhaps we need to pull 10 samples from a process that by the law of large numbers, probably has a normal distribution with a mean of 50 and a sd of 12, with the `rnorm` function that's simple!

``` r
rnorm(10, 50, 12)
```

    ##  [1] 67.47438 36.82185 46.22783 44.23206 40.75758 54.09735 67.07903
    ##  [8] 61.91172 52.98483 44.34440

``` r
# want those to be intergers?
round(rnorm(10,50,12))
```

    ##  [1] 57 29 73 83 57 26 58 45 50 43

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
|  2001|  16.98598|  16.31770|  20.44448|  24.69365|  28.59485|  26.49183|  29.37802|  27.13749|  26.11919|  24.39395|  23.20675|  16.65224|
|  2002|  16.57521|  19.80508|  22.23315|  24.48746|  27.62149|  27.66435|  27.90220|  24.23490|  28.46916|  25.28122|  22.33979|  18.22325|
|  2003|  15.94836|  15.38695|  18.34776|  22.79160|  25.80325|  31.70307|  31.19384|  31.10549|  26.74249|  31.38105|  22.05595|  18.11720|
|  2004|  15.99893|  22.06372|  23.17723|  21.86511|  23.30933|  27.06241|  29.04805|  31.17517|  27.56623|  28.31270|  26.07213|  15.85787|
|  2005|  14.90212|  14.77337|  21.11541|  26.35027|  24.24758|  27.54529|  28.28355|  27.49023|  27.79338|  26.89061|  23.75375|  17.84871|
|  2006|  16.04677|  16.06178|  21.17508|  22.94076|  25.48534|  29.55628|  29.33054|  28.24310|  26.94258|  25.90313|  22.61389|  16.40418|
|  2007|  18.83685|  16.91475|  17.00986|  21.75644|  25.69099|  25.87279|  28.45980|  28.89645|  26.97324|  24.95500|  17.26128|  15.47260|
|  2008|  15.97326|  16.15138|  20.01693|  23.95789|  23.05724|  28.18780|  29.22718|  31.11135|  28.75101|  28.97401|  22.36273|  16.13598|
|  2009|  14.98030|  19.44455|  19.10415|  24.80945|  29.40921|  28.69481|  29.80610|  25.01722|  28.41232|  29.32503|  21.44991|  16.85128|
|  2010|  16.42588|  17.48684|  18.59558|  27.50452|  26.30356|  29.50013|  25.32466|  30.79987|  26.58879|  27.29094|  22.27007|  17.65097|

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
    ##  1  2001 16.98598   62.57476
    ##  2  2002       NA -999.00000
    ##  3  2003 15.94836   60.70704
    ##  4  2004 15.99893   60.79807
    ##  5  2005 14.90212   58.82381
    ##  6  2006 16.04677   60.88419
    ##  7  2007 18.83685   65.90633
    ##  8  2008 15.97326   60.75186
    ##  9  2009 14.98030   58.96454
    ## 10  2010 16.42588   61.56659

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
|  2001|  16.98598|    62.57476|
|  2002|        NA|  -999.00000|
|  2003|  15.94836|    60.70704|
|  2004|  15.99893|    60.79807|
|  2005|  14.90212|    58.82381|
|  2006|  16.04677|    60.88419|
|  2007|  18.83685|    65.90633|
|  2008|  15.97326|    60.75186|
|  2009|  14.98030|    58.96454|
|  2010|  16.42588|    61.56659|

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

    ##  [1] 23.36801 24.38746 24.21475 24.29241 23.41619 23.39195 22.34167
    ##  [8] 23.65890 23.94203 23.81182

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

    ##  [1] 16.98598       NA 15.94836 15.99893 14.90212 16.04677 18.83685
    ##  [8] 15.97326 14.98030 16.42588 13.16660 19.73703 17.22133 16.97850
    ## [15] 16.38289

``` r
# Or maybe we want to round every column to integers

for(i in 1:length(temp)){
  temp[i] <- round(temp[i])
}

temp
```

|  YEAR|  JAN|  FEB|  MAR|  APR|  MAY|  JUN|  JUL|  AUG|  SEP|  OCT|  NOV|  DEC|
|-----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|
|  2001|   17|   16|   20|   25|   29|   26|   29|   27|   26|   24|   23|   17|
|  2002|   NA|   20|   22|   24|   28|   28|   28|   24|   28|   25|   22|   18|
|  2003|   16|   15|   18|   23|   26|   32|   31|   31|   27|   31|   22|   18|
|  2004|   16|   22|   23|   22|   23|   27|   29|   31|   28|   28|   26|   16|
|  2005|   15|   15|   21|   26|   24|   28|   28|   27|   28|   27|   24|   18|
|  2006|   16|   16|   21|   23|   25|   30|   29|   28|   27|   26|   23|   16|
|  2007|   19|   17|   17|   22|   26|   26|   28|   29|   27|   25|   17|   15|
|  2008|   16|   16|   20|   24|   23|   28|   29|   31|   29|   29|   22|   16|
|  2009|   15|   19|   19|   25|   29|   29|   30|   25|   28|   29|   21|   17|
|  2010|   16|   17|   19|   28|   26|   30|   25|   31|   27|   27|   22|   18|

``` r
# Looping over names or indices rather than sequences.

# print the 5th row of just a few specific columns
months <- c("JAN", "MAY", "SEP")
for (i in months){
 print(mean(temp[,i]), na.rm=TRUE)
}
```

    ## [1] NA
    ## [1] 25.9
    ## [1] 27.5

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

    ## [1] 7

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
    ##  [1] 62.6   NA 60.8 60.8 59.0 60.8 66.2 60.8 59.0 60.8
    ## 
    ## $FEB
    ##  [1] 60.8 68.0 59.0 71.6 59.0 60.8 62.6 60.8 66.2 62.6
    ## 
    ## $MAR
    ##  [1] 68.0 71.6 64.4 73.4 69.8 69.8 62.6 68.0 66.2 66.2
    ## 
    ## $APR
    ##  [1] 77.0 75.2 73.4 71.6 78.8 73.4 71.6 75.2 77.0 82.4
    ## 
    ## $MAY
    ##  [1] 84.2 82.4 78.8 73.4 75.2 77.0 78.8 73.4 84.2 78.8
    ## 
    ## $JUN
    ##  [1] 78.8 82.4 89.6 80.6 82.4 86.0 78.8 82.4 84.2 86.0
    ## 
    ## $JUL
    ##  [1] 84.2 82.4 87.8 84.2 82.4 84.2 82.4 84.2 86.0 77.0
    ## 
    ## $AUG
    ##  [1] 80.6 75.2 87.8 87.8 80.6 82.4 84.2 87.8 77.0 87.8
    ## 
    ## $SEP
    ##  [1] 78.8 82.4 80.6 82.4 82.4 80.6 80.6 84.2 82.4 80.6
    ## 
    ## $OCT
    ##  [1] 75.2 77.0 87.8 82.4 80.6 78.8 77.0 84.2 84.2 80.6
    ## 
    ## $NOV
    ##  [1] 73.4 71.6 71.6 78.8 75.2 73.4 62.6 71.6 69.8 71.6
    ## 
    ## $DEC
    ##  [1] 62.6 64.4 64.4 60.8 64.4 60.8 59.0 60.8 62.6 64.4

``` r
# we can use bind_rows(), to bind this list to a dataframe
lapply(temp[,2:13], celsius_to_faren) %>% bind_rows()
```

|   JAN|   FEB|   MAR|   APR|   MAY|   JUN|   JUL|   AUG|   SEP|   OCT|   NOV|   DEC|
|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|  62.6|  60.8|  68.0|  77.0|  84.2|  78.8|  84.2|  80.6|  78.8|  75.2|  73.4|  62.6|
|    NA|  68.0|  71.6|  75.2|  82.4|  82.4|  82.4|  75.2|  82.4|  77.0|  71.6|  64.4|
|  60.8|  59.0|  64.4|  73.4|  78.8|  89.6|  87.8|  87.8|  80.6|  87.8|  71.6|  64.4|
|  60.8|  71.6|  73.4|  71.6|  73.4|  80.6|  84.2|  87.8|  82.4|  82.4|  78.8|  60.8|
|  59.0|  59.0|  69.8|  78.8|  75.2|  82.4|  82.4|  80.6|  82.4|  80.6|  75.2|  64.4|
|  60.8|  60.8|  69.8|  73.4|  77.0|  86.0|  84.2|  82.4|  80.6|  78.8|  73.4|  60.8|
|  66.2|  62.6|  62.6|  71.6|  78.8|  78.8|  82.4|  84.2|  80.6|  77.0|  62.6|  59.0|
|  60.8|  60.8|  68.0|  75.2|  73.4|  82.4|  84.2|  87.8|  84.2|  84.2|  71.6|  60.8|
|  59.0|  66.2|  66.2|  77.0|  84.2|  84.2|  86.0|  77.0|  82.4|  84.2|  69.8|  62.6|
|  60.8|  62.6|  66.2|  82.4|  78.8|  86.0|  77.0|  87.8|  80.6|  80.6|  71.6|  64.4|

You may also see, `sapply()` or `vapply()`, these do the same thing but return the output in different formats.

In a slightly different flavor, `apply()` takes the additional `MARGIN` argument, which allows you to specify, when x is a matrix or dataframe, wether you want a function to be run over just the rows, `1`, just the columns, `2`, or both, `c(1,2)`.

For example, maybe we want the mean temperature of each year:

``` r
apply(temp[2:13], 1, mean, na.rm=TRUE)  #drop Nas, and drop column 1 to leave out year. 
```

    ##  [1] 23.25000 24.27273 24.16667 24.25000 23.41667 23.33333 22.33333
    ##  [8] 23.58333 23.83333 23.83333

Or instead the average by month:

``` r
apply(temp[2:13], 2, mean, na.rm=TRUE)  #drop Nas, and drop column 1 to leave out year. 
```

    ##      JAN      FEB      MAR      APR      MAY      JUN      JUL      AUG 
    ## 16.22222 17.30000 20.00000 24.20000 25.90000 28.40000 28.60000 28.40000 
    ##      SEP      OCT      NOV      DEC 
    ## 27.50000 27.10000 22.20000 16.90000

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
    ##  [1] 62.6   NA 60.8 60.8 59.0 60.8 66.2 60.8 59.0 60.8
    ## 
    ## $FEB
    ##  [1] 60.8 68.0 59.0 71.6 59.0 60.8 62.6 60.8 66.2 62.6
    ## 
    ## $MAR
    ##  [1] 68.0 71.6 64.4 73.4 69.8 69.8 62.6 68.0 66.2 66.2
    ## 
    ## $APR
    ##  [1] 77.0 75.2 73.4 71.6 78.8 73.4 71.6 75.2 77.0 82.4
    ## 
    ## $MAY
    ##  [1] 84.2 82.4 78.8 73.4 75.2 77.0 78.8 73.4 84.2 78.8
    ## 
    ## $JUN
    ##  [1] 78.8 82.4 89.6 80.6 82.4 86.0 78.8 82.4 84.2 86.0
    ## 
    ## $JUL
    ##  [1] 84.2 82.4 87.8 84.2 82.4 84.2 82.4 84.2 86.0 77.0
    ## 
    ## $AUG
    ##  [1] 80.6 75.2 87.8 87.8 80.6 82.4 84.2 87.8 77.0 87.8
    ## 
    ## $SEP
    ##  [1] 78.8 82.4 80.6 82.4 82.4 80.6 80.6 84.2 82.4 80.6
    ## 
    ## $OCT
    ##  [1] 75.2 77.0 87.8 82.4 80.6 78.8 77.0 84.2 84.2 80.6
    ## 
    ## $NOV
    ##  [1] 73.4 71.6 71.6 78.8 75.2 73.4 62.6 71.6 69.8 71.6
    ## 
    ## $DEC
    ##  [1] 62.6 64.4 64.4 60.8 64.4 60.8 59.0 60.8 62.6 64.4

``` r
map(temp[,2:13], celsius_to_faren)
```

    ## $JAN
    ##  [1] 62.6   NA 60.8 60.8 59.0 60.8 66.2 60.8 59.0 60.8
    ## 
    ## $FEB
    ##  [1] 60.8 68.0 59.0 71.6 59.0 60.8 62.6 60.8 66.2 62.6
    ## 
    ## $MAR
    ##  [1] 68.0 71.6 64.4 73.4 69.8 69.8 62.6 68.0 66.2 66.2
    ## 
    ## $APR
    ##  [1] 77.0 75.2 73.4 71.6 78.8 73.4 71.6 75.2 77.0 82.4
    ## 
    ## $MAY
    ##  [1] 84.2 82.4 78.8 73.4 75.2 77.0 78.8 73.4 84.2 78.8
    ## 
    ## $JUN
    ##  [1] 78.8 82.4 89.6 80.6 82.4 86.0 78.8 82.4 84.2 86.0
    ## 
    ## $JUL
    ##  [1] 84.2 82.4 87.8 84.2 82.4 84.2 82.4 84.2 86.0 77.0
    ## 
    ## $AUG
    ##  [1] 80.6 75.2 87.8 87.8 80.6 82.4 84.2 87.8 77.0 87.8
    ## 
    ## $SEP
    ##  [1] 78.8 82.4 80.6 82.4 82.4 80.6 80.6 84.2 82.4 80.6
    ## 
    ## $OCT
    ##  [1] 75.2 77.0 87.8 82.4 80.6 78.8 77.0 84.2 84.2 80.6
    ## 
    ## $NOV
    ##  [1] 73.4 71.6 71.6 78.8 75.2 73.4 62.6 71.6 69.8 71.6
    ## 
    ## $DEC
    ##  [1] 62.6 64.4 64.4 60.8 64.4 60.8 59.0 60.8 62.6 64.4

``` r
map_df(temp[,2:13], celsius_to_faren)
```

|   JAN|   FEB|   MAR|   APR|   MAY|   JUN|   JUL|   AUG|   SEP|   OCT|   NOV|   DEC|
|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|  62.6|  60.8|  68.0|  77.0|  84.2|  78.8|  84.2|  80.6|  78.8|  75.2|  73.4|  62.6|
|    NA|  68.0|  71.6|  75.2|  82.4|  82.4|  82.4|  75.2|  82.4|  77.0|  71.6|  64.4|
|  60.8|  59.0|  64.4|  73.4|  78.8|  89.6|  87.8|  87.8|  80.6|  87.8|  71.6|  64.4|
|  60.8|  71.6|  73.4|  71.6|  73.4|  80.6|  84.2|  87.8|  82.4|  82.4|  78.8|  60.8|
|  59.0|  59.0|  69.8|  78.8|  75.2|  82.4|  82.4|  80.6|  82.4|  80.6|  75.2|  64.4|
|  60.8|  60.8|  69.8|  73.4|  77.0|  86.0|  84.2|  82.4|  80.6|  78.8|  73.4|  60.8|
|  66.2|  62.6|  62.6|  71.6|  78.8|  78.8|  82.4|  84.2|  80.6|  77.0|  62.6|  59.0|
|  60.8|  60.8|  68.0|  75.2|  73.4|  82.4|  84.2|  87.8|  84.2|  84.2|  71.6|  60.8|
|  59.0|  66.2|  66.2|  77.0|  84.2|  84.2|  86.0|  77.0|  82.4|  84.2|  69.8|  62.6|
|  60.8|  62.6|  66.2|  82.4|  78.8|  86.0|  77.0|  87.8|  80.6|  80.6|  71.6|  64.4|

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
|  62.6|  60.8|  68.0|  77.0|  84.2|  78.8|  84.2|  80.6|  78.8|  75.2|  73.4|  62.6|
|    NA|  68.0|  71.6|  75.2|  82.4|  82.4|  82.4|  75.2|  82.4|  77.0|  71.6|  64.4|
|  60.8|  59.0|  64.4|  73.4|  78.8|  89.6|  87.8|  87.8|  80.6|  87.8|  71.6|  64.4|
|  60.8|  71.6|  73.4|  71.6|  73.4|  80.6|  84.2|  87.8|  82.4|  82.4|  78.8|  60.8|
|  59.0|  59.0|  69.8|  78.8|  75.2|  82.4|  82.4|  80.6|  82.4|  80.6|  75.2|  64.4|
|  60.8|  60.8|  69.8|  73.4|  77.0|  86.0|  84.2|  82.4|  80.6|  78.8|  73.4|  60.8|
|  66.2|  62.6|  62.6|  71.6|  78.8|  78.8|  82.4|  84.2|  80.6|  77.0|  62.6|  59.0|
|  60.8|  60.8|  68.0|  75.2|  73.4|  82.4|  84.2|  87.8|  84.2|  84.2|  71.6|  60.8|
|  59.0|  66.2|  66.2|  77.0|  84.2|  84.2|  86.0|  77.0|  82.4|  84.2|  69.8|  62.6|
|  60.8|  62.6|  66.2|  82.4|  78.8|  86.0|  77.0|  87.8|  80.6|  80.6|  71.6|  64.4|

Makes `map_df` seem pretty handy right?!
