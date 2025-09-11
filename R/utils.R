# Get names of arguments of a function
get_fun_args <- function(fun) {
  names(formals(fun))
}

# To enable nice character priting of a function definition
deparse_fun_body <- function(fun) {
  body_as_char <- gsub(
    "\\[\\d*\\]\\s*", "", utils::capture.output(body(fun))
  )
  out <- paste(body_as_char, collapse = "\n")
  return(out)
}

# Transform character or family function to a call
check_formula <- function(formula) {
  out <- tryCatch(
    formula(formula),
    error = function(e) {
      sym_formula <- rlang::as_label(rlang::enquo(formula))
      cli::cli_abort(
      c(
        "`{sym_formula}` is not of class `formula` or could not be coerced to one.",
        i = "This usually means you did not include a response followed by a `~`."
      )
    )
    }
  )

  return(out)
}

formula_to_str <- function(formula) {
  deparse1(formula)
}

# Extract response from formula to
get_response_from_formula <- function(formula) {
  formula <- check_formula(formula)
  formula <- formula_to_str(formula)
  lhs_oftilde <- gsub("\\s*~.*", "", formula)
  return(lhs_oftilde)
}

# Checks if response is present in data from a formula
is_response_in_data <- function(formula, data) {
  response_var_name <- get_response_from_formula(formula)

  if (!response_var_name %in% colnames(data))
    cli::cli_abort("Tried to create formula to fit prognostic model but did not find the response variable {.var {response_var_name}} specified in the primary formula.\nProvide a formula manually through the argument {.arg prog_formula}.")

  return(invisible())
}

# Create formula that is function of
formula_everything <- function(formula) {
  response_var_name <- get_response_from_formula(formula)
  formula(
    paste0(response_var_name, " ~ ."),
    env = parent.frame()
  )
}

# Get names of arguments containing 0 and 1 from function
get01args <- function(fun) {

  arg0 <- grep("0$", get_fun_args(fun), value = TRUE)
  arg1 <- grep("1$", get_fun_args(fun), value = TRUE)

  if (length(arg0) == 0 | length(arg1) == 0) {
    cli::cli_abort("Arguments of the {.var estimand_fun} need to end in {.code 0} and {.code 1} to perform automatic symbolic differentiation. Alternatively, specify the partial derivatives, {.var estimand_fun_deriv0} and {.var estimand_fun_deriv1}, manually.")
  }

  return(list(arg0 = arg0, arg1 = arg1))
}

# Perform symbolic differentiation of function and print message
print_symbolic_differentiation <- function(fun, arg, add_string = "", verbose = options::opt("verbose")) {
  derivative <- Deriv::Deriv(fun, arg)

  body_of_fun <- deparse_fun_body(fun)
  body_of_derivative <- deparse_fun_body(derivative)

  if (verbose >= 1) {
    cli::cli_alert_info("Symbolically deriving partial derivative of the function '{body_of_fun}' with respect to '{arg}' as: '{body_of_derivative}'.\n")
    if (stringr::str_length(add_string) > 0)
      cli::cli_ul(add_string)
  }

  return(derivative)
}

# Utility to get the name of the newdata/new_data argument of a predict method
get_predict_method <- function(object) {
  for (cls in class(object)) {
    pred_method <- tryCatch({
      pred_method <- utils::getS3method("predict", cls)
      return(pred_method)
    }, error = function(e) NULL)
    if (!is.null(pred_method)) return(pred_method)
  }
  cli::cli_abort(paste0("Could not find predict method for object of class: ", class(object)))
}

get_newdata_arg_name <- function(object) {
  pred_method <- get_predict_method(object)

  arg_names <- names(formals(pred_method))
  newdata_arg_name <- arg_names[grepl("new.*data", arg_names)]
  if (length(newdata_arg_name) == 0) {
    cli::cli_abort(
      paste0("Could not find an argument like 'new.*data' in predict method dispatched on
             object of class: ",
             class(object))
    )
  }
  newdata_arg_name[1]
}

# Convert the r parameter in power_linear to exposure_prob from power_marginaleffect
r_to_exposure_prob <- function(r) {
  r / (r+1)
}

# Used to add power assumption parameters to data
add_power_assumption_params_to_data <- function(
    .data, power_fun = c("power_marginaleffect", "power_gs", "power_nc"), ...) {
  power_fun <- match.arg(power_fun)
  power_fun_function <- utils::getFromNamespace(power_fun, ns = "postcard")
  n <- nrow(.data)
  if (power_fun == "power_marginaleffect") {
    dummy_power <- power_fun_function(
      response = rep(1, n),
      predictions = rep(1, n),
      verbose = 0,
      ...
    )
  } else {
    dummy_power <- power_fun_function(
      variance = 1, n = n,
      ...
    )
  }

  assumptions <- attributes(dummy_power)
  assumptions_add_to_data <- assumptions[names(assumptions) != "estimand_fun"]
  .data %>%
    dplyr::mutate(!!!c(assumptions_add_to_data, list(power_fun = power_fun)))
}
