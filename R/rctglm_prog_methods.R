#' Extract information about the fitted prognostic model
#'
#' Extracts the `prognostic_info` element from an `rctglm_prog` object. The
#' element is an object of class `prognostic_info` (a list) with the structure
#' described in the `Value` section of [rctglm_with_prognosticscore]. `print`
#' and `summary` methods are provided for `prognostic_info` objects.
#'
#' @param x,object an object of class `rctglm_prog` (returned by
#' [rctglm_with_prognosticscore]), or (for the `prognostic_info` methods)
#' an object of class `prognostic_info` returned by [prog()].
#' @param ... additional arguments passed to methods (currently unused).
#'
#' @returns
#' `prog` returns an object of class `prognostic_info`. The methods for
#' `prognostic_info` return the object invisibly (`print`) or a
#' `summary.prognostic_info` object (`summary`).
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

#' @export
#' @rdname prog
print.prognostic_info <- function(x, ...) {
  cat("\nObject of class prognostic_info\n\n")
  cat("Formula: ", deparse(x$formula), "\n", sep = "")
  cat("Number of candidate learners: ", length(x$learners), "\n", sep = "")
  cat("Learner names: ", paste(names(x$learners), collapse = ", "), "\n", sep = "")
  cat("CV folds: ", x$cv_folds, "\n", sep = "")
  cat("Historical data: ", nrow(x$data), " rows, ",
      ncol(x$data), " columns\n", sep = "")
  return(invisible(x))
}

#' @export
#' @rdname prog
summary.prognostic_info <- function(object, ...) {
  # Best-effort extraction of the fitted workflow's class
  workflow_class <- tryCatch(class(object$model_fit),
                             error = function(e) NULL)
  structure(
    list(
      formula = object$formula,
      n_learners = length(object$learners),
      learner_names = names(object$learners),
      cv_folds = object$cv_folds,
      n_hist = nrow(object$data),
      n_hist_cols = ncol(object$data),
      workflow_class = workflow_class
    ),
    class = "summary.prognostic_info"
  )
}

#' @export
#' @rdname prog
print.summary.prognostic_info <- function(x, ...) {
  cat("\nSummary of prognostic_info\n\n")
  cat("Formula: ", deparse(x$formula), "\n", sep = "")
  cat("Discrete super learner over ", x$n_learners,
      " candidate learner(s): ",
      paste(x$learner_names, collapse = ", "), "\n", sep = "")
  cat("CV folds used: ", x$cv_folds, "\n", sep = "")
  cat("Historical data: ", x$n_hist, " rows x ", x$n_hist_cols, " cols\n", sep = "")
  if (!is.null(x$workflow_class))
    cat("Underlying model_fit class: ",
        paste(x$workflow_class, collapse = ", "), "\n", sep = "")
  return(invisible(x))
}
