# Modify data to have the same value of a group identifier and then predict
predict_counterfactual_mean <- function(model,
                                        exposure_indicator_name,
                                        group_val,
                                        newdata = NULL,
                                        data = NULL) {
  if (is.null(data)) data <- model$data
  if (is.null(newdata)) newdata <- data
  newdata_same_group_val <- newdata %>%
    dplyr::mutate("{exposure_indicator_name}" := group_val)

  exposure_indicator_in_model <- exposure_indicator_name %in% names(coef(model))
  if (!exposure_indicator_in_model)
    cli::cli_abort("{.arg {exposure_indicator_name}} is not in {.arg {model}}. Specify name of a binary predictor in the {.arg {model}}")
  predict(model,
          type = "response",
          newdata = newdata_same_group_val)
}

predict_counterfactual_means <- function(model,
                                         exposure_indicator_name,
                                         newdata = NULL,
                                         data = NULL) {
  args <- as.list(environment())
  counterfactual_preds <- sapply(
    c(0,1),
    function(x) {
      do.call(
        predict_counterfactual_mean,
        c(args, list(group_val = x))
      )
    },
    simplify = FALSE
  ) %>%
    as.data.frame() %>%
    stats::setNames(c("psi0", "psi1"))

  return(counterfactual_preds)
}

# Default estimand functions
default_estimand_funs <- function(default = c("ate", "rate_ratio")) {
  default <- match.arg(default)

  switch(default,
         ate = function(psi1, psi0) psi1-psi0,
         rate_ratio = function(psi1, psi0) psi1/psi0
  )
}

# Do cross validation splits, fit models to training data and predict on test
# data to obtain out-of-sample predictions
oos_fitted.values_counterfactual <- function(
    data,
    exposure_indicator_name,
    full_model.args_glm,
    cv_variance_folds = 5
) {
  data <- data %>%
    dplyr::mutate(rowname = dplyr::row_number())
  folds <- rsample::vfold_cv(
    data,
    v = cv_variance_folds,
    strata = dplyr::all_of(exposure_indicator_name)
  )
  train_test_folds <- lapply(
    folds$splits,
    extract_train_test
  )

  out <- lapply(train_test_folds, function(x) {
    test_indices <- x$test$rowname
    x <- lapply(x, function(dat) dplyr::select(dat, -"rowname"))
    args_glm_copy <- full_model.args_glm
    args_glm_copy$data <- x$train

    model_train <- do.call(glm, args = args_glm_copy)

    preds <- predict_counterfactual_means(
      model = model_train,
      exposure_indicator_name = exposure_indicator_name,
      newdata = x$test
    ) %>%
      dplyr::mutate(rowname = as.numeric(test_indices))
    return(preds)
  }) %>%
    dplyr::bind_rows()

  # Added the rowname before, and sorting now to "collect" the out-of-sample
  # predictions in the same order as data was originally
  out <- out %>%
    dplyr::arrange(.data$rowname)

  return(out)
}


# x of class c("vfold_split", "rsplit"). Result of rsample::vfold_cv
extract_train_test <- function(x) {
  train_data <- x$data[x$in_id, ]
  out_id <- setdiff(1:nrow(x$data), x$in_id)
  test_data <- x$data[out_id, ]
  return(list(train = train_data, test = test_data))
}

get_indicator_name <- function(exposure_indicator) {
  ind_expr <- rlang::quo_get_expr(exposure_indicator)
  called_within_prognosticscore <- ind_expr == "exposure_indicator"
  if (called_within_prognosticscore) {
    exposure_indicator_name <- as.character(rlang::quo_get_expr(rlang::eval_tidy(exposure_indicator)))
  } else {
    exposure_indicator_name <- as.character(ind_expr)
  }
}

check_exposure_indicator <- function(data, exposure_indicator_name) {
  group_vals <- dplyr::pull(data, dplyr::all_of(exposure_indicator_name))
  group_vals_unique <- unique(group_vals)
  if (!all(c(0,1) %in% group_vals)) cli::cli_abort("{.var exposure_indicator} column can only have 1's and 0's")
  return(invisible())
}

check_exposure_prob <- function(exposure_prob) {
  exposure_prob_is_num <- inherits(exposure_prob, "numeric")
  exposure_in_range <- exposure_prob > 0 & exposure_prob < 1
  if (!exposure_prob_is_num | !exposure_in_range)
    cli::cli_abort("`exposure_prob` needs to be a probability, i.e. a numeric between 0 and 1")
  return(invisible())
}

# Symbolic differentiation of estimand_fun
deriv_estimand_fun <- function(fun, d0 = NULL, d1 = NULL, verbose = options::opt("verbose")) {
  args01 <- get01args(fun = fun)

  if (verbose >= 1) cli::cli_h2("Symbolic differentiation of estimand function")
  if (is.null(d0)) {
    d0 <- print_symbolic_differentiation(
      arg = args01[["arg0"]],
      fun = fun,
      add_string = "Alternatively, specify the derivative through the argument {.var estimand_fun_deriv0}\n",
      verbose = verbose)
  }
  if (is.null(d1)) {
    d1 <- print_symbolic_differentiation(
      arg = args01[["arg1"]],
      fun = fun,
      add_string = "Alternatively, specify the derivative through the argument {.var estimand_fun_deriv1}\n",
      verbose = verbose)
  }
  return(list(d0 = d0, d1 = d1))
}

estimand_fun_setdefault_findderivs <- function(
    estimand_fun, estimand_fun_deriv0, estimand_fun_deriv1, verbose = options::opt("verbose")
) {
  if (is.character(estimand_fun)) estimand_fun <- default_estimand_funs(estimand_fun)
  if (is.null(estimand_fun_deriv0) | is.null(estimand_fun_deriv1)) {
    derivs <- deriv_estimand_fun(
      fun = estimand_fun, d0 = estimand_fun_deriv0, d1 = estimand_fun_deriv1,
      verbose = verbose
    )
    estimand_fun_deriv0 <- derivs$d0
    estimand_fun_deriv1 <- derivs$d1
  }
  out <- list(
    f = estimand_fun,
    d0 = estimand_fun_deriv0,
    d1 = estimand_fun_deriv1
  )
  return(out)
}
