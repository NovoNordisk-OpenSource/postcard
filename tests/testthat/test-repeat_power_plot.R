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

test_that("`summary.postcard_rpl` summarises power curves per model", {
  withr::local_seed(42)
  train_data <- sim_power_train_data()
  rpl <- repeat_power_linear(
    ate = 0.5,
    formula_list = list("ANCOVA 1 covariate" = Y ~ X, "ANCOVA 2 covariates" = Y ~ W + X),
    train_data = train_data,
    ns = seq(10, 400, 10))
  expect_false("std_error" %in% colnames(rpl))

  s <- summary(rpl)
  expect_s3_class(s, "summary.postcard_rpl")
  expect_equal(s$power_table$model, c("ANCOVA 1 covariate", "ANCOVA 2 covariates"))
  expect_equal(s$desired_power, 0.9)
  expect_equal(s$ns, c(10, 400))
  expect_equal(s$assumptions$power_fun, "power_gs")
  expect_equal(s$assumptions$target_effect, 0.5)
  expect_null(s$assumptions$df)

  for (m in unique(rpl$model)) {
    rpl_m <- rpl[rpl$model == m, ]
    tab_m <- s$power_table[s$power_table$model == m, ]
    expected_n <- if (any(rpl_m$flag_achieve_power)) min(rpl_m$n[rpl_m$flag_achieve_power]) else NA
    expect_equal(tab_m$n_achieve_power, expected_n)
    expect_equal(tab_m$power_at_max_n, rpl_m$power[rpl_m$n == 400])
    expect_equal(tab_m$max_power, max(rpl_m$power))
  }

  expect_output(out <- print(s), "Summary of power curves \\(class postcard_rpl\\)")
  expect_identical(out, s)
  expect_output(print(s), "Power approximation:\\s+power_gs")
  expect_output(print(s), "Sample sizes:\\s+10 to 400")
  expect_false(any(grepl("Degrees of freedom", capture.output(print(s)))))
})

test_that("`summary.postcard_rpl` handles `power_nc` and unreached desired power", {
  withr::local_seed(42)
  train_data <- sim_power_train_data()
  rpl_nc <- repeat_power_linear(
    ate = 0.5,
    formula_list = list("ANCOVA" = Y ~ X),
    train_data = train_data,
    power_fun = "power_nc",
    df = 997,
    ns = seq(10, 30, 10),
    desired_power = 0.99)

  s <- summary(rpl_nc)
  expect_true(is.na(s$power_table$n_achieve_power))
  expect_equal(s$assumptions$df, 997)
  expect_output(print(s), "Degrees of freedom:\\s+997")
  expect_output(print(s), "NA")
})

test_that("`summary.postcard_rpm` summarises power curves per model", {
  withr::local_seed(42)
  rpm <- repeat_power_marginaleffect(
    target_effect = 0.9, exposure_prob = 0.5, ns = seq(5, 30, 5),
    test_data_fun = function(n) mtcars[1:n, ],
    model_list = list(ANCOVA = lm(mpg ~ wt + cyl, data = mtcars),
                      NullModel = lm(mpg ~ 1, data = mtcars)))
  expect_false("std_error" %in% colnames(rpm))

  s <- summary(rpm)
  expect_s3_class(s, "summary.postcard_rpm")
  expect_equal(sort(s$power_table$model), c("ANCOVA", "NullModel"))
  expect_equal(s$ns, c(5, 30))
  expect_equal(s$assumptions$power_fun, "power_marginaleffect")
  expect_equal(s$assumptions$target_effect, 0.9)
  expect_equal(s$assumptions$exposure_prob, 0.5)

  anc <- rpm[rpm$model == "ANCOVA", ]
  tab_anc <- s$power_table[s$power_table$model == "ANCOVA", ]
  expect_equal(tab_anc$max_power, max(anc$power))
  expect_equal(tab_anc$power_at_max_n, anc$power[anc$n == 30])

  expect_output(out <- print(s), "Summary of power curves \\(class postcard_rpm\\)")
  expect_identical(out, s)
  expect_output(print(s), "Exposure probability:\\s+0.5")
})
