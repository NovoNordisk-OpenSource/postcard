#' Generate data simulated from a GLM
#'
#' Provide a formula, variables and a family to generate a linear predictor
#' using the formula and provided variables before using the inverse link of
#' the family to generate the GLM modelled mean, mu, which is then used to
#' simulate the response with this mean from the generating function according
#' to the chosen family.
#'
#' @inheritParams rctglm
#' @param ... a `data.frame` with columns corresponding to variables used
#' in `formula`, a named `list` of those variables, or individually provided
#' named arguments of variables
#' @param family the `family` of the response. this can be a `character`
#' string naming a family function, a family `function` or the result of
#' a `call` to a family function
#' @param family_args a named `list` with values of arguments passed to
#' family relevant `r<family_name>` function for simulating the data
#'
#' @returns a `data.frame`
#'
#' @examples
#' # Generate a gaussian response from a single covariate
#' glm_data(Y ~ 1+2*x1,
#'                 x1 = rnorm(10))
#'
#' # Generate a gaussian response from a single covariate with non-linear
#' # effects. Specify that the response should have standard deviation sqrt(3)
#' glm_data(Y ~ 1+2*abs(sin(x1)),
#'                 x1 = runif(10, min = -2, max = 2),
#'                 family_args = list(sd = sqrt(3)))
#'
#' # Generate a negative binomial response
#' glm_data(Y ~ 1+2*x1-x2,
#'                 x1 = rnorm(10),
#'                 x2 = rgamma(10, shape = 2),
#'                 family = MASS::negative.binomial(2))
#'
#' # Provide variables as a list/data.frame and pass a link to the negative.binomial
#' # function
#' glm_data(resp ~ 1+2*x1-x2,
#'                 data.frame(
#'                   x1 = rnorm(10),
#'                   x2 = rgamma(10, shape = 2)
#'                 ),
#'                 family = MASS::negative.binomial(2),
#'                 family_args = list(link = "identity"))
#'
#' @export
glm_data <- function(formula,
                     ...,
                     family = gaussian(),
                     family_args = NULL) {
  formula <- check_formula(formula)
  family <- check_family(family)

  covs <- list(...)
  if (length(covs) == 0) cli::cli_abort("You need to specify columns to generate data from")
  # if (length(data_list) == 0 && is.null(formula)) {
  #   data_list <- list(A = rbinom(10, size = 1, prob = .5),
  #                     X1 = rnorm(10))
  #   formula <- expression(A + X1)
  # }
  covs_data <- as.data.frame(covs)
  n_obs <- nrow(covs_data)

  cols_env <- rlang::new_environment(
    data = covs_data,
    parent = parent.frame()
  )
  rhs_of_formula <- formula[[3]]
  linear_predictor <- eval(rhs_of_formula, envir = cols_env)
  mu <- family$linkinv(linear_predictor)

  args_to_rfun <- c(list(n = n_obs,
                         mu = mu,
                         family = family),
                    family_args)
  Y <- do.call(generate_from_family, args_to_rfun)

  response_name <- get_response_from_formula(formula)
  out <- covs_data %>%
    dplyr::mutate("{response_name}" := Y,
                  .before = dplyr::everything())

  return(out)
}

#' Use the r<family_name> function to generate data from family
#' @noRd
generate_from_family <- function(family, n, mu, ...) {
  family <- check_family(family)
  family_name_only_small_letters <- tolower(
    gsub("[^a-zA-Z\\.]", "", family$family)
  )

  family_with_dist_as_class <- structure(
    family,
    class = c(
      family_name_only_small_letters,
      class(family)
    )
  )

  UseMethod("generate_from_family", object = family_with_dist_as_class)
}

#' @export
#' @noRd
generate_from_family.gaussian <- function(family, n, mu, sd = 1, ...) {
  rnorm(n = n, mean = mu, sd = sd)
}

#' @export
#' @noRd
generate_from_family.binomial <- function(family, n, mu, ...) {
  rbinom(n = n, size = 1, prob = mu)
}

#' @export
#' @noRd
generate_from_family.poisson <- function(family, n, mu, ...) {
  rpois(n = n, lambda = mu)
}

#' @export
#' @noRd
generate_from_family.negativebinomial <- function(family, n, mu, ...) {
  rnbinom(n = n, size = 1, mu = mu)
}

#' Transform character or family function to a call
#' @noRd
check_family <- function(family) {
  if (is.character(family)) {
    family <- get(family, mode = "function", envir = parent.frame())
  }
  if (is.function(family)) {
    family <- family()
  }
  if (is.null(family$family)) {
    print(family)
    cli::cli_abort("'family' not recognized")
  }

  return(family)
}
