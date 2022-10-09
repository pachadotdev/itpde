#' Delete the itpde database from your computer
#'
#' Deletes the `itpde` directory and all of its contents, including
#' all versions of the itpde database created with any DuckDB version.
#'
#' @param ask If so, a menu will be displayed to confirm the action to
#' delete any existing itpde database. By default it is true.
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{ itpde_delete() }
itpde_delete <- function(ask = TRUE) {
  if (isTRUE(ask)) {
    answer <- utils::menu(c("Agree", "Cancel"),
                   title = "This will eliminate all itpde databases",
                   graphics = FALSE)
    if (answer == 2) {
       return(invisible())
    }
  }

  suppressWarnings(itpde_disconnect())
  try(unlink(itpde_path(), recursive = TRUE))
  update_itpde_pane()
  return(invisible())
}
