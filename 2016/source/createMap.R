# create map of median income by county

## Dependencies
### tidyverse
library(ggplot2)

### mapping
library(albersusa)
library(classInt)
library(sf)
library(tidycensus)

### other
library(prener) 
# this is only needed for the specific theme and export functions at the end

## Create us state outlines in albers projection
us_sf <- usa_sf("laea")

## Create median income object
### download missouri counties
us_county_income <- get_acs(geography = "county", variables = "B19013_001", 
                            shift_geo = TRUE, geometry = TRUE)

### jenks natural breaks
jenks <- classIntervals(us_county_income$estimate, n=5, style="jenks")
income <- cut(us_county_income$estimate, breaks = c(jenks$brks))


## Create base map
base <- ggplot() + 
  geom_sf(data = us_county_income, aes(fill = income), color = NA) + 
  geom_sf(data = us_sf, fill = NA, color = "#000000", size = .25) +
  coord_sf(datum = NA) +
  scale_fill_brewer(palette = "BuPu", name = "Median Income",
                    labels = c("$19.0k - $38.5k", "$38.5k - $47.9k", "$47.9k - $58.9k", "$58.9k - $76.4k", "$76.4k - $126k")) +
  labs(
    title = "Median Income by County, 2016",
    subtitle = "2016 5-year American Community Survey Estimates",
    caption = "Data via U.S. Census Bureau \nMap by Christopher Prener, Ph.D."
  )

### functions from here on out use the `prener` package
### these could be replaced with `ggsave()` and a different theme
cp_plotSave(filename = "2016/results/incomeMap16-base.png", plot = base, preset = "lg", dpi = 500)

## map with white background
map01 <- base +
  cp_sequoiaTheme(background = "white", map = TRUE)

cp_plotSave(filename = "2016/results/incomeMap16-white.png", plot = map01, preset = "lg", dpi = 500)

## map with transparent background
map02 <- base +
  cp_sequoiaTheme(background = "transparent", map = TRUE)

cp_plotSave(filename = "2016/results/incomeMap16-trans.png", plot = map02, preset = "lg", dpi = 500)
