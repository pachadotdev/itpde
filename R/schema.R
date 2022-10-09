#' Crea el esquema SQL
#' @noRd
create_schema <- function() {
  con <- usitcgravity_connect()

  # comunas ----

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS country_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE country_names (
  	country_iso3 CHAR(3),
	  country_dynamic_code VARCHAR(5),
  	country_name VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS industry_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE industry_names (
  	industry_id INTEGER,
	  industry_descr VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS sector_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE sector_names (
  	broad_sector_id INTEGER,
	  broad_sector VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS trade")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE trade (
  	exporter_iso3 CHAR(3),
  	exporter_dynamic_code VARCHAR(5),
  	importer_iso3 CHAR(3),
  	importer_dynamic_code VARCHAR(5),
  	broad_sector_id INTEGER,
  	industry_id INTEGER,
  	year INTEGER,
  	trade FLOAT,
  	flag_mirror CHAR(1),
  	flag_zero CHAR(1))"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS region_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE region_names (
  	region_id INTEGER,
  	region_name VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS gravity")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE gravity (
    year INTEGER,
    iso3_o CHAR(3),
    dynamic_code_o VARCHAR(5),
    iso3_d CHAR(3),
    dynamic_code_d VARCHAR(5),
    colony_of_destination_ever INTEGER,
    colony_of_origin_ever INTEGER,
    colony_ever INTEGER,
    common_colonizer INTEGER,
    common_legal_origin INTEGER,
    contiguity INTEGER,
    distance DOUBLE,
    member_gatt_o INTEGER,
    member_wto_o INTEGER,
    member_eu_o INTEGER,
    member_gatt_d INTEGER,
    member_wto_d INTEGER,
    member_eu_d INTEGER,
    member_gatt_joint INTEGER,
    member_wto_joint INTEGER,
    member_eu_joint INTEGER,
    lat_o DOUBLE,
    lng_o DOUBLE,
    lat_d DOUBLE,
    lng_d DOUBLE,
    landlocked_o INTEGER,
    island_o INTEGER,
    region_id_o INTEGER,
    landlocked_d INTEGER,
    island_d INTEGER,
    region_id_d INTEGER,
    agree_pta_goods INTEGER,
    agree_pta_services INTEGER,
    agree_fta INTEGER,
    agree_eia INTEGER,
    agree_cu INTEGER,
    agree_psa INTEGER,
    agree_fta_eia INTEGER,
    agree_cu_eia INTEGER,
    agree_pta INTEGER,
    capital_const_d DOUBLE,
    capital_const_o DOUBLE,
    capital_cur_d DOUBLE,
    capital_cur_o DOUBLE,
    gdp_pwt_const_d DOUBLE,
    gdp_pwt_const_o DOUBLE,
    gdp_pwt_cur_d DOUBLE,
    gdp_pwt_cur_o DOUBLE,
    pop_d DOUBLE,
    pop_o DOUBLE,
    hostility_level_o INTEGER,
    hostility_level_d INTEGER,
    common_language INTEGER,
    polity_o INTEGER,
    polity_d INTEGER,
    sanction_threat INTEGER,
    sanction_threat_trade INTEGER,
    sanction_imposition INTEGER,
    sanction_imposition_trade INTEGER,
    gdp_wdi_cur_o DOUBLE,
    gdp_wdi_cap_cur_o DOUBLE,
    gdp_wdi_const_o DOUBLE,
    gdp_wdi_cap_const_o DOUBLE,
    gdp_wdi_cur_d DOUBLE,
    gdp_wdi_cap_cur_d DOUBLE,
    gdp_wdi_const_d DOUBLE,
    gdp_wdi_cap_const_d DOUBLE)"
  )

  # disconnect ----

  DBI::dbDisconnect(con, shutdown = TRUE)
  gc()
}
