#' @keywords internal
"_PACKAGE"

#' @title Trade: Sector-level trade table
#' @name trade
#' @docType data
#' @author USITC, adapted from UN COMTRADE and other sources
#' @format A data frame with 72,534,869 rows and 13 columns:
#' |Variable name         |Variable description                                                                                                |
#' |:---------------------|:-------------------------------------------------------------------------------------------------------------------|
#' |exporter_iso3         |ISO 3-letter alpha code of the exporter                                                                             |
#' |exporter_dynamic_code |DGD's dynamic code of the exporter                                                                                  |
#' |exporter_name         |Name of the exporter                                                                                                |
#' |importer_iso3         |ISO 3-letter alpha code of the importer                                                                             |
#' |importer_dynamic_code |DGD's dynamic code of the importer                                                                                  |
#' |importer_name         |Name of the importer                                                                                                |
#' |year                  |Year                                                                                                                |
#' |industry_id           |ITPD industry code                                                                                                  |
#' |industry_descr        |ITPD industry description                                                                                           |
#' |broad_sector          |Broad sector                                                                                                        |
#' |trade                 |Trade flows in million of current US dollars                                                                        |
#' |flag_mirror           |Flag indicator, 1 if trade mirror value is used                                                                     |
#' |flag_zero             |Flag indicator: `p` if positive trade, `r` if the raw data contained zero and `u`` missing (unknown, assigned zero) |
#' @description The data goes back to 1986 for Agriculture, and to 1988 for Mining & Energy and Manufacturing. Due to administrative data limitations, the data for Services is not available before to the year 2000.
#' @details There are differences with respect to the original CSV file. This version provides a more compact representation of the data, with the following changes:
#' \itemize{
#' \item{The `exporter_name` and `importer_name` columns are provided in the country names table as `country_name` and can be joined by using the `_iso3` and `_dynamic` columns.}
#' \item{The `industry_descr` column is provided in the industry names table.}
#' \item{The `broad_sector` column is provided in the sector names table and `broad_sector_id` was created for this version of the table.}
#' }
#' @source The original data is available at https://www.usitc.gov/data/gravity/itpde.htm
#' @keywords data
NULL

#' @title Country names: Auxiliary table
#' @name country_names
#' @docType data
#' @author Own creation
#' @format A data frame with 267 rows and 3 columns:
#' |Variable name         |Variable description                                                                                                |
#' |country_iso3          |ISO 3-letter alpha code of the country                                                                              |
#' |country_dynamic_code  |DGD's dynamic country code of the country                                                                           |
#' |country_name          |Name of the country                                                                                                 |
#' @source Adapted from the original ITPD-E dataset

#' @title Industry names: Auxiliary table
#' @name industry_names
#' @docType data
#' @author Own creation, adapted from the original ITPD-E dataset
#' @format A data frame with 170 rows and 2 columns:
#' |Variable name         |Variable description                                                                                                |
#' |industry_id           |ITPD industry code                                                                                                  |
#' |industry_descr        |ITPD industry description                                                                                           |
#' @source Adapted from the original ITPD-E dataset

#' Sector names: Auxiliary table
#' @name sector_names
#' @docType data
#' @author Own creation, adapted from the original ITPD-E dataset
#' @format A data frame with 4 rows and 2 columns:
#' |Variable name         |Variable description                                                                                                |
#' |broad_sector_id       |Broad sector code                                                                                                   |
#' |broad_sector          |Broad sector                                                                                                        |
#' @source Adapted from the original ITPD-E dataset
