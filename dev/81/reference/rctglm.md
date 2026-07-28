# Fit GLM and find any estimand (marginal effect) using plug-in estimation with variance estimation using influence functions

The procedure uses plug-in-estimation and influence functions to perform
robust inference of any specified estimand in the setting of a
randomised clinical trial, even in the case of heterogeneous effect of
covariates in randomisation groups. See [Powering RCTs for marginal
effects with GLMs using prognostic score
adjustment](https://arxiv.org/abs/2503.22284) by Højbjerre-Frandsen et.
al (2025) for more details on methodology.

## Usage

``` r
rctglm(
  formula,
  exposure_indicator,
  exposure_prob,
  data,
  family = gaussian,
  estimand_fun = "ate",
  estimand_fun_deriv0 = NULL,
  estimand_fun_deriv1 = NULL,
  cv_variance = FALSE,
  cv_variance_folds = 10,
  verbose = options::opt("verbose"),
  ...
)
```

## Arguments

- formula:

  an object of class "formula" (or one that can be coerced to that
  class): a symbolic description of the model to be fitted. The details
  of model specification are given under ‘Details’ in the
  [glm](https://rdrr.io/r/stats/glm.html) documentation.

- exposure_indicator:

  (name of) the *binary* variable in `data` that identifies
  randomisation groups. The variable is required to be binary currently.

- exposure_prob:

  a `numeric` with the probability of being in "group 1" (rather than
  group 0) in groups defined by `exposure_indicator`.

- data:

  an optional data frame, list or environment (or object coercible by
  as.data.frame to a data frame) containing the variables in the model.
  If not found in data, the variables are taken from
  environment(formula), typically the environment from which the
  function is called.

- family:

  a description of the error distribution and link function to be used
  in the model. For `glm` this can be a character string naming a family
  function, a family function or the result of a call to a family
  function. For `glm.fit` only the third option is supported. (See
  [`family`](https://rdrr.io/r/stats/family.html) for details of family
  functions.)

- estimand_fun:

  a `function` with arguments `psi1` and `psi0` specifying the estimand.
  Alternative, specify "ate" or "rate_ratio" as a `character` to use one
  of the default estimand functions. See more details in the "Estimand"
  section of rctglm.

- estimand_fun_deriv0:

  a `function` specifying the derivative of `estimand_fun` wrt. `psi0`.
  As a default the algorithm will use symbolic differentiation to
  automatically find the derivative from `estimand_fun`

- estimand_fun_deriv1:

  a `function` specifying the derivative of `estimand_fun` wrt. `psi1`.
  As a default the algorithm will use symbolic differentiation to
  automatically find the derivative from `estimand_fun`

- cv_variance:

  a `logical` determining whether to estimate the variance using
  cross-validation (see details of rctglm).

- cv_variance_folds:

  a `numeric` with the number of folds to use for cross validation if
  `cv_variance` is `TRUE`.

- verbose:

  `numeric` verbosity level. Higher values means more information is
  printed in console. A value of 0 means nothing is printed to console
  during execution (Defaults to `2`, overwritable using option
  'postcard.verbose' or environment variable 'R_POSTCARD_VERBOSE')

- ...:

  Additional arguments passed to
  [`stats::glm()`](https://rdrr.io/r/stats/glm.html)

## Value

`rctglm` returns an object of class inheriting from `"rctglm"`.

An object of class `rctglm` is a list containing the following
components:

- **`estimand`**: A `data.frame` with plug-in estimate of estimand,
  standard error (SE) estimate and variance estimate of estimand

- `estimand_funs`: A `list` with

  - `f`: The `estimand_fun` used to obtain an estimate of the estimand
    from counterfactual means

  - `d0`: The derivative with respect to `psi0`

  - `d1`: The derivative with respect to `psi1`

- `means_counterfactual`: A `data.frame` with counterfactual means
  `psi0` and `psi1`

- `fitted.values_counterfactual`: A `data.frame` with counterfactual
  mean values, obtained by transforming the linear predictors for each
  group by the inverse of the link function.

- `glm`: A `glm` object returned from running
  [stats::glm](https://rdrr.io/r/stats/glm.html) within the procedure

- `call`: The matched `call`

## Details

The procedure assumes the setup of a randomised clinical trial with
observations grouped by a binary `exposure_indicator` variable,
allocated randomly with probability `exposure_prob`. A GLM is fit and
then used to predict the response of all observations in the event that
the `exposure_indicator` is 0 and 1, respectively. Taking means of these
predictions produce the *counterfactual means* `psi0` and `psi1`, and an
estimand `r(psi0, psi1)` is calculated using any specified
`estimand_fun`.

The variance of the estimand is found by taking the variance of the
influence function of the estimand. If `cv_variance` is `TRUE`, then the
counterfactual predictions for each observation (which are used to
calculate the value of the influence function) is obtained as
out-of-sample (OOS) predictions using cross validation with number of
folds specified by `cv_variance_folds`. The cross validation splits are
performed using stratified sampling with `exposure_indicator` as the
`strata` argument in
[rsample::vfold_cv](https://rsample.tidymodels.org/reference/vfold_cv.html).

Read more in
[`vignette("model-fit")`](https://novonordisk-opensource.github.io/postcard/articles/model-fit.md).

## Estimands

As noted in the description, `psi0` and `psi1` are the counterfactual
means found by prediction using a fitted GLM in the binary groups
defined by `exposure_indicator`.

Default estimand functions can be specified via `"ate"` (which uses the
function `function(psi1, psi0) psi1-psi0`) and `"rate_ratio"` (which
uses the function `function(psi1, psi0) psi1/psi0`). See more
information on specifying the `estimand_fun` in
[`vignette("model-fit")`](https://novonordisk-opensource.github.io/postcard/articles/model-fit.md).

As a default, the `Deriv` package is used to perform symbolic
differentiation to find the derivatives of the `estimand_fun`.

## See also

See how to extract information using methods in
[rctglm_methods](https://novonordisk-opensource.github.io/postcard/reference/rctglm_methods.md).

Use
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
to include prognostic covariate adjustment.

See vignettes

## Examples

``` r
# Generate some data to showcase example
n <- 100
exp_prob <- .5

dat_gaus <- glm_data(
  Y ~ 1+1.5*X1+2*A,
  X1 = rnorm(n),
  A = rbinom(n, 1, exp_prob),
  family = gaussian()
)

# Fit the model
ate <- rctglm(formula = Y ~ .,
              exposure_indicator = A,
              exposure_prob = exp_prob,
              data = dat_gaus,
              family = gaussian)
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`

# Pull information on estimand
estimand(ate)
#>   Estimate Std. Error
#> 1  1.73555  0.1967519

## Another example with different family and specification of estimand_fun
dat_binom <- glm_data(
  Y ~ 1+1.5*X1+2*A,
  X1 = rnorm(n),
  A = rbinom(n, 1, exp_prob),
  family = binomial()
)

rr <- rctglm(formula = Y ~ .,
              exposure_indicator = A,
              exposure_prob = exp_prob,
              data = dat_binom,
              family = binomial(),
              estimand_fun = "rate_ratio")
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1/psi0' with respect to 'psi0' as: '-(psi1/psi0^2)'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1/psi0' with respect to 'psi1' as: '1/psi0'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`

odds_ratio <- function(psi1, psi0) (psi1*(1-psi0))/(psi0*(1-psi1))
or <- rctglm(formula = Y ~ .,
              exposure_indicator = A,
              exposure_prob = exp_prob,
              data = dat_binom,
              family = binomial,
              estimand_fun = odds_ratio)
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function '(psi1 * (1 - psi0))/(psi0 * (1 - psi1))' with respect to 'psi0' as: '{     .e1 <- 1 - psi1     .e2 <- psi0 * .e1     -(psi1 * ((1 - psi0) * .e1/.e2^2 + 1/.e2)) }'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function '(psi1 * (1 - psi0))/(psi0 * (1 - psi1))' with respect to 'psi1' as: '{     .e2 <- psi0 * (1 - psi1)     (1 - psi0) * (1/.e2 + psi0 * psi1/.e2^2) }'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`
```
