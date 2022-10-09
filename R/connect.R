itpde_path <- function() {
  sys_itpde_path <- Sys.getenv("ITPDE_DIR")
  sys_itpde_path <- gsub("\\\\", "/", sys_itpde_path)
  if (sys_itpde_path == "") {
    return(gsub("\\\\", "/", tools::R_user_dir("itpde")))
  } else {
    return(gsub("\\\\", "/", sys_itpde_path))
  }
}

itpde_check_status <- function() {
  if (!itpde_status(FALSE)) {
    stop("The itpde database is empty or damaged.
         Download it with itpde_download().")
  }
}

#' Connect to the itpde database
#'
#' Returns a local database connection. This corresponds to a DBI-compatible
#' DuckDB database.
#'
#' @param dir Database location on disk. Defaults to the `itpde`
#' directory inside the R user folder or the `ITPDE_DIR` environment variable
#' if specified.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  DBI::dbListTables(itpde_connect())
#'
#'  DBI::dbGetQuery(
#'   itpde_connect(),
#'   'SELECT * FROM itpde WHERE year = 2010'
#'  )
#' }
itpde_connect <- function(dir = itpde_path()) {
  duckdb_version <- utils::packageVersion("duckdb")
  db_file <- paste0(dir, "/itpde_duckdb_v", gsub("\\.", "", duckdb_version), ".sql")

  db <- mget("itpde_connect", envir = itpde_cache, ifnotfound = NA)[[1]]

  if (inherits(db, "DBIConnection")) {
    if (DBI::dbIsValid(db)) {
      return(db)
    }
  }

  try(dir.create(dir, showWarnings = FALSE, recursive = TRUE))

  drv <- duckdb::duckdb(db_file, read_only = FALSE)

  tryCatch({
    con <- DBI::dbConnect(drv)
  },
  error = function(e) {
    if (grepl("Failed to open database", e)) {
      stop(
        "The local itpde database is being used by another process. Try
        closing other R sessions or disconnecting the database using
        itpde_disconnect() in the other sessions.",
        call. = FALSE
      )
    } else {
      stop(e)
    }
  },
  finally = NULL
  )

  assign("itpde_connect", con, envir = itpde_cache)
  con
}

#' Disconnect the itpde database
#'
#' An auxiliary function to disconnect from the database.
#'
#' @examples
#' itpde_disconnect()
#' @export
#'
itpde_disconnect <- function() {
  itpde_disconnect_()
}

itpde_disconnect_ <- function(environment = itpde_cache) {
  db <- mget("itpde_connect", envir = itpde_cache, ifnotfound = NA)[[1]]
  if (inherits(db, "DBIConnection")) {
    DBI::dbDisconnect(db, shutdown = TRUE)
  }
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionClosed("ITPD-E", "itpde")
  }
}

itpde_status <- function(msg = TRUE) {
  expected_tables <- sort(itpde_tables())
  existing_tables <- sort(DBI::dbListTables(itpde_connect()))

  if (isTRUE(all.equal(expected_tables, existing_tables))) {
    status_msg <- crayon::green(paste(cli::symbol$tick,
    "The local itpde database is OK."))
    out <- TRUE
  } else {
    status_msg <- crayon::red(paste(cli::symbol$cross,
    "The local itpde database is empty, damaged or not compatible with your duckdb version. Download it with itpde_download()."))
    out <- FALSE
  }
  if (msg) msg(status_msg)
  invisible(out)
}

itpde_tables <- function() {
  c("itpde", "country_names", "industry_names", "sector_names")
}

itpde_cache <- new.env()
reg.finalizer(itpde_cache, itpde_disconnect_, onexit = TRUE)
