# Create data and plot power curves calculated using [`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md) for a list of models

Iterate a process of simulating test data from `test_data_fun`, making
predictions using models in `model_list`, and calculating power using
[`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)
across a number of sample sizes `ns` and iterations `n_iter`. The
results are averaged and used to create a plot of the resulting power
curves.

## Usage

``` r
repeat_power_marginaleffect(
  target_effect,
  exposure_prob,
  model_list = default_power_model_list(),
  test_data_fun = function(n) {
     glm_data(Y ~ 1 + 3 * log(W), W = stats::runif(n, min
    = 1, max = 50))
 },
  ns = seq(10, 300, 10),
  desired_power = 0.9,
  n_iter = 1,
  ...
)

# S3 method for class 'postcard_rpm'
plot(x, cols = NULL, ...)
```

## Arguments

- target_effect:

  Passed to
  [`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)

- exposure_prob:

  Passed to
  [`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)

- model_list:

  a named `list` of models used to get predictions on generated test
  data sets that are then passed to
  [`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)
  as `predictions`. The elements of `model_list` need to have an
  existing [`predict()`](https://rdrr.io/r/stats/predict.html) method.
  The default is an ANCOVA and a prognostic model fitted with
  [`fit_best_learner()`](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md)
  to a simple data set of 1000 observations generated with a non-linear
  effect of a single covariate using
  [`glm_data()`](https://novonordisk-opensource.github.io/postcard/reference/glm_data.md).

- test_data_fun:

  a `function` with a single argument `n` that generates test data sets
  for the sample sizes `ns` specified. The default generates data using
  [`glm_data()`](https://novonordisk-opensource.github.io/postcard/reference/glm_data.md)
  with the same data generating process as the training data used to fit
  the default models in `model_list`.

- ns:

  a `numeric` vector of sample sizes

- desired_power:

  a `numeric` between 0 and 1 indicating the desired power level

- n_iter:

  a `numeric` indicating a number of iterations to process and average
  over

- ...:

  additional arguments passed to
  [`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)

- x:

  an object of class `postcard_rpm` created by
  `repeat_power_marginaleffect()`

- cols:

  a (potentially named) `character` vector of colors for the different
  models in `model_list`

## Value

`repeat_power_marginal` returns an object of class `postcard_rpm`, which
is just a `data.frame` with a `plot` method defined. The `plot` method
returns a `ggplot2` object.

## See also

[`repeat_power_linear()`](https://novonordisk-opensource.github.io/postcard/reference/repeat_power_linear.md)
for a similar implementation to iterate the process of approximating
power with the functions in
[`power_linear()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)

## Examples

``` r
# Note everything is wrapped in dontrun to avoid long runtimes of examples (tests are
# still in place). Reduce the number of sample sizes and/or iterations to avoid long
# runtimes
if (FALSE) { # \dontrun{
# A simple use case with default models and test data (we run only with a few sample
# sizes to reduce runtime of examples)
rpm <- repeat_power_marginaleffect(
  target_effect = 0.9,
  exposure_prob = 0.5
)
plot(rpm)

################################
# Create model from a poisson family and estimate the power of rate ratio with
# several arguments passed to power_marginaleffect
################################
b1 <- 0.9
b2 <- 0.2
b3 <- -0.4
b4 <- -0.6

train_pois <- glm_data(
  Y ~ b1*log(X1)+b2*X2+b3*X3+b4*X2*X3,
  X1 = runif(1e3, min = 1, max = 10),
  X2 = rnorm(1e3),
  X3 = rgamma(1e3, shape = 1),
  family = poisson()
)

# Define models to compare fit to training data
ancova_prog_list <- list(
ANCOVA = glm(Y ~ X1 + X2 + X3, data = train_pois, family = poisson),
"ANCOVA with prognostic score" = fit_best_learner(list(mod = Y ~ X1 + X2 + X3), data = train_pois)
)

# Create a function that produces data to predict on
test_pois_fun <- function(n) {
 glm_data(
   Y ~ b1*log(X1)+b2*X2+b3*X3+b4*X2*X3,
   X1 = runif(n, min = 1, max = 10),
   X2 = rnorm(n),
   X3 = rgamma(n, shape = 1),
   family = poisson()
 )
}

# Specify a bunch of different arguments that are passed to power_marginaleffect()
## Run for 2 sample sizes to reduce runtime
rpm_rr <- repeat_power_marginaleffect(
  model_list = ancova_prog_list,
  test_data_fun = test_pois_fun,
  ns = seq(100, 200), n_iter = 1,
  var1 = function(var0) 1.1 * var0,
  kappa1_squared = function(kap0) 1.1 * kap0,
  estimand_fun = "rate_ratio",
  target_effect = 1.4,
  exposure_prob = 1/2,
  margin = 0.8
)
plot(rpm_rr2)
} # }
```
