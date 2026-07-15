# Use prognostic covariate adjustment when fitting an [rctglm](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)

The procedure uses
[fit_best_learner](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md)
to fit a prognostic model to historical data and uses the model to
produce counterfactual predictions as a prognostic score that is then
adjusted for as a covariate in the
[rctglm](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
procedure. See [Powering RCTs for marginal effects with GLMs using
prognostic score adjustment](https://arxiv.org/abs/2503.22284) by
Højbjerre-Frandsen et. al (2025) for more details.

## Usage

``` r
rctglm_with_prognosticscore(
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
  ...,
  data_hist,
  prog_formula = NULL,
  cv_prog_folds = 5,
  learners = default_learners(),
  verbose = options::opt("verbose")
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
  section of
  [rctglm](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md).

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
  cross-validation (see details of
  [rctglm](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)).

- cv_variance_folds:

  a `numeric` with the number of folds to use for cross validation if
  `cv_variance` is `TRUE`.

- ...:

  Additional arguments passed to
  [`stats::glm()`](https://rdrr.io/r/stats/glm.html)

- data_hist:

  a `data.frame` with historical data on which to fit a prognostic model

- prog_formula:

  an object of class "formula" (or one that can be coerced to that
  class): a symbolic description of the prognostic model to be fitted to
  `data_hist`. Passed in a list as the `preproc` argument in
  [`fit_best_learner()`](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md).
  As a default, the formula is created by modelling the response
  (assumed to have the same name as in `formula`) using all columns in
  `data_hist`.

- cv_prog_folds:

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

`rctglm_with_prognosticscore` returns an object of class `rctglm_prog`,
which inherits from
[rctglm](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md).

An `rctglm_prog` object is a list with the same components as an
[rctglm](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
object (see the **`Value`** section of
[rctglm](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
for a breakdown of the structure), but with an additional list element
of:

- `prognostic_info`: List with information about the fitted prognostic
  model on historical data. It has components:

  - `formula`: The `formula` with symbolic description of how the
    response is modelled as function of covariates in the models

  - `model_fit`: A trained `workflow` - the result of
    [fit_best_learner](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md)

  - `learners`: A `list` of learners used for the discrete super learner

  - `cv_folds`: The amount of folds used for cross validation

  - `data`: The historical data used for cross validation when fitting
    and testing models

## Details

Prognostic covariate adjustment involves training a prognostic model
(using
[fit_best_learner](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md))
on historical data (`data_hist`) to predict the response in that data.

Assuming that the historical data is representative of the comparator
group in a “new” data set (group 0 of the binary `exposure_indicator` in
`data`), we can use the prognostic model to predict the counterfactual
outcome of all observations (including the ones in the comparator group
for which the prediction of counterfactual outcome coincides with a
prediction of actual outcome).

This prediction, which is called the prognostic score, is then used as
an adjustment covariate in the GLM (the prognostic score is added to
`formula` before calling
[rctglm](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
with the modified formula).

See much more details in the reference in the description.

## See also

Method to extract information of the prognostic model in
[prog](https://novonordisk-opensource.github.io/postcard/reference/prog.md).
Function used to fit the prognostic model is
[`fit_best_learner()`](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md).

See
[`rctglm()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
for the function and class this inherits from.

## Examples

``` r
# Generate some data
n <- 100
b0 <- 1
b1 <- 1.5
b2 <- 2
W1 <- runif(n, min = 1, max = 10)
exp_prob <- .5

dat_treat <- glm_data(
  Y ~ b0+b1*log(W1)+b2*A,
  W1 = W1,
  A = rbinom (n, 1, exp_prob)
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
 ),
    lm = list(
      model = parsnip::set_engine(
        parsnip::linear_reg(),
        "lm"
      )
    )
)
ate <- rctglm_with_prognosticscore(
  formula = Y ~ .,
  exposure_indicator = A,
  exposure_prob = exp_prob,
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
#> • mod_lm
#> i   No tuning parameters. `fit_resamples()` will be attempted
#> i 1 of 2 resampling: mod_mars
#> ✔ 1 of 2 resampling: mod_mars (269ms)
#> i   No tuning parameters. `fit_resamples()` will be attempted
#> i 2 of 2 resampling: mod_lm
#> ✔ 2 of 2 resampling: mod_lm (238ms)
#> ℹ Model with lowest RMSE: mod_lm
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

# Pull information on estimand
estimand(ate)
#>   Estimate Std. Error
#> 1 1.512962  0.2014753
```
