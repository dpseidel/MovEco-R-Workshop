library(tlocoh)
library(adehabitatLT)
library(move)

# Preparing first 2000 points of the toni path for testing
data(toni)
toni <- toni[!duplicated(toni$timestamp.utc),]
toni <- toni[1:2000,]

toni.sp.latlong <- SpatialPoints(toni[ , c("long","lat")], proj4string=CRS("+proj=longlat +ellps=WGS84"))
toni.sp.utm <- spTransform(toni.sp.latlong, CRS("+proj=utm +south +zone=36 +ellps=WGS84"))
toni.mat.utm <- coordinates(toni.sp.utm)
toni.gmt <- as.POSIXct(toni$timestamp.utc, tz="UTC")
local.tz <- "Africa/Johannesburg"
toni.localtime <- as.POSIXct(format(toni.gmt, tz=local.tz), tz=local.tz)

toni.move <- move(x=toni.mat.utm[,1],
                  y=toni.mat.utm[,2],
                  time=toni.localtime,
                  data=toni,
                  animal = as.factor(toni$id),
                  sensor = as.factor(toni$id),
                  proj=CRS("+proj=utm +south +zone=36"))

toni_ltraj  <- as(toni.move, 'ltraj')

# Function to sample available points based on empirical steps
# steps.ltraj - an ltraj object of the movement path
# n.avail.per.pt - number of available points to select per used point
SSF.sampling <- function(steps.ltraj, n.avail.per.pt) {
  ltraj.df <- steps.ltraj[[1]]
  step.lengths <- ltraj.df$dist
  turning.angles <- ltraj.df$rel.angle
  
  avail.pts <- data.frame(matrix(0,nrow(ltraj.df)*n.avail.per.pt,2))
  for (i in 1:nrow(ltraj.df)) {
    used.pt <- ltraj.df[i, 1:2]
    for (j in 1:n.avail.per.pt) {
      rand.rows <- round(runif(2,0.5,(nrow(ltraj.df)+0.5)))
      temp.step.length <- step.lengths[rand.rows[1]]
      temp.turning.angle <- turning.angles[rand.rows[2]]
      dx <- cos(temp.turning.angle) * temp.step.length
      dy <- sin(temp.turning.angle) * temp.step.length
      new.x <- used.pt[,1] + dx
      new.y <- used.pt[,2] + dy
      avail.pts[(i-1)*n.avail.per.pt+j,1] <- new.x
      avail.pts[(i-1)*n.avail.per.pt+j,2] <- new.y
    }
  }
  return(avail.pts)
}

# Run function and plot to verify that it works as expected
avail.pts <- SSF.sampling(toni_ltraj, 5)
plot(avail.pts[,1], avail.pts[,2], pch=19)
points(toni_ltraj[[1]][,1], toni_ltraj[[1]][,2], pch=19, col='red', cex=0.3)
