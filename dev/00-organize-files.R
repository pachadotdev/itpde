library(archive)
library(data.table)
library(dplyr)
library(tidyr)
library(purrr)

url <- "https://www.usitc.gov/data/gravity/itpd_e/itpd_e_r02.zip"
url2 <- "https://www.usitc.gov/data/gravity/dgd_docs/release_2.1_1948_1999.zip"
url3 <- "https://www.usitc.gov/data/gravity/dgd_docs/release_2.1_2000_2019.zip"

finp <- "dev/finp/"
fout <- "dev/fout/"

zip <- gsub(".*/", finp, url)
zip2 <- gsub(".*/", finp, url2)
zip3 <- gsub(".*/", finp, url3)
zip4 <- paste0(fout, "itpde.zip")

try(dir.create(finp, recursive = T))
try(dir.create(fout, recursive = T))

if (!file.exists(zip)) {
  try(download.file(url, zip, method = "wget", quiet = T))
}

if (!file.exists(zip2)) {
  try(download.file(url2, zip2, method = "wget", quiet = T))
}

if (!file.exists(zip3)) {
  try(download.file(url3, zip3, method = "wget", quiet = T))
}

if (!length(list.files(finp, pattern = "csv")) == 1) {
  archive_extract(zip, dir = finp)
  archive_extract(zip2, dir = finp)
  archive_extract(zip3, dir = finp)
}

trade_tsv <- paste0(fout, "trade.tsv")

if (!file.exists(trade_tsv)) {
  trade <- fread(paste0(finp, "/ITPD_E_R02.csv"))

  country_names <- trade %>%
    select(country_iso3 = exporter_iso3,
           country_dynamic_code = exporter_dynamic_code,
           country_name = exporter_name) %>%
    distinct() %>%
    bind_rows(
      trade %>%
        select(country_iso3 = importer_iso3,
               country_dynamic_code = importer_dynamic_code,
               country_name = importer_name) %>%
        distinct()
    ) %>%
    distinct() %>%
    arrange(country_iso3)

  trade <- trade %>%
    select(-exporter_name, -importer_name)

  industry_names <- trade %>%
    select(industry_id, industry_descr) %>%
    distinct()

  sector_names <- trade %>%
    select(broad_sector) %>%
    distinct() %>%
    arrange(broad_sector) %>%
    mutate(broad_sector_id = row_number()) %>%
    select(broad_sector_id, broad_sector)

  sector_names_2 <- trade %>%
    select(broad_sector) %>%
    inner_join(sector_names)

  trade <- trade %>%
    select(-broad_sector, -industry_descr)

  trade <- trade %>%
    bind_cols(sector_names_2) %>%
    select(exporter_iso3:importer_dynamic_code, broad_sector_id, industry_id:flag_zero)

  fwrite(trade, trade_tsv, sep = "\t")
  fwrite(country_names, paste0(fout, "country_names.tsv"), sep = "\t")
  fwrite(industry_names, paste0(fout, "industry_names.tsv"), sep = "\t")
  fwrite(sector_names, paste0(fout, "sector_names.tsv"), sep = "\t")

  yrs <- min(trade$year):max(trade$year)
  rm(trade, industry_names, sector_names)

  csv_gravity <- list.files(finp,
    pattern = "release_2\\.1_[0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9]\\.csv", full.names = T)

  gravity <- map_df(
    rev(csv_gravity),
    function(f) {
      fread(f) %>%
        filter(year %in% yrs) %>%
        select(-country_o, -country_d) %>%
        inner_join(
          country_names %>%
            select(country_iso3, country_dynamic_code),
          by = c("iso3_o" = "country_iso3", "dynamic_code_o" = "country_dynamic_code")
        ) %>%
        inner_join(
          country_names %>%
            select(country_iso3, country_dynamic_code),
          by = c("iso3_d" = "country_iso3", "dynamic_code_d" = "country_dynamic_code")
        )
    }
  )

  region_names <- gravity %>%
    select(region = region_o) %>%
    distinct() %>%
    bind_rows(
      gravity %>%
        select(region = region_d) %>%
        distinct()
    ) %>%
    filter(region != "") %>%
    distinct() %>%
    arrange(region) %>%
    mutate(region_id = row_number()) %>%
    select(region_id, region)

  gravity <- gravity %>%
    left_join(
      region_names %>%
        select(region_o = region, region_id_o = region_id)
    ) %>%
    left_join(
      region_names %>%
        select(region_d = region, region_id_d = region_id)
    )

  gravity <- gravity %>%
    select(year:island_o, region_id_o, landlocked_d:island_d,
           region_id_d, agree_pta_goods:gdp_wdi_cap_const_d)

  fwrite(gravity, paste0(fout, "gravity.tsv"), sep = "\t")
  fwrite(region_names, paste0(fout, "region_names.tsv"), sep = "\t")
}

if (!file.exists(zip4)) {
  archive_write_dir(zip4, fout)
}
