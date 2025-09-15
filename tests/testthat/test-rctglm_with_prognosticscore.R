test_that("`rctglm_with_prognosticscore` snapshot tests", {
  withr::local_seed(42)

  n <- 100
  b0 <- 1
  b1 <- 1.5
  b2 <- 2
  W1 <- runif(n, min = 1, max = 10)
  exposure_prob <- .5

  dat_treat <- glm_data(
    Y ~ b0+b1*log(W1)+b2*A,
    W1 = W1,
    A = rbinom (n, 1, exposure_prob)
  )
  dat_notreat <- glm_data(
    Y ~ b0+b1*log(W1),
    W1 = W1
  )

  learners <- list(
    mars = list(
      model = parsnip::mars(
        mode = "regression", prod_degree = 3) %>%
        parsnip::set_engine("earth")
    ),
    lm = list(
      model = parsnip::linear_reg() %>%
        parsnip::set_engine("lm")
    )
  )

  elapsed_time_pattern <- "\\d+\\.?\\d*m?s"
  expect_snapshot({
    ate <- withr::with_seed(42, {
      rctglm_with_prognosticscore(
        formula = Y ~ .,
        exposure_indicator = A,
        exposure_prob = exposure_prob,
        data = dat_treat,
        family = gaussian(),
        estimand_fun = "ate",
        data_hist = dat_notreat,
        learners = learners,
        cv_variance = TRUE,
        verbose = 2)
    })
  },
  transform = function(x) gsub(elapsed_time_pattern, "", x))

  expect_s3_class(ate, "rctglm_prog")
  expect_s3_class(ate, "rctglm")

  expect_snapshot({
    ate_wo_cvvariance <- withr::with_seed(42, {
      rctglm_with_prognosticscore(
        formula = Y ~ .,
        exposure_indicator = A,
        exposure_prob = exposure_prob,
        data = dat_treat,
        family = gaussian(),
        estimand_fun = "ate",
        data_hist = dat_notreat,
        learners = learners,
        cv_variance = FALSE,
        verbose = 0)
    })
  },
  transform = function(x) gsub(elapsed_time_pattern, "", x))

  n <- 100
  b0 <- 1
  b1 <- 1.5
  b2 <- 2
  W1 <- runif(n, min = 1, max = 10)
  dat_treat_pois <- glm_data(
    Y ~ b0+b1*log(W1)+b2*A,
    W1 = W1,
    A = rbinom (n, 1, exposure_prob),
    family = poisson()
  )
  dat_notreat_pois <- glm_data(
    Y ~ b0+b1*log(W1),
    W1 = W1,
    family = poisson()
  )

  rr_pois_wo_cvvariance <- withr::with_seed(42, {
    rctglm_with_prognosticscore(
      formula = Y ~ .,
      exposure_indicator = A,
      exposure_prob = exposure_prob,
      data = dat_treat_pois,
      family = poisson(),
      estimand_fun = "rate_ratio",
      data_hist = dat_notreat_pois,
      learners = learners,
      cv_variance = FALSE,
      verbose = 0)
  })
  expect_snapshot(rr_pois_wo_cvvariance)

  rr_pois_with_cvvariance <- withr::with_seed(42, {
    rctglm_with_prognosticscore(
      formula = Y ~ .,
      exposure_indicator = A,
      exposure_prob = exposure_prob,
      data = dat_treat_pois,
      family = poisson(),
      estimand_fun = "rate_ratio",
      data_hist = dat_notreat_pois,
      learners = learners,
      cv_variance = TRUE,
      verbose = 0)
  })
  expect_snapshot(rr_pois_with_cvvariance)

  rr_nb_wo_cvvariance <- withr::with_seed(42, {
    rctglm_with_prognosticscore(
      formula = Y ~ .,
      exposure_indicator = A,
      exposure_prob = exposure_prob,
      data = dat_treat_pois,
      family = MASS::negative.binomial(2),
      estimand_fun = "rate_ratio",
      data_hist = dat_notreat_pois,
      learners = learners,
      cv_variance = FALSE,
      verbose = 0)
  })
  expect_snapshot(rr_nb_wo_cvvariance)

  rr_nb_with_cvvariance <- withr::with_seed(42, {
    rctglm_with_prognosticscore(
      formula = Y ~ .,
      exposure_indicator = A,
      exposure_prob = exposure_prob,
      data = dat_treat_pois,
      family = MASS::negative.binomial(2),
      estimand_fun = "rate_ratio",
      data_hist = dat_notreat_pois,
      learners = learners,
      cv_variance = TRUE,
      verbose = 0)
  })
  expect_snapshot(rr_nb_with_cvvariance)
})

test_that("`cv_variance` produces same point estimates but different SE estimates", {
  withr::local_seed(42)
  withr::local_options(
    list(postcard.verbose = 0)
  )

  n <- 100
  b0 <- 1
  b1 <- 1.5
  b2 <- 2
  W1 <- runif(n, min = 1, max = 10)
  exposure_prob <- .5

  dat_treat <- glm_data(
    Y ~ b0+b1*log(W1)+b2*A,
    W1 = W1,
    A = rbinom (n, 1, exposure_prob)
  )
  dat_notreat <- glm_data(
    Y ~ b0+b1*log(W1),
    W1 = W1
  )

  learners <- list(
    mars = list(
      model = parsnip::mars(
        mode = "regression", prod_degree = 3) %>%
        parsnip::set_engine("earth")
    ),
    lm = list(
      model = parsnip::linear_reg() %>%
        parsnip::set_engine("lm")
    )
  )

  ate_w_cvvariance <- withr::with_seed(42, {
      rctglm_with_prognosticscore(
        formula = Y ~ .,
        exposure_indicator = A,
        exposure_prob = exposure_prob,
        data = dat_treat,
        family = gaussian(),
        estimand_fun = "ate",
        data_hist = dat_notreat,
        learners = learners,
        cv_variance = TRUE)
    })
  ate_wo_cvvariance <- withr::with_seed(42, {
      rctglm_with_prognosticscore(
        formula = Y ~ .,
        exposure_indicator = A,
        exposure_prob = exposure_prob,
        data = dat_treat,
        family = gaussian(),
        estimand_fun = "ate",
        data_hist = dat_notreat,
        learners = learners,
        cv_variance = FALSE)
    })

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
  withr::local_seed(42)
  withr::local_options(
    list(postcard.verbose = 0)
  )

  n <- 100
  b0 <- 1
  b1 <- 1.5
  b2 <- 2
  W1 <- runif(n, min = 1, max = 10)
  exposure_prob <- .5

  dat_treat <- glm_data(
    Y ~ b0+b1*log(W1)+b2*A,
    W1 = W1,
    A = rbinom (n, 1, exposure_prob)
  )
  dat_notreat <- glm_data(
    Y ~ b0+b1*log(W1),
    W1 = W1
  )

  learners <- list(
    mars = list(
      model = parsnip::mars(
        mode = "regression", prod_degree = 3) %>%
        parsnip::set_engine("earth")
    ),
    lm = list(
      model = parsnip::linear_reg() %>%
        parsnip::set_engine("lm")
    )
  )

  # Note default behavior models response as all variables in data, in this case just W1
  ate_wo_prog_formula <- withr::with_seed(42, {
      rctglm_with_prognosticscore(
        formula = Y ~ .,
        exposure_indicator = A,
        exposure_prob = exposure_prob,
        data = dat_treat,
        family = gaussian(),
        estimand_fun = "ate",
        data_hist = dat_notreat,
        learners = learners,
        cv_variance = FALSE)
    })

  ate_w_prog_formula <- withr::with_seed(42, {
    rctglm_with_prognosticscore(
      formula = Y ~ .,
      exposure_indicator = A,
      exposure_prob = exposure_prob,
      data = dat_treat,
      family = gaussian(),
      estimand_fun = "ate",
      data_hist = dat_notreat,
      learners = learners,
      cv_variance = FALSE,
      prog_formula = "Y ~ W1")
  })

  expect_equal(est(ate_wo_prog_formula), est(ate_w_prog_formula))
})
