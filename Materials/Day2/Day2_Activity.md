Day 2 Activity
================

1.  Find and load unique movement data. This can be some of your own, or some pulled from movebank, any other online source, or example data pulled from R packages.

2.  Build a regular ltraj object and plot distributions of turning angles and step lengths for each individual in your dataset

3.  Find an appropriate raster from an online data source. Below are a few options to help you get started, alternatively just search "global gis data" or similar:

-   <https://earthexplorer.usgs.gov/>
-   <https://www.movebank.org/node/7471>
-   <https://earthworks.stanford.edu/>
-   <http://gisgeography.com/best-free-gis-data-sources-raster-vector/>

4.  Load and project raster into R. Remember you may need to crop, or transform your raster to match your vector data.

5.  Extract, intersect, or spatially join your raster values to your movement data points and form a clean data.frame.

6.  Using dpylr verbs, filter those points based upon some interesting limits of your extracted values. For instance, if your raster is elevation, filter points above or below, or between certain elevation levels.

7.  Visualize the movement points with a custom map using ggplot with geom\_sf or mapview
