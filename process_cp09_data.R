library(tidyverse)
library(ggplot2)
library(lubridate)
library(plotly)

setwd('/home/greg/Nextcloud/DataScience/SummerTime/')
tmean <- read.csv('raw_files/ukcp09_gridded-land-obs-daily_timeseries_mean-temperature_250000E_700000N_19600101-20161231.csv', header = F)
tmin <- read.csv('raw_files/ukcp09_gridded-land-obs-daily_timeseries_minimum-temperature_250000E_700000N_19600101-20161231.csv', header = F)
tmax <- read.csv('raw_files/ukcp09_gridded-land-obs-daily_timeseries_maximum-temperature_250000E_700000N_19600101-20161231.csv', header = F)
rain <- read.csv('raw_files/ukcp09_gridded-land-obs-daily_timeseries_rainfall_250000E_700000N_19580101-20161231.csv', header = F)

tmean <- tmean %>%
  select(V1,V79) %>%
  filter(V1 != 'easting' & V1 != 'northing') %>%
  mutate(V1 = ymd(V1)) %>%
  rename(date = V1,mean_temp_celsius = V79)
tmin <- tmin %>%
  select(V1,V79) %>%
  filter(V1 != 'easting' & V1 != 'northing') %>%
  mutate(V1 = ymd(V1)) %>%
  rename(date = V1,min_temp_celsius = V79)
tmax <- tmax %>%
  select(V1,V79) %>%
  filter(V1 != 'easting' & V1 != 'northing') %>%
  mutate(V1 = ymd(V1)) %>%
  rename(date = V1,max_temp_celsius = V79)

rain <- rain %>%
  select(V1,V79) %>%
  filter(V1 != 'easting' & V1 != 'northing') %>%
  mutate(V1 = ymd(V1)) %>%
  filter(V1 >= '1960-01-01') %>%
  rename(date = V1,mm_precipitation = V79)

weather <- merge(tmean, tmin) %>% merge(tmax) %>% merge( rain) %>%
  mutate(year = year(date), month = month(date), day = yday(date)) %>%
  mutate(summer = ifelse(month %in% c(5,6,7,8,9), 1, 0))
  

# Proposed model:
# * mean > (max-min)/2 - how much more?
# * precip < ?
# * 3 days for a "spell" - how to quantify?

# Explore precipitation first

summary <- weather %>%
  filter(summer == 1) %>%
  group_by(year) %>%
  summarise_at(c('mean_temp_celsius','min_temp_celsius',
                 'max_temp_celsius','mm_precipitation'),
               c('mean','sum')) %>%
  select(year,'Mean Temp' = mean_temp_celsius_mean, 'Total Rainfall' = mm_precipitation_sum)

d1 <- select(summary, x = year, y = `Mean Temp`)
d2 <- select(summary, x = year, y = `Total Rainfall`)
d1$panel <- "Mean Temp (C)"
d2$panel <- "Total Rain (mm)"
d1$z <- d1$y
d2$z <- d1$y

d <- rbind(d2, d1)

overall_mean_temp = mean(summary$`Mean Temp`)
p <- ggplot(data = d, mapping = aes(x = x, y = y)) + 
  facet_grid(panel ~ ., scale="free") + 
  geom_point(data = d1, stat = "identity") + 
  geom_smooth(data = d1, method = 'lm') +
  geom_bar(data=d2, aes(fill = z), stat = "identity") + 
  scale_fill_gradient2(low = "blue", high = "red", mid = "grey", midpoint = overall_mean_temp ) +
  theme(legend.position = 'none') + 
  theme(axis.title.y = element_blank()) +
  xlab('Year') + ggtitle('Mean Temperature and Total Rainfall for summers since 1960')

cor = cor(summary$`Mean Temp`,summary$`Total Rainfall`)
