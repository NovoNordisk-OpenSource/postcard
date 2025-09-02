test_that("snapshot tests", {
  withr::local_seed(42)
  dat_gaus <- glm_data(Y ~ 1+2*X1+2*A,
                       X1 = rnorm(100),
                       A = rbinom(100, size = 1, prob = 0.5),
                       family = gaussian())

  va1 <- variance_ancova(Y ~ X1 * A, dat_gaus)
  va2 <- variance_ancova(Y ~ X1 + A, dat_gaus)
  va3 <- variance_ancova(Y ~ A, dat_gaus)
  expect_snapshot(va1)
  expect_snapshot(va2)
  expect_snapshot(va3)

  pgs <- power_gs(variance = 6, ate = 1, n = 200, r = 2, margin = 0.5, alpha = 0.05)
  expect_snapshot(pgs)

  ssgs2 <- samplesize_gs(variance = 27.3, ate = 2, r = 2/3, margin = -1, alpha = 0.05)
  expect_snapshot(ssgs2)
})

test_that("`power_gs` and `samplesize_gs` agree", {
  desired_power <- 0.9
  common_args <- list(variance = 6, ate = 0.7, margin = 0, alpha = 0.025)
  ssgs <- do.call(samplesize_gs, c(common_args, list(power = desired_power)))
  pgs <- do.call(power_gs, c(common_args, list(n = ssgs)))
  expect_equal(pgs, desired_power)
})

test_that("`variance_ancova` works", {
  dat1 <- data.frame(Y = rnorm(100))
  var_fun <- variance_ancova(Y ~ 1, data = dat1)
  var_man <- var(dat1$Y)
  expect_equal(var_fun, var_man)

  dat2 <- data.frame(
    Y = rnorm(100) + c(rep(0, 50), rep(2, 50)),
    A = c(rep(0, 50), rep(1, 50))
  )
  var_int <- variance_ancova(Y ~ A, data = dat2)
  var_noint <- variance_ancova(Y ~ A - 1, data = dat2)
  expect_equal(var_int, var_noint)
})
