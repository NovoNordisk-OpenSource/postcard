# Power approximation for estimating marginal effects in GLMs

The functions implements the algorithm for power estimation described in
[Powering RCTs for marginal effects with GLMs using prognostic score
adjustment](https://arxiv.org/abs/2503.22284) by Højbjerre-Frandsen et.
al (2025). See a bit more context in details and all details in
reference.

## Usage

``` r
power_marginaleffect(
  response,
  predictions,
  target_effect,
  exposure_prob,
  var1 = NULL,
  kappa1_squared = NULL,
  estimand_fun = "ate",
  estimand_fun_deriv0 = NULL,
  estimand_fun_deriv1 = NULL,
  inv_estimand_fun = NULL,
  margin = estimand_fun(1, 1),
  alpha = 0.05,
  tolerance = 0.001,
  verbose = options::opt("verbose"),
  ...
)
```

## Arguments

- response:

  a vector of mode `numeric` with the response variable from comparator
  participants

- predictions:

  a vector of mode `numeric` with predictions of the response

- target_effect:

  a `numeric` minimum effect size that we should be able to detect. See
  more in details.

- exposure_prob:

  a `numeric` with the probability of being in "group 1" (rather than
  group 0). See more in details.

- var1:

  a `numeric` variance of the potential outcome corresponding to group
  1, or a `function` with a single argument meant to obtain `var1` as a
  transformation of the variance of the potential outcome corresponding
  to group 0. See more in details.

- kappa1_squared:

  a `numeric` mean-squared error from predicting potential outcome
  corresponding to group 1, or a `function` with a single arguments
  meant to obtain `kappa1_squared` as a transformation of the MSE in
  group 0. See more in details.

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

- inv_estimand_fun:

  (optional) a `function` with arguments `psi0` and `target_effect`, so
  `estimand_fun(psi1 = y, psi0 = x) = z` and
  `inv_estimand_fun(psi0 = x, target_effect = z) = y` for all x, y, z.
  If left as `NULL`, the inverse will be found numerically.

- margin:

  a `numeric` superiority margin. As a default, the `estimand_fun` is
  evaluated with the same counterfactual means `psi1` and `psi0`,
  corresponding to a superiority margin assuming no difference (fx. 0
  for ATE and 1 for rate ratio).

- alpha:

  a `numeric` significance level. The critical value used for testing
  corresponds to using the significance level for a two-sided test. I.e.
  we use the quantile \\1-\alpha/2\\ of the null distribution as the
  critical value.

- tolerance:

  passed to [all.equal](https://rdrr.io/r/base/all.equal.html) when
  comparing calculated `target_effect` from derivations and given
  `target_effect` during numeric derivation of `inv_estimand_fun`. Thus
  only relevant when `inv_estimand_fun` is `NULL`.

- verbose:

  `numeric` verbosity level. Higher values means more information is
  printed in console. A value of 0 means nothing is printed to console
  during execution (Defaults to `2`, overwritable using option
  'postcard.verbose' or environment variable 'R_POSTCARD_VERBOSE')

- ...:

  arguments passed to
  [stats::uniroot](https://rdrr.io/r/stats/uniroot.html), which is used
  to find the inverse of `estimand_fun`, when `inv_estimand_fun` is
  `NULL`.

## Value

a `numeric` with the estimated power.

## Details

The reference in the description shows in its "Prospective power"
section a derivation of a variance bound \$\$ v\_\infty^{\uparrow 2} =
r_0'^{\\ 2}\sigma_0^2+ r_1'^{\\ 2}\sigma_1^2+
\pi_0\pi_1\left(\frac{\|r_0'\|\kappa_0}{\pi_0} +
\frac{\|r_1'\|\kappa_1}{\pi_1} \right)^2 \$\$

where \\r_a'\\ is the derivative of the `estimand_fun` with respect to
\\\Psi_a\\, \\\sigma_a^2\\ is the variance of the potential outcome
corresponding to group \\a\\, \\\pi_a\\ is the probability of being
assigned to group \\a\\, and \\\kappa_a\\ is the expected mean-squared
error when predicting the potential outcome corresponding to group
\\a\\.

The variance bound is then used for calculating a lower bound of the
power using the distributions corresponding to the null and alternative
hypotheses \\\mathcal{H}\_0: \hat{\Psi} \sim F_0 = \mathcal{N}(\Delta
,v\_\infty^{\uparrow 2} / n)\\ and \\\mathcal{H}\_1: \hat{\Psi} \sim F_1
= \mathcal{N}(\Psi,v\_\infty^{\uparrow 2} / n)\\. See more details in
the reference.

### Relating arguments to formulas

- `response`: Used to obtain both \\\sigma_0^2\\ (by taking the sample
  variance of the response) and \\\kappa_0\\.

- `predictions`: Used when calculating the MSE \\\kappa_0\\.

- `var1`: \\\sigma_1^2\\. As a default, chosen to be the same as
  \\\sigma_0^2\\. Can specify differently through this argument fx. by

  - Inflating or deflating the value of \\\sigma_0^2\\ by a scalar
    according to prior beliefs. Fx. specify `var1 = function(x) 1.2 * x`
    to inflate \\\sigma_0^2\\ by 1.2.

  - If historical data is available for group 1, an estimate of the
    variance from that data can be provided here.

- `kappa1_squared`: \\\kappa_1\\. Same as for `var1`, default is to
  assume the same value as `kappa0_squared`, which is found by using the
  `response` and `predictions` vectors. Adjust the value according to
  prior beliefs if relevant.

- `target_effect`: \\\Psi\\.

- `exposure_prob`: \\\pi_1\\

## See also

See
[power_linear](https://novonordisk-opensource.github.io/postcard/reference/power_linear.md)
for power approximation functionalities specific to linear models.

## Examples

``` r
# Generate a data set to use as an example
n <- 100
exposure_prob <- .5

dat_gaus <- glm_data(Y ~ 1+2*X1-X2+3*A+1.6*A*X2,
                X1 = rnorm(n),
                X2 = rgamma(n, shape = 2),
                A = rbinom(n, size = 1, prob = exposure_prob),
                family = gaussian())

# ---------------------------------------------------------------------------
# Obtain out-of-sample (OOS) prediction using glm model
# ---------------------------------------------------------------------------
gaus1 <- dat_gaus[1:(n/2), ]
gaus2 <- dat_gaus[(n/2+1):n, ]

glm1 <- glm(Y ~ X1 + X2 + A, data = gaus1)
glm2 <- glm(Y ~ X1 + X2 + A, data = gaus2)
preds_glm1 <- predict(glm2, newdata = gaus1, type = "response")
preds_glm2 <- predict(glm1, newdata = gaus2, type = "response")
preds_glm <- c(preds_glm1, preds_glm2)

# Obtain power
power_marginaleffect(
  response = dat_gaus$Y,
  predictions = preds_glm,
  target_effect = 2,
  exposure_prob = exposure_prob
)
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`
#> [1] 0.8599756
#> attr(,"samplesize")
#> [1] 100
#> attr(,"target_effect")
#> [1] 2
#> attr(,"exposure_prob")
#> [1] 0.5
#> attr(,"estimand_fun")
#> function (psi1, psi0) 
#> psi1 - psi0
#> <bytecode: 0x5589e9b58368>
#> <environment: 0x5589ede6b0d0>
#> attr(,"margin")
#> [1] 0
#> attr(,"alpha")
#> [1] 0.05

# ---------------------------------------------------------------------------
# Get OOS predictions using discrete super learner and adjust variance
# ---------------------------------------------------------------------------
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
lrnr1 <- fit_best_learner(preproc = list(mod = Y ~ X1 + X2 + A),
                          data = gaus1,
                          learners = learners)
#> ℹ Fitting learners
#> • mod_mars
#> • mod_lm
#> i   No tuning parameters. `fit_resamples()` will be attempted
#> i 1 of 2 resampling: mod_mars
#> ✔ 1 of 2 resampling: mod_mars (284ms)
#> i   No tuning parameters. `fit_resamples()` will be attempted
#> i 2 of 2 resampling: mod_lm
#> ✔ 2 of 2 resampling: mod_lm (239ms)
#> ℹ Model with lowest RMSE: mod_mars
lrnr2 <- fit_best_learner(preproc = list(mod = Y ~ X1 + X2 + A),
                          data = gaus2,
                          learners = learners)
#> ℹ Fitting learners
#> • mod_mars
#> • mod_lm
#> i   No tuning parameters. `fit_resamples()` will be attempted
#> i 1 of 2 resampling: mod_mars
#> ✔ 1 of 2 resampling: mod_mars (270ms)
#> i   No tuning parameters. `fit_resamples()` will be attempted
#> i 2 of 2 resampling: mod_lm
#> ✔ 2 of 2 resampling: mod_lm (236ms)
#> ℹ Model with lowest RMSE: mod_mars
preds_lrnr1 <- dplyr::pull(predict(lrnr2, new_data = gaus1))
preds_lrnr2 <- dplyr::pull(predict(lrnr1, new_data = gaus2))
preds_lrnr <- c(preds_lrnr1, preds_lrnr2)

# Estimate the power AND adjust the assumed variance in the "unknown"
# group 1 to be 20% larger than in group 0
power_marginaleffect(
  response = dat_gaus$Y,
  predictions = preds_lrnr,
  target_effect = 2,
  exposure_prob = exposure_prob,
  var1 = function(var0) 1.2 * var0
)
#> 
#> ── Symbolic differentiation of estimand function ──
#> 
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv0`
#> ℹ Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
#> • Alternatively, specify the derivative through the argument
#> `estimand_fun_deriv1`
#> [1] 0.8720903
#> attr(,"samplesize")
#> [1] 100
#> attr(,"target_effect")
#> [1] 2
#> attr(,"exposure_prob")
#> [1] 0.5
#> attr(,"estimand_fun")
#> function (psi1, psi0) 
#> psi1 - psi0
#> <bytecode: 0x5589e9b58368>
#> <environment: 0x5589e7f700c8>
#> attr(,"margin")
#> [1] 0
#> attr(,"alpha")
#> [1] 0.05
```
