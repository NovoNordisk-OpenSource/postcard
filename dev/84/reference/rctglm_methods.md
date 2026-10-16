# Methods for objects of class `rctglm`

Methods for extracting information about the estimand and about the
underlying GLM fit from an `rctglm` object. See details for information
on each method.

## Usage

``` r
estimand(object)

# S3 method for class 'rctglm'
estimand(object)

est(object)

# S3 method for class 'rctglm'
est(object)

# S3 method for class 'rctglm'
coef(object, ...)

# S3 method for class 'rctglm'
predict(object, ...)

# S3 method for class 'rctglm'
print(x, digits = max(3L, getOption("digits") - 3L), ...)

# S3 method for class 'rctglm'
summary(object, level = 0.95, ...)

# S3 method for class 'summary.rctglm'
print(x, digits = max(3L, getOption("digits") - 3L), ...)

# S3 method for class 'rctglm'
plot(x, level = 0.95, ...)

# S3 method for class 'rctglm'
formula(x, ...)

# S3 method for class 'rctglm'
family(object, ...)

# S3 method for class 'rctglm'
fitted(object, ...)

# S3 method for class 'rctglm'
model.frame(formula, ...)

# S3 method for class 'rctglm'
model.matrix(object, ...)

# S3 method for class 'rctglm'
nobs(object, ...)

# S3 method for class 'rctglm'
residuals(object, ...)

# S3 method for class 'rctglm'
logLik(object, ...)

# S3 method for class 'rctglm'
deviance(object, ...)

# S3 method for class 'rctglm'
AIC(object, ..., k = 2)

# S3 method for class 'rctglm'
terms(x, ...)

# S3 method for class 'rctglm'
weights(object, ...)

# S3 method for class 'rctglm'
vcov(object, type = c("coefficients", "estimand"), ...)

# S3 method for class 'rctglm'
confint(object, parm, level = 0.95, ...)

# S3 method for class 'rctglm'
update(object, formula., ..., evaluate = TRUE)
```

## Arguments

- object:

  an object of class `rctglm`

- ...:

  additional arguments passed to methods

- x:

  an object of class `rctglm`

- digits:

  a `numeric` with the number of digits to display when printing

- level:

  a `numeric` confidence level in \\(0, 1)\\, used for the Wald interval
  on the estimand in `summary`, `plot`, and `confint`. Defaults to 0.95.

- type:

  for `vcov`, one of `"coefficients"` (default) or `"estimand"`.
  `"coefficients"` returns `vcov(object$glm)` (the variance-covariance
  matrix of the GLM coefficient vector); `"estimand"` returns the
  estimated variance of the marginal-effect estimand as a 1x1 matrix.

- parm:

  for `confint`, either omitted (returns the Wald CI for the estimand)
  or the character string `"coefficients"` (delegates to
  [`stats::confint`](https://rdrr.io/r/stats/confint.html) on the
  underlying GLM).

- formula.:

  for `update`, a formula, updated via
  [`stats::update.formula`](https://rdrr.io/r/stats/update.formula.html).
  See [`stats::update()`](https://rdrr.io/r/stats/update.html).

- evaluate:

  for `update`, if `TRUE` (default) the updated call is evaluated; if
  `FALSE` the unevaluated call is returned.

- formula:

  for `model.frame`, an object of class `rctglm`.

- k:

  for `AIC`, the penalty per parameter. See
  [`stats::AIC()`](https://rdrr.io/r/stats/AIC.html).

## Value

`estimand`/`est` return a `data.frame` with columns `Estimate` and
`Std. Error` with the estimate and standard error of the estimand.

`summary` returns a `summary.rctglm` object. `plot` returns a `ggplot`
object. `confint` returns a 1x2 matrix (or the GLM `confint` output).
`vcov` returns a variance-covariance matrix (default) or a 1x1 matrix
(for the estimand). `update` returns a new `rctglm` object (or an
unevaluated call when `evaluate = FALSE`).

See [`coef()`](https://rdrr.io/r/stats/coef.html) and
[`predict.glm()`](https://rdrr.io/r/stats/predict.glm.html) for details
on what is returned by the corresponding methods.

## Details

The generics estimand (and its alias est) extract a one-row `data.frame`
with the estimate and standard error of the estimand.

`summary.rctglm` returns a `summary.rctglm` object printed with
`print.summary.rctglm`. The object holds a coefficient-style table for
the estimand with columns `Estimate`, `Std. Error`, `z value`,
`Pr(>|z|)`, and the lower/upper Wald CI bounds at the requested `level`.
The Wald test uses the null value \\r(\psi, \psi)\\ (which equals 0 for
the ATE and 1 for rate/odds ratios). The underlying GLM summary is
stored in the `glm_summary` element for full access to the GLM
diagnostics.

`plot.rctglm` returns a `ggplot2` object with the estimand estimate and
its Wald CI drawn as a point and horizontal error bar, plus a dashed
vertical reference line at the null value.

Thin wrappers to the corresponding methods on the underlying `glm` are
provided for `coef`, `predict`, `formula`, `family`, `fitted`,
`model.frame`, `model.matrix`, `nobs`, `residuals`, `logLik`,
`deviance`, `AIC`, `terms`, `weights`. `vcov.rctglm` returns the GLM
coefficient variance-covariance matrix by default and the estimand
variance when `type = "estimand"`. `confint.rctglm` returns the Wald CI
for the estimand by default (or delegates to `confint(object$glm)` when
`parm = "coefficients"`). `update.rctglm` re-runs
[`rctglm()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
with an updated call.

## See also

The generic
[`rctglm()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
which produces `rctglm` class objects.

## Examples

``` r
# Generate some data to showcase example
n <- 100
exposure_prob <- .5
dat_binom <- glm_data(
  Y ~ 1+1.5*X1+2*A,
  X1 = rnorm(n),
  A = rbinom(n, 1, exposure_prob),
  family = binomial()
)

# Fit the model
ate <- rctglm(formula = Y ~ .,
              exposure_indicator = A,
              exposure_prob = exposure_prob,
              data = dat_binom,
              family = binomial,
              estimand_fun = "ate")
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`

print(ate)
#> 
#> Object of class rctglm 
#> 
#> Call:  rctglm(formula = Y ~ ., exposure_indicator = A, exposure_prob = exposure_prob, 
#>     data = dat_binom, family = binomial, estimand_fun = "ate")
#> 
#> Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: 0.569
#> Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: 0.815
#> Estimand function r: psi1 - psi0
#> Estimand (r(psi_1, psi_0)) estimate (SE): 0.246 (0.07336)
summary(ate)
#> 
#> Summary of rctglm fit
#> 
#> Call:  rctglm(formula = Y ~ ., exposure_indicator = A, exposure_prob = exposure_prob, 
#>     data = dat_binom, family = binomial, estimand_fun = "ate")
#> 
#> Counterfactual control mean (psi_0=E[Y|X, A=0]): 0.569
#> Counterfactual active  mean (psi_1=E[Y|X, A=1]): 0.815
#> 
#> Estimand function r: psi1 - psi0
#> Null value (r(psi, psi)): 0
#> 
#>          Estimate Std. Error z value  Pr(>|z|)  2.5 % 97.5 %
#> Estimand  0.24602    0.07336   3.354 0.0007973 0.1022   0.39
#> 
#> (Wald-type 95% CI; standard error computed from the full-model influence-function variance.)
#> Access the underlying GLM summary via `<summary_object>$glm_summary`.
estimand(ate)
#>    Estimate Std. Error
#> 1 0.2460163 0.07335603
est(ate)
#>    Estimate Std. Error
#> 1 0.2460163 0.07335603
coef(ate)
#> (Intercept)          X1           A 
#>    0.460642    1.871062    1.857131 
confint(ate)
#>              2.5 %    97.5 %
#> Estimand 0.1022411 0.3897915
if (FALSE) { # \dontrun{
plot(ate)
} # }
```
