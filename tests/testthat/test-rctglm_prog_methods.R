test_that("`rctglm_with_prognosticscore` returns object of correct class", {
  withr::local_seed(42)
  # Generate some data
  exposure_prob <- .5
  dat <- sim_prognostic_data(exposure_prob = exposure_prob)
  dat_treat <- dat$dat_treat
  dat_notreat <- dat$dat_notreat

  learners <- example_learners()

  ate <- rctglm_with_prognosticscore(
    formula = Y ~ .,
    exposure_indicator = A,
    exposure_prob = exposure_prob,
    data = dat_treat,
    family = gaussian(),
    estimand_fun = "ate",
    data_hist = dat_notreat,
    learners = learners,
    cv_variance = FALSE)

  expect_equal(ate$prognostic_info, prog(ate))
  expect_snapshot(prog(ate),
                  transform = function(x) gsub("^<environment:.*>$", "", x))
})

