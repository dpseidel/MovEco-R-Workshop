---
layout: page
title: Day 1 Activities
use-site-title: true
---

In our first hands-on activity we are going to ask you to import, clean, and visualize a novel data set and finally to build a simple simulation to try to reproduce the patterns obvserved.

This activity and code was adapted from Module 2 of the Fall 2017 ESPM 157 Data Science for Global Change course taught at UC Berkeley by Carl Boettiger & Dana Seidel.

Task 1: Import Data
===================

In this activity, we will explore population dynamics of multiple interacting species using an example of a classic data set that played a fundamental role in our early understanding of population dynamics and the mathematical field of dynamical systems more generally. This example comes from records of the Hudson Bay fur trapping company on the prevelance of Canadian Lynx and Snowshoe Hare populations.

The data for this activity is found [here](https://raw.githubusercontent.com/bblais/Systems-Modeling-Spring-2015-Notebooks/master/data/Lynx%20and%20Hare%20Data/lynxhare.csv). Using the proper `readr` command, read in this dataset, preserving only the columns "year", "hare",. and "lynx".

Explore your newly imported data using the `summary` command and evaluate its first lines using the `head` command. Be sure that the data looks clean and properly formatted and then answer the following questions.

#### Some Questions:

-   What years does this dataset cover?
-   Does our dataset contain missing values?

Task 2: Clean & manipulate the data
===================================

Let's try cleaning up this dataset a bit.

Filter only the years that have data for both hare and lynx.

The scales of the populations are very different - a log scale may make these easier to compare. Mutate two new columns and take the log of the original hare and lynx columns.

Task 3: Visualize
=================

Now, plot your new columns using `ggplot2`. Hint: the `select` and `gather` commands make multi-series plotting easier.

Task 4: A Simulation Teaser
===========================

A combination of the ideas introduced today form the basis of all simulations. Although we will go into simulation construction in much more depth later in the workshop, just to see how all these parts fit together, let's now try your hand at a very basic simulation of lynx and hare populations,

Step 1: Defining the model
--------------------------

Let's say we want to simulate the growth of the classic lynx and hare populations through time. First, we need to construct our underlying growth equations using custom R functions:

For our simple purposes we'll ignore elements like search time and carrying capacity and define prey (H) and predator (P) growth as follows:

*f*(*H*, *P*)=*a* − *b**P*

*g*(*H*, *P*)=*c**H* − *d*

### Task 4.1: translate into custom R functions named `prey` and `pred`:

Step 2: Initialize
------------------

Before we can simulate our populations through time we have to establish some starting values for our parameters: a,b,c,d, H0 (initial prey population), and P0 (intial predator population).

Use the following parameters to get started:

    a = 0.01
    b = 0.01
    c = 0.01
    d = 0.01

use initial value *H*<sub>0</sub> = 1.1 and *P*<sub>0</sub> = 1.1 and a max time of 500 iterations to get started.

### Task 4.2: Try putting your intial values into a named list to make it easy to keep track of them:

Step 3: Simulate
----------------

Now to simulate population levels through time, we need to loop over equations that take the value of a given population at time t and add it to the change in the population over a given time step, e.g.:

*H*<sub>*t* + 1</sub> = *H*<sub>*t*</sub> + *H*<sub>*t*</sub>*f*(*H*, *P*)

*P*<sub>*t* + 1</sub> = *P*<sub>*t*</sub> + *P*<sub>*t*</sub>*g*(*H*, *P*)

A basic simulation is just a complex custom function containing 3 steps. Below I've included some starter code to help you better understand the 3 required steps:

1.  initialize: initialize your vectors so that the for loop knows where to start and has place to store output.

<!-- -->

    # something like: 
      H <- numeric(t)  # makes a blank vector of length t
      P <- numeric(t)
      H[1] <- H0  # places our initial population values
      P[1] <- P0

1.  iterate: run your loop!

<!-- -->

    # we're looking for a loop like this
     for(i in 1:(t-1)){
          H[i+1] <- (1 + prey(H[i], P[i], pars)) * H[i] # note this is just the r code for the population equations above
          P[i+1] <- (1 + pred(H[i], P[i], pars)) * P[i] # see how I included our custom growth equation from step 1?
      }

1.  output: return your results!

<!-- -->

    # we will want a dataframe with our simulated H and P values, and an id for each iteration or timestep
    data.frame(time = 1:t, hare = H, lynx = P)

Just like our custom functions from step 1, this simulation needs to take several arguments namely:

-   the number of iterations we want to run for
-   all necessary parameters and initial values for our models
-   our predator growth function
-   our prey growth function

### Task 4.3: Try putting together your simulation in a custom function

Try taking the above arguments and looping over the discrete equations listed above. Your simulation function should include each of the 3 steps: initialize, iterate, and output.

### Task 4.4: Visualize your simulated data

Create a plot showing your simulated population sizes of hare (x) and lynx (y) over time.

Use `geom_path` to create a phase plane diagram i.e, a plot of hare size vs linx size with various starting conditions.

### Task 4.5: Adapt your simulation

Try playing with your intial values or adapting your inital equations to include carrying capacity or search time for more biologically realistic results.

Now that you have the basic structure of your simulation down, try playing with it to learn about the senstivity and role of each of your parameters. Some ideas:

1.  Increase the time interval to 1000, 3000, 9000. Plot. What happens?
2.  Vary the starting conditions. Plot. What do you see?
3.  Re-define the function for hare population, `f(x,y)`, to reflect limits on growth due to a carrying capacity:
    *f*(*x*, *y*)=*a*(1 − *H*/*K*)−*b**P*
     Adapt and rerun your simulation. For starters, use `K = 10` and the same initial conditions as before (`H0 = 1.1`, `P0 = 1.1`). Plot the results. How have things changed? Can you obtain stable long-term behavior? What behavior do you see? Can you obtain stable long-term cycles? If so, how? If not, then why do you think that is?
4.  Introduce a saturating function into your functions for hare and lynx populations to reflect the search and handling time that limit the number of prey lynx can take in a given time step. Including this "saturating" function
    $$h(H) = \\frac{1}{1 + s \\cdot H}$$
    , your equations for prey and predator become:
    *f*(*H*, *P*)=*a*(1 − *H*/*K*)−*b* ⋅ *P* ⋅ *h*(*H*)
    *g*(*H*, *P*)=*c* ⋅ *H* ⋅ *h*(*H*)−*d*

Note that *h*(*x*) is called a *functional response*, or handling time. Write this out as a new custom r fucntion. Adapt and rerun your simulation. For starters, use `s = 1/5`. Plot the results. How have things changed? Can you obtain stable long-term behavior? What behavior do you see? Can you obtain stable long-term cycles now?

That's it for today - much more practice with data and simulations in the coming days!
