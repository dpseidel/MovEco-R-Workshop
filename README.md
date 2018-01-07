# MovEco-R-Workshop
Materials for the Movement Ecology &amp; R Workshop. Hong Kong University Jan 3-12, 2018

**Note: during the workshop, the materials in this repository are likely to be updated 
daily. Once the workshop is complete and the materials finalized, we will publish 
a webpage for easier navigation and dissemination of the polished materials**

**If you want to download individual files during the workshop, We suggest you adapt and use the following code structure from R:**
`download.file("rawgithub_hyperlink", "destination_file_name")`

OR

use [DownGit](https://minhaskamal.github.io/DownGit/#/home) to download a specific folder or file

# Files
- The workshop schedule is found in the [Schedule.pdf](https://github.com/dpseidel/MovEco-R-Workshop/blob/master/Schedule.pdf), produced by the `Schedule.Rmd`, both found in the main directory. 
- All files, including slides, live coding scripts, and activities are found sorted into directories according to workshop day in the `Materials/` directory.

# Instructions before the workshop
Please make sure you have installed:

- [R (version 3.3.0 or higher)](https://www.r-project.org/)
- [Rstudio](https://www.rstudio.com/products/rstudio/download/#download) 
- The following packages:
    - tidyverse
    - lubridate
    - sf
    - ggplot2 (*developer's version)
    - mapview 
    - tlocoh **
    - adehabitatLT
    - adehabitatHR
    - move
    - raster
    - lme4
    - glmer
  
## Installation Instructions:
Inside the Rstudio console, you can install packages using the function `install.packages()`.

You can install packages one at a time using their name in quotes: `install.packages("raster")`

OR you can install multiple at one time using the `c()` function to combine all your names into one character vector:` install.packages(c("raster", "tidyverse", "sf"))`. 

**Keep an eye out for errors that may mean one or multiple packages are failing to load.**

*For the developer's versions, you will need to use the `devtools` package to download the most up to date versions from github.
This is very similar to the base `install.packages()` function except we have to give it more specific path names e.g.:
- `devtools::install_github("tidyverse/ggplot2")`

** The tlocoh package is found on R-forge so the installation function must be adapted to the following: `install.packages("tlocoh", dependencies=T, repos=c("http://R-Forge.R-project.org"))`

# Additional R Resources: A (woefully incomplete) list 
For those interested in further tutorials or resources for spatial data analysis and R more generally, please refer to:
- The [R for DataScience](http://r4ds.had.co.nz/) book
- [Rstudio Cheatsheets!](https://www.rstudio.com/resources/cheatsheets/) 
- Jamie Afflerbach's Spatial Analysis in R tutorials and [repo](https://github.com/jafflerbach/spatial-analysis-R)
- the upcoming textbook [Geocomputation with R](http://robinlovelace.net/geocompr/)
- the [vignettes](https://cran.r-project.org/web/packages/sf/) of the `sf` package
- the vignettes of the [adehabitatLT](https://cran.r-project.org/web/packages/adehabitatLT/) & [adehabitatHR](https://cran.r-project.org/web/packages/sf/) packages
- the [r-spatial blog & website](http://r-spatial.org/) for the latest news from the r-spatial community
- the [Tidyverse website/blog](https://www.tidyverse.org/articles/) for the latest news from the tidyverse

# Acknowledgements
Much of this code is adapted from other resources produced by the [#Rstats](https://twitter.com/search?q=%23rstats&src=typd) community at large. We make an effort to cite these resources throughout our materials where appropriate but would like to specifically acknowledge the contributions of Andy Lyons, Brianna Abrahms, Clement Calenge, Hadley Wickham, Garrett Grolemund, Carl Boettiger, and Jamie Afflerbach that have influenced this workshop. 

