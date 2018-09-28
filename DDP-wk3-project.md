Summer Temperature & Rainfall exploration
========================================================
author: Greg Sutcliffe
date: 2018-09-28
autosize: true

Summer Temperature & Rainfall exploration
========================================================

This is a Plotly chart which investigates the **mean** temperature and **total** rainfall for the summer months (defined as May to September, inclusive) over the last 50+ years.

Data source
==============

This is based on the Met Office UKCP09 daily climate dataset, cited as:
```
Met Office (2017): UKCP09: Met Office gridded land surface climate
observations - daily temperature and precipitation at 5km resolution.
Centre for Environmental Data Analysis, 2018-07-05
http://catalogue.ceda.ac.uk/uuid/319b3f878c7d4cbfbdb356e19d8061d6
```

The data shown is for a single 5km x 5km area near while the author lives.

Temp & rainfall plot
=====================


```r
source('./process_cp09_data.R')
ggplotly(p)
```

![plot of chunk unnamed-chunk-1](DDP-wk3-project-figure/unnamed-chunk-1-1.png)
