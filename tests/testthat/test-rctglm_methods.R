test_that("`estimand` method works", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  est1 <- estimand(ate)
  est2 <- est(ate)
  expect_equal(est1, est2)
  expect_equal(est2, ate$estimand)
  expect_named(est1, c("Estimate", "Std. Error"))
})

test_that("`coef` method works", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  expect_equal(coef(ate$glm), coef(ate))
  expect_snapshot(coef(ate))
})

test_that("`print` method works", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  expect_output(print(ate))
})
