# Fitted-model and object fixtures shared across tests.

# A fitted glm on a small deterministic data set, used to test the
# counterfactual-mean prediction utilities.
fit_glm <- function(treat_diff = 10) {
  dat <- data.frame(
    Y = 1:(2 * treat_diff),
    X = rep(1:treat_diff, 2),
    A = c(rep(0, treat_diff), rep(1, treat_diff))
  )
  mod <- glm(Y ~ X + A, data = dat)
  list(data = dat, mod = mod, treat_diff = treat_diff)
}

# A set of fitted models of different classes, used to test the predict-method
# and newdata-argument helpers.
predict_method_models <- function() {
  list(
    lm_mod = lm(mpg ~ wt + cyl, data = mtcars),
    glm_mod = glm(vs ~ wt + cyl, data = mtcars, family = binomial()),
    dsl_mod = fit_best_learner(list(vs ~ wt + cyl), data = mtcars)
  )
}

# Fit an ATE `rctglm` model on simulated data, used to test rctglm methods.
fit_rctglm_ate <- function(data, exposure_prob = NULL,
                           family = gaussian, cv_variance = FALSE, ...) {
  if (is.null(exposure_prob)) exposure_prob <- unique(data$exposure_prob)
  data <- data[, setdiff(names(data), "exposure_prob")]
  rctglm(
    formula = Y ~ .,
    exposure_indicator = A,
    exposure_prob = exposure_prob,
    data = data,
    family = family,
    cv_variance = cv_variance,
    ...
  )
}

# Fit an ATE prognostic-score model with a fixed seed. Extra arguments are
# forwarded to `rctglm_with_prognosticscore()`.
fit_prognostic_ate <- function(dat_treat, dat_notreat,
                               exposure_prob = .5,
                               learners = example_learners(),
                               family = gaussian(),
                               estimand_fun = "ate",
                               cv_variance = TRUE, ...) {
  withr::with_seed(42, {
    rctglm_with_prognosticscore(
      formula = Y ~ .,
      exposure_indicator = A,
      exposure_prob = exposure_prob,
      data = dat_treat,
      family = family,
      estimand_fun = estimand_fun,
      data_hist = dat_notreat,
      learners = learners,
      cv_variance = cv_variance,
      ...
    )
  })
}
