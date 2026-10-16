# Generate data simulated from a GLM

Provide a formula, variables and a family to generate a linear predictor
using the formula and provided variables before using the inverse link
of the family to generate the GLM modelled mean, mu, which is then used
to simulate the response with this mean from the generating function
according to the chosen family.

## Usage

``` r
glm_data(formula, ..., family = gaussian(), family_args = NULL)
```

## Arguments

- formula:

  an object of class "formula" (or one that can be coerced to that
  class): a symbolic description of the model to be fitted. The details
  of model specification are given under ‘Details’ in the
  [glm](https://rdrr.io/r/stats/glm.html) documentation.

- ...:

  a `data.frame` with columns corresponding to variables used in
  `formula`, a named `list` of those variables, or individually provided
  named arguments of variables

- family:

  the `family` of the response. this can be a `character` string naming
  a family function, a family `function` or the result of a `call` to a
  family function

- family_args:

  a named `list` with values of arguments passed to family relevant
  `r<family_name>` function for simulating the data

## Value

a `data.frame`

## Examples

``` r
# Generate a gaussian response from a single covariate
glm_data(Y ~ 1+2*x1,
                x1 = rnorm(10))
#>            Y          x1
#> 1  -1.449147 -0.89480241
#> 2   2.865960  0.90426912
#> 3  -1.648712  0.07964921
#> 4  -2.429914 -1.25882722
#> 5   2.268991  1.02568511
#> 6  -1.125662 -0.73077860
#> 7   1.246019 -0.19014551
#> 8   1.550481  0.52886469
#> 9   2.370782  0.55021053
#> 10  2.566846  0.54968434

# Generate a gaussian response from a single covariate with non-linear
# effects. Specify that the response should have standard deviation sqrt(3)
glm_data(Y ~ 1+2*log(x1),
                x1 = runif(10, min = 1, max = 10),
                family_args = list(sd = sqrt(3)))
#>           Y       x1
#> 1  8.271982 7.889190
#> 2  4.641847 6.642700
#> 3  7.418128 7.573046
#> 4  3.056034 4.813340
#> 5  3.081129 3.414977
#> 6  3.954917 7.921432
#> 7  3.906440 6.286120
#> 8  6.464185 9.087110
#> 9  6.438088 8.832921
#> 10 2.844874 4.593756

# Generate a negative binomial response
glm_data(Y ~ 1+2*x1-x2,
                x1 = rnorm(10),
                x2 = rgamma(10, shape = 2),
                family = MASS::negative.binomial(2))
#>     Y         x1        x2
#> 1   0 -0.7836391 2.3050987
#> 2   1 -0.9531239 1.3214499
#> 3   0  1.7927561 3.7469426
#> 4   0  0.3489767 1.8461783
#> 5   2  0.2591038 2.0354566
#> 6   0 -0.8059519 0.6438993
#> 7   4  0.1056647 0.7646888
#> 8   2 -0.3335997 0.9691220
#> 9  20  1.6418480 0.6479179
#> 10  0 -0.6439059 0.5980742

# Provide variables as a list/data.frame and pass a link to the negative.binomial
# function
glm_data(resp ~ 1+2*x1-x2,
                data.frame(
                  x1 = rnorm(10),
                  x2 = rgamma(10, shape = 2)
                ),
                family = MASS::negative.binomial(2),
                family_args = list(link = "identity"))
#>    resp          x1        x2
#> 1     0 -0.05367151 2.0555178
#> 2     0 -0.56352463 4.8979183
#> 3     0 -0.74390896 0.9440099
#> 4     0 -0.10904165 0.3404743
#> 5     0 -0.56082923 2.1408569
#> 6     0  0.18800155 0.6841673
#> 7     1  0.74885094 1.8483538
#> 8     0 -1.91653832 0.6336780
#> 9     2  0.23609585 0.2305099
#> 10    2  0.62895342 1.4685068
```
