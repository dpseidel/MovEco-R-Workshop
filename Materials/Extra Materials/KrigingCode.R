# Kriging
library(tidyverse)
library(sf)
library(raster)
library(gstat)
library(automap)


########### interpolate missing depth measures ################
# load sample data
# dolphin
dolphins <- read_delim("../GIS Layers - HK/Midway_Lagoon_18.csv", delim = ";") %>%
  st_as_sf(., coords = c("X", "Y"), crs = "+proj=longlat") %>%
  st_transform("+proj=utm +zone=1 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0") 

# variogram model/kriging

dolphins_sp <- dolphins %>% filter(!is.na(Depth)) %>% sf::select.sf(Depth) %>% as(., "Spatial")
spplot(dolphins_sp,"Depth",colorkey=TRUE)

to_interpolate <-  dolphins %>% filter(is.na(Depth)) %>% sf::select.sf(Depth) %>% as(., "Spatial")
plot(to_interpolate)

#  interpolate to dolphin points with NAs
points_kri <- autoKrige(Depth~1, input_data = dolphins_sp, new_data = to_interpolate)


########## interpolate over a larger area:##############

# without a new data set given the autoKrige makes 5000 cell grid around the points. 
kr <- autoKrige(Depth~1, dolphins_sp) # auto grid

# for more fine scale interpolation we need to specify our own grid. 
# Use st_make grid to make a grid
# can be made at a smaller grid size but it's just slow to build. so cellsize=100 is good for testing
dolphin_grid <-  st_make_grid(dolphins, 
                              cellsize = 100, what= 'corners') %>% st_sf
# We likely want to for mask/clip out the land so let's load in the island layer
islands <- st_read("../GIS Layers - HK/midway/Midway_island_wgs.shp") %>% 
  st_transform("+proj=utm +zone=1 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0") %>% st_union

# take our islands and clip the grid. Selecting those points that do no intersect the island. 
masked_grid = filter(dolphin_grid, 
                     st_intersects(dolphin_grid, islands, sparse = FALSE) == FALSE) 
# Add an empty column to interpolate
masked_grid$Depth <- NA
plot(st_geometry(masked_grid))

# Krige. 
mask_krig <- autoKrige(formula = Depth~1,
                        input_data = dolphins_sp,
                        new_data = as(masked_grid, "Spatial"))


