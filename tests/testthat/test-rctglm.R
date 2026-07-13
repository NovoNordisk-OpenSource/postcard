test_that("`rctglm` snapshot tests", {
  withr::local_seed(42)
  n <- 100
  exposure_prob <- .5
  dat_gaus <- sim_rct_data(n = n, exposure_prob = exposure_prob)
  dat_pois <- sim_rct_data(n = n, exposure_prob = exposure_prob, family = poisson())

  ate_with_cv <- rctglm(formula = Y ~ .,
                        exposure_indicator = A,
                        exposure_prob = exposure_prob,
                        data = dat_gaus,
                        family = gaussian,
                        cv_variance = TRUE)
  expect_s3_class(ate_with_cv, "rctglm")
  expect_snapshot(estimand(ate_with_cv))

  ate_wo_cv <- rctglm(formula = Y ~ .,
                      exposure_indicator = A,
                      exposure_prob = exposure_prob,
                      data = dat_gaus,
                      family = gaussian,
                      cv_variance = FALSE)
  expect_snapshot(estimand(ate_wo_cv))

  rr_with_cv <- rctglm(formula = Y ~ .,
                       exposure_indicator = A,
                       exposure_prob = exposure_prob,
                       data = dat_pois,
                       family = poisson(),
                       cv_variance = TRUE)
  expect_snapshot(estimand(rr_with_cv))

  rr_wo_cv <- rctglm(formula = Y ~ .,
                     exposure_indicator = A,
                     exposure_prob = exposure_prob,
                     data = dat_pois,
                     family = poisson(),
                     cv_variance = FALSE)
  expect_snapshot(estimand(rr_wo_cv))
})

test_that("`cv_variance` produces same point estimates but different SE estimates", {
  withr::local_seed(42)
  withr::local_options(
    list(postcard.verbose = 0)
  )

  n <- 100
  exposure_prob <- .5
  dat_gaus <- sim_rct_data(n = n, exposure_prob = exposure_prob)

  ate_with_cv <- rctglm(formula = Y ~ .,
                        exposure_indicator = A,
                        exposure_prob = exposure_prob,
                        data = dat_gaus,
                        family = gaussian,
                        cv_variance = TRUE)
  ate_wo_cv <- rctglm(formula = Y ~ .,
                      exposure_indicator = A,
                      exposure_prob = exposure_prob,
                      data = dat_gaus,
                      family = gaussian,
                      cv_variance = FALSE)
  expect_equal(
    estimand(ate_wo_cv)$Estimate,
    estimand(ate_with_cv)$Estimate
  )
  expect_failure(
    expect_identical(
      estimand(ate_wo_cv)$`Std. Error`,
      estimand(ate_with_cv)$`Std. Error`
    )
  )
})

test_that("Different `cv_variance_folds` produces same estimate but different estimated SE", {
  withr::local_seed(42)
  withr::local_options(
    list(postcard.verbose = 0)
  )

  n <- 100
  exposure_prob <- .5
  dat_gaus <- sim_rct_data(n = n, exposure_prob = exposure_prob)

  ate_with_cv <- rctglm(formula = Y ~ .,
                        exposure_indicator = A,
                        exposure_prob = exposure_prob,
                        data = dat_gaus,
                        family = gaussian,
                        cv_variance = TRUE,
                        cv_variance_folds = 2)
  ate_with_cv_difffolds <- rctglm(formula = Y ~ .,
                                  exposure_indicator = A,
                                  exposure_prob = exposure_prob,
                                  data = dat_gaus,
                                  family = gaussian,
                                  cv_variance = TRUE,
                                  cv_variance_folds = 10)
  expect_equal(
    estimand(ate_with_cv)$Estimate,
    estimand(ate_with_cv_difffolds)$Estimate
  )
  expect_failure(
    expect_identical(
      estimand(ate_with_cv)$`Std. Error`,
      estimand(ate_with_cv_difffolds)$`Std. Error`
    )
  )
})

test_that("`rctglm` fails when `exposure_indicator` is non-binary", {
  withr::local_seed(42)
  withr::local_options(
    list(postcard.verbose = 0)
  )

  n <- 100
  exposure_prob <- .5
  dat_gaus <- sim_rct_data(n = n, exposure_prob = exposure_prob) %>%
    dplyr::mutate(A_fac = factor(A, levels = 0:1, labels = c("A", "B")))

  # Fit the model
  expect_error(
    {rctglm(formula = Y ~ .,
            exposure_indicator = A_fac,
            exposure_prob = exposure_prob,
            data = dat_gaus,
            family = gaussian,
            cv_variance = FALSE)
    },
    regexp = ".*1.*0"
  )
})

test_that("`estimand_fun` argument can be specified as function or character", {
  withr::local_seed(42)
  withr::local_options(
    list(postcard.verbose = 0)
  )

  n <- 100
  exposure_prob <- .5
  dat_gaus <- sim_rct_data(n = n, exposure_prob = exposure_prob)

  ate <- rctglm(formula = Y ~ .,
                exposure_indicator = A,
                exposure_prob = exposure_prob,
                data = dat_gaus,
                family = gaussian,
                estimand_fun = "ate",
                cv_variance = FALSE)
  estimand_fun_ate <- gsub("\\s*", "", deparse_fun_body(ate$estimand_funs$f))
  expect_equal(estimand_fun_ate, "psi1-psi0")

  rr <- rctglm(formula = Y ~ .,
               exposure_indicator = A,
               exposure_prob = exposure_prob,
               data = dat_gaus,
               family = gaussian,
               estimand_fun = "rate_ratio",
               cv_variance = FALSE)
  estimand_fun_rr <- gsub("\\s*", "", deparse_fun_body(rr$estimand_funs$f))
  expect_equal(estimand_fun_rr, "psi1/psi0")

  nonsense_estimand_fun <- function(psi1, psi0) (psi1^2 - sqrt(psi0)) / 2^psi0
  nonsense <- rctglm(formula = Y ~ .,
                     exposure_indicator = A,
                     exposure_prob = exposure_prob,
                     data = dat_gaus,
                     family = gaussian,
                     estimand_fun = nonsense_estimand_fun,
                     cv_variance = FALSE)
  expect_equal(nonsense$estimand_funs$f, nonsense_estimand_fun)

  # Error when giving character that is not among the defaults
  expect_error(rctglm(formula = Y ~ .,
                      exposure_indicator = A,
                      exposure_prob = exposure_prob,
                      data = dat_gaus,
                      family = gaussian,
                      estimand_fun = "test",
                      cv_variance = FALSE),
               regexp = 'should be one of "ate", "rate_ratio"')
})

test_that("`estimand_fun_derivX` can be left as NULL or specified manually", {
  n <- 100
  exposure_prob <- 0.5
  withr::with_seed(42, {
    dat_gaus <- sim_rct_data(n = n, exposure_prob = exposure_prob)
  })

  # Also checking that message is output to console when left as NULL
  expect_snapshot({
    ate_auto <- withr::with_seed(42, {
      rctglm(formula = Y ~ .,
             exposure_indicator = A,
             exposure_prob = exposure_prob,
             data = dat_gaus,
             family = gaussian,
             estimand_fun = "ate",
             cv_variance = FALSE,
             verbose = 1)
    })
  })
  ate_man <- withr::with_seed(42, {
    rctglm(formula = Y ~ .,
           exposure_indicator = A,
           exposure_prob = exposure_prob,
           data = dat_gaus,
           family = gaussian,
           estimand_fun = "ate",
           estimand_fun_deriv0 = function(psi1, psi0) -1,
           estimand_fun_deriv1 = function(psi1, psi0) 1,
           cv_variance = FALSE,
           verbose = 0)
  })
  expect_equal(ate_auto$estimand, ate_man$estimand)
})

test_that("`rctglm` provides error if `exposure_prob` is not a numeric between 0 and 1", {
  withr::local_seed(42)
  withr::local_options(
    list(postcard.verbose = 0)
  )

  n <- 100
  exposure_prob <- 0.5

  dat_gaus <- sim_rct_data(n = n, exposure_prob = exposure_prob)

  expect_error(
    rctglm(formula = Y ~ .,
           exposure_indicator = A,
           exposure_prob = "1/2",
           data = dat_gaus,
           family = gaussian,
           cv_variance = FALSE,
           verbose = 0)
  )
  expect_error(
    rctglm(formula = Y ~ .,
           exposure_indicator = A,
           exposure_prob = 1.2,
           data = dat_gaus,
           family = gaussian,
           cv_variance = FALSE,
           verbose = 0)
  )
})
