# if_counterfactual_mean_glm
test_that("`if_counterfactual_mean_glm` returns vector of evaluated IF", {
  dat <- sim_if_data()

  res <- if_counterfactual_mean_glm(
    response_variable = dat$y,
    exposure_indicator = dat$treatindicator,
    counterfactual_pred = dat$mean_treatgroup,
    counterfactual_mean = dat$treateffect,
    exposure_prob = dat$exposure_prob
  )

  expect_length(res, nrow(dat))
  expect_snapshot(res)
})

# if_marginaleffect
test_that("`if_marginaleffect` returns vector of evaluated IF", {
  dat <- sim_if_data()

  ate <- function(psi0, psi1) psi1 - psi0
  ate_deriv0 <- function(psi0, psi1) -1
  ate_deriv1 <- function(psi0, psi1) 1

  res <- if_marginaleffect(
    response_variable = dat$y,
    exposure_indicator = dat$treatindicator,
    exposure_prob = dat$exposure_prob,
    counterfactual_pred0 = rep(0, nrow(dat)),
    counterfactual_pred1 = dat$mean_treatgroup,
    counterfactual_mean0 = 0,
    counterfactual_mean1 = dat$treateffect,
    estimand_fun_deriv0 = ate_deriv0,
    estimand_fun_deriv1 = ate_deriv1
  )

  expect_length(res, nrow(dat))
  expect_snapshot(res)
})
