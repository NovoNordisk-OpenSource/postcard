# get_fun_args
test_that("`get_fun_args` gives argument names as vector", {
  extpkg_args <- get_fun_args(base::t)
  thispkg_args <- get_fun_args(get01args)
  f <- function(x, y) x+y
  predef_args <- get_fun_args(f)
  anon_args <- get_fun_args(\(a, b) a-b)

  expect_equal(extpkg_args, "x")
  expect_equal(thispkg_args, "fun")
  expect_equal(predef_args, c("x", "y"))
  expect_equal(anon_args, c("a", "b"))
})

# deparse_fun_body
test_that("`deparse_fun_body` produces character string of function body", {
  extpkg_body <- deparse_fun_body(base::t)
  thispkg_body <- deparse_fun_body(get01args)
  f <- function(x, y) {
    z <- x+y
    return(z)
  }
  predef_body <- deparse_fun_body(f)
  anon_body <- deparse_fun_body(\(a, b) a-b)

  expect_type(extpkg_body, "character")
  expect_length(extpkg_body, 1)
  expect_snapshot(extpkg_body)

  expect_type(thispkg_body, "character")
  expect_length(thispkg_body, 1)

  expect_type(predef_body, "character")
  expect_length(predef_body, 1)
  expect_snapshot(predef_body)

  expect_type(anon_body, "character")
  expect_length(anon_body, 1)
  expect_equal(anon_body, "a - b")
})

# get_response_from_formula
test_that("`get_response_from_formula` works for different formula specifiations", {
  expect_equal(get_response_from_formula(Y ~ A),
               "Y")
  expect_equal(get_response_from_formula(formula("testing~bla")),
               "testing")
})

# is_response_in_data
cli::test_that_cli("`is_response_in_data` correctly gives error when column not in data", {
  dat <- data.frame(A = 1:2, B = 4:5)
  expect_snapshot(
    error = TRUE,
    is_response_in_data(formula = C ~ A, data = dat))
})

test_that("`is_response_in_data` does not give error when column is in data", {
  dat <- data.frame(A = 1:2, B = 4:5)
  expect_no_error(
    is_response_in_data(formula = B ~ A, data = dat)
  )
})

# formula_everything
test_that("`formula_everything` returns the correct formula object", {
  expect_equal(
    formula_everything(Y ~ A),
    Y ~ .)
  expect_equal(
    formula_everything(resp ~ A + B + mph * fpg),
    resp ~ .)
})

# formula_to_str
test_that("`formula_to_str` returns character of length 1", {
  formula_str <- formula_to_str(Y ~ A + X)
  expect_equal(formula_str, "Y ~ A + X")

  formula_str2 <- formula_to_str(Y ~ A1 + A2 + A3 + A4 + A5 + A6 + A7 + A8 + A9 +
                                   A10 + A11 + A12 + A13 + A14 + A15 + A16 + A17)
  expect_length(formula_str2, 1)
  expect_equal(formula_str2, paste0("Y ~ ", paste("A", 1:17, sep = "", collapse = " + ")))
})

# check_formula
test_that("`check_formula` works", {
  expect_s3_class(check_formula("Y ~ 1 + X"), "formula")
  expect_error(check_formula(2),
               regexp = "This usually means you did not include a response")
  expect_error(check_formula(1+2*x1),
               regexp = "This usually means you did not include a response")
})

# get01args
test_that("`get01args` returns list of arguments with 0 and 1 in them", {
  ate <- function(psi0, psi1) psi1 - psi0
  expect_equal(
    get01args(fun = ate),
    list(arg0 = "psi0", arg1 = "psi1")
  )
  some_fun <- function(blablabla0, c1) sum(log(blablabla0), sqrt(c1))
  expect_equal(
    get01args(fun = some_fun),
    list(arg0 = "blablabla0", arg1 = "c1")
  )
  fun_with_additionalargs <- function(psi0, psi1, add_arg, ...) psi1 - psi0
  expect_equal(
    get01args(fun = fun_with_additionalargs),
    list(arg0 = "psi0", arg1 = "psi1")
  )
})

cli::test_that_cli("`get01args` gives error when arguments with 0 and 1 are missing", {
  argsnotendingwith0and1 <- function(psi0, psi18) psi18 - psi0
  expect_error({
    get01args(argsnotendingwith0and1)
  },
  regexp = "need to end in"
  )
  missing1 <- function(a0, b) a0 - b
  expect_error({
    get01args(missing1)
  },
  regexp = "need to end in"
  )
  missing0 <- function(a, b1) a - b1
  expect_error({
    get01args(missing0)
  },
  regexp = "need to end in"
  )
  # missing both
  expect_error({
    get01args(sum)
  },
  regexp = "need to end in"
  )
})

# print_symbolic_differentiation
test_that("`print_symbolic_differentiation` returns the result of Deriv", {
  ate <- function(psi0, psi1) psi1 - psi0
  expect_equal(
    print_symbolic_differentiation(ate, "psi0"),
    Deriv::Deriv(ate, "psi0")
  )
})

cli::test_that_cli("`print_symbolic_differentiation` provides message", {
  withr::local_options(postcard.verbose = 1)
  ate <- function(psi0, psi1) psi1 - psi0
  # Note we are using the transform argument to remove printing of
  # the environment which changes between each run
  expect_snapshot(
    print_symbolic_differentiation(
      ate,
      "psi1",
      add_string = "test string add"
    ),
    transform = function(x) gsub("^<environment:.*>$", "", x)
  )
})

test_that("`get_predict_method` works for different model types", {
  mods <- predict_method_models()

  expect_equal(get_predict_method(mods$lm_mod), predict.lm)
  expect_equal(get_predict_method(mods$glm_mod), predict.glm)
  expect_equal(get_predict_method(mods$dsl_mod), getS3method("predict", "workflow"))
})

test_that("`get_predict_method` fails for object with no predict method", {
  expect_error(get_predict_method(5),
               regexp = "Could not find predict method for object of class")
})

test_that("`get_newdata_arg_name` works for different model types", {
  mods <- predict_method_models()

  expect_equal(get_newdata_arg_name(mods$lm_mod), "newdata")
  expect_equal(get_newdata_arg_name(mods$glm_mod), "newdata")
  expect_equal(get_newdata_arg_name(mods$dsl_mod), "new_data")
})

test_that("`r_to_exposure_prob` calculates correctly", {
  expect_equal(r_to_exposure_prob(2), 2/3)
  expect_equal(r_to_exposure_prob(1/2), 1/3)
})

test_that("`add_power_assumption_params_to_data` works correctly", {
  dat <- data.frame(A = c(0, 1, 1, 0, 1),
                    W = rnorm(5),
                    Y = rnorm(5))

  ep <- 1/2
  te <- 1.3
  margin <- 0.5
  alpha <- 0.1
  # Test with default parameters
  result1 <- add_power_assumption_params_to_data(
    .data = dat, power_fun = "power_marginaleffect",
    exposure_prob = ep, target_effect = te, margin = margin, alpha = alpha
  )
  expect_true(all(c("samplesize", "target_effect", "exposure_prob", "margin",
                    "alpha", "power_fun") %in% colnames(result1)))
  expect_equal(nrow(result1), nrow(dat))
  expect_equal(nrow(result1), unique(result1$samplesize))
  expect_equal(ep, unique(result1$exposure_prob))
  expect_equal(te, unique(result1$target_effect))
  expect_equal(margin, unique(result1$margin))
  expect_equal(alpha, unique(result1$alpha))

  # Test with custom parameters
  result2 <- add_power_assumption_params_to_data(
    .data = dat, power_fun = "power_gs", ate = 1.3, margin = margin, alpha = alpha
  )
  expect_true(all(c("samplesize", "target_effect", "exposure_prob", "margin",
                    "alpha", "power_fun") %in% colnames(result2)))
  expect_equal(nrow(result2), nrow(dat))
  expect_equal(nrow(result2), unique(result2$samplesize))
  expect_equal(ep, unique(result2$exposure_prob))
  expect_equal(te, unique(result2$target_effect))
  expect_equal(margin, unique(result2$margin))
  expect_equal(alpha, unique(result2$alpha))
})

test_that("`get_formula_from_model` gives correct type of output", {
  lm <- lm(cyl ~ wt + mpg, data = mtcars)
  lm_formula <- get_formula_from_model(lm)

  dsl <- fit_best_learner(list(cyl ~ wt + mpg), data = mtcars)
  dsl_formula <- get_formula_from_model(dsl)

  expect_type(lm_formula, "language")
  expect_equal(dsl_formula, lm_formula)
})

test_that("`get_formula_from_model` gives error when no method exists", {
  expect_error(
    get_formula_from_model(list(a = 2)),
    regexp = "Tried extracting the formula of an element in"
  )
})

test_that("`get_response_name_from_model_list` correctly returns response name when it's given as the same in models", {
  lm1 <- lm(cyl ~ wt + mpg, data = mtcars)
  glm1 <- glm(cyl ~ wt + mpg, data = mtcars, family = poisson())
  expect_equal(
    "cyl",
    get_response_name_from_model_list(list(lm1, glm1), .data = mtcars)
  )
})

test_that("`get_response_name_from_model_list` gives error when response names different in models", {
  lm1 <- lm(cyl ~ wt + mpg, data = mtcars)
  glm2 <- glm(gear ~ wt + mpg, data = mtcars, family = poisson())
  expect_error(
    get_response_name_from_model_list(list(lm1, glm2), .data = mtcars),
    regexp = "Could not extract a unique response"
  )
})

test_that("`get_response_name_from_model_list` gives response name if one model has response name and other doesn't specify", {
  lm1 <- lm(cyl ~ wt + mpg, data = mtcars)
  expect_equal(
    "cyl",
    get_response_name_from_model_list(list(lm1, 5), .data = mtcars)
  )
})

test_that("`get_response_name_from_model_list` gives error if response name cannot be extracted from any model", {
  expect_error(
    get_response_name_from_model_list(list(2, 5), .data = mtcars),
    regexp = "No method exists. Define a method get_formula_from_model.numeric"
  )
})
