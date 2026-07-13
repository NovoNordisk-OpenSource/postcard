# Find the best learner in terms of RMSE among specified learners using cross validation

Find the best learner in terms of RMSE among specified learners using
cross validation

## Usage

``` r
fit_best_learner(
  preproc,
  data,
  cv_folds = 5,
  learners = default_learners(),
  verbose = options::opt("verbose")
)
```

## Arguments

- preproc:

  A list (preferably named) with preprocessing objects: formulas,
  recipes, or
  [`workflows::workflow_variables()`](https://workflows.tidymodels.org/reference/add_variables.html).
  Passed to
  [`workflowsets::workflow_set()`](https://workflowsets.tidymodels.org/reference/workflow_set.html).

- data:

  A data frame.

- cv_folds:

  a `numeric` with the number of cross-validation folds used when
  fitting and evaluating models

- learners:

  a `list` (preferably named) containing named lists of elements `model`
  and optionally `grid`. The `model` element should be a `parsnip` model
  specification, which is passed to
  [workflowsets::workflow_set](https://workflowsets.tidymodels.org/reference/workflow_set.html)
  as the `model` argument, while the `grid` element is passed as the
  `grid` argument of
  [workflowsets::option_add](https://workflowsets.tidymodels.org/reference/option_add.html)

- verbose:

  `numeric` verbosity level. Higher values means more information is
  printed in console. A value of 0 means nothing is printed to console
  during execution (Defaults to `2`, overwritable using option
  'postcard.verbose' or environment variable 'R_POSTCARD_VERBOSE')

## Value

a trained `workflow`

## Details

Ensure data compatibility with the learners.

## See also

See
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
for a function that utilises this function to perform prognostic
covariate adjustment.

## Examples

``` r
# Generate some synthetic 2-armed RCT data along with historical controls
n <- 100
dat_rct <- glm_data(
  Y ~ 1+2*x1+3*a,
  x1 = rnorm(n, 2),
  a = rbinom (n, 1, .5),
  family = gaussian()
)
dat_hist <- glm_data(
  Y ~ 1+2*x1,
  x1 = rnorm(n, 2),
  family = gaussian()
)

# Fit a learner to the historical control data
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
fit <- fit_best_learner(
  preproc = list(mod = Y ~ .),
  data = dat_hist,
  learners = learners
)
#> ℹ Fitting learners
#> • mod_mars
#> i   No tuning parameters. `fit_resamples()` will be attempted
#> i 1 of 1 resampling: mod_mars
#> ✔ 1 of 1 resampling: mod_mars (348ms)
#> ℹ Model with lowest RMSE: mod_mars

# Use it fx. to predict the "control outcome" in the 2-armed RCT
predict(fit, new_data = dat_rct)
#> # A tibble: 100 × 1
#>     .pred
#>     <dbl>
#>  1  2.17 
#>  2  5.54 
#>  3 -0.219
#>  4  5.04 
#>  5  6.23 
#>  6  7.22 
#>  7  1.20 
#>  8  4.59 
#>  9  4.59 
#> 10  4.52 
#> # ℹ 90 more rows
```
