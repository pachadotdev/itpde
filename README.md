# itpde: The International Trade and Production Database for Estimation (ITPD-E)

<!-- badges: start -->
<!-- badges: end -->

The goal of itpde is to provide the same data from [The International Trade and Production Database for Estimation (ITPD-E)](https://www.usitc.gov/data/gravity/itpde.htm) ready to be used in R (i.e. with the [gravity](https://pacha.dev/gravity) package).

The package provides consistent data on international and domestic trade for 243 countries, 170 industries, and 17 years. The data are constructed at the industry level covering agriculture, mining, energy, manufacturing, and services for the period 1986-2019. The ITPD-E is constructed using reported administrative data and intentionally does not include information estimated by statistical techniques, which makes the ITPD-E well suited for estimation of economic models, such as the gravity model of trade.

`itpde` can be installed by running

```
# install.packages("remotes")
install_github("pachadotdev/itpde")
```

The main source to obtain the data in this package is:

Borchert, Ingo & Larch, Mario & Shikher, Serge & Yotov, Yoto, 2020. *The International Trade and Production Database for Estimation (ITPD-E)*. School of Economics Working Paper Series 2020-5, LeBow College of Business, Drexel University.

An example to estimate the gravity model of trade with cross sectional for different sectors data is:

```r
library(usitcgravity)
library(dplyr)
library(purrr)
library(fixest)

con <- usitcgravity_connect()
  
# run one model per sector
models <- map(
  tbl(con, "sector_names") %>% pull(broad_sector_id),
  function(s) {
    message(s)
    
    yrs <- seq(2005, 2015, by = 5)
    
    d <- tbl(con, "trade") %>% 
      filter(year %in% yrs, broad_sector_id == s) %>% 
      group_by(year, exporter_iso3, importer_iso3, broad_sector_id) %>% 
      summarise(trade = sum(trade, na.rm = T)) %>% 
      inner_join(
        tbl(con, "gravity") %>% 
          filter(year %in% yrs) %>% 
          select(iso3_o, iso3_d, contiguity, common_language, colony_ever, distance),
        by = c("exporter_iso3" = "iso3_o", "importer_iso3" = "iso3_d")
      ) %>% 
      collect()
    
    # add exporter/importer time fixed effects for the estimation
    d <- d %>% 
      mutate(
        etfe = paste(exporter_iso3, year, sep = "_"),
        itfe = paste(importer_iso3, year, sep = "_")
      )
    
    feglm(trade ~ contiguity + common_language + colony_ever + 
            log(distance) | etfe + itfe,
          family = quasipoisson(),
          data = d)
  }
)

usitc_disconnect()
```

```r
print(models)

[[1]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 246,359 
Fixed-effects: etfe: 666,  itfe: 685
Standard-errors: Clustered (etfe) 
                 Estimate Std. Error   t value   Pr(>|t|)    
contiguity      -1.107178   0.095210 -11.62882  < 2.2e-16 ***
common_language  0.904003   0.093483   9.67025  < 2.2e-16 ***
colony_ever     -0.574003   0.123660  -4.64179 4.1623e-06 ***
log(distance)   -2.296888   0.049558 -46.34779  < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.995066                   

[[2]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 399,386 
Fixed-effects: etfe: 699,  itfe: 699
Standard-errors: Clustered (etfe) 
                 Estimate Std. Error   t value   Pr(>|t|)    
contiguity      -0.607615   0.066616  -9.12114  < 2.2e-16 ***
common_language  1.018309   0.122366   8.32184 4.5501e-16 ***
colony_ever     -0.349478   0.095461  -3.66094 2.7027e-04 ***
log(distance)   -1.231589   0.079559 -15.48011  < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.993537                   

[[3]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 184,626 
Fixed-effects: etfe: 658,  itfe: 682
Standard-errors: Clustered (etfe) 
                 Estimate Std. Error   t value  Pr(>|t|)    
contiguity      -1.288373   0.104177 -12.36711 < 2.2e-16 ***
common_language  1.346375   0.132477  10.16305 < 2.2e-16 ***
colony_ever     -0.288694   0.222472  -1.29766   0.19486    
log(distance)   -2.298326   0.074100 -31.01657 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.992104                   

[[4]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 46,471 
Fixed-effects: etfe: 578,  itfe: 579
Standard-errors: Clustered (etfe) 
                 Estimate Std. Error    t value  Pr(>|t|)    
contiguity      -2.671951   0.183676 -14.547108 < 2.2e-16 ***
common_language  1.612853   0.127480  12.651800 < 2.2e-16 ***
colony_ever      0.139065   0.170706   0.814645   0.41561    
log(distance)   -2.267023   0.081150 -27.936349 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.998325
```
