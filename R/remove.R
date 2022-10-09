#' Delete the usitcgravity database from your computer
#'
#' Deletes the `usitcgravity` directory and all of its contents, including
#' all versions of the usitcgravity database created with any DuckDB version.
#'
#' @param ask If so, a menu will be displayed to confirm the action to
#' delete any existing usitcgravity database. By default it is true.
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{ usitcgravity_delete() }
usitcgravity_delete <- function(ask = TRUE) {
  if (isTRUE(ask)) {
    answer <- utils::menu(c("Agree", "Cancel"),
                   title = "This will eliminate all usitcgravity databases",
                   graphics = FALSE)
    if (answer == 2) {
       return(invisible())
    }
  }

  suppressWarnings(usitcgravity_disconnect())
  try(unlink(usitcgravity_path(), recursive = TRUE))
  update_usitcgravity_pane()
  return(invisible())
}
