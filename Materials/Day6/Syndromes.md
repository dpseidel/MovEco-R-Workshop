Day 6 - Clustering Movement Syndromes
================


Today we will explore code used in Abrahms et al. 2017 for 5 secondary metrics on movement paths. Although we will spend most of our time exploring the individual metrics and what they tell us about different trajectorties, at the end of this section we will briefly touch on the final steps of the paper which used the results from these metrics together to cluster movement "syndromes" across species.

Metrics
=======

1.  Mean turn angle correlation (TAC). Following Dray et al. (2010), Abrahms et al. 2017 calculated angular autocorrelation as the sum of squares of chord distances between successive turn angles.

2.  Mean residence time (RT). Residence time was measured as the number of hours the animal spends inside a circle of a given radius centered on each location without leaving the radius for more than a specified cut-off time. Abrahms et al. 2017 used a radius of mean step length (SL) and a 12-h cut-off time.

3.  Mean time-to-return (T2R). Time-to-return was measured as the number of hours the animal spends beyond a specified cut-off time before its return to a circle of a given radius centered on each location. Abrahms et al. 2017 again used a radius of mean SL and a 12-h cut-off time.

4.  Mean volume of intersection (VI). Volume of intersection was measured by the overlap between monthly 95% kernel density home ranges. Volume of intersection varies between 0 and 1, with increasing values corresponding to increasing overlap between monthly home ranges. VI is thus a measure of home range stability.

5.  Maximum net squared displacement (MNSD). Maximum net squared displacement was calculated as the maximum squared Euclidean displacement from the first relocation of the trajectory over the full course of the trajectory. To make comparisons among individuals across species that have orders of magnitude different motion capacities, Abrahms et al. 2017 scaled this parameter for each individual by dividing by the smallest MNSD observed for its species.

``` r
#' Calculation of Animal Movement Statistics #######
#' From: Abrahms et al. 2017, Movement Ecology #####
#' DOI: 10.1186/s40462-017-0104-2 ##################

#' Calculate 5 metrics:
#' 1. Turn angle correlation (TAC)
#' 2. Mean Residence Time (RT)
#' 3. Mean Time to Return (T2R)
#' 4. Mean Volume of Intersection (VI)
#' 5. Max Net Squared Displacement (MNSD)

################################ SETUP ###############################

# load libraries
library(adehabitatLT)
library(adehabitatHR)
library(lubridate)
library(tidyverse)
library(sf)

# load dataframe
argos_data <- read_csv("Abrahms-argos.csv")
ids <- unique(argos_data$`individual-local-identifier`)
ids
```

    ##  [1] "sea lion 1"   "sea lion 2"   "sea lion 3"   "sea lion 4"  
    ##  [5] "sea lion 5"   "sea lion 6"   "sea lion 7"   "sea lion 8"  
    ##  [9] "sea lion 9"   "sea lion 10"  "sea lion 11"  "sea lion 12" 
    ## [13] "sea lion 13"  "sea lion 14"  "sea lion 15"  "seal 2004001"
    ## [17] "seal 2004003" "seal 2004004" "seal 2004005" "seal 2004006"
    ## [21] "seal 2004017" "seal 2004018" "seal 2004021" "seal 2004022"
    ## [25] "seal 2004025" "seal 2004028" "seal 2004029" "seal 2004030"
    ## [29] "seal 2004032" "seal 2004035"

``` r
names(argos_data)
```

    ##  [1] "event-id"                        "visible"                        
    ##  [3] "timestamp"                       "location-long"                  
    ##  [5] "location-lat"                    "modelled"                       
    ##  [7] "sensor-type"                     "individual-taxon-canonical-name"
    ##  [9] "tag-local-identifier"            "individual-local-identifier"    
    ## [11] "study-name"

``` r
argos_data %>% 
  select(long = `location-long`,
         lat = `location-lat`,
         timestamp,
         id = `individual-local-identifier`) %>% 
  filter(id %in% c("sea lion 1", 
                   "sea lion 8", 
                   "sea lion 9", 
                   "seal 2004001", 
                   "seal 2004028")) %>%
  st_as_sf(coords = 1:2, crs = "+proj=longlat") %>%
  st_transform("+proj=aea") -> Data



# Convert dataframe to ltraj object
ltraj <- as.ltraj(xy = st_coordinates(Data), 
                  date = pull(Data, timestamp), 
                  id = pull(Data, id))

# regularize traj
for(i in 1:5){print(median(ltraj[[i]]$dt, na.rm = TRUE))}
```

    ## [1] 3602
    ## [1] 3603
    ## [1] 3603
    ## [1] 3600
    ## [1] 3600

``` r
# all should be 1 hour interval

for(i in 1:5){
  ref <- round(ltraj[[i]]$date[1], "hours")
  ltraj[i] %>% 
    setNA(ltraj = ., date.ref = ref, dt = 1, units = "hour") %>%
    sett0(ltraj = ., date.ref = ref, dt = 1, units = "hour") -> ltraj[i]
}

# for todays example, let's just drop sealion 8 .. too many NAs
ltraj <- ltraj[c(1,3:5)]
```

``` r
############################## CALCULATE METRICS ############################

#################################
# 1. Turn angle correlation (TAC) 
#################################

# for-loop for calculating TAC for multiple individuals
# NB: a) all trajectories in the ltraj object must be 'regular'

TAC <- matrix(ncol=1, nrow=length(ltraj)) # create empty data frame to populate with for-loop

for (i in 1:length(ltraj)){
  SA <- adehabitatLT::acfang.ltraj(ltraj[i], which = "relative", plot = FALSE) 
  TAC[i,] <- 1/(SA[[1]][1,])
}

TAC
```

    ##              [,1]
    ## [1,]    0.8549279
    ## [2,]    1.4437594
    ## [3,]   83.7544610
    ## [4,] 1120.2254685

``` r
######################################################
# 2-3. Residence Times (RT) and Times to Return (T2R)
######################################################

#' Residence time = the number of hours the animal spends inside a circle of a given radius 
#' centered on each location without leaving the radius for more than a specified cut-off time
#' Time-to-return = the number of hours the animal spends beyond a specified cut-off time 
#' before its return to a circle of a given radius centered on each location
#' *Adapted from van Moorter et al. 2015, Journal of Animal Ecology

# define Residence Times and Times to Return functions
RTandT2R <- function(x, radius, maxt, units="hour", addinfo = F){
  fR <- function(x, dframe, radius, maxt, units=units){
    tmp <- dframe[c(x:nrow(dframe)),]
    dists <- sqrt((tmp$x - tmp$x[1])^2 + (tmp$y - tmp$y[1])^2)
    dists <- as.numeric(dists<=radius)
    ext <- which(dists[-length(dists)] > dists[-1])+1
    entr <-  which(dists[-length(dists)] < dists[-1])+1
    bts <- difftime(tmp$date[entr], tmp$date[ext[c(1:length(entr))]], units=units)    
    tmp1 <- as.numeric(difftime(tmp$date[ext[(as.numeric(bts)>maxt)][1]], tmp$date[1], units=units)) #first exit
    if (is.na(tmp1) & length(ext)>0) tmp1 <- as.numeric(difftime(tmp$date[ext[length(ext)]], tmp$date[1], units=units))  
    tmp2 <- as.numeric(difftime(tmp$date[entr[(as.numeric(bts)>maxt)][1]], tmp$date[1], units=units)) #first re-entry
    return(c(tmp1, tmp2))
  } 
  res <- data.frame(do.call(rbind, lapply(c(1:nrow(x)), fR, dframe=x, radius=radius, maxt=maxt, units=units)))
  names(res) <- c(paste("RT", radius, maxt, sep="_"), paste("T2R", radius, maxt, sep="_"))
  
  if (!addinfo) return(res)
  if (addinfo) {
    attributes(x)$infolocs <- cbind(attributes(x)$infolocs, res)
    return(x) 
  }
}

# create for-loop for calculating RT and T2R for multiple individuals
lres <- list()
for (j in 1:length(ltraj)){
  res <- ltraj[[j]][,c("x","y","date")]
  meanDist<- mean(ltraj[[j]][1:nrow(ltraj[[j]])-1,"dist"], na.rm=T)
  rads <- c(meanDist) 
  maxts <- c(12) 
  params <- expand.grid(rads=rads, maxts=maxts)
  for (i in 1:nrow(params)){
    nams <- names(res)
    tmp <- RTandT2R(ltraj[[j]], radius = params$rads[i], maxt=params$maxts[i], units="hour", addinfo = F)
    res <- cbind(res, tmp)
    names(res) <- c(nams, paste("RT", params$rads[i], params$maxts[i], sep="_"), paste("T2R", params$rads[i], params$maxts[i], sep="_"))
  }
  lres[[j]] <- res
}

# Produce a mean statistic for each individual
meanRTs <- sapply(lapply(lres, "[[", 4), function(x) mean(x, na.rm=T))
meanRTs
```

    ## [1] 9.316667 4.882716 2.513136 3.010707

``` r
meanT2Rs <- sapply(lapply(lres, "[[", 5), function(x) mean(x, na.rm=T))
meanT2Rs
```

    ## [1] 102.9664 131.9329 352.5769 323.8897

``` r
#####################################
# 4. Mean Volume of Intersection (VI)
#####################################

# For-loop to calculate overlap within an individual's 95% home range by month for multiple individuals

VI_monthly<-matrix(ncol=1, nrow=length(ltraj)) # create an empty matrix to populate with a for-loop

for (i in 1:length(ltraj)){
  ltraj[[i]] <- ltraj[[i]][complete.cases(ltraj[[i]][,c("x","y")]),] # remove NAs from coordinates
  ltraj[[i]]$month <- month(ltraj[[i]]$date)
  kudoverlap_monthly <- adehabitatHR::kerneloverlap(SpatialPointsDataFrame(ltraj[[i]][,c("x","y")], 
                                                    data=data.frame(id=ltraj[[i]]$month)), 
                                                    grid=200, method="VI")
  mw <- matrix(nr = nrow(kudoverlap_monthly), nc = nrow(kudoverlap_monthly))
  mw<-(row(mw) == col(mw) - 1) + 0 
  monthval<-kudoverlap_monthly * mw
  avg_kudoverlap_monthly<-sum(monthval)/(nrow(monthval)-1) # average month-to-month volume of intersection 
  VI_monthly[i,]<-c(avg_kudoverlap_monthly) 
}

VI_monthly<-data.frame(VI_monthly)
VI_monthly
```

    ##   VI_monthly
    ## 1  0.5184994
    ## 2  0.8385496
    ## 3  0.1869980
    ## 4  0.1433966

``` r
############################################
# 5. Maximum Net Squared Displacement (MNSD)
############################################

# use for-loop to calculate MNSD for multiple individuals
df_ltraj<-ld(ltraj) # convert ltraj object back to data frame
id<-levels(df_ltraj$id)
maxNSD<-matrix(ncol=1, nrow=length(id)) # create empty data frame to populate with for-loop

for (i in 1:length(id)){
  NSD <- data.frame(maxNSD = df_ltraj$R2n[which(df_ltraj$id==id[i])]) # net squared displacements
  maxNSD[i,] <- sapply(NSD, function(x) max(NSD$maxNSD, na.rm=TRUE)) # calculate max NSD
}

maxNSD
```

    ##              [,1]
    ## [1,] 3.649022e+09
    ## [2,] 4.760534e+09
    ## [3,] 2.745718e+12
    ## [4,] 1.142633e+13

Post-Processing
===============

Although today we have focused on the metrics themselves and what they individually can tell us about movement trajectories, if we would like to explore the syndromic behaviors overall we might consider the final steps of Abrahms et al. 2017: a principle components and cluster analysis

See [supplementary data file 2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5452391/bin/40462_2017_104_MOESM2_ESM.r) from Abrahms et al. 2017 for code for simulated movement archetypes, necessary for interpretting and assigning movement syndromes.

Principle Component Analysis
----------------------------

> To elucidate any underlying structure in our dataset, we performed a principal components analysis (PCA) for the above metrics calculated from our empirical datasets using the prcomp function in the R stats library \[29\]. PCA is a widely used technique for summarizing a multivariate dataset into a reduced number of uncorrelated dimensions, or principal components, while minimizing the loss of information in the original dataset \[48\]. We used the Broken-stick criterion to retain important composite (PC) axes, in which components are retained if their eigenvalues exceed those expected by random data \[43\]. Comparative analyses of component retention methods have shown the Broken-stick model to be among the most reliable techniques \[48, 49\]. To normalize the dataset for this analysis we first log-transformed the data, followed by centering around the mean and dividing by the variance \[50\].

Example R commands:

    pca <- prcomp(data,
                     center = TRUE,
                     scale = TRUE) 
    #explore via print() and plot()

Clustering
----------

> Finally, we applied Ward’s agglomerative hierarchical clustering algorithm to the resulting PCA values \[51\] using the hclust function in the R stats library \[29\]. This approach clusters the most similar pair of points based on their squared Euclidean distance at each stage of the algorithm, and is an efficient method to identify clusters based on minimum within-cluster variance without making an a priori determination of the number of clusters to generate \[52\]. These clusters can be viewed as functional movement groups, analogous to functional types first theorized for plant communities, which provide a non-phylogenetic classification based on shared responses to environmental conditions \[53\]. To determine the significance of the resulting cluster arrangement, we calculated p-values for each cluster via multi-scale bootstrap resampling with 1000 bootstrap replications using the R package Pvclust \[54, 55\]. By simulating the following idealized movers and determining their cluster assignments, we were able to identify these clusters by movement syndrome.

Example R commands:

    hclust(pca, method="ward.D")

References
==========

Abrahms B, Seidel DP, Dougherty E, Hazen EL, Bograd SJ, Wilson AM, McNutt JW, Costa DP, Blake S, Brashares JS, Getz WM (2017) Suite of simple metrics reveals common movement syndromes across vertebrate taxa. Movement Ecology 5:12. <doi:10.1186/s40462-017-0104-2>

Abrahms B (2017) Data from: Suite of simple metrics reveals common movement syndromes across vertebrate taxa. Movebank Data Repository. <doi:10.5441/001/1.hm5nk220>
