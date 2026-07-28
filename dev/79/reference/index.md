# Package index

## Estimation of marginal effects in GLMs for two-armed randomised trials

In cases where observations are randomly allocated into binary groups,
any group effect estimand is most robustly estimated using plug-in
estimation and estimating the variance using influence functions

- [`rctglm()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
  : Fit GLM and find any estimand (marginal effect) using plug-in
  estimation with variance estimation using influence functions

### Methods for `rctglm` objects

- [`estimand()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_methods.md)
  [`est()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_methods.md)
  [`coef(`*`<rctglm>`*`)`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_methods.md)
  [`predict(`*`<rctglm>`*`)`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_methods.md)
  [`print(`*`<rctglm>`*`)`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_methods.md)
  :

  Methods for objects of class `rctglm`

### Estimation using prognostic scores

When historical data is available from one group, a (prognostic) model
can be fit to the historical data, which is then used to predict
outcomes for all observations and used as a covariate in the model to
improve efficiency

- [`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
  : Use prognostic covariate adjustment when fitting an rctglm
- [`prog()`](https://novonordisk-opensource.github.io/postcard/reference/prog.md)
  : Extract information about the fitted prognostic model
- [`fit_best_learner()`](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md)
  : Find the best learner in terms of RMSE among specified learners
  using cross validation
- [`default_learners()`](https://novonordisk-opensource.github.io/postcard/reference/default_learners.md)
  : Creates a list of learners

## Power approximation

Approximation formulas exist to estimate the sample size needed to
obtain a power of a chosen level. Functionalities are implemented here
to utilise these formulas to approximate the power from a given sample
size and assumed effect size together with other parameters.

- [`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)
  : Power approximation for estimating marginal effects in GLMs
- [`variance_ancova()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
  [`power_gs()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
  [`samplesize_gs()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
  [`power_nc()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
  : Power and sample size estimation for linear models

### Plotting power curves

- [`repeat_power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/repeat_power_marginaleffect.md)
  [`plot(`*`<postcard_rpm>`*`)`](https://novonordisk-opensource.github.io/postcard/reference/repeat_power_marginaleffect.md)
  :

  Create data and plot power curves calculated using
  [`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)
  for a list of models

- [`repeat_power_linear()`](https://novonordisk-opensource.github.io/postcard/reference/repeat_power_linear.md)
  [`plot(`*`<postcard_rpl>`*`)`](https://novonordisk-opensource.github.io/postcard/reference/repeat_power_linear.md)
  :

  Create data and plot power curves calculated using functions in
  [`power_linear()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
  for a list of formulas/models

## Generate data from GLM model with known mean

Used in development for examples, vignettes and tests, but exported to
enable users to perform exploratory analyses across different scenarios
of simulated data with and without prognostic covariate adjustment

- [`glm_data()`](https://novonordisk-opensource.github.io/postcard/reference/glm_data.md)
  : Generate data simulated from a GLM

## Package level options

- [`options`](https://novonordisk-opensource.github.io/postcard/reference/options.md)
  : postcard Options
