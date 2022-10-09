library(archive)
library(data.table)
library(dplyr)

url <- "https://www.usitc.gov/data/gravity/itpd_e/itpd_e_r02.zip"
finp <- "dev/finp/"
fout <- "dev/fout/"
zip <- gsub(".*/", finp, url)

try(dir.create(finp, recursive = T))
try(dir.create(fout, recursive = T))

if (!file.exists(zip)) {
  try(download.file(url, zip, method = "wget", quiet = T))
}

if (!length(list.files(finp, pattern = "csv")) == 1) {
  archive::archive_extract(zip, dir = finp)
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
}
