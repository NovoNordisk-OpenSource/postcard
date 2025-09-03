#' Find the best learner in terms of RMSE among specified learners using cross validation
#'
#' @inheritParams rctglm
#'
#' @param data A data frame.
#' @param preproc A list (preferably named) with preprocessing objects:
#' formulas, recipes, or [workflows::workflow_variables()]. Passed to
#' [workflowsets::workflow_set()].
#' @param cv_folds a `numeric` with the number of cross-validation folds used when fitting and
#' evaluating models
#' @param learners a `list` (preferably named) containing named lists of elements
#' `model` and optionally `grid`. The `model` element should be a `parsnip`
#' model specification, which is passed to [workflowsets::workflow_set] as the
#' `model` argument, while the `grid` element is passed as the `grid` argument
#' of [workflowsets::option_add]
#'
#' @details
#' Ensure data compatibility with the learners.
#'
#' @returns a trained `workflow`
#'
#' @seealso
#' See [rctglm_with_prognosticscore()] for a function that utilises this
#' function to perform prognostic covariate adjustment.
#'
#' @examples
#' # Generate some synthetic 2-armed RCT data along with historical controls
#' n <- 100
#' dat_rct <- glm_data(
#'   Y ~ 1+2*x1+3*a,
#'   x1 = rnorm(n, 2),
#'   a = rbinom (n, 1, .5),
#'   family = gaussian()
#' )
#' dat_hist <- glm_data(
#'   Y ~ 1+2*x1,
#'   x1 = rnorm(n, 2),
#'   family = gaussian()
#' )
#'
#' # Fit a learner to the historical control data
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
#' fit <- fit_best_learner(
#'   preproc = list(mod = Y ~ .),
#'   data = dat_hist,
#'   learners = learners
#' )
#'
#' # Use it fx. to predict the "control outcome" in the 2-armed RCT
#' predict(fit, new_data = dat_rct)
#'
#' @export
fit_best_learner <- function(preproc, data, cv_folds = 5, learners = default_learners(),
                             verbose = options::opt("verbose")) {
  cv_folds <- rsample::vfold_cv(data, v = cv_folds)
  lrnr <- get_best_learner(resamples = cv_folds,
                     learners = learners,
                     preproc = preproc,
                     verbose = verbose)
  lrnr_fit <- generics::fit(lrnr, data)

  return(lrnr_fit)
}

#' Creates a list of learners
#'
#' This function creates a list of learners compatible with the `learners`
#' argument of [fit_best_learner], which is used as the default argument.
#'
#' @returns a named `list` of learners, where each element consists of a
#' - `model`: A `parsnip` model specification
#' - `grid`: A `data.frame` with columns corresponding to tuning parameters
#'
#' @examples
#' default_learners()
#'
#' @export
default_learners <- function() {
  list(
    mars = list(
      model = parsnip::mars(
        mode = "regression", prod_degree = 3) %>%
        parsnip::set_engine("earth")
    ),
    lm = list(
      model = parsnip::linear_reg() %>%
        parsnip::set_engine("lm")
    ),
    gbt = list(
      model = parsnip::boost_tree(
        mode = "regression",
        trees = parsnip::tune("trees"),
        tree_depth = parsnip::tune("tree_depth"),
        learn_rate = 0.1
      ) %>%
        parsnip::set_engine("xgboost"),
      grid = data.frame(
        trees = seq(from = 25, to = 500, by = 25),
        tree_depth = 3
      )
    )
  )
}

# set up the pre-processing of the work flow
get_preproc_names <- function(wf) {
  wf %>%
    dplyr::pull(.data$wflow_id) %>%
    sapply(function(x) gsub("\\_.*$", "", x)) %>%
    unique()
}

# function to add learners with the pre-processing
add_learners <- function(preproc, learners) {
  wf <- workflowsets::workflow_set(
    preproc = preproc,
    models = learners %>%
      lapply(function(x) x$model)
  )
  for (learner_name in names(learners)){
    for (preproc_name in get_preproc_names(wf)) {
      wf <- wf %>%
        workflowsets::option_add(
          id = stringr::str_c(preproc_name, "_", learner_name),
          grid = learners[[learner_name]]$grid
        )
    }
  }
  wf
}

# K fold cross validation with recipe -------------------------------------
get_best_learner <- function(
    resamples,
    preproc,
    learners = default_learners(),
    verbose = options::opt("verbose")
) {
  wfs <- add_learners(preproc = preproc,
                      learners = learners)

  if (verbose >= 1) {
    cli::cli_alert_info("Fitting learners")
    cli::cli_ul(wfs$wflow_id)
  }

  print_model_tuning <- ifelse(verbose >= 2, TRUE, FALSE)
  fit_learners <- wfs %>%
    workflowsets::workflow_map(
      resamples = resamples,
      metrics = yardstick::metric_set(yardstick::rmse),
      verbose = print_model_tuning
    )

  best_learner_name <- fit_learners %>%
    workflowsets::rank_results(rank_metric = 'rmse') %>%
    dplyr::select("wflow_id", "model", ".config", rmse=mean, rank) %>%
    dplyr::filter(dplyr::row_number() == 1) %>%
    dplyr::pull("wflow_id")

  if (verbose >= 1) {
    cli::cli_alert_info("Model with lowest RMSE: {best_learner_name}")
  }

  best_params <- fit_learners %>%
    workflowsets::extract_workflow_set_result(best_learner_name) %>%
    tune::select_best(metric='rmse')

  fit_learners %>%
    tune::extract_workflow(best_learner_name) %>%
    tune::finalize_workflow(best_params)
}
