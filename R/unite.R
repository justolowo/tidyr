#' Unite multiple columns into one.
#'
#' Convenience function to paste together multiple functions into one.
#'
#' @inheritParams unite_
#' @param col (Bare) name of column to add
#' @param ... Specification of columns to unite. Use bare variable names.
#'   Select all variables between x and z with \code{x:z}, exclude y with
#'   \code{-y}. For more options, see the \link[dplyr]{select} documentation.
#' @seealso \code{\link{separate}()}, the complement.
#' @export
#' @examples
#' library(dplyr)
#' unite_(mtcars, "vs_am", c("vs","am"))
#'
#' # Separate is the complement of unite
#' mtcars %>%
#'   unite(vs_am, vs, am) %>%
#'   separate(vs_am, c("vs", "am"))
unite <- function(data, col, ..., sep = "_", remove = TRUE) {
  col <- col_name(substitute(col))
  from <- dplyr::select_vars(names(data), ...)

  unite_(data, col, from, sep = sep, remove = remove)
}

#' Standard-evaluation version of \code{unite}
#'
#' @keywords internal
#' @param data A data frame.
#' @param col Name of new column as string.
#' @param from Names of existing columns as character vector
#' @param sep Separator to use between values.
#' @param remove If \code{TRUE}, remove \code{col} from the data.
#' @export
unite_ <- function(data, col, from, sep = "_", remove = TRUE) {

  united <- do.call("paste", c(data[from], list(sep = sep)))

  first_col <- sort(which(names(data) %in% from))[1]
  data2 <- append_col(data, united, col, after = first_col - 1)

  if (remove) {
    data2 <- data2[setdiff(names(data2), from)]
  }

  data2
}