sql_action <- function() {
  if (requireNamespace("rstudioapi", quietly = TRUE) &&
      exists("documentNew", asNamespace("rstudioapi"))) {
    contents <- paste(
      "-- !preview conn=itpde::itpde_connect()",
      "",
      "SELECT * FROM itpde WHERE year = 2010",
      "",
      sep = "\n"
    )

    rstudioapi::documentNew(
      text = contents, type = "sql",
      position = rstudioapi::document_position(2, 40),
      execute = FALSE
    )
  }
}

itpde_pane <- function() {
  observer <- getOption("connectionObserver")
  if (!is.null(observer) && interactive()) {
    observer$connectionOpened(
      type = "ITPD-E",
      host = "itpde",
      displayName = "ITPD-E",
      icon = system.file("img", "edit-sql.png", package = "itpde"),
      connectCode = "itpde::itpde_pane()",
      disconnect = itpde::itpde_disconnect,
      listObjectTypes = function() {
        list(
          table = list(contains = "data")
        )
      },
      listObjects = function(type = "datasets") {
        tbls <- DBI::dbListTables(itpde_connect())
        data.frame(
          name = tbls,
          type = rep("table", length(tbls)),
          stringsAsFactors = FALSE
        )
      },
      listColumns = function(table) {
        res <- DBI::dbGetQuery(itpde_connect(),
                               paste("SELECT * FROM", table, "LIMIT 1"))
        data.frame(
          name = names(res), type = vapply(res, function(x) class(x)[1],
                                           character(1)),
          stringsAsFactors = FALSE
        )
      },
      previewObject = function(rowLimit, table) {
        DBI::dbGetQuery(itpde_connect(),
                        paste("SELECT * FROM", table, "LIMIT", rowLimit))
      },
      actions = list(
        Status = list(
          icon = system.file("img", "edit-sql.png", package = "itpde"),
          callback = itpde_status
        ),
        SQL = list(
          icon = system.file("img", "edit-sql.png", package = "itpde"),
          callback = sql_action
        )
      ),
      connectionObject = itpde_connect()
    )
  }
}

update_itpde_pane <- function() {
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionUpdated("ITPD-E", "itpde", "")
  }
}
