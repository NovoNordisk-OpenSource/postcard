# Creates a list of learners

This function creates a list of learners compatible with the `learners`
argument of
[fit_best_learner](https://novonordisk-opensource.github.io/postcard/reference/fit_best_learner.md),
which is used as the default argument.

## Usage

``` r
default_learners()
```

## Value

a named `list` of learners, where each element consists of a

- `model`: A `parsnip` model specification

- `grid`: A `data.frame` with columns corresponding to tuning parameters

## Examples

``` r
default_learners()
#> $mars
#> $mars$model
#> MARS Model Specification (regression)
#> 
#> Main Arguments:
#>   prod_degree = 3
#> 
#> Computational engine: earth 
#> 
#> 
#> 
#> $lm
#> $lm$model
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: lm 
#> 
#> 
#> 
#> $gbt
#> $gbt$model
#> Boosted Tree Model Specification (regression)
#> 
#> Main Arguments:
#>   trees = parsnip::tune("trees")
#>   tree_depth = parsnip::tune("tree_depth")
#>   learn_rate = 0.1
#> 
#> Computational engine: xgboost 
#> 
#> 
#> $gbt$grid
#>    trees tree_depth
#> 1     25          3
#> 2     50          3
#> 3     75          3
#> 4    100          3
#> 5    125          3
#> 6    150          3
#> 7    175          3
#> 8    200          3
#> 9    225          3
#> 10   250          3
#> 11   275          3
#> 12   300          3
#> 13   325          3
#> 14   350          3
#> 15   375          3
#> 16   400          3
#> 17   425          3
#> 18   450          3
#> 19   475          3
#> 20   500          3
#> 
#> 
```
