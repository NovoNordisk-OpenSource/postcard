test_that("`default_power_model_list` returns list of models with predict methods", {
  l <- default_power_model_list()
  expect_type(l, "list")
  expect_no_error(
    lapply(l, get_predict_method)
  )
})

test_that("`repeat_power_marginaleffect` and plot snapshot tests", {
  withr::local_seed(42)

  train_data <- sim_power_train_data()
  model_list <- list(
    "ANCOVA" = glm(Y ~ W, data = train_data),
    "ANCOVA with prognostic score" = fit_best_learner(
      list(mod = Y ~ W),
      data = train_data,
      verbose = 0)
  )
  test_data_fun = function(n) {
    glm_data(Y ~ 1+1.5*log(W), W = stats::runif(n, min = 1, max = 50))
  }

  rpm <- repeat_power_marginaleffect(target_effect = 0.9, exposure_prob = 0.5, ns = seq(100, 500, 100),
                                     test_data_fun = test_data_fun, model_list = model_list)
  expect_snapshot(rpm)

  p <- plot(rpm)
  expect_equal(
    p, create_power_plot(rpm)
  )
  expect_doppelganger("plot_repeat_power_marginaleffect",
                      p)

  rpm_cars <- repeat_power_marginaleffect(target_effect = 0.9, exposure_prob = 0.5, ns = seq(5, 30, 5),
                                          test_data_fun = function(n) mtcars[1:n, ],
                                          model_list = list(ANCOVA = lm(mpg ~ wt + cyl, data = mtcars),
                                                            NullModel = lm(mpg ~ 1, data = mtcars)))
  expect_snapshot(rpm_cars)
})

test_that("`repeat_power_linear` and plot snapshot tests", {
  withr::local_seed(42)

  train_data <- sim_power_train_data()
  rpl <- repeat_power_linear(
    ate = 0.5,
    formula_list = list("ANCOVA 1 covariate" = Y ~ X, "ANCOVA 2 covariates" = Y ~ W + X),
    train_data = train_data)
  expect_snapshot(rpl)

  p <- plot(rpl)
  expect_equal(
    p, create_power_plot(rpl)
  )
  expect_doppelganger("plot_repeat_power_linear",
                      p)
})
