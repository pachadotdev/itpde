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
library(itpde)
library(cepiigravity)
library(dplyr)
library(purrr)
library(fixest)

con1 <- itpde_connect()
con2 <- gravity_connect()

# run one model per sector
models <- map(
  tbl(con1, "sector_names") %>% pull(broad_sector_id),
  function(s) {
    message(s)
    
    yrs <- seq(2005, 2015, by = 5)
    
    d <- tbl(con1, "trade") %>% 
      filter(year %in% yrs, broad_sector_id == s) %>% 
      group_by(year, exporter_iso3, importer_iso3, broad_sector_id) %>% 
      summarise(trade = sum(trade, na.rm = T)) %>% 
      collect() %>% # important because gravity is another SQL source
      inner_join(
        tbl(con2, "gravity") %>% 
          filter(year %in% yrs) %>% 
          mutate(iso3_o = toupper(iso3_o),
                 iso3_d = toupper(iso3_d)) %>% 
          select(iso3_o, iso3_d, contig, comlang_off, col_dep_ever, dist) %>% 
          collect(),
        by = c("exporter_iso3" = "iso3_o", "importer_iso3" = "iso3_d")
      )
    
    # add exporter/importer time fixed effects for the estimation
    d <- d %>% 
      mutate(
        etfe = paste(exporter_iso3, year, sep = "_"),
        itfe = paste(importer_iso3, year, sep = "_")
      )
    
    feglm(trade ~ contig + comlang_off + col_dep_ever + log(dist) | etfe + itfe,
          family = quasipoisson(),
          data = d)
  }
)

itpde_disconnect()
gravity_disconnect()
```

```r
print(models)

[[1]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 240,365 
Fixed-effects: etfe: 644,  itfe: 656
Standard-errors: Clustered (etfe) 
              Estimate Std. Error    t value   Pr(>|t|)    
contig       -1.433329   0.150747  -9.508170  < 2.2e-16 ***
comlang_off  -0.723613   0.139631  -5.182314 2.9376e-07 ***
col_dep_ever  0.096605   0.259608   0.372120 7.0993e-01    
log(dist)    -2.212230   0.047428 -46.643871  < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.993606                   

[[2]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 369,427 
Fixed-effects: etfe: 659,  itfe: 659
Standard-errors: Clustered (etfe) 
              Estimate Std. Error    t value   Pr(>|t|)    
contig       -0.835875   0.111194  -7.517238 1.8368e-13 ***
comlang_off   0.033070   0.132264   0.250031 8.0264e-01    
col_dep_ever  0.135281   0.126313   1.070997 2.8456e-01    
log(dist)    -1.379965   0.039582 -34.863335  < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.987631                   

[[3]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 179,961 
Fixed-effects: etfe: 630,  itfe: 654
Standard-errors: Clustered (etfe) 
              Estimate Std. Error    t value  Pr(>|t|)    
contig       -1.562049   0.115587 -13.514050 < 2.2e-16 ***
comlang_off  -0.111590   0.202820  -0.550194   0.58238    
col_dep_ever -0.278042   0.200428  -1.387244   0.16586    
log(dist)    -2.389919   0.069540 -34.367704 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.983621                   

[[4]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 45,522 
Fixed-effects: etfe: 565,  itfe: 564
Standard-errors: Clustered (etfe) 
              Estimate Std. Error    t value  Pr(>|t|)    
contig       -4.275377   0.482382  -8.863045 < 2.2e-16 ***
comlang_off   0.130516   0.331913   0.393224   0.69430    
col_dep_ever  0.057388   0.262086   0.218965   0.82676    
log(dist)    -2.406638   0.072950 -32.990276 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                          
  Squared Cor.: 0.99044
```

