sql_action <- function() {
  if (requireNamespace("rstudioapi", quietly = TRUE) &&
      exists("documentNew", asNamespace("rstudioapi"))) {
    contents <- paste(
      "-- !preview conn=usitcgravity::usitcgravity_connect()",
      "",
      "SELECT * FROM usitcgravity WHERE year = 2010",
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

usitcgravity_pane <- function() {
  observer <- getOption("connectionObserver")
  if (!is.null(observer) && interactive()) {
    observer$connectionOpened(
      type = "USITC Gravity Database",
      host = "usitcgravity",
      displayName = "USITC Gravity Database",
      icon = system.file("img", "edit-sql.png", package = "usitcgravity"),
      connectCode = "usitcgravity::usitcgravity_pane()",
      disconnect = usitcgravity::usitcgravity_disconnect,
      listObjectTypes = function() {
        list(
          table = list(contains = "data")
        )
      },
      listObjects = function(type = "datasets") {
        tbls <- DBI::dbListTables(usitcgravity_connect())
        data.frame(
          name = tbls,
          type = rep("table", length(tbls)),
          stringsAsFactors = FALSE
        )
      },
      listColumns = function(table) {
        res <- DBI::dbGetQuery(usitcgravity_connect(),
                               paste("SELECT * FROM", table, "LIMIT 1"))
        data.frame(
          name = names(res), type = vapply(res, function(x) class(x)[1],
                                           character(1)),
          stringsAsFactors = FALSE
        )
      },
      previewObject = function(rowLimit, table) {
        DBI::dbGetQuery(usitcgravity_connect(),
                        paste("SELECT * FROM", table, "LIMIT", rowLimit))
      },
      actions = list(
        Status = list(
          icon = system.file("img", "edit-sql.png", package = "usitcgravity"),
          callback = usitcgravity_status
        ),
        SQL = list(
          icon = system.file("img", "edit-sql.png", package = "usitcgravity"),
          callback = sql_action
        )
      ),
      connectionObject = usitcgravity_connect()
    )
  }
}

update_usitcgravity_pane <- function() {
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionUpdated("USITC Gravity Database", "usitcgravity", "")
  }
}
