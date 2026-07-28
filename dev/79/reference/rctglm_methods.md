# Methods for objects of class `rctglm`

Methods mostly to extract information from model fit and inference. See
details for more information on each method.

## Usage

``` r
estimand(object)

# S3 method for class 'rctglm'
estimand(object)

est(object)

# S3 method for class 'rctglm'
coef(object, ...)

# S3 method for class 'rctglm'
predict(object, ...)

# S3 method for class 'rctglm'
print(x, digits = max(3L, getOption("digits") - 3L), ...)
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

## Value

`estimand`/`est` returns a `data.frame` with columns `Estimate` and
`Std. Error` with the estimate and standard error of the estimand.

See [`coef()`](https://rdrr.io/r/stats/coef.html) and
[`predict.glm()`](https://rdrr.io/r/stats/predict.glm.html) for details
on what is returned by the corresponding methods.

## Details

The function estimand (or short-hand version est) can be used to extract
a `data.frame` with an estimated value and standard error of the
estimand.

A method for the generic [`coef()`](https://rdrr.io/r/stats/coef.html)
has been added for class `rctglm`, which extracts coefficient
information from the underlying `glm` fit in the procedure. The same is
true for the method defined for the
[`predict()`](https://rdrr.io/r/stats/predict.html) generic. The method
for an `rctglm` class object calls
[`predict.glm()`](https://rdrr.io/r/stats/predict.glm.html) on the `glm`
fit contained within an `rctglm` object.

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
estimand(ate)
#>    Estimate Std. Error
#> 1 0.2460163 0.07335603
coef(ate)
#> (Intercept)          X1           A 
#>    0.460642    1.871062    1.857131 
```
