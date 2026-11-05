# Methods for `postcard_power` and `postcard_samplesize` objects

`power_gs`, `power_nc`, and
[`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)
return objects of class `postcard_power`.
[`samplesize_gs()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
returns an object of class `postcard_samplesize`. Both classes are lists
holding the primary numeric output (`power` or `samplesize`) together
with the assumptions used to compute it. `print` and `summary` methods
for both classes are provided. A `plot` method is provided for
`postcard_power` objects, showing the approximate sampling distributions
of the estimator under the null and alternative hypotheses with the
power shaded.

## Usage

``` r
# S3 method for class 'postcard_power'
print(x, digits = max(3L, getOption("digits") - 3L), ...)

# S3 method for class 'postcard_power'
summary(object, ...)

# S3 method for class 'summary.postcard_power'
print(x, digits = max(3L, getOption("digits") - 3L), ...)

# S3 method for class 'postcard_power'
plot(x, ...)

# S3 method for class 'postcard_samplesize'
print(x, digits = max(3L, getOption("digits") - 3L), ...)

# S3 method for class 'postcard_samplesize'
summary(object, ...)

# S3 method for class 'summary.postcard_samplesize'
print(x, digits = max(3L, getOption("digits") - 3L), ...)
```

## Arguments

- x:

  an object of class `postcard_power` or `postcard_samplesize` (or the
  corresponding `summary.*` class).

- digits:

  a `numeric` with the number of digits to display when printing.

- ...:

  additional arguments (currently unused).

- object:

  an object of class `postcard_power` or `postcard_samplesize`.

## Value

`print` methods return their input invisibly. `summary` methods return
an object of class `summary.postcard_power` or
`summary.postcard_samplesize` respectively, which extends the input
class with additional information (currently just the deparsed estimand
function) displayed by the corresponding `print` method.
`plot.postcard_power` returns a `ggplot2` object.

## See also

[`power_gs()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md),
[`power_nc()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md),
[`samplesize_gs()`](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md),
[`power_marginaleffect()`](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md).
