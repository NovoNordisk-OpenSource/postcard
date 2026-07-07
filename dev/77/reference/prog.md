# Extract information about the fitted prognostic model

Extracts the `prognostic_info` list element from an `rctglm_prog`
object. See 'Value' at
[rctglm_with_prognosticscore](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md)
for more details.

## Usage

``` r
prog(x)

# S3 method for class 'rctglm_prog'
prog(x)
```

## Arguments

- x:

  an object of class `rctglm_prog` (returned by
  [rctglm_with_prognosticscore](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md))

## Value

a list with the structure described of `prognostic_info` in the `Value`
section of
[rctglm_with_prognosticscore](https://novonordisk-opensource.github.io/postcard/reference/rctglm_with_prognosticscore.md).

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
#> ✔ 1 of 1 resampling: mod_mars (277ms)
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
#> $formula
#> Y ~ .
#> <environment: 0x55bbf5098120>
#> 
#> $model_fit
#> ══ Workflow [trained] ══════════════════════════════════════════════════════════
#> Preprocessor: Formula
#> Model: mars()
#> 
#> ── Preprocessor ────────────────────────────────────────────────────────────────
#> Y ~ .
#> 
#> ── Model ───────────────────────────────────────────────────────────────────────
#> Selected 3 of 8 terms, and 1 of 1 predictors
#> Termination condition: RSq changed by less than 0.001 at 8 terms
#> Importance: W1
#> Number of terms at each degree of interaction: 1 2 (additive model)
#> GCV 1.153364    RSS 101.9112    GRSq 0.3974581    RSq 0.4567839
#> 
#> $learners
#> $learners$mars
#> $learners$mars$model
#> MARS Model Specification (regression)
#> 
#> Main Arguments:
#>   prod_degree = 3
#> 
#> Computational engine: earth 
#> 
#> 
#> 
#> 
#> $cv_folds
#> [1] 5
#> 
#> $data
#>              Y       W1
#> 1    2.9124394 7.278070
#> 2    4.9501366 5.490171
#> 3   -0.4194504 1.130394
#> 4    4.2747795 5.584718
#> 5    3.8312129 3.240246
#> 6    3.8078752 5.784287
#> 7    0.6745001 2.046196
#> 8    3.2837203 3.923799
#> 9    3.2644458 7.442224
#> 10   3.2307320 3.204737
#> 11   1.0352681 1.759793
#> 12   4.1617119 6.358291
#> 13   4.0436445 5.806350
#> 14   2.6770825 5.026351
#> 15   3.3918011 5.517352
#> 16   4.2084264 4.104007
#> 17   5.4632685 8.282395
#> 18   0.8844953 4.080676
#> 19   4.1823739 9.948056
#> 20   4.4190720 8.054280
#> 21   3.9820146 7.743522
#> 22   3.0803113 3.100132
#> 23   4.8295120 4.175262
#> 24   2.7776362 8.202766
#> 25   2.4285216 8.146120
#> 26   3.5481356 9.287358
#> 27   1.5832299 1.978866
#> 28   3.6410631 4.584301
#> 29   6.3151076 8.229323
#> 30   3.1291967 4.734298
#> 31   2.4588041 1.723683
#> 32   4.7801386 8.362255
#> 33   3.6492343 3.768794
#> 34   3.8003356 6.755241
#> 35   0.9781454 1.077221
#> 36   2.6054132 4.141598
#> 37   4.6822163 8.628211
#> 38   4.9849223 6.778669
#> 39   3.8158349 8.987460
#> 40   4.6950243 9.603369
#> 41   3.8194107 3.703488
#> 42   2.9552755 8.374734
#> 43   3.0592671 4.729989
#> 44   4.7659053 3.750651
#> 45   4.1397835 5.665703
#> 46   4.8049196 7.521980
#> 47  -0.1180611 1.326455
#> 48   5.1528192 9.518249
#> 49   3.9563128 5.185436
#> 50   4.4773440 9.018702
#> 51   2.4650076 4.915578
#> 52   2.8249848 3.997709
#> 53   4.8496616 8.508268
#> 54   3.6085679 4.411281
#> 55   2.9711474 8.595222
#> 56   3.4698738 8.007686
#> 57   2.5843722 7.781198
#> 58   5.0910683 7.055589
#> 59   3.3714617 3.587769
#> 60   5.3787916 9.796029
#> 61   4.3717135 7.450139
#> 62   2.8114241 3.410406
#> 63  -0.6125444 1.270140
#> 64   2.4978830 6.023307
#> 65   3.4029638 4.992764
#> 66   4.2374485 6.226682
#> 67   3.4723677 4.404522
#> 68   3.0942708 3.656227
#> 69   6.2023526 8.140726
#> 70   2.5127696 3.575334
#> 71   3.0982264 9.625719
#> 72   3.2600299 4.661983
#> 73   5.1608853 9.516887
#> 74   6.3918858 7.067554
#> 75   4.0550188 3.931327
#> 76   2.9543913 7.265746
#> 77   3.6830371 9.508500
#> 78   2.5413864 5.678420
#> 79   2.0051199 2.647777
#> 80   3.4686345 9.258796
#> 81   0.4986201 3.707809
#> 82   0.7791946 1.890157
#> 83   3.4203177 9.694692
#> 84   4.3540300 7.690062
#> 85   4.7086070 2.429835
#> 86   2.1942212 3.409121
#> 87   2.8876956 4.966140
#> 88   2.7298615 9.106231
#> 89   2.8587031 3.879241
#> 90   1.4694083 5.245921
#> 91   3.1339428 2.613819
#> 92   3.4576404 6.715504
#> 93   3.0085414 8.996986
#> 94   2.9424048 8.250813
#> 95   2.3583769 5.188651
#> 96   4.2268013 6.797406
#> 97   1.7751598 7.321683
#> 98   2.3536272 5.802903
#> 99   5.2994749 8.895249
#> 100  4.3751511 9.480564
#> 
```
