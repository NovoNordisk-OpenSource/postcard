#' Methods for `postcard_power` and `postcard_samplesize` objects
#'
#' @description
#' `power_gs`, `power_nc`, and [power_marginaleffect()] return objects of class
#' `postcard_power`. [samplesize_gs()] returns an object of class
#' `postcard_samplesize`. Both classes are lists holding the primary numeric
#' output (`power` or `samplesize`) together with the assumptions used to
#' compute it. `print` and `summary` methods for both classes are provided.
#' A `plot` method is provided for `postcard_power` objects, showing the
#' approximate sampling distributions of the estimator under the null and
#' alternative hypotheses with the power shaded.
#'
#' @name postcard_power_methods
#'
#' @param x an object of class `postcard_power` or `postcard_samplesize` (or
#' the corresponding `summary.*` class).
#' @param object an object of class `postcard_power` or `postcard_samplesize`.
#' @param digits a `numeric` with the number of digits to display when printing.
#' @param ... additional arguments (currently unused).
#'
#' @returns
#' `print` methods return their input invisibly. `summary` methods return an
#' object of class `summary.postcard_power` or `summary.postcard_samplesize`
#' respectively, which extends the input class with additional information
#' (currently just the deparsed estimand function) displayed by the
#' corresponding `print` method. `plot.postcard_power` returns a `ggplot2`
#' object.
#'
#' @seealso [power_gs()], [power_nc()], [samplesize_gs()],
#' [power_marginaleffect()].
NULL

# ----- Shared printing helpers -----------------------------------------------

print_power_body <- function(x, digits) {
  cat("Call:  ", paste(deparse(x$call), sep = "\n", collapse = "\n"),
      "\n", sep = "")
  cat("Estimated power:      ", format(x$power, digits = digits), "\n", sep = "")
  cat("Sample size:          ", x$samplesize, "\n", sep = "")
  cat("Target effect:        ", format(x$target_effect, digits = digits),
      "\n", sep = "")
  cat("Superiority margin:   ", format(x$margin, digits = digits),
      "\n", sep = "")
  cat("Exposure probability: ", format(x$exposure_prob, digits = digits),
      "\n", sep = "")
  cat("Significance level:   ", format(x$alpha, digits = digits),
      "\n", sep = "")
  if (!is.null(x$df))
    cat("Degrees of freedom:   ", x$df, "\n", sep = "")
}

print_samplesize_body <- function(x, digits) {
  cat("Call:  ", paste(deparse(x$call), sep = "\n", collapse = "\n"),
      "\n", sep = "")
  cat("Estimated sample size: ", format(x$samplesize, digits = digits),
      "\n", sep = "")
  cat("Desired power:         ", format(x$power, digits = digits),
      "\n", sep = "")
  cat("Target effect:         ", format(x$target_effect, digits = digits),
      "\n", sep = "")
  cat("Superiority margin:    ", format(x$margin, digits = digits),
      "\n", sep = "")
  cat("Exposure probability:  ", format(x$exposure_prob, digits = digits),
      "\n", sep = "")
  cat("Significance level:    ", format(x$alpha, digits = digits),
      "\n", sep = "")
}

# ----- postcard_power --------------------------------------------------------

#' @export
#' @rdname postcard_power_methods
print.postcard_power <- function(x,
                                 digits = max(3L, getOption("digits") - 3L),
                                 ...) {
  cat("\nPower approximation (class postcard_power)\n\n")
  print_power_body(x, digits = digits)
  return(invisible(x))
}

#' @export
#' @rdname postcard_power_methods
summary.postcard_power <- function(object, ...) {
  structure(object, class = c("summary.postcard_power", class(object)))
}

#' @export
#' @rdname postcard_power_methods
print.summary.postcard_power <- function(x,
                                         digits = max(3L, getOption("digits") - 3L),
                                         ...) {
  cat("\nSummary of power approximation (class postcard_power)\n\n")
  print_power_body(x, digits = digits)
  cat("Estimand function:    ", deparse_fun_body(x$estimand_fun),
      "\n", sep = "")
  return(invisible(x))
}

#' @export
#' @rdname postcard_power_methods
plot.postcard_power <- function(x, ...) {
  se <- x$std_error
  margin <- x$margin
  target <- x$target_effect

  # power_nc uses (non-central) t-distributions; the others are normal-based
  if (is.null(x$df)) {
    crit <- stats::qnorm(1 - x$alpha / 2, mean = margin, sd = se)
    dens0 <- function(q) stats::dnorm(q, mean = margin, sd = se)
    dens1 <- function(q) stats::dnorm(q, mean = target, sd = se)
  } else {
    ncp <- (target - margin) / se
    crit <- margin + se * stats::qt(1 - x$alpha / 2, df = x$df)
    dens0 <- function(q) stats::dt((q - margin) / se, df = x$df) / se
    dens1 <- function(q) stats::dt((q - margin) / se, df = x$df, ncp = ncp) / se
  }

  grid <- seq(min(margin, target) - 4 * se, max(margin, target) + 4 * se,
              length.out = 500)
  hyp_levels <- c("Null (H0)", "Alternative (H1)")
  dens_df <- data.frame(
    x = rep(grid, 2),
    density = c(dens0(grid), dens1(grid)),
    hypothesis = factor(rep(hyp_levels, each = length(grid)),
                        levels = hyp_levels)
  )
  shade_df <- dens_df[dens_df$hypothesis == hyp_levels[2] & dens_df$x >= crit, ]

  ggplot2::ggplot(
    dens_df,
    ggplot2::aes(x = .data$x, y = .data$density, colour = .data$hypothesis)
  ) +
    ggplot2::geom_area(
      data = shade_df,
      ggplot2::aes(fill = .data$hypothesis),
      alpha = 0.3, colour = NA, show.legend = FALSE
    ) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::geom_vline(xintercept = crit, linetype = "dashed",
                        colour = "grey40") +
    ggplot2::labs(
      x = "Estimand",
      y = "Density",
      colour = NULL,
      title = paste0("Estimated power: ", format(x$power, digits = 3)),
      subtitle = paste0("n = ", format(x$samplesize, digits = 3),
                        "; dashed line = critical value ",
                        format(crit, digits = 3),
                        " (alpha = ", format(x$alpha), ")")
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "bottom")
}

# ----- postcard_samplesize ---------------------------------------------------

#' @export
#' @rdname postcard_power_methods
print.postcard_samplesize <- function(x,
                                      digits = max(3L, getOption("digits") - 3L),
                                      ...) {
  cat("\nSample size approximation (class postcard_samplesize)\n\n")
  print_samplesize_body(x, digits = digits)
  return(invisible(x))
}

#' @export
#' @rdname postcard_power_methods
summary.postcard_samplesize <- function(object, ...) {
  structure(object, class = c("summary.postcard_samplesize", class(object)))
}

#' @export
#' @rdname postcard_power_methods
print.summary.postcard_samplesize <- function(x,
                                              digits = max(3L, getOption("digits") - 3L),
                                              ...) {
  cat("\nSummary of sample size approximation (class postcard_samplesize)\n\n")
  print_samplesize_body(x, digits = digits)
  cat("Estimand function:     ", deparse_fun_body(x$estimand_fun),
      "\n", sep = "")
  return(invisible(x))
}
