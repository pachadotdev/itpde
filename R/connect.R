usitcgravity_path <- function() {
  sys_usitcgravity_path <- Sys.getenv("USITCGRAVITY_DIR")
  sys_usitcgravity_path <- gsub("\\\\", "/", sys_usitcgravity_path)
  if (sys_usitcgravity_path == "") {
    return(gsub("\\\\", "/", tools::R_user_dir("usitcgravity")))
  } else {
    return(gsub("\\\\", "/", sys_usitcgravity_path))
  }
}

usitcgravity_check_status <- function() {
  if (!usitcgravity_status(FALSE)) {
    stop("The usitcgravity database is empty or damaged.
         Download it with usitcgravity_download().")
  }
}

#' Connect to the usitcgravity database
#'
#' Returns a local database connection. This corresponds to a DBI-compatible
#' DuckDB database.
#'
#' @param dir Database location on disk. Defaults to the `usitcgravity`
#' directory inside the R user folder or the `USITCGRAVITY_DIR` environment variable
#' if specified.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  DBI::dbListTables(usitcgravity_connect())
#'
#'  DBI::dbGetQuery(
#'   usitcgravity_connect(),
#'   'SELECT * FROM usitcgravity WHERE year = 2010'
#'  )
#' }
usitcgravity_connect <- function(dir = usitcgravity_path()) {
  duckdb_version <- utils::packageVersion("duckdb")
  db_file <- paste0(dir, "/usitcgravity_duckdb_v", gsub("\\.", "", duckdb_version), ".sql")

  db <- mget("usitcgravity_connect", envir = usitcgravity_cache, ifnotfound = NA)[[1]]

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
        "The local usitcgravity database is being used by another process. Try
        closing other R sessions or disconnecting the database using
        usitcgravity_disconnect() in the other sessions.",
        call. = FALSE
      )
    } else {
      stop(e)
    }
  },
  finally = NULL
  )

  assign("usitcgravity_connect", con, envir = usitcgravity_cache)
  con
}

#' Disconnect the usitcgravity database
#'
#' An auxiliary function to disconnect from the database.
#'
#' @examples
#' usitcgravity_disconnect()
#' @export
#'
usitcgravity_disconnect <- function() {
  usitcgravity_disconnect_()
}

usitcgravity_disconnect_ <- function(environment = usitcgravity_cache) {
  db <- mget("usitcgravity_connect", envir = usitcgravity_cache, ifnotfound = NA)[[1]]
  if (inherits(db, "DBIConnection")) {
    DBI::dbDisconnect(db, shutdown = TRUE)
  }
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionClosed("USITC Gravity Database", "usitcgravity")
  }
}

usitcgravity_status <- function(msg = TRUE) {
  expected_tables <- sort(usitcgravity_tables())
  existing_tables <- sort(DBI::dbListTables(usitcgravity_connect()))

  if (isTRUE(all.equal(expected_tables, existing_tables))) {
    status_msg <- crayon::green(paste(cli::symbol$tick,
    "The local usitcgravity database is OK."))
    out <- TRUE
  } else {
    status_msg <- crayon::red(paste(cli::symbol$cross,
    "The local usitcgravity database is empty, damaged or not compatible with your duckdb version. Download it with usitcgravity_download()."))
    out <- FALSE
  }
  if (msg) msg(status_msg)
  invisible(out)
}

usitcgravity_tables <- function() {
  c("trade", "gravity", "country_names", "region_names", "industry_names", "sector_names", "metadata")
}

usitcgravity_cache <- new.env()
reg.finalizer(usitcgravity_cache, usitcgravity_disconnect_, onexit = TRUE)
