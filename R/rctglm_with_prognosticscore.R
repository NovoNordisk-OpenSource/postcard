#' Use prognostic covariate adjustment when fitting an [rctglm]
#'
#' The procedure uses [fit_best_learner] to fit a prognostic model to historical data and uses
#' the model to produce counterfactual predictions as a prognostic score that is then adjusted
#' for as a covariate in the [rctglm] procedure. See
#' [Powering RCTs for marginal effects with GLMs using prognostic score adjustment](https://arxiv.org/abs/2503.22284)
#' by Højbjerre-Frandsen et. al (2025) for more details.
#'
#' @inheritParams rctglm
#' @inheritParams fit_best_learner
#'
#' @param data_hist a `data.frame` with historical data on which to fit a prognostic model
#' @param prog_formula an object of class "formula" (or one that can be coerced to that class):
#' a symbolic description of the prognostic model to be fitted to `data_hist`. Passed in a
#' list as the `preproc` argument in [fit_best_learner()]. As a default,
#' the formula is created by modelling the response (assumed to have the same name as in
#' `formula`) using all columns in `data_hist`.
#' @param cv_prog_folds a `numeric` with the number of cross-validation folds used when fitting and
#' evaluating models
#'
#' @details
#' Prognostic covariate adjustment involves training a prognostic model (using
#' [fit_best_learner]) on historical data (`data_hist`) to predict the response
#' in that data.
#'
#' Assuming that the
#' historical data is representative of the comparator group in a “new” data
#' set (group 0 of the binary `exposure_indicator` in `data`), we can use the
#' prognostic model to predict the counterfactual
#' outcome of all observations (including the ones in the comparator group
#' for which the prediction of counterfactual outcome coincides with a
#' prediction of actual outcome).
#'
#' This prediction, which is called the prognostic score, is then used as an
#' adjustment covariate in the GLM (the prognostic score is added to `formula`
#' before calling [rctglm] with the modified formula).
#'
#' See much more details in the reference in the description.
#'
#' @returns `rctglm_with_prognosticscore` returns an object of class `rctglm_prog`,
#' which inherits from [rctglm].
#'
#' An `rctglm_prog` object is a list with the same components as an [rctglm] object
#' (see the **`Value`** section of [rctglm] for a breakdown of the structure),
#' but with an additional list element of:
#' - `prognostic_info`: List with information about the fitted prognostic model
#' on historical data. It has components:
#'    - `formula`: The `formula` with symbolic description of how the response
#'    is modelled as function of covariates in the models
#'    - `model_fit`: A trained `workflow` - the result of [fit_best_learner]
#'    - `learners`: A `list` of learners used for the discrete super learner
#'    - `cv_folds`: The amount of folds used for cross validation
#'    - `data`: The historical data used for cross validation when fitting and
#'    testing models
#'
#' @seealso
#' Method to extract information of the prognostic model in [prog]. Function
#' used to fit the prognostic model is [fit_best_learner()].
#'
#' See [rctglm()] for the function and class this inherits from.
#'
#' @examples
#' # Generate some data
#' n <- 100
#' b0 <- 1
#' b1 <- 1.5
#' b2 <- 2
#' W1 <- runif(n, min = -2, max = 2)
#' exp_prob <- .5
#'
#' dat_treat <- glm_data(
#'   Y ~ b0+b1*sin(W1)^2+b2*A,
#'   W1 = W1,
#'   A = rbinom (n, 1, exp_prob)
#' )
#'
#' dat_notreat <- glm_data(
#'   Y ~ b0+b1*sin(W1)^2,
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
#'  ),
#'     lm = list(
#'       model = parsnip::set_engine(
#'         parsnip::linear_reg(),
#'         "lm"
#'       )
#'     )
#' )
#' ate <- rctglm_with_prognosticscore(
#'   formula = Y ~ .,
#'   exposure_indicator = A,
#'   exposure_prob = exp_prob,
#'   data = dat_treat,
#'   family = gaussian(),
#'   estimand_fun = "ate",
#'   data_hist = dat_notreat,
#'   learners = learners)
#'
#' # Pull information on estimand
#' estimand(ate)
#'
#' @export
rctglm_with_prognosticscore <- function(
    formula,
    exposure_indicator,
    exposure_prob,
    data,
    family = gaussian,
    estimand_fun = "ate",
    estimand_fun_deriv0 = NULL, estimand_fun_deriv1 = NULL,
    cv_variance = FALSE,
    cv_variance_folds = 10,
    ...,
    data_hist,
    prog_formula = NULL,
    cv_prog_folds = 5,
    learners = default_learners(),
    verbose = options::opt("verbose")) {

  call <- match.call()

  exposure_indicator <- rlang::enquo(exposure_indicator)
  named_args <- as.list(environment())
  extra_glm_args <- list(...)

  formula <- check_formula(formula)
  family <- check_family(family)

  if (verbose >= 1) cli::cli_h2("Fitting prognostic model")
  if (is.null(prog_formula)) {
    is_response_in_data(formula, data = data_hist)
    prog_formula <- formula_everything(formula)
    if (verbose >= 1)
      cli::cli_alert_info("Created formula for fitting prognostic model as: {deparse(prog_formula)}")
  }
  prog_formula <- check_formula(prog_formula)

  lrnr_fit <- fit_best_learner(preproc = list(mod = prog_formula),
                               data = data_hist,
                               cv_folds = cv_prog_folds,
                               learners = learners,
                               verbose = verbose)

  lrnr_pred <- predict(lrnr_fit, data) %>%
    dplyr::pull(.data$.pred)
  data <- data %>%
    dplyr::mutate(link_prog = family$linkfun(lrnr_pred))

  if (verbose >= 2)
    cli::cli_alert_info("Investigate trained learners and fitted model in {.var prognostic_info} list element")

  formula_with_prognosticscore <- paste0(formula_to_str(formula), " + link_prog")

  rctglm_with_prognosticscore <- rctglm(
    formula = formula_with_prognosticscore,
    family = family,
    data = data,
    exposure_indicator = exposure_indicator,
    exposure_prob = exposure_prob,
    estimand_fun = estimand_fun,
    estimand_fun_deriv0 = estimand_fun_deriv0,
    estimand_fun_deriv1 = estimand_fun_deriv1,
    cv_variance = cv_variance,
    cv_variance_folds = cv_variance_folds,
    verbose = verbose,
    ...
  )

  prog_info <- list(
    prognostic_info = list(
      formula = prog_formula,
      model_fit = lrnr_fit,
      learners = learners,
      cv_folds = cv_prog_folds,
      data = data_hist
    ))

  list_with_prognostic_info <- c(rctglm_with_prognosticscore, prog_info)
  list_with_prognostic_info$call <- call

  out <- structure(list_with_prognostic_info,
                   class = c("rctglm_prog",
                             class(rctglm_with_prognosticscore)
                   )
  )

  return(out)
}
