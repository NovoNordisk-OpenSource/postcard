# Data simulation helpers shared across tests.
#
# The random-number generating calls in each helper are kept in the exact same
# order as the original inline test code. This means that, when a helper is
# called under a fixed seed (e.g. after `withr::local_seed()`), it reproduces
# the same data - and therefore the same snapshots - as the original code.

# Simulate treatment and historical data used to test prognostic-score models.
sim_prognostic_data <- function(exposure_prob = 0.5, family = gaussian()) {
  withr::local_seed(42)

  n <- 100
  W1 <- runif(n, min = 1, max = 10)
  dat_treat <- glm_data(
    Y ~ 1 + 1.5 * log(W1) + 2 * A,
    W1 = W1,
    A = rbinom(n, 1, exposure_prob),
    family = family
  )
  dat_notreat <- glm_data(
    Y ~ 1 + 1.5 * log(W1),
    W1 = W1,
    family = family
  )
  list(dat_treat = dat_treat, dat_notreat = dat_notreat)
}

# Simulate randomised trial data with a single covariate `X1` and binary
# exposure `A`.
sim_rct_data <- function(n = 100, exposure_prob = 0.5, family = gaussian()) {
  withr::local_seed(42)

  out <- glm_data(
    Y ~ 1 + 1.5 * X1 + 2 * A,
    X1 = rnorm(n),
    A = rbinom(n, 1, exposure_prob),
    family = family
  )
  out$exposure_prob <- exposure_prob
  return(out)
}

# Simulate a simple data set with a single covariate `x1`.
sim_covariate_data <- function(n = 10) {
  glm_data(
    y ~ 1 + 2 * x1,
    x1 = rnorm(n)
  )
}

# Simulate training data used across the power-related tests.
sim_power_train_data <- function() {
  glm_data(
    Y ~ 1 + 1.5 * log(W) + 2 * X,
    W = runif(1e3, min = 1, max = 10),
    X = rnorm(1e3, sd = 3)
  )
}

# Simulate the data used to test influence-function utilities.
sim_if_data <- function(n = 10, exposure_prob = 0.5, treateffect = 2) {
  withr::local_seed(13746)

  out <- data.frame(
    n = n,
    exposure_prob = exposure_prob,
    treateffect = treateffect,
    treatindicator = rbinom(n, size = 1, prob = exposure_prob),
    mean_treatgroup = rep(treateffect, n)
  )
  out$truemean <- out$treatindicator * out$mean_treatgroup
  out$y <- rnorm(n, mean = out$truemean)

  return(out)
}
