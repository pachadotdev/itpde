#' Crea el esquema SQL
#' @noRd
create_schema <- function() {
  con <- itpde_connect()

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

  # disconnect ----

  DBI::dbDisconnect(con, shutdown = TRUE)
  gc()
}
