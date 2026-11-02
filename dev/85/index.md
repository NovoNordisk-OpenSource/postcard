# postcard

postcard provides tools for accurately estimating marginal effects using
plug-in estimation with GLMs, including increasing precision using
prognostic covariate adjustment. See [Powering RCTs for marginal effects
with GLMs using prognostic score
adjustment](https://arxiv.org/abs/2503.22284) by Højbjerre-Frandsen et.
al (2025).

### Estimating marginal effects

[`rctglm()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm.md)
is used to estimate marginal effects. See introductory examples of its
usage in
[`vignette("postcard")`](https://novonordisk-opensource.github.io/postcard/articles/postcard.md)
and more details in
[`vignette("model-fit")`](https://novonordisk-opensource.github.io/postcard/articles/model-fit.md).

**Marginal effects** are causal effects of the form \\r(\Psi_1,
\Psi_0)\\, where \\\Psi_a=\mathbb{E}\[Y(a)\]\\ are population mean
outcomes under exposure \\a=0, 1\\, respectively, and \\r\\ is the
*estimand* (function). \\\Psi_a\\ are sometimes referred to as
*counterfactual means*. The package uses **plug-in estimation** for
robust estimation of any marginal effect estimand as well as **influence
functions** for robust estimation of the variance of the estimand
(Rosenblum, M. and M. J. van der Laan, 2010: Simple, efficient
estimators of treatment effects in randomized trials using generalized
linear models to leverage baseline variables. The International Journal
of Biostatistics, 6, no. 1).

### Prognostic covariate adjustment

[`rctglm_with_prognosticscore()`](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
is used to estimate marginal effects including the use of prognostic
covariate adjustment. See introductory examples of its usage in
[`vignette("postcard")`](https://novonordisk-opensource.github.io/postcard/articles/postcard.md)
and more details in
[`vignette("model-fit")`](https://novonordisk-opensource.github.io/postcard/articles/model-fit.md).

*Prognostic covariate adjustment* involves training a **prognostic
model** on historical data to predict the response in that data.
Assuming that the historical data is representative of the comparator
group in a *“new”* data set, we can use the prognostic model to predict
the *comparator counterfactual outcome* for all observations (including
the ones in the comparator group). This prediction, which is called the
**prognostic score**, is then used as an adjustment covariate in the
GLM.

## Power approximation

Implementations of sample size/power approximation formulas are
available, enabling retrospective power analyses to be performed using
the package.

Introductory examples are available in
[`vignette("postcard")`](https://novonordisk-opensource.github.io/postcard/articles/postcard.md)
and more details in
[`vignette("prospective-power")`](https://novonordisk-opensource.github.io/postcard/articles/prospective-power.md).

### When estimating marginal effects using any model

A method of estimating power in any case of estimating marginal effects
is described in the reference at the top of this page, and the algorithm
is implemented in the function `power_marginaleffect`.

### Specifically for linear models

Functionalities available to estimate the power for linear models
include functions `variance_ancova`, `power_gs`, `samplesize_gs`,
`power_nc`.

## Installation

To install the package:

``` r

install.packages("postcard")

# Development version:
# install.packages("pak")
pak::pak("NovoNordisk-OpenSource/postcard")
```
