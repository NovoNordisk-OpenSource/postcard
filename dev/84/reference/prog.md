# Extract information about the fitted prognostic model

Extracts the `prognostic_info` element from an `rctglm_prog` object. The
element is an object of class `prognostic_info` (a list) with the
structure described in the `Value` section of
[rctglm_with_prognosticscore](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md).
`print` and `summary` methods are provided for `prognostic_info`
objects.

## Usage

``` r
prog(x)

# S3 method for class 'rctglm_prog'
prog(x)

# S3 method for class 'prognostic_info'
print(x, ...)

# S3 method for class 'prognostic_info'
summary(object, ...)

# S3 method for class 'summary.prognostic_info'
print(x, ...)
```

## Arguments

- x, object:

  an object of class `rctglm_prog` (returned by
  [rctglm_with_prognosticscore](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)),
  or (for the `prognostic_info` methods) an object of class
  `prognostic_info` returned by `prog()`.

- ...:

  additional arguments passed to methods (currently unused).

## Value

`prog` returns an object of class `prognostic_info`. The methods for
`prognostic_info` return the object invisibly (`print`) or a
`summary.prognostic_info` object (`summary`).

## See also

The generic
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
for which this method works.

## Examples

``` r
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
  A = rbinom(n, 1, exposure_prob)
)

dat_notreat <- glm_data(
  Y ~ b0+b1*log(W1),
  W1 = W1
)

learners <- list(
  mars = list(
    model = parsnip::set_engine(
      parsnip::mars(
        mode = "regression", prod_degree = 3
      ),
      "earth"
    )
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
  learners = learners)
#> 
#> ── Fitting prognostic model ──
#> 
#> ℹ Created formula for fitting prognostic model as: Y ~ .
#> ℹ Fitting learners
#> • mod_mars
#> i   No tuning parameters. `fit_resamples()` will be attempted
#> i 1 of 1 resampling: mod_mars
#> ✔ 1 of 1 resampling: mod_mars (271ms)
#> ℹ Model with lowest RMSE: mod_mars
#> ℹ Investigate trained learners and fitted model in `prognostic_info` list element
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`

prog(ate)
#> 
#> Object of class prognostic_info
#> 
#> Formula: Y ~ .
#> Number of candidate learners: 1
#> Learner names: mars
#> CV folds: 5
#> Historical data: 100 rows, 2 columns
```
