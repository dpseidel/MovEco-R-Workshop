library(raster)
library(sf)
library(tidyverse)
library(sp)
library(rgdal)
library(fasterize)

# Load dataset
setwd("/Users/ericdougherty/Desktop/HK_2018/")
dolphins <- read.csv('Dolphin data_11/Midway/2018/Midway_Lagoon_18.csv', sep=";")
dolphins$X.1 <- NULL

# As an example, create and sf object from a dataframe 
dolphins_sf <- st_as_sf(dolphins, coords= c("X","Y"), crs = "+proj=longlat") %>% 
  st_transform(32601)

# Create SpatialPoints
dolphin.latlong <- sp::SpatialPoints(dolphins[,c("X", "Y")], proj4string=CRS("+proj=longlat +ellps=WGS84"))
dolphin.utm <- spTransform(dolphin.latlong, "+init=epsg:32601")
dolphin.spdf <- SpatialPointsDataFrame(dolphin.utm, data=dolphins[,c(1:11,14:21)])

# Load bathymetry layer (raster) and class
bathy <- raster('Atoll_schematic/Midway/midway_bathy_4m.tif')
class <- readOGR('Atoll_schematic/Midway/midway_class_wgs.shp')
class <- spTransform(class, "+init=epsg:32601")

#Alternatively, load the same class layer using sf
class2 <- st_read('Atoll_schematic/Midway/midway_class_wgs.shp') %>%
  st_transform(32601)

# Pull the habitat class data from underlying polygons
dolphinHAB <- class2 %>% 
  st_join(x= dolphins_sf, y = . )
                    
class.rast <- fasterize(class2, bathy, field='HABCLASS')

extent(class.rast)
extent(bathy)
predictor.stack <- stack(bathy, class.rast)
extraction <- raster::extract(predictor.stack, dolphin.spdf)
extraction <- as.data.frame(extraction)
extraction %>% 
  mutate(bathy.m = midway_bathy_4m * .3048) %>% 
  filter(., midway_bathy_4m < 85) %>% 
  pull(midway_bathy_4m) %>% hist()

extraction %>% group_by(layer) %>% summarise(avg_depth =mean(bathy.m),
                                             med_depth =median(bathy.m),
                                             no_measures =n())  -> habitibble
str(habitibble)
unique(habitibble$layer)
unique(as.numeric(class2$HABCLASS))

class2$factor_id <- as.numeric(class2$HABCLASS)

habitibble %>% left_join(x = ., y = class2, by = c("layer" = "factor_id") )

# calcuate distance your points are from a line - say a boundary or a coast. 
# from the habitat layer
boundary <- st_union(class2)

land <- filter(class2, HABCLASS == "land")  %>% 
  st_cast("LINESTRING") %>% 
  st_union


dolphins_sf %>% mutate(dist_land = st_distance(dophins_sf,land))

# write out a file
st_write(class2, "class2.shp")
writeOGR(dolphin.spdf, dsn = ".", layer= "class2OGR.shp", driver= "ESRI Shapefile")
writeRaster(class.rast, "Class_Rast", format="GTiff")

################################################################################

setwd("~/Desktop/data_HK_phil")

# cliping a layer by a custom box
country <- read_sf("Country.shp")
crop_box <- extent(c(121.882324,124.129028,8.982749,11.689894))
country_crop <- crop(as(country, "Spatial"), crop_box)

spinners <- read.csv('Spinner_PH.csv')
spinners <- spinners %>% 
  group_by(., DATE_MISC, GROUP_MISC) %>% 
  mutate(encounter.id = paste(DATE_MISC,GROUP_MISC, sep="_"))
spinners$encounter.id <- as.numeric(as.factor(spinners$encounter.id))

spinners <- spinners %>% 
  mutate(Date = paste(DATE_MISC, Time_hh_mm_ss), Timestamp = mdy_hms(Date)) 
spinners <- spinners[!duplicated(spinners$Date),]
spinners <- spinners[!is.na(spinners$LONGITUDE),]

spinners_sf <- st_as_sf(spinners, coords=c("LONGITUDE", "LATITUDE"), crs="+proj=longlat") %>%
  st_transform("+proj=utm +north +zone=51")
spinners_sp <- as(spinners_sf, 'Spatial')

spinner.traj <- as.ltraj(date=spinners_sf$Timestamp, xy=st_coordinates(spinners_sf), 
                         id=spinners_sf$encounter.id)
for (i in 1:length(spinner.traj)) {
  ref <- round(spinner.traj[[i]]$date[1], "min")
  spinner.traj[i] %>%
    setNA(ltraj = ., date.ref = ref, dt = 10, units = "min") %>%
    sett0(ltraj = ., date.ref = ref, dt = 10, units = "min") -> spinner.traj[i]
}




