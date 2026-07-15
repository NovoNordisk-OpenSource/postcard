test_that("`rctglm_with_prognosticscore` snapshot tests", {
  dat <- sim_prognostic_data(family = gaussian())
  dat_treat <- dat$dat_treat
  dat_notreat <- dat$dat_notreat

  elapsed_time_pattern <- "\\d+\\.?\\d*m?s"
  expect_snapshot({
    ate <- fit_prognostic_ate(
      dat_treat = dat_treat,
      dat_notreat = dat_notreat,
      verbose = 2
    )
  },
  transform = function(x) gsub(elapsed_time_pattern, "", x))

  expect_s3_class(ate, "rctglm_prog")
  expect_s3_class(ate, "rctglm")

  expect_snapshot({
    ate_wo_cvvariance <- fit_prognostic_ate(
      dat_treat = dat_treat,
      dat_notreat = dat_notreat,
      cv_variance = FALSE,
      verbose = 0
    )
  },
  transform = function(x) gsub(elapsed_time_pattern, "", x))

  dat_pois <- sim_prognostic_data(family = poisson())
  dat_treat_pois <- dat_pois$dat_treat
  dat_notreat_pois <- dat_pois$dat_notreat

  rr_pois_wo_cvvariance <- fit_prognostic_ate(
    dat_treat = dat_treat_pois,
    dat_notreat = dat_notreat_pois,
    family = poisson(),
    estimand_fun = "rate_ratio",
    cv_variance = FALSE,
    verbose = 0
  )
  expect_snapshot(rr_pois_wo_cvvariance)

  rr_pois_with_cvvariance <- fit_prognostic_ate(
    dat_treat = dat_treat_pois,
    dat_notreat = dat_notreat_pois,
    family = poisson(),
    estimand_fun = "rate_ratio",
    cv_variance = TRUE,
    verbose = 0
  )
  expect_snapshot(rr_pois_with_cvvariance)

  rr_nb_wo_cvvariance <- fit_prognostic_ate(
    dat_treat = dat_treat_pois,
    dat_notreat = dat_notreat_pois,
    family = MASS::negative.binomial(2),
    estimand_fun = "rate_ratio",
    cv_variance = FALSE,
    verbose = 0
  )
  expect_snapshot(rr_nb_wo_cvvariance)

  rr_nb_with_cvvariance <- fit_prognostic_ate(
    dat_treat = dat_treat_pois,
    dat_notreat = dat_notreat_pois,
    family = MASS::negative.binomial(2),
    estimand_fun = "rate_ratio",
    cv_variance = TRUE,
    verbose = 0
  )
  expect_snapshot(rr_nb_with_cvvariance)
})

test_that("`cv_variance` produces same point estimates but different SE estimates", {
  withr::local_options(
    list(postcard.verbose = 0)
  )

  dat <- sim_prognostic_data(family = gaussian())
  dat_treat <- dat$dat_treat
  dat_notreat <- dat$dat_notreat

  ate_w_cvvariance <- fit_prognostic_ate(
    dat_treat, dat_notreat, cv_variance = TRUE)
  ate_wo_cvvariance <- fit_prognostic_ate(
    dat_treat, dat_notreat, cv_variance = FALSE)

  expect_equal(
    estimand(ate_wo_cvvariance)$Estimate,
    estimand(ate_w_cvvariance)$Estimate
  )
  expect_failure(
    expect_identical(
      estimand(ate_wo_cvvariance)$`Std. Error`,
      estimand(ate_w_cvvariance)$`Std. Error`
    )
  )
})

test_that("`prog_formula` manual specification consistent with default behavior", {
  withr::local_options(
    list(postcard.verbose = 0)
  )

  dat <- sim_prognostic_data(family = gaussian())
  dat_treat <- dat$dat_treat
  dat_notreat <- dat$dat_notreat

  # Note default behavior models response as all variables in data, in this case just W1
  ate_wo_prog_formula <- fit_prognostic_ate(
    dat_treat, dat_notreat, cv_variance = FALSE)

  ate_w_prog_formula <- fit_prognostic_ate(
    dat_treat, dat_notreat, cv_variance = FALSE,
    prog_formula = "Y ~ W1")

  expect_equal(est(ate_wo_prog_formula), est(ate_w_prog_formula))
})
