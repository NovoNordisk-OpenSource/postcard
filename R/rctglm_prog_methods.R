#' Extract information about the fitted prognostic model
#'
#' Extracts the `prognostic_info` list element from an `rctglm_prog` object. See
#' 'Value' at [rctglm_with_prognosticscore] for more details.
#'
#' @param x an object of class `rctglm_prog` (returned by
#' [rctglm_with_prognosticscore])
#'
#' @returns a list with the structure described of `prognostic_info` in the
#' `Value` section of [rctglm_with_prognosticscore].
#'
#' @seealso The generic [rctglm_with_prognosticscore()] for which this method
#' works.
#'
#' @examples
#' # Generate some data
#' n <- 100
#' b0 <- 1
#' b1 <- 1.5
#' b2 <- 2
#' W1 <- runif(n, min = 1, max = 10)
#' exposure_prob <- .5
#'
#' dat_treat <- glm_data(
#'   Y ~ b0+b1*log(W1)+b2*A,
#'   W1 = W1,
#'   A = rbinom(n, 1, exposure_prob)
#' )
#'
#' dat_notreat <- glm_data(
#'   Y ~ b0+b1*log(W1),
#'   W1 = W1
#' )
#'
#' learners <- list(
#'   mars = list(
#'     model = parsnip::set_engine(
#'       parsnip::mars(
#'         mode = "regression", prod_degree = 3
#'       ),
#'       "earth"
#'     )
#'   )
#' )
#' ate <- rctglm_with_prognosticscore(
#'   formula = Y ~ .,
#'   exposure_indicator = A,
#'   exposure_prob = exposure_prob,
#'   data = dat_treat,
#'   family = gaussian(),
#'   estimand_fun = "ate",
#'   data_hist = dat_notreat,
#'   learners = learners)
#'
#' prog(ate)
#'
#' @export
prog <- function(x) {
  UseMethod("prog")
}

#' @export
#' @rdname prog
prog.rctglm_prog <- function(x) {
  x$prognostic_info
}
