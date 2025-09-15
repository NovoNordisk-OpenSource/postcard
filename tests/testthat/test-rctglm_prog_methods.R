test_that("`rctglm_with_prognosticscore` returns object of correct class", {
  withr::local_seed(42)
  # Generate some data
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

