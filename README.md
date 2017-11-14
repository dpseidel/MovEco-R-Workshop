# MovEco-R-Workshop
Scripts and Code for the Movement Ecology &amp; R Workshop. Hong Kong University Jan 3-12, 2018

# Instructions before the workshop
Please make sure you have installed:

- R
- Rstudio
- The following packages:
    - devtools
    - tidyverse
    - sf
    - sp
    - ggplot2 (developer's version)
    - mapview (developer's version)
    - rgeos
    - adehabitat
    - adehabitatLT
    - adehabitatHR
    - move
    - raster

### Installation Instructions:
Inside the Rstudio console, you can install packages using the function `install.packages()`.

You can install packages one at a time using their name in quotes: `install.packages("raster")`

OR you can install multiple at one time using the `c()` function to combine all your names into one character vector:` install.packages(c("raster", "tidyverse", "sf"))`. 

Keep an eye out for errors that may mean one or multiple packages are failing to load. 

For the developer's versions, you will need to use the devtools package to download the most up to date versions from github.
This is very similar to the base `install.packages()` function except we have to give it more specific path names e.g.:
- ` devtools::install_github("tidyverse/ggplot2")`
- ` devtools::install_github("r-spatial/mapview")`

# Files
- The proposed schedule is found in the [Suggested_Schedule.md](https://github.com/dpseidel/MovEco-R-Workshop/blob/master/Suggested_Schedule.md), produced by the `Suggested_Schedule.Rmd`, both found in the main directory. 
- All files, including slides, live coding scripts, and activities are found sorted into directories according to workshop day in the `materials/` directory.

