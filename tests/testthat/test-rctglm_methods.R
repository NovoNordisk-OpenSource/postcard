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

test_that("`rctglm` object does not inherit from `list`", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  expect_s3_class(ate, "rctglm")
  expect_false(inherits(ate, "list"))
  # But list-shaped access still works because typeof(x) is still "list"
  expect_type(ate, "list")
  expect_true(!is.null(ate$glm))
})

test_that("`est` matches `estimand`", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  expect_equal(est(ate), estimand(ate))
})

test_that("`summary` method returns a `summary.rctglm` object with expected table", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  s <- summary(ate)
  expect_s3_class(s, "summary.rctglm")
  expect_named(
    s,
    c("call", "estimand_fun", "counterfactual_means", "estimand_table",
      "null_value", "conf_level", "cv_variance", "glm_summary")
  )
  # ATE null is 0
  expect_equal(s$null_value, 0)
  # Table has the six expected columns
  expect_equal(
    colnames(s$estimand_table),
    c("Estimate", "Std. Error", "z value", "Pr(>|z|)", "2.5 %", "97.5 %")
  )
  # The underlying GLM summary is preserved
  expect_s3_class(s$glm_summary, "summary.glm")

  expect_output(print(s))
})

test_that("`summary` `level` argument changes the CI columns", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  s90 <- summary(ate, level = 0.9)
  expect_equal(
    tail(colnames(s90$estimand_table), 2),
    c("5.0 %", "95.0 %")
  )
})

test_that("`plot.rctglm` returns a ggplot", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  p <- plot(ate)
  expect_s3_class(p, "ggplot")
})

test_that("`confint.rctglm` returns Wald CI for the estimand", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  ci <- confint(ate)
  expect_equal(dim(ci), c(1L, 2L))
  expect_equal(rownames(ci), "Estimand")

  # Delegating to underlying GLM works
  ci_glm <- confint(ate, parm = "coefficients")
  expect_equal(dim(ci_glm), dim(confint(ate$glm)))
})

test_that("`vcov.rctglm` type argument switches between coef vcov and estimand var", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  # Default: coefficient vcov matches the underlying GLM
  expect_equal(vcov(ate), vcov(ate$glm))

  # Estimand variance is the squared standard error, as a 1x1 matrix
  vc_est <- vcov(ate, type = "estimand")
  expect_equal(dim(vc_est), c(1L, 1L))
  expect_equal(
    as.numeric(vc_est),
    estimand(ate)[["Std. Error"]]^2
  )
})

test_that("`rctglm` provides the glm-mirrored accessor methods", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  expect_identical(formula(ate), formula(ate$glm))
  expect_identical(family(ate)$family, family(ate$glm)$family)
  expect_identical(fitted(ate), fitted(ate$glm))
  expect_identical(nobs(ate), nobs(ate$glm))
  expect_identical(residuals(ate), residuals(ate$glm))
  expect_identical(deviance(ate), deviance(ate$glm))
  expect_identical(AIC(ate), AIC(ate$glm))
  expect_identical(dim(model.matrix(ate)), dim(model.matrix(ate$glm)))
})

test_that("`update.rctglm` re-runs the fit with an updated formula", {
  dat <- sim_rct_data()
  ate <- fit_rctglm_ate(dat)

  ate_up <- update(ate, . ~ A)
  expect_s3_class(ate_up, "rctglm")
  # The updated call has the new formula
  expect_equal(deparse1(formula(ate_up)), "Y ~ A")
})
