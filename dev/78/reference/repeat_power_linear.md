# Create data and plot power curves calculated using functions in [`power_linear()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md) for a list of formulas/models

Estimate a variance for power approximation using
[`variance_ancova()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
for each formula in `formula_list` on `train_data`. Then calculate power
using the function with name specified in `power_fun` across a number of
sample sizes `ns` for an assumed average treatment effect of `ate`.

## Usage

``` r
repeat_power_linear(
  ate,
  formula_list,
  train_data,
  power_fun = c("power_gs", "power_nc"),
  ns = 10:400,
  desired_power = 0.9,
  ...
)

# S3 method for class 'postcard_rpl'
plot(x, cols = NULL, ...)
```

## Arguments

- ate:

  Passed to
  [`power_gs()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
  or
  [`power_nc()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)

- formula_list:

  a named `list` of formulas that are element wise passed to
  [`variance_ancova()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)

- train_data:

  Passed as the `data` argument in
  [`variance_ancova()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)

- power_fun:

  a `character` string with value `"power_gs"` or `"power_nc"`,
  specifying what function in the
  [`power_linear()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
  topic to use

- ns:

  a `numeric` vector of sample sizes

- desired_power:

  a `numeric` between 0 and 1 indicating the desired power level

- ...:

  Arguments passed to
  [`variance_ancova()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
  and
  [`power_gs()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
  or
  [`power_nc()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)

- x:

  an object of class `postcard_rpl` created by `repeat_power_linear()`

- cols:

  a (potentially named) `character` vector of colors for the different
  models in `formula_list`

## Value

`repeat_power_linear` returns an object of class `postcard_rpl`, which
is just a `data.frame` with a `plot` method defined. The `plot` method
returns a `ggplot2` object.

## See also

[`repeat_power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/repeat_power_marginaleffect.md)
for a similar implementation to iterate the process of approximating
power with the
[`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)

## Examples

``` r
train_data <- glm_data(
  Y ~ 1+1.5*log(W)+2*X,
  W = runif(1e3, min = 1, max = 10),
  X = rnorm(1e3, sd = 3)
)
rpl <- repeat_power_linear(
  ate = 0.5,
  formula_list = list("ANCOVA 1 covariate" = Y ~ X, "ANCOVA 2 covariates" = Y ~ W + X),
  train_data = train_data)

rpl_nc <- repeat_power_linear(
  ate = 0.5,
  formula_list = list("ANCOVA 1 covariate" = Y ~ X, "ANCOVA 2 covariates" = Y ~ W + X),
  train_data = train_data,
  power_fun = "power_nc",
  df = 1e3-3,
  deflation = 0.95,
  margin = -0.2,
  r = 2)

if (FALSE) { # \dontrun{
plot(rpl)

plot(rpl_nc)
} # }
```
