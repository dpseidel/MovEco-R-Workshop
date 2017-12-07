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

    ##  [1]  308.5782 1997.7912  721.9664  644.1900 1495.5826  601.5609 1980.4834
    ##  [8] 1097.3696  292.4010  697.0004

Now you'll notice that this returns fractional values, if you want whole numbers, the `sample` function can handle this:

``` r
sample(0:2000, 10, replace=T)
```

    ##  [1] 1493 1439   86 1775 1237 1564  876 1790 1442  522

``` r
# this is the same as 
sample.int(2000, 10)
```

    ##  [1]  784 1198  123  706  760 1593  101 1453 1903 1947

**Keep in mind, `sample` is an especially powerful function because you can use it to randomly sample any empirical dataset you have.**

Often when we are simulating a process, we want to pull our numbers not from a uniform distribition but instead from a distribution that matches the process we are trying to siumulate. For example, if we wanted to simulate coin flips, all we have to do is generate "flips" from the Bernoulli distribution (otherwise known as a Binomial distribution with size = 1 and p = .5).

Let's flip this (even) coin 20 times:

``` r
rbinom(20, 1, .5)
```

    ##  [1] 0 0 1 1 0 0 0 1 1 0 0 1 1 0 1 0 0 0 0 0

Or perhaps we need to pull 10 samples from a process that by the law of large numbers, probably has a normal distribution with a mean of 50 and a sd of 12, with the `rnorm` function that's simple!

``` r
rnorm(10, 50, 12)
```

    ##  [1] 70.19385 34.03369 38.33878 64.65660 52.87328 42.96657 41.90171
    ##  [8] 46.53470 52.17158 53.40053

``` r
# want those to be intergers?
round(rnorm(10,50,12))
```

    ##  [1] 54 47 50 48 50 37 28 68 56 54

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
|  2001|  14.84660|  16.88711|  18.55798|  23.27374|  27.59450|  26.54286|  32.43845|  31.27726|  24.09979|  26.91385|  20.60480|  18.21024|
|  2002|  17.44123|  16.57492|  17.84345|  24.46722|  26.40836|  24.89514|  27.35391|  32.71892|  25.18962|  26.03140|  26.36635|  14.70560|
|  2003|  15.17742|  18.69836|  19.58965|  26.22134|  24.86826|  27.14172|  29.56830|  29.90131|  25.75465|  29.20215|  22.06015|  17.51356|
|  2004|  12.08496|  17.51968|  16.28341|  25.36499|  28.79505|  29.34478|  28.70523|  32.33470|  25.35711|  23.84697|  20.32338|  17.35990|
|  2005|  15.99418|  15.07345|  21.35153|  25.35129|  27.59585|  26.53395|  31.07954|  29.10185|  26.89694|  26.74828|  23.70932|  15.95888|
|  2006|  13.36767|  16.86028|  17.82342|  26.29173|  25.83099|  27.38953|  28.52723|  30.81119|  25.46940|  27.23214|  21.99162|  14.48517|
|  2007|  18.57349|  17.18884|  21.86173|  24.15913|  26.95898|  29.75618|  28.54650|  29.23814|  24.05854|  27.43791|  22.05300|  17.52372|
|  2008|  15.99258|  15.25088|  18.82789|  23.24385|  23.34731|  29.56732|  26.61242|  27.80091|  27.94538|  25.18649|  21.48878|  19.98983|
|  2009|  14.97639|  16.75579|  17.47944|  17.65333|  25.69261|  32.61584|  28.02073|  30.33270|  27.72738|  24.59126|  21.61495|  15.62952|
|  2010|  16.64222|  18.57798|  18.02384|  24.45729|  25.27836|  27.01510|  28.91910|  30.22011|  27.21243|  25.73336|  17.12818|  19.07317|

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
    ##  1  2001 14.84660   58.72388
    ##  2  2002       NA -999.00000
    ##  3  2003 15.17742   59.31936
    ##  4  2004 12.08496   53.75293
    ##  5  2005 15.99418   60.78952
    ##  6  2006 13.36767   56.06181
    ##  7  2007 18.57349   65.43229
    ##  8  2008 15.99258   60.78664
    ##  9  2009 14.97639   58.95750
    ## 10  2010 16.64222   61.95600

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
|  2001|  14.84660|    58.72388|
|  2002|        NA|  -999.00000|
|  2003|  15.17742|    59.31936|
|  2004|  12.08496|    53.75293|
|  2005|  15.99418|    60.78952|
|  2006|  13.36767|    56.06181|
|  2007|  18.57349|    65.43229|
|  2008|  15.99258|    60.78664|
|  2009|  14.97639|    58.95750|
|  2010|  16.64222|    61.95600|

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
for(i in 1:10){         
  averages[i] <- mean(as.numeric(temp[i,]))       # take the mean of row i of temp dataframe and put it the averages vector
}

# Now we can read out results
averages
```

    ##  [1] 175.5575       NA 176.0536 175.4862 176.1842 175.5446 176.4889
    ##  [8] 175.6349 175.5454 176.0216

Once you understand the basic for loop it's useful to consider some important variations, namely:

1.  Modifying an existing object, instead of creating a new object.
2.  Looping over names or values, instead of indices.
3.  Handling sequences of unknown length ("while" loops, covered in the next section)

Consider the following loops and their outputs for examples of these variations, for more information see the readings. Note the consitent syntax of these loops.

``` r
# Modifying an existing object
```

``` r
# Looping over names or indices rather than sequences.

# print the 5th row of just a few specific columns
months <- c("JAN", "MAY", "SEP")
for (i in months){
  print(temp[,i])
}
```

    ##  [1] 14.84660       NA 15.17742 12.08496 15.99418 13.36767 18.57349
    ##  [8] 15.99258 14.97639 16.64222
    ##  [1] 27.59450 26.40836 24.86826 28.79505 27.59585 25.83099 26.95898
    ##  [8] 23.34731 25.69261 25.27836
    ##  [1] 24.09979 25.18962 25.75465 25.35711 26.89694 25.46940 24.05854
    ##  [8] 27.94538 27.72738 27.21243

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

    ## [1] 12

The `apply` and `map` functions
-------------------------------

This same pattern of looping over a vector, in other words, implementing some computation or function over many elements is so common both baseR and tidyverse have families of functions to do it for you: the apply family of functions (baseR) or the map family of functions from the purrr library in (baseR)

These functions make iteration much simpler and your code a lot more concise and readable but may take some time to wrap your head around. We introduce them here just for you to be aware of but if you're just starting out, you may find that for loops are easier for you to understand. That's okay! Loops work just as well, they just take more time and text to code.

### Apply: Base R

`lapply()` takes arguments `x`, and `FUN` as inputs. `x` is equivalent to the vector you would iterate over in a for loop and `FUN` is equivalent to whatever you would put into the body of the for loop. `lapply` always returns a list.

You may also see, `sapply()` or `vapply()`, these do the same thing but return the output in different formats.

In a slightly different flavor, `apply()` takes the additional `MARGIN` argument, which allows you to specify, when x is a matrix or dataframe, wether you want a function to be run over just the rows, `1`, just the columns, `2`, or both, `c(1,2)`.

### Map: tidyverse and the purrr package

The `purrr` package provides a similar family of functions to do this same iterative computation with the added clarity of providing one funtion each type of output and the benefit of playing nicely with all the other tidyverse functions we introduced earlier e.g. `group_by` & the pipe operator `%>%`.

Just as before, each function takes a vector as input, applies a function to each piece, and then returns a new vector that’s the same length (and has the same names) as the input. The type of the vector is determined by the suffix to the map function.

map() makes a list. (equivalent to `lapply`) map\_df() makes a dataframe. map\_lgl() makes a logical vector. map\_int() makes an integer vector. map\_dbl() makes a double vector. map\_chr() makes a character vector.
