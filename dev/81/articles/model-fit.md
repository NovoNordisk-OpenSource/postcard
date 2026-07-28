# Controlling behavior of model fitting functions

``` r

library(postcard)
library(dplyr)
withr::local_seed(1395878)
withr::local_options(list(postcard.verbose = 0))
```

For introductory examples on how to use the package, see
[`vignette("postcard")`](https://novonordisk-opensource.github.io/postcard/articles/postcard.md).

In this vignette, we will explain how to alter the default behavior of
the model fitting functions
[`rctglm()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
and
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md).

### Generating some data to run examples

As in
[`vignette("postcard")`](https://novonordisk-opensource.github.io/postcard/articles/postcard.md),
we simulate data using the
[`glm_data()`](https://novonordisk-opensource.github.io/postcard/reference/glm_data.md)
function from the package.

``` r

n <- 1000
b0 <- 1
b1 <- 3
b2 <- 2

dat_gaus <- glm_data(
  Y ~ b0+b1*log(W)+b2*A,
  W = runif(n, min = 1, max = 10),
  A = rbinom(n, 1, prob = 1/2)
)

dat_gaus_hist <- glm_data(
  Y ~ b0+b1*log(W),
  W = runif(n, min = 1, max = 10)
)

dat_pois <- glm_data(
  Y ~ b0+b1*log(W)+b2*A,
  W = runif(n, min = 1, max = 10),
  A = rbinom(n, 1, 1/2),
  family = poisson(link = "log")
)
```

## Controlling verbosity

See package level options documentation in
[`options()`](https://novonordisk-opensource.github.io/postcard/reference/options.md),
giving information on how to change package behavior through options and
environmental variables. Only option is `verbose`, which controls the
amount of information printed to the console.

As a default, `verbose = 2`, meaning various information printed
throughout the algorithm. Change to `verbose = 1` for a little less
information or `verbose = 0` for no information.

Below we showcase the information that is printed with different
specifications of verbosity.

``` r

 # Default amount of printing
ate <- rctglm(
  formula = Y ~ A + W,
  exposure_indicator = A,
  exposure_prob = 1/2,
  data = dat_gaus,
  verbose = 2)
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`
ate_prog <- rctglm_with_prognosticscore(
  formula = Y ~ A + W,
  exposure_indicator = A,
  exposure_prob = 1/2,
  data = dat_gaus,
  data_hist = dat_gaus_hist,
  verbose = 2)
#> 
#> ── Fitting prognostic model ──
#> 
#> ℹ Created formula for fitting prognostic model as: Y ~ .
#> ℹ Fitting learners
#> • mod_mars
#> • mod_lm
#> • mod_gbt
#> i  No tuning parameters. `fit_resamples()` will be attempted
#> i 1 of 3 resampling: mod_mars
#> ✔ 1 of 3 resampling: mod_mars (325ms)
#> i  No tuning parameters. `fit_resamples()` will be attempted
#> i 2 of 3 resampling: mod_lm
#> ✔ 2 of 3 resampling: mod_lm (230ms)
#> i 3 of 3 tuning:     mod_gbt
#> ✔ 3 of 3 tuning:     mod_gbt (1.5s)
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
# At little less printing
ate <- rctglm(
  formula = Y ~ A + W,
  exposure_indicator = A,
  exposure_prob = 1/2,
  data = dat_gaus,
  verbose = 1)
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`
ate_prog <- rctglm_with_prognosticscore(
  formula = Y ~ A + W,
  exposure_indicator = A,
  exposure_prob = 1/2,
  data = dat_gaus,
  data_hist = dat_gaus_hist,
  verbose = 1)
#> 
#> ── Fitting prognostic model ──
#> 
#> ℹ Created formula for fitting prognostic model as: Y ~ .
#> ℹ Fitting learners
#> • mod_mars
#> • mod_lm
#> • mod_gbt
#> ℹ Model with lowest RMSE: mod_mars
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`
# No printing
ate <- rctglm(
  formula = Y ~ A + W,
  exposure_indicator = A,
  exposure_prob = 1/2,
  data = dat_gaus,
  verbose = 0)
ate_prog <- rctglm_with_prognosticscore(
  formula = Y ~ A + W,
  exposure_indicator = A,
  exposure_prob = 1/2,
  data = dat_gaus,
  data_hist = dat_gaus_hist,
  verbose = 0)
```

> Verbosity is suppressed in the rest of the vignette by setting option
> `postcard.verbose` to `0`.

## Specifying the estimand

The default `estimand_fun` in
[`rctglm()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
and
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
is the average treatment effect (ATE).

However, it’s possible to specify any estimand by giving any function
with 2 named arguments, `psi0` and `psi1`. Note that in addition to
`estimand_fun`, the functions also take arguments `estimand_fun_deriv0`
and `estimand_fun_deriv1`, which is the derivative with respect to
`psi0` and `psi1`, respectively. As a default, these are `NULL`, which
means symbolic differentiation is performed on the `estimand_fun` to
derive them automatically.

> Note that when `verbose > 0`, information is printed to the console
> about the results of the symbolic differentiation. We run the below
> code with `verbose = 1` though otherwise muted in this vignette to
> showcase this.

### Built-in estimands - average treatment effect and rate ratio

Built in is the ATE and rate ratio, which can be specified with
character strings. As is apparent from the documentation of
[`rctglm()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
and
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md),
the default of `estimand_fun` is `"ate"`, and similarly the user can
specify `estimand_fun = "rate_ratio"` to use the estimand function
`psi1 / psi0` as seen below:

``` r

rate_ratio <- rctglm(
  formula = Y ~ A + W,
  exposure_indicator = A,
  exposure_prob = 1/2,
  data = dat_pois,
  family = "poisson",
  estimand_fun = "rate_ratio",
  verbose = 1)
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1/psi0' with respect to 'psi0' as: '-(psi1/psi0^2)'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1/psi0' with respect to 'psi1' as: '1/psi0'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`
rate_ratio$estimand_funs
#> $f
#> function (psi1, psi0) 
#> psi1/psi0
#> <bytecode: 0x55bb52b25da0>
#> <environment: 0x55bb5b335988>
#> 
#> $d0
#> function (psi1, psi0) 
#> -(psi1/psi0^2)
#> <environment: 0x55bb5b335988>
#> 
#> $d1
#> function (psi1, psi0) 
#> 1/psi0
#> <environment: 0x55bb5b335988>
```

### Specifying any estimand

Below is an example showing the specification of a custom defined
function with arguments `psi0` and `psi1`.

``` r

est_fun <- function(psi1, psi0) {
  psi1 / sqrt(psi0) * 2 - 1
}

nonsense_estimand <- rctglm(
  formula = Y ~ A * W,
  exposure_indicator = A,
  exposure_prob = 1/2,
  data = dat_pois,
  family = poisson(),
  estimand_fun = est_fun,
  verbose = 1)
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function '{     psi1/sqrt(psi0) * 2 - 1 }' with respect to 'psi0' as: '-(psi1/(psi0 * sqrt(psi0)))'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function '{     psi1/sqrt(psi0) * 2 - 1 }' with respect to 'psi1' as: '2/sqrt(psi0)'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`
nonsense_estimand$estimand_funs
#> $f
#> function (psi1, psi0) 
#> {
#>     psi1/sqrt(psi0) * 2 - 1
#> }
#> 
#> $d0
#> function (psi1, psi0) 
#> -(psi1/(psi0 * sqrt(psi0)))
#> 
#> $d1
#> function (psi1, psi0) 
#> 2/sqrt(psi0)
```

## Variance estimation using cross validation

The variance is estimated as the variance of the influence function of
the marginal effect. During the calculation of this function,
counterfactual predictions are made for all observations, using a GLM to
predict their outcome in case they were in exposure group 0 and 1,
respectively.

`cv_variance` is an argument in
[`rctglm()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
and
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
that enables obtaining these counterfactual predictions as out-of-sample
(OOS) prediction by using cross validation.

## Prognostic covariate adjustment

The
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
uses the function
[`fit_best_learner()`](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md)
to fit a prognostic model to the historical data, `data_hist`.
Thereafter, the model is used to predict prognostic scores for all
observations in `data` before using these scores as a covariate when
performing plug-in estimation in a GLM using `rctglm`.

The behavior of
[`fit_best_learner()`](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md)
and subsequently fitting the prognostic model on `data_hist` in
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
is to fit a discrete super learner (discrete to avoid overfitting) by
finding the model with the lowest RMSE among a list of models. The
algorithm uses a default of 5 folds for cross validation
(`cv_prog_folds`) and if no formula is given for the prognostic model
(`prog_formula`), the function attempts to model a response with the
same name as given in the `formula` using an intercept and main effect
from all variables in `data_hist`.

### Specifying learners

`fit_best_learner` has a list of default models to use for fitting the
discrete super learner, which can be seen in the section below. However,
it’s easy for the user to specify a list of other learners to train the
discrete super learner. The package utilises the framework of
[tidymodels](https://www.tidymodels.org/), and it can be seen below how
the list of models can look like.

#### Default learners

Below we show the code of the `default_learners` function, which creates
a list of default learners that are used in
[`fit_best_learner()`](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md)
and
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md).

> The body of the function thus represents a valid way of specifying a
> list as the `learners` argument.

``` r

default_learners
#> function () 
#> {
#>     list(mars = list(model = parsnip::mars(mode = "regression", 
#>         prod_degree = 3) %>% parsnip::set_engine("earth")), lm = list(model = parsnip::linear_reg() %>% 
#>         parsnip::set_engine("lm")), gbt = list(model = parsnip::boost_tree(mode = "regression", 
#>         trees = parsnip::tune("trees"), tree_depth = parsnip::tune("tree_depth"), 
#>         learn_rate = 0.1) %>% parsnip::set_engine("xgboost"), 
#>         grid = data.frame(trees = seq(from = 25, to = 500, by = 25), 
#>             tree_depth = 3)))
#> }
#> <bytecode: 0x55bb5788c8d0>
#> <environment: namespace:postcard>
```

#### Creating own list of learners

A listing of models is available at [the tidymodels
website](https://www.tidymodels.org/find/parsnip/), and the user can
specify a list of any of those models as the `learners` argument.

Below is an example of fitting the prognostic model as a discrete super
learner with the best RMSE among a *random forest* and *linear support
vector machines* model.

``` r

learners <- list(
  rf = list(
    model = parsnip::rand_forest(
      mode = "regression",
      trees = 500,
      min_n = parsnip::tune("min_n")
    ) %>% 
      parsnip::set_engine("ranger"),
    grid = data.frame(
      min_n = 1:10
    )
  ),
  svm.linear = list(
    model = parsnip::svm_linear(
      mode = "regression",
      cost = parsnip::tune("cost"),
      margin = parsnip::tune("margin")) %>% 
      parsnip::set_engine("LiblineaR"),
    grid = data.frame(
      cost = 1:5,
      margin = seq(0.1, 0.5, 0.1)
    )
  )
)

model_own_learners <- rctglm_with_prognosticscore(
  formula = Y ~ A * W,
  exposure_indicator = A,
  exposure_prob = 1/2,
  data = dat_gaus,
  data_hist = dat_gaus_hist,
  learners = learners)
```

### Inspecting the prognostic model

It’s possible to view information regarding the fit of the prognostic
model in the `rctglm_prog` class object that
[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
returns by looking at the list element `prognostic_info`. A shorthand
way of doing this is using the method
[`prog()`](https://novonordisk-opensource.github.io/postcard/reference/prog.md).

Inside this list element are elements

- `formula`: The formula used as `preproc` when fitting models in
  [`fit_best_learner()`](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md)
- `model_fit`: The result of
  [`fit_best_learner()`](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md)
- `learners`: The list of learners used
- `cv_folds`: The number of folds used for cross validation
- `data`: The data given as `data_hist`, which the prognostic model is
  fitted upon

> Note that we change the value of data to only show the first rows to
> not take up too much space when printing in the vignette.

``` r

prog_info <- prog(model_own_learners)
prog_info$data <- head(prog_info$data)
prog_info
#> $formula
#> Y ~ .
#> <environment: 0x55bb5db9fbd8>
#> 
#> $model_fit
#> ══ Workflow [trained] ══════════════════════════════════════════════════════════
#> Preprocessor: Formula
#> Model: rand_forest()
#> 
#> ── Preprocessor ────────────────────────────────────────────────────────────────
#> Y ~ .
#> 
#> ── Model ───────────────────────────────────────────────────────────────────────
#> Ranger result
#> 
#> Call:
#>  ranger::ranger(x = maybe_data_frame(x), y = y, num.trees = ~500,      min.node.size = min_rows(~10L, x), num.threads = 1, verbose = FALSE,      seed = sample.int(10^5, 1)) 
#> 
#> Type:                             Regression 
#> Number of trees:                  500 
#> Sample size:                      1000 
#> Number of independent variables:  1 
#> Mtry:                             1 
#> Target node size:                 10 
#> Variable importance mode:         none 
#> Splitrule:                        variance 
#> OOB prediction error (MSE):       1.381527 
#> R squared (OOB):                  0.6751407 
#> 
#> $learners
#> $learners$rf
#> $learners$rf$model
#> Random Forest Model Specification (regression)
#> 
#> Main Arguments:
#>   trees = 500
#>   min_n = parsnip::tune("min_n")
#> 
#> Computational engine: ranger 
#> 
#> 
#> $learners$rf$grid
#>    min_n
#> 1      1
#> 2      2
#> 3      3
#> 4      4
#> 5      5
#> 6      6
#> 7      7
#> 8      8
#> 9      9
#> 10    10
#> 
#> 
#> $learners$svm.linear
#> $learners$svm.linear$model
#> Linear Support Vector Machine Model Specification (regression)
#> 
#> Main Arguments:
#>   cost = parsnip::tune("cost")
#>   margin = parsnip::tune("margin")
#> 
#> Computational engine: LiblineaR 
#> 
#> 
#> $learners$svm.linear$grid
#>   cost margin
#> 1    1    0.1
#> 2    2    0.2
#> 3    3    0.3
#> 4    4    0.4
#> 5    5    0.5
#> 
#> 
#> 
#> $cv_folds
#> [1] 5
#> 
#> $data
#>          Y        W
#> 1 8.038754 9.625692
#> 2 9.134305 9.608290
#> 3 5.763027 3.165046
#> 4 3.258947 2.021302
#> 5 7.442597 6.177533
#> 6 5.428690 6.740723
```
