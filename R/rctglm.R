#' Fit GLM and find any estimand (marginal effect) using plug-in estimation with variance estimation using
#' influence functions
#'
#' The procedure uses plug-in-estimation and influence functions to perform robust inference of any specified
#' estimand in the setting of a randomised clinical trial, even in the case of heterogeneous effect of
#' covariates in randomisation groups. See
#' [Powering RCTs for marginal effects with GLMs using prognostic score adjustment](https://arxiv.org/abs/2503.22284)
#' by Højbjerre-Frandsen et. al (2025) for more details on methodology.
#'
#' @inheritParams stats::glm
#' @inheritParams options
#' @param data an optional data frame, list or environment (or object coercible
#' by as.data.frame to a data frame) containing the variables in the model. If
#' not found in data, the variables are taken from environment(formula), typically
#' the environment from which the function is called.
#' @param formula an object of class "formula" (or one that can be coerced to that class):
#' a symbolic description of the model to be fitted. The details of model specification are
#' given under ‘Details’ in the [glm] documentation.
#' @param exposure_indicator (name of) the *binary* variable in `data` that
#' identifies randomisation groups. The variable is required to be binary currently.
#' @param exposure_prob a `numeric` with the probability of being in
#' "group 1" (rather than group 0) in groups defined by `exposure_indicator`.
#' @param estimand_fun a `function` with arguments `psi1` and `psi0` specifying
#' the estimand. Alternative, specify "ate" or "rate_ratio" as a `character`
#' to use one of the default estimand functions. See
#' more details in the "Estimand" section of [rctglm].
#' @param estimand_fun_deriv0 a `function` specifying the derivative of `estimand_fun` wrt. `psi0`. As a default
#' the algorithm will use symbolic differentiation to automatically find the derivative from `estimand_fun`
#' @param estimand_fun_deriv1 a `function` specifying the derivative of `estimand_fun` wrt. `psi1`. As a default
#' the algorithm will use symbolic differentiation to automatically find the derivative from `estimand_fun`
#' @param cv_variance a `logical` determining whether to estimate the variance
#' using cross-validation (see details of [rctglm]).
#' @param cv_variance_folds a `numeric` with the number of folds to use for cross
#' validation if `cv_variance` is `TRUE`.
#' @param ... Additional arguments passed to [stats::glm()]
#'
#' @details
#' The procedure assumes the setup of a randomised clinical trial with observations grouped by a binary
#' `exposure_indicator` variable, allocated randomly with probability `exposure_prob`. A GLM is
#' fit and then used to predict the response of all observations in the event that the `exposure_indicator`
#' is 0 and 1, respectively. Taking means of these predictions produce the *counterfactual means*
#' `psi0` and `psi1`, and an estimand `r(psi0, psi1)` is calculated using any specified `estimand_fun`.
#'
#' The variance of the estimand is found by taking the variance of the influence function of the estimand.
#' If `cv_variance` is `TRUE`, then the counterfactual predictions for each observation (which are
#' used to calculate the value of the influence function) is obtained as out-of-sample (OOS) predictions
#' using cross validation with number of folds specified by `cv_variance_folds`. The cross validation splits
#' are performed using stratified sampling with `exposure_indicator` as the `strata` argument in [rsample::vfold_cv].
#'
#' Read more in `vignette("model-fit")`.
#'
#' @section Estimands:
#' As noted in the description, `psi0` and `psi1` are the counterfactual means found by prediction using
#' a fitted GLM in the binary groups defined by `exposure_indicator`.
#'
#' Default estimand functions can be specified via `"ate"` (which uses the function
#' `function(psi1, psi0) psi1-psi0`) and `"rate_ratio"` (which uses the function
#' `function(psi1, psi0) psi1/psi0`). See more information on specifying the `estimand_fun`
#' in `vignette("model-fit")`.
#'
#' As a default, the `Deriv` package is used to perform symbolic differentiation to find the derivatives of
#' the `estimand_fun`.
#'
#' @returns `rctglm` returns an object of class inheriting from `"rctglm"`.
#'
#' An object of class `rctglm` is a list containing the following components:
#' \itemize{
#'    \item **`estimand`**: A `data.frame` with plug-in estimate of estimand, standard
#' error (SE) estimate and variance estimate of estimand
#'    \item `estimand_funs`: A `list` with
#'    \itemize{
#'      \item `f`: The `estimand_fun` used to obtain an estimate of the estimand from counterfactual means
#'      \item `d0`: The derivative with respect to `psi0`
#'      \item `d1`: The derivative with respect to `psi1`
#'    }
#'    \item `means_counterfactual`: A `data.frame` with counterfactual means `psi0` and `psi1`
#'    \item `fitted.values_counterfactual`: A `data.frame` with counterfactual mean
#'    values, obtained by transforming the linear predictors for each group
#'    by the inverse of the link function.
#'    \item `glm`: A `glm` object returned from running [stats::glm] within the procedure
#'    \item `call`: The matched `call`
#'  }
#'
#' @seealso
#' See how to extract information using methods in [rctglm_methods].
#'
#' Use [rctglm_with_prognosticscore()] to include prognostic covariate adjustment.
#'
#' See vignettes
#'
#' @examples
#' # Generate some data to showcase example
#' n <- 100
#' exp_prob <- .5
#'
#' dat_gaus <- glm_data(
#'   Y ~ 1+1.5*X1+2*A,
#'   X1 = rnorm(n),
#'   A = rbinom(n, 1, exp_prob),
#'   family = gaussian()
#' )
#'
#' # Fit the model
#' ate <- rctglm(formula = Y ~ .,
#'               exposure_indicator = A,
#'               exposure_prob = exp_prob,
#'               data = dat_gaus,
#'               family = gaussian)
#'
#' # Pull information on estimand
#' estimand(ate)
#'
#' ## Another example with different family and specification of estimand_fun
#' dat_binom <- glm_data(
#'   Y ~ 1+1.5*X1+2*A,
#'   X1 = rnorm(n),
#'   A = rbinom(n, 1, exp_prob),
#'   family = binomial()
#' )
#'
#' rr <- rctglm(formula = Y ~ .,
#'               exposure_indicator = A,
#'               exposure_prob = exp_prob,
#'               data = dat_binom,
#'               family = binomial(),
#'               estimand_fun = "rate_ratio")
#'
#' odds_ratio <- function(psi1, psi0) (psi1*(1-psi0))/(psi0*(1-psi1))
#' or <- rctglm(formula = Y ~ .,
#'               exposure_indicator = A,
#'               exposure_prob = exp_prob,
#'               data = dat_binom,
#'               family = binomial,
#'               estimand_fun = odds_ratio)
#'
#' @export
rctglm <- function(formula,
                   exposure_indicator,
                   exposure_prob,
                   data,
                   family = gaussian,
                   estimand_fun = "ate",
                   estimand_fun_deriv0 = NULL, estimand_fun_deriv1 = NULL,
                   cv_variance = FALSE,
                   cv_variance_folds = 10,
                   verbose = options::opt("verbose"),
                   ...
) {

  exposure_indicator <- rlang::enquo(exposure_indicator)
  args <- as.list(environment())
  cal <- match.call()
  formula <- check_formula(formula)
  family <- check_family(family)
  exposure_indicator_name <- get_indicator_name(exposure_indicator)
  check_exposure_indicator(data = data, exposure_indicator_name = exposure_indicator_name)
  check_exposure_prob(exposure_prob = exposure_prob)
  estimand_funs <- estimand_fun_setdefault_findderivs(
    estimand_fun = estimand_fun,
    estimand_fun_deriv0 = estimand_fun_deriv0,
    estimand_fun_deriv1 = estimand_fun_deriv1,
    verbose = verbose
  )

  args_glm <- c(args[names(args) %in% names(formals(glm))], list(...))
  model <- do.call(glm, args = args_glm)

  response_var <- model$y
  exposure_indicator_var <- data %>%
    dplyr::pull(tidyselect::all_of(exposure_indicator_name))

  full_model_fitted.values_counterfactual <- predict_counterfactual_means(
    model = model,
    exposure_indicator_name = exposure_indicator_name
  )
  full_model_means_counterfactual <- colMeans(full_model_fitted.values_counterfactual)
  full_model_means_counterfactual0 <- as.numeric(full_model_means_counterfactual["psi0"])
  full_model_means_counterfactual1 <- as.numeric(full_model_means_counterfactual["psi1"])

  estimate_estimand <- estimand_funs$f(
    psi1 = full_model_means_counterfactual1,
    psi0 = full_model_means_counterfactual0
  )

  # If cv_variance then use out-of-sample counterfactual predictions, otherwise
  # use predictions from full model fitted to all data
  preds_for_variance <- if (cv_variance) {
    oos_fitted.values_counterfactual(
      data = data,
      exposure_indicator_name = exposure_indicator_name,
      full_model.args_glm = args_glm,
      cv_variance_folds = cv_variance_folds
    )
  } else {
    full_model_fitted.values_counterfactual
  }

  if_marginaleffect_val <- if_marginaleffect(
    response_variable = response_var,
    exposure_indicator = exposure_indicator_var,
    exposure_prob = exposure_prob,
    counterfactual_pred0 = preds_for_variance$psi0,
    counterfactual_pred1 = preds_for_variance$psi1,
    counterfactual_mean0 = full_model_means_counterfactual0,
    counterfactual_mean1 = full_model_means_counterfactual1,
    estimand_fun_deriv0 = estimand_funs$d0,
    estimand_fun_deriv1 = estimand_funs$d1)

  var_estimand <- as.numeric(var(if_marginaleffect_val))
  se_estimand <- sqrt(var_estimand/nrow(data))

  data_estimand <- data.frame(Estimate = estimate_estimand,
                              `Std. Error` = se_estimand,
                              check.names = FALSE)

  out <- list(
    estimand = data_estimand,
    estimand_funs = estimand_funs,
    means_counterfactual = full_model_means_counterfactual,
    fitted.values_counterfactual = full_model_fitted.values_counterfactual,
    glm = model,
    call = cal
  )

  return(structure(out, class = c("rctglm", class(out))))
}
