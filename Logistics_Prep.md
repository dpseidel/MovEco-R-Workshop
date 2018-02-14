---
layout: page
title: Instructions before the workshop
use-site-title: true
---

Please make sure you have installed:

-   [R (version 3.3.0 or higher)](https://www.r-project.org/)
-   [Rstudio](https://www.rstudio.com/products/rstudio/download/#download)
-   The following packages:
    -   tidyverse
    -   lubridate
    -   sf
    -   ggplot2 (\*developer's version)
    -   mapview
    -   tlocoh \*\*
    -   adehabitatLT
    -   adehabitatHR
    -   move
    -   raster
    -   lme4
    -   glmer

### Installation Instructions:

Inside the Rstudio console, you can install packages using the function `install.packages()`.

You can install packages one at a time using their name in quotes: `install.packages("raster")`

OR

you can install multiple at one time using the `c()` function to combine all your names into one character vector:`install.packages(c("raster", "tidyverse", "sf"))`.

**Keep an eye out for errors that may mean one or multiple packages are failing to load.**

-   For the developer's versions, you will need to use the `devtools` package to download the most up to date versions from github. This is very similar to the base `install.packages()` function except we have to give it more specific path names e.g.:
-   `devtools::install_github("tidyverse/ggplot2")`

\*\* The tlocoh package is found on R-forge so the installation function must be adapted to the following: `install.packages("tlocoh", dependencies=T, repos=c("http://R-Forge.R-project.org"))`

Downloading Individual Files from github
----------------------------------------

If you want to download individual files during the workshop, We suggest you adapt and use the following code structure from R:

`download.file("rawgithub_hyperlink", "destination_file_name")`

OR

consider using [DownGit](https://minhaskamal.github.io/DownGit/#/home) to download a specific folder or file.
