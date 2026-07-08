# Power and sample size estimation for linear models

`variance_ancova` provides a convenient function for estimating a
variance to use for power and sample size approximation.

The `power_gs` and `samplesize_gs` functions calculate the
Guenther-Schouten power approximation for ANOVA or ANCOVA. The
approximation is based in (Guenther WC. Sample Size Formulas for Normal
Theory T Tests. The American Statistician. 1981;35(4):243–244) and
(Schouten HJA. Sample size formula with a continuous outcome for unequal
group sizes and unequal variances. Statistics in Medicine.
1999;18(1):87–91).

The function `power_nc` calculates the power for ANOVA or ANCOVA based
on the non-centrality parameter and the exact t-distributions.

See more details about each function in `Details` and in sections after
`Value`.

## Usage

``` r
variance_ancova(formula, data, inflation = 1, deflation = 1, ...)

power_gs(variance, ate, n, r = 1, margin = 0, alpha = 0.05, ...)

samplesize_gs(variance, ate, r = 1, margin = 0, power = 0.9, alpha = 0.05, ...)

power_nc(variance, df, ate, n, r = 1, margin = 0, alpha = 0.05, ...)
```

## Arguments

- formula:

  an object of class "formula" (or one that can be coerced to that
  class): a symbolic description used in
  [`stats::model.frame()`](https://rdrr.io/r/stats/model.frame.html) to
  create a `data.frame` with response and covariates. This data.frame is
  used to estimate the \\R^2\\, which is then used to find the variance.
  See more in details.

- data:

  a data frame, list or environment (or object coercible by
  [`as.data.frame`](https://rdrr.io/r/base/as.data.frame.html) to a data
  frame), containing the variables in `formula`. Neither a matrix nor an
  array will be accepted.

- inflation:

  a `numeric` to multiply the marginal variance of the response by.
  Default is `1` which estimates the variance directly from data. Use
  values above `1` to obtain a more conservative estimate of the
  marginal response variance.

- deflation:

  a `numeric` to multiply the \\R^2\\ by. Default is `1` which means the
  estimate of \\R^2\\ is unchanged. Use values below `1` to obtain a
  more conservative estimate of the coefficient of determination. See
  details about how \\R^2\\ related to the estimation.

- ...:

  Not currently used. Here to accomodate implementation of `...` for the
  [`repeat_power_linear()`](https://novonordisk-opensource.github.io/postcard/reference/repeat_power_linear.md)
  function.

- variance:

  a `numeric` variance to use for the approximation. See more details in
  documentation sections of each power approximating function.

- ate:

  a `numeric` minimum effect size that we should be able to detect.

- n:

  a `numeric` with number of participants in total. From this number of
  participants in the treatment group is \\n1=(r/(1+r))n\\ and the
  control group is \\n0=(1/(1+r))n\\.

- r:

  a `numeric` allocation ratio \\r=n1/n0\\. For one-to-one randomisation
  `r=1`.

- margin:

  a `numeric` superiority margin (for non-inferiority margin, a negative
  value can be provided).

- alpha:

  a `numeric` significance level. The critical value used for testing
  corresponds to using the significance level for a two-sided test. I.e.
  we use the quantile \\1-\alpha/2\\ of the null distribution as the
  critical value.

- power:

  a `numeric` giving the desired power when calculating the sample size

- df:

  a `numeric` degrees of freedom to use in the t-distribution.

## Value

All functions return a `numeric`. `variance_ancova` returns a `numeric`
with a variance estimated from data to used for power estimation and
sample size estimation. `power_xx` and `samplesize_xx` functions return
a `numeric` with the power or sample size approximation.

## Details

This details section provides information about relation between
arguments to functions and the formulas described in sections below for
each power approximation formula.

Note that all entities that carry the same name as an argument and in
the formula will not be mentioned below, as they are obviously linked
(n, r, alpha)

- `ate`: \\\beta_1-\beta_0\\

- `margin`: \\\Delta_s\\

- `variance`: \\\widehat{\sigma}^2(1-\widehat{R}^2)\\

### Finding the `variance` to use for approximation

The `variance_ancova` function estimates \\\sigma^2(1-R^2)\\ in data and
returns it as a `numeric` that can be passed directly as the `variance`
in `power_gs`. Corresponds to estimating the power from using an `lm`
with the same `formula` as specified in `variance_ancova`.

The user can estimate the `variance` any way they see fit.

## Guenther-Schouten power approximation

The estimation formula in the case of an ANCOVA model with multiple
covariate adjustment is (see description for reference):

\$\$
n=\frac{(1+r)^2}{r}\frac{(z\_{1-\alpha/2}+z\_{1-\beta})^2\widehat{\sigma}^2(1-\widehat{R}^2)}{(\beta_1-\beta_0-\Delta_s)^2}+\frac{(z\_{1-\alpha/2})^2}{2}
\$\$

where \\\widehat{R}^2= \frac{\widehat{\sigma}\_{XY}^\top
\widehat{\Sigma}\_X^{-1}\widehat{\sigma}\_{XY}}{\widehat{\sigma}^2}\\,
we denote by \\\widehat{\sigma^2}\\ an estimate of the variance of the
outcome, \\\widehat{\Sigma_X}\\ and estimate of the covariance matrix of
the covariates, and \\\widehat{\sigma\_{XY}}\\ a \\p\\-dimensional
column vector consisting of an estimate of the covariance between the
outcome variable and each covariate. In the univariate case \\R^2\\ is
replaced by \\\rho^2\\

## Power approximation using non-centrality parameter

The prospective power estimations are based on (Kieser M. Methods and
Applications of Sample Size Calculation and Recalculation in Clinical
Trials. Springer; 2020). The ANOVA power is calculated based on the
non-centrality parameter given as

\$\$nc =\sqrt{\frac{r}{(1+r)^2}\cdot
n}\cdot\frac{\beta_1-\beta_0-\Delta_s}{\sigma},\$\$

where we denote by \\\sigma^2\\ the variance of the outcome, such that
the power can be estimated as

\$\$1-\beta = 1 - F\_{t,n-2,nc}\left(F\_{t, n-2,
0}^{-1}(1-\alpha/2)\right).\$\$

The power of ANCOVA with univariate covariate adjustment and no
interaction is calculated based on the non-centrality parameter given as

\$\$nc
=\sqrt{\frac{rn}{(1+r)^2}}\frac{\beta_1-\beta_0-\Delta_s}{\sigma\sqrt{1-\rho^2}},\$\$

such that the power can be estimated as

\$\$1-\beta = 1 - F\_{t,n-3,nc}\left(F\_{t, n-3,
0}^{-1}(1-\alpha/2)\right).\$\$

The power of ANCOVA with either univariate covariate adjustment and
interaction or multiple covariate adjustement with or without
interaction is calculated based on the non-centrality parameter given as

\$\$nc
=\frac{\beta_1-\beta_0-\Delta_s}{\sqrt{\left(\frac{1}{n_1}+\frac{1}{n_0} +
X_d^\top\left((n-2)\Sigma_X\right)^{-1}X_d
\right)\sigma^2\left(1-\widehat{R}^2\right)}}.\$\$

where \\X_d = \left(\overline{X}\_1^1-\overline{X}\_0^1, \ldots,
\overline{X}\_1^p-\overline{X}\_0^p\right)^\top\\, \\\widehat{R}^2=
\frac{\widehat{\sigma}\_{XY}^\top
\widehat{\Sigma}\_X^{-1}\widehat{\sigma}\_{XY}}{\widehat{\sigma}^2}\\,
we denote by \\\widehat{\sigma^2}\\ an estimate of the variance of the
outcome, \\\widehat{\Sigma_X}\\ and estimate of the covariance matrix of
the covariates, and \\\widehat{\sigma\_{XY}}\\ a \\p\\-dimensional
column vector consisting of an estimate of the covariance between the
outcome variable and each covariate. Since we are in the case of
randomized trials the expected difference between the covariate values
between the to groups is 0. Furthermore, the elements of
\\\Sigma_X^{-1}\\ will be small, unless the variances are close to 0, or
the covariates exhibit strong linear dependencies, so that the
correlations are close to 1. These scenarios are excluded since they
could lead to potentially serious problems regarding inference either
way. These arguments are used by Zimmermann et. al (Zimmermann G, Kieser
M, Bathke AC. Sample Size Calculation and Blinded Recalculation for
Analysis of Covariance Models with Multiple Random Covariates. Journal
of Biopharmaceutical Statistics. 2020;30(1):143–159.) to approximate the
non-centrality parameter as in the univariate case where \\\rho^2\\ is
replaced by \\R^2\\.

Then the power for ANCOVA with `d` degrees of freedom can be estimated
as

\$\$1-\beta = 1 - F\_{t,d,nc}\left(F\_{t, d,0),
0}^{-1}(1-\alpha/2)\right).\$\$

## See also

See
[power_marginaleffect](https://novonordisk-opensource.github.io/postcard/reference/power_marginaleffect.md)
for a power approximation function that works for a larger class of
models.

## Examples

``` r
# Generate a data set to use as an example
n_train <- 1e3
n_test <- 100

dat_gaus <- glm_data(Y ~ 1+2*X1-X2+3*A,
                X1 = rnorm(n_train),
                X2 = rgamma(n_train, shape = 2),
                A = rbinom(n_train, size = 1, prob = 0.5),
                family = gaussian())

# Approximate the power using no adjustment covariates
va_nocov <- var(dat_gaus$Y)
power_gs(n = n_test, variance = va_nocov, ate = 1)
#> [1] 0.3597079
#> attr(,"samplesize")
#> [1] 100
#> attr(,"target_effect")
#> [1] 1
#> attr(,"exposure_prob")
#> [1] 0.5
#> attr(,"estimand_fun")
#> function (psi1, psi0) 
#> psi1 - psi0
#> <bytecode: 0x564403147978>
#> <environment: 0x564403147cc0>
#> attr(,"margin")
#> [1] 0
#> attr(,"alpha")
#> [1] 0.05

# Approximate the power with a model adjusting for both variables in the
# data generating process

## First estimate the variance sigma^2 * (1-R^2)
va_cov <- variance_ancova(Y ~ X1 + X2 + A, dat_gaus)
## Then estimate the power using this variance
power_gs(n = n_test, variance = va_cov, ate = 1.8, margin = 1, r = 2)
#> [1] 0.9536433
#> attr(,"samplesize")
#> [1] 100
#> attr(,"target_effect")
#> [1] 1.8
#> attr(,"exposure_prob")
#> [1] 0.6666667
#> attr(,"estimand_fun")
#> function (psi1, psi0) 
#> psi1 - psi0
#> <bytecode: 0x564403147978>
#> <environment: 0x564403062948>
#> attr(,"margin")
#> [1] 1
#> attr(,"alpha")
#> [1] 0.05

# Approximate the sample size needed to obtain 90% power with same model as
# above
samplesize_gs(
  variance = va_cov, ate = 1.8, power = 0.9, margin = 1, r = 2
)
#> [1] 79.64914
#> attr(,"power")
#> [1] 0.9
#> attr(,"target_effect")
#> [1] 1.8
#> attr(,"exposure_prob")
#> [1] 0.6666667
#> attr(,"estimand_fun")
#> function (psi1, psi0) 
#> psi1 - psi0
#> <bytecode: 0x564403147978>
#> <environment: 0x564403014458>
#> attr(,"margin")
#> [1] 1
#> attr(,"alpha")
#> [1] 0.05

# No adjustment covariates
power_nc(n = n_test, variance = va_nocov, df = 199, ate = 1)
#> [1] 0.3626287
#> attr(,"samplesize")
#> [1] 100
#> attr(,"target_effect")
#> [1] 1
#> attr(,"exposure_prob")
#> [1] 0.5
#> attr(,"estimand_fun")
#> function (psi1, psi0) 
#> psi1 - psi0
#> <bytecode: 0x564403147978>
#> <environment: 0x564402fcaa30>
#> attr(,"margin")
#> [1] 0
#> attr(,"alpha")
#> [1] 0.05
#> attr(,"df")
#> [1] 199
# Adjusting for all covariates in data generating process
power_nc(n = n_test, variance = va_cov, df = 196, ate = 1.8, margin = 1, r = 2)
#> [1] 0.9553085
#> attr(,"samplesize")
#> [1] 100
#> attr(,"target_effect")
#> [1] 1.8
#> attr(,"exposure_prob")
#> [1] 0.6666667
#> attr(,"estimand_fun")
#> function (psi1, psi0) 
#> psi1 - psi0
#> <bytecode: 0x564403147978>
#> <environment: 0x564402f902b0>
#> attr(,"margin")
#> [1] 1
#> attr(,"alpha")
#> [1] 0.05
#> attr(,"df")
#> [1] 196
```
