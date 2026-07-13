test_that("`estimand` method works", {
  withr::local_seed(42)
  ate <- fit_rctglm_ate()

  est1 <- estimand(ate)
  est2 <- est(ate)
  expect_equal(est1, est2)
  expect_equal(est2, ate$estimand)
  expect_named(est1, c("Estimate", "Std. Error"))
})

test_that("`coef` method works", {
  withr::local_seed(42)
  ate <- fit_rctglm_ate()

  expect_equal(coef(ate$glm), coef(ate))
  expect_snapshot(coef(ate))
})

test_that("`print` method works", {
  ate <- fit_rctglm_ate()

  expect_output(print(ate))
})
