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
#' \item{The `exporter_name` and `importer_name` columns are provided in the `country_names` table as `country_name` and can be joined by using the `_iso3` and `_dynamic` columns.}
#' \item{The `industry_descr` column is provided in the industry names table.}
#' \item{The `broad_sector` column is provided in the sector names table and `broad_sector_id` was created for this version of the table.}
#' }
#' @source The original data is available at https://www.usitc.gov/data/gravity/itpde.htm
#' @keywords data
NULL

#' @title Gravity: Macroeconomic, geographic and institutional variables table.
#' @name gravity
#' @docType data
#' @author USITC, adapted from WTO, UN COMTRADE, National Geographic and other sources
#' @format A data frame with 1,973,285 rows and 67 columns:
#' |Variable name              |Variable description                                                                                 |
#' |:--------------------------|:----------------------------------------------------------------------------------------------------|
#' |year                       |Year of observation                                                                                  |
#' |iso3_o                     |3-digit ISO code of origin country                                                                   |
#' |dynamic_code_o             |Year appropriate 3-digit code of origin country                                                      |
#' |iso3_d                     |3-digit ISO code of destination country                                                              |
#' |dynamic_code_d             |Year appropriate 3-digit code of destination country                                                 |
#' |colony_of_destination_ever |Origin country was ever a colony of the destination country                                          |
#' |colony_of_origin_ever      |Destination country was ever a colony of the origin country                                          |
#' |colony_ever                |Country pair has been in a colonial relationship                                                     |
#' |common_colonizer           |Country pair has been colonized by a common colonizer                                                |
#' |common_legal_origin        |Country pair shares common legal origin                                                              |
#' |contiguity                 |Country pair shares a common border                                                                  |
#' |distance                   |Population weighted distance between country pair                                                    |
#' |member_gatt_o              |Origin country is a General Agreement on Tariffs and Trade member                                    |
#' |member_wto_o               |Origin country is a World Trade Organization member                                                  |
#' |member_eu_o                |Origin country is a European Union member                                                            |
#' |member_gatt_d              |Destination country is a General Agreement on Tariffs and Trade member                               |
#' |member_wto_d               |Destination country is a World Trade Organization member                                             |
#' |member_eu_d                |Destination country is a European Union member                                                       |
#' |member_gatt_joint          |Country pair are both members of the General Agreement on Tariffs and Trade                          |
#' |member_wto_joint           |Country pair are both members of the World Trade Organization                                        |
#' |member_eu_joint            |Country pair are both members of the European Union                                                  |
#' |lat_o                      |Latitude coordinate of origin country                                                                |
#' |lng_o                      |Longitude coordinate of origin country                                                               |
#' |lat_d                      |Latitude coordinate of destination country                                                           |
#' |lng_d                      |Longitude coordinate of destination country                                                          |
#' |landlocked_o               |Origin country is landlocked                                                                         |
#' |island_o                   |Origin country is an island                                                                          |
#' |region_id_o                |Geographic region of origin country                                                                  |
#' |landlocked_d               |Destination country is landlocked                                                                    |
#' |island_d                   |Destination country is an island                                                                     |
#' |region_id_d                |Geographic region of destination country                                                             |
#' |agree_pta_goods            |Country pair is in at least one active preferential trade agreement covering goods                   |
#' |agree_pta_services         |Country pair is in at least one active preferential trade agreement covering services                |
#' |agree_fta                  |Country pair is in at least one free trade agreement                                                 |
#' |agree_eia                  |Country pair is in at least one economic integration agreement                                       |
#' |agree_cu                   |Country pair is in at least one customs union                                                        |
#' |agree_psa                  |Country pair is in at least one partial scope agreement                                              |
#' |agree_fta_eia              |Country pair is in at least one free trade agreement and at least one economic integration agreement |
#' |agree_cu_eia               |Country pair is in at least one customs union and at least one economic integration agreement        |
#' |agree_pta                  |Country pair is in at least one active preferential trade agreement covering goods                   |
#' |capital_const_d            |Capital stock at constant prices of destination country                                              |
#' |capital_const_o            |Capital stock at constant prices of origin country                                                   |
#' |capital_cur_d              |Capital stock at current PPP of destination country                                                  |
#' |capital_cur_o              |Capital stock at current PPP of origin country                                                       |
#' |gdp_pwt_const_d            |Real, inflation-adjusted, PPP-adjusted GDP of destination country (PWT)                              |
#' |gdp_pwt_const_o            |Real, inflation-adjusted, PPP-adjusted GDP of origin country (PWT)                                   |
#' |gdp_pwt_cur_d              |Real, current, PPP-adjusted GDP of destination country (PWT)                                         |
#' |gdp_pwt_cur_o              |Real, current, PPP-adjusted GDP of origin country (PWT)                                              |
#' |pop_d                      |Population of destination country                                                                    |
#' |pop_o                      |Population of origin country                                                                         |
#' |hostility_level_o          |Level of the origin/destination country’s hostility toward the destination country                   |
#' |hostility_level_d          |Level of the origin/destination country’s hostility toward the origin country                        |
#' |common_language            |Residents of country pair speak at least one common language                                         |
#' |polity_o                   |Polity (political stability) score of origin country                                                 |
#' |polity_d                   |Polity (political stability) score of destination country                                            |
#' |sanction_threat            |There exists a threat of sanction between one country in a record towards the other                  |
#' |sanction_threat_trade      |There exists a threat of trade sanction between one country in a record towards the other            |
#' |sanction_imposition        |There exists a sanction between one country in a record towards the other                            |
#' |sanction_imposition_trade  |There exists a trade sanction between one country in a record towards the other                      |
#' |gdp_wdi_cur_o              |Nominal GDP of origin country (WDI)                                                                  |
#' |gdp_wdi_cap_cur_o          |Nominal GDP per capita of origin country (WDI)                                                       |
#' |gdp_wdi_const_o            |Real, current, PPP-adjusted GDP of origin country (PWT)                                              |
#' |gdp_wdi_cap_const_o        |Real GDP per capita of origin country (WDI)                                                          |
#' |gdp_wdi_cur_d              |Nominal GDP of destination country (WDI)                                                             |
#' |gdp_wdi_cap_cur_d          |Nominal GDP per capita of destination country (WDI)                                                  |
#' |gdp_wdi_const_d            |Real, current, PPP-adjusted GDP of destination country (PWT)                                         |
#' |gdp_wdi_cap_const_d        |Real GDP per capita of destination country (WDI)                                                     |
#' @description The data goes back to 1986 and is suited to join with the `trade` table.
#' @details There are differences with respect to the original CSV files. This version provides a more compact representation of the data, with the following changes:
#' \itemize{
#' \item{Starts in 1986 instead of 1948.}
#' \item{Is limited to ISO codes contained in the `trade` table.}
#' \item{The `region_origin` and `region_destination` columns are provided in the `region names` table as `region_name` and can be joined by using the `region_id_` columns.}
#' }
#' @source The original data is available at https://www.usitc.gov/data/gravity/dgd.htm
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
#' @keywords data
NULL

#' @title Industry names: Auxiliary table
#' @name industry_names
#' @docType data
#' @author Own creation, adapted from the original ITPD-E dataset
#' @format A data frame with 170 rows and 2 columns:
#' |Variable name         |Variable description                                                                                                |
#' |industry_id           |ITPD industry code                                                                                                  |
#' |industry_descr        |ITPD industry description                                                                                           |
#' @source Adapted from the original ITPD-E dataset
#' @keywords data
NULL

#' Sector names: Auxiliary table
#' @name sector_names
#' @docType data
#' @author Own creation, adapted from the original ITPD-E dataset
#' @format A data frame with 4 rows and 2 columns:
#' |Variable name         |Variable description                                                                                                |
#' |broad_sector_id       |Broad sector code                                                                                                   |
#' |broad_sector          |Broad sector                                                                                                        |
#' @source Adapted from the original ITPD-E dataset
#' @keywords data
NULL

#' @title Region names: Auxiliary table
#' @name region_names
#' @docType data
#' @author Own creation, adapted from the original DGD dataset
#' @format A data frame with 15 rows and 2 columns:
#' |Variable name         |Variable description                                                                                                |
#' |region_id             |Region code                                                                                                         |
#' |region                |Region name                                                                                                         |
#' @source Adapted from the original DGD dataset
#' @keywords data
NULL
