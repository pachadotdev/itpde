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
