test_that("`default_power_model_list` returns list of models with predict methods", {
  l <- default_power_model_list()
  expect_type(l, "list")
  expect_no_error(
    lapply(l, get_predict_method)
    )
})

test_that("`repeat_power_marginaleffect` works", {
  withr::local_seed(42)

  rpm <- repeat_power_marginaleffect(target_effect = 0.9, exposure_prob = 0.5, ns = seq(100, 500, 100))
  expect_snapshot(rpm)
  expect_doppelganger("plot_repeat_power_marginaleffect",
                      plot(rpm))
})

test_that("`repeat_power_linear` works", {
  withr::local_seed(42)

  train_data <- glm_data(
    Y ~ 1+1.5*log(W)+2*X,
    W = runif(1e3, min = 1, max = 10),
    X = rnorm(1e3, sd = 3)
  )
  rpl <- repeat_power_linear(
    ate = 0.5,
    formula_list = list("ANCOVA 1 covariate" = Y ~ X, "ANCOVA 2 covariates" = Y ~ W + X),
    train_data = train_data)
  expect_snapshot(rpl)
  expect_doppelganger("plot_repeat_power_linear",
                      plot(rpl))
})
