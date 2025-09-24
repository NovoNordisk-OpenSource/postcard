#' @name rctglm_methods
#' @rdname rctglm_methods
#'
#' @title Methods for objects of class `rctglm`
#'
#' @description
#' Methods mostly to extract information from model fit and inference. See
#' details for more information on each method.
#'
#' @param x an object of class `rctglm`
#' @param object an object of class `rctglm`
#' @param digits a `numeric` with the number of digits to display when printing
#' @param ... additional arguments passed to methods
#'
#' @details
#' The function [estimand] (or short-hand version [est]) can be used to extract
#' a `data.frame` with an estimated value and standard error of the estimand.
#'
#' A method for the generic [coef()] has been added for class `rctglm`, which
#' extracts coefficient information from the underlying `glm` fit
#' in the procedure. The same is true for the method defined for the [predict()] generic.
#' The method for an `rctglm` class object calls [predict.glm()] on the `glm` fit
#' contained within an `rctglm` object.
#'
#' @seealso The generic [rctglm()] which produces `rctglm` class objects.
#'
#' @returns
#' `estimand`/`est` returns a `data.frame` with columns `Estimate` and
#' `Std. Error` with the estimate and standard error of the estimand.
#'
#' See [coef()] and [predict.glm()] for details on what is returned by the corresponding
#' methods.
#'
#' @examples
#' # Generate some data to showcase example
#' n <- 100
#' exposure_prob <- .5
#' dat_binom <- glm_data(
#'   Y ~ 1+1.5*X1+2*A,
#'   X1 = rnorm(n),
#'   A = rbinom(n, 1, exposure_prob),
#'   family = binomial()
#' )
#'
#' # Fit the model
#' ate <- rctglm(formula = Y ~ .,
#'               exposure_indicator = A,
#'               exposure_prob = exposure_prob,
#'               data = dat_binom,
#'               family = binomial,
#'               estimand_fun = "ate")
#'
#' print(ate)
#' estimand(ate)
#' coef(ate)
NULL

#' @export
#' @rdname rctglm_methods
estimand <- function(object) {
  UseMethod("estimand")
}

#' @export
#' @rdname rctglm_methods
estimand.rctglm <- function(object) {
  object$estimand
}

#' @export
#' @rdname rctglm_methods
est <- function(object) {
  estimand(object)
}

#' @export
#' @rdname rctglm_methods
coef.rctglm <- function(object, ...) {
  coef(object$glm)
}

#' @rdname rctglm_methods
#' @export
predict.rctglm <- function(object, ...) {
  predict(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
print.rctglm <- function(x,
                         digits = max(3L, getOption("digits") - 3L),
                         ...) {
  mc_formatted <- format(x$means_counterfactual, digits = digits)
  cat("\nObject of class", class(x)[1], "\n\n")
  cat("Call:  ",
      paste(deparse(x$call), sep = "\n", collapse = "\n"), "\n\n", sep = "")
  cat("Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: ",
      mc_formatted["psi0"],
      "\n",
      sep = "")
  cat("Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: ",
      mc_formatted["psi1"],
      "\n",
      sep = "")
  print_estimand_info(x,
                      digits = digits,
                      ...)

  return(invisible())
}

print_estimand_info <- function(x,
                                digits = max(3L, getOption("digits") - 3L),
                                ...) {
  est_formatted <- format(est(x), digits = digits)
  cat("Estimand function r: ",
      deparse_fun_body(x$estimand_funs$f),
      "\n",
      sep = "")
  cat("Estimand (r(psi_1, psi_0)) estimate (SE): ",
      est_formatted[, "Estimate"],
      " (",
      est_formatted[, "Std. Error"],
      ")\n",
      sep = "")
  return(invisible())
}
