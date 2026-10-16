#' @name rctglm_methods
#' @rdname rctglm_methods
#'
#' @title Methods for objects of class `rctglm`
#'
#' @description
#' Methods for extracting information about the estimand and about the
#' underlying GLM fit from an `rctglm` object. See details for information on
#' each method.
#'
#' @param x an object of class `rctglm`
#' @param object an object of class `rctglm`
#' @param digits a `numeric` with the number of digits to display when printing
#' @param level a `numeric` confidence level in \eqn{(0, 1)}, used for the Wald
#' interval on the estimand in `summary`, `plot`, and `confint`. Defaults to 0.95.
#' @param type for `vcov`, one of `"coefficients"` (default) or `"estimand"`.
#' `"coefficients"` returns `vcov(object$glm)` (the variance-covariance matrix
#' of the GLM coefficient vector); `"estimand"` returns the estimated variance
#' of the marginal-effect estimand as a 1x1 matrix.
#' @param parm for `confint`, either omitted (returns the Wald CI for the
#' estimand) or the character string `"coefficients"` (delegates to
#' `stats::confint` on the underlying GLM).
#' @param formula. for `update`, a formula, updated via
#' `stats::update.formula`. See [stats::update()].
#' @param evaluate for `update`, if `TRUE` (default) the updated call is
#' evaluated; if `FALSE` the unevaluated call is returned.
#' @param ... additional arguments passed to methods
#'
#' @details
#' The generics [estimand] (and its alias [est]) extract a one-row
#' `data.frame` with the estimate and standard error of the estimand.
#'
#' `summary.rctglm` returns a `summary.rctglm` object printed with
#' `print.summary.rctglm`. The object holds a coefficient-style table for the
#' estimand with columns `Estimate`, `Std. Error`, `z value`, `Pr(>|z|)`, and
#' the lower/upper Wald CI bounds at the requested `level`. The Wald test uses
#' the null value \eqn{r(\psi, \psi)} (which equals 0 for the ATE and 1 for
#' rate/odds ratios). The underlying GLM summary is stored in the
#' `glm_summary` element for full access to the GLM diagnostics.
#'
#' `plot.rctglm` returns a `ggplot2` object with the estimand estimate and its
#' Wald CI drawn as a point and horizontal error bar, plus a dashed vertical
#' reference line at the null value.
#'
#' Thin wrappers to the corresponding methods on the underlying `glm` are
#' provided for `coef`, `predict`, `formula`, `family`, `fitted`,
#' `model.frame`, `model.matrix`, `nobs`, `residuals`, `logLik`, `deviance`,
#' `AIC`, `terms`, `weights`. `vcov.rctglm` returns the GLM coefficient
#' variance-covariance matrix by default and the estimand variance when
#' `type = "estimand"`. `confint.rctglm` returns the Wald CI for the estimand
#' by default (or delegates to `confint(object$glm)` when
#' `parm = "coefficients"`). `update.rctglm` re-runs [rctglm()] with an updated
#' call.
#'
#' @seealso The generic [rctglm()] which produces `rctglm` class objects.
#'
#' @returns
#' `estimand`/`est` return a `data.frame` with columns `Estimate` and
#' `Std. Error` with the estimate and standard error of the estimand.
#'
#' `summary` returns a `summary.rctglm` object. `plot` returns a `ggplot`
#' object. `confint` returns a 1x2 matrix (or the GLM `confint` output).
#' `vcov` returns a variance-covariance matrix (default) or a 1x1 matrix (for
#' the estimand). `update` returns a new `rctglm` object (or an unevaluated
#' call when `evaluate = FALSE`).
#'
#' See [coef()] and [predict.glm()] for details on what is returned by the
#' corresponding methods.
#'
#' @examples
#' # Generate some data to showcase example
#' n <- 100
#' exposure_prob <- .5
#' dat_binom <- glm_data(
#'   Y ~ 1+1.5*X1+2*A,
#'   X1 = rnorm(n),
#'   A = rbinom(n, 1, exposure_prob),
#'   family = binomial()
#' )
#'
#' # Fit the model
#' ate <- rctglm(formula = Y ~ .,
#'               exposure_indicator = A,
#'               exposure_prob = exposure_prob,
#'               data = dat_binom,
#'               family = binomial,
#'               estimand_fun = "ate")
#'
#' print(ate)
#' summary(ate)
#' estimand(ate)
#' est(ate)
#' coef(ate)
#' confint(ate)
#' \dontrun{
#' plot(ate)
#' }
NULL

#' @export
#' @rdname rctglm_methods
estimand <- function(object) {
  UseMethod("estimand")
}

#' @export
#' @rdname rctglm_methods
estimand.rctglm <- function(object) {
  object$estimand
}

#' @export
#' @rdname rctglm_methods
est <- function(object) {
  UseMethod("est")
}

#' @export
#' @rdname rctglm_methods
est.rctglm <- function(object) {
  object$estimand
}

#' @export
#' @rdname rctglm_methods
coef.rctglm <- function(object, ...) {
  coef(object$glm)
}

#' @rdname rctglm_methods
#' @export
predict.rctglm <- function(object, ...) {
  predict(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
print.rctglm <- function(x,
                         digits = max(3L, getOption("digits") - 3L),
                         ...) {
  cat("\nObject of class", class(x)[1], "\n\n")
  cat("Call:  ",
      paste(deparse(x$call), sep = "\n", collapse = "\n"), "\n\n", sep = "")
  cat("Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: ",
      format(x$means_counterfactual["psi0"], digits = digits),
      "\n",
      sep = "")
  cat("Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: ",
      format(x$means_counterfactual["psi1"], digits = digits),
      "\n",
      sep = "")
  print_estimand_info(x,
                      digits = max(3L, getOption("digits") - 3L),
                      ...)

  return(invisible())
}

print_estimand_info <- function(x,
                                digits = max(3L, getOption("digits") - 3L),
                                ...) {
  cat("Estimand function r: ",
      deparse_fun_body(x$estimand_funs$f),
      "\n",
      sep = "")
  cat("Estimand (r(psi_1, psi_0)) estimate (SE): ",
      format(est(x)[, "Estimate"], digits = digits),
      " (",
      format(est(x)[, "Std. Error"], digits = digits),
      ")\n",
      sep = "")
  return(invisible())
}

#' @rdname rctglm_methods
#' @export
summary.rctglm <- function(object, level = 0.95, ...) {
  est_df <- object$estimand
  psi0 <- as.numeric(object$means_counterfactual["psi0"])
  psi1 <- as.numeric(object$means_counterfactual["psi1"])
  ef <- object$estimand_funs$f

  # For any well-defined marginal-effect estimand, r(psi, psi) does not depend
  # on psi (0 for ATE, 1 for rate/odds ratio, 0 for log-scale, ...). Using psi0
  # gives the clearest H0 interpretation: "if treatment had no effect, both
  # counterfactual means equal psi0 and the null estimand value is r(psi0, psi0)".
  null_value <- ef(psi1 = psi0, psi0 = psi0)
  alt_null   <- tryCatch(ef(psi1 = psi1, psi0 = psi1),
                         error = function(e) null_value)
  null_stable <- isTRUE(all.equal(alt_null, null_value))
  if (!null_stable)
    cli::cli_warn(
      "{.code estimand_fun(psi, psi)} depends on {.arg psi} — the Wald null value is not uniquely defined for this estimand."
    )

  se <- est_df[["Std. Error"]]
  z  <- (est_df$Estimate - null_value) / se
  p  <- 2 * stats::pnorm(-abs(z))
  q  <- stats::qnorm(1 - (1 - level) / 2)
  ci_lo <- est_df$Estimate - q * se
  ci_hi <- est_df$Estimate + q * se
  ci_name_lo <- sprintf("%.1f %%", 100 * (1 - level) / 2)
  ci_name_hi <- sprintf("%.1f %%", 100 * (1 - (1 - level) / 2))

  tab <- data.frame(
    Estimate     = est_df$Estimate,
    `Std. Error` = se,
    `z value`    = z,
    `Pr(>|z|)`   = p,
    check.names  = FALSE
  )
  tab[[ci_name_lo]] <- ci_lo
  tab[[ci_name_hi]] <- ci_hi
  rownames(tab) <- "Estimand"

  cv_variance <- isTRUE(object$cv_variance)

  structure(
    list(
      call = object$call,
      estimand_fun = ef,
      counterfactual_means = object$means_counterfactual,
      estimand_table = tab,
      null_value = null_value,
      conf_level = level,
      cv_variance = cv_variance,
      glm_summary = summary(object$glm)
    ),
    class = "summary.rctglm"
  )
}

#' @rdname rctglm_methods
#' @export
print.summary.rctglm <- function(x,
                                 digits = max(3L, getOption("digits") - 3L),
                                 ...) {
  cat("\nSummary of rctglm fit\n\n")
  cat("Call:  ",
      paste(deparse(x$call), sep = "\n", collapse = "\n"), "\n\n", sep = "")
  cat("Counterfactual control mean (psi_0=E[Y|X, A=0]): ",
      format(x$counterfactual_means["psi0"], digits = digits), "\n", sep = "")
  cat("Counterfactual active  mean (psi_1=E[Y|X, A=1]): ",
      format(x$counterfactual_means["psi1"], digits = digits), "\n\n", sep = "")
  cat("Estimand function r: ", deparse_fun_body(x$estimand_fun), "\n", sep = "")
  cat("Null value (r(psi, psi)): ",
      format(x$null_value, digits = digits), "\n\n", sep = "")

  stats::printCoefmat(
    as.matrix(x$estimand_table),
    digits       = digits,
    signif.legend = TRUE,
    P.values     = TRUE, has.Pvalue = TRUE,
    tst.ind      = 3, cs.ind = 1:2
  )

  cat("\n(Wald-type ", format(100 * x$conf_level), "% CI; standard error ",
      if (x$cv_variance) "estimated via cross-validation."
      else "computed from the full-model influence-function variance.",
      ")\n", sep = "")
  cat("Access the underlying GLM summary via `<summary_object>$glm_summary`.\n")

  return(invisible(x))
}

#' @rdname rctglm_methods
#' @export
plot.rctglm <- function(x, level = 0.95, ...) {
  s <- summary(x, level = level)
  tab <- s$estimand_table
  fixed <- c("Estimate", "Std. Error", "z value", "Pr(>|z|)")
  ci_names <- setdiff(colnames(tab), fixed)

  plot_df <- data.frame(
    label    = "Estimand",
    estimate = tab$Estimate,
    lower    = tab[[ci_names[1]]],
    upper    = tab[[ci_names[2]]]
  )

  ggplot2::ggplot(
    plot_df,
    ggplot2::aes(x = .data$estimate, y = .data$label)
  ) +
    ggplot2::geom_vline(
      xintercept = s$null_value,
      linetype = "dashed",
      colour = "grey40"
    ) +
    ggplot2::geom_errorbar(
      ggplot2::aes(xmin = .data$lower, xmax = .data$upper),
      orientation = "y",
      width = 0.15,
      linewidth = 0.8
    ) +
    ggplot2::geom_point(size = 3) +
    ggplot2::labs(
      x = "Estimand estimate",
      y = NULL,
      title = paste0("Estimand: r(psi_1, psi_0) = ",
                     deparse_fun_body(s$estimand_fun)),
      subtitle = paste0(format(100 * level),
                        "% Wald CI; dashed line = null value ",
                        format(s$null_value, digits = 3))
    ) +
    ggplot2::theme_minimal()
}

# ---------------------------------------------------------------------------
# Thin wrappers around the underlying $glm object.
# Every method matches the signature of the corresponding stats generic.
# ---------------------------------------------------------------------------

#' @rdname rctglm_methods
#' @export
formula.rctglm <- function(x, ...) {
  stats::formula(x$glm, ...)
}

#' @rdname rctglm_methods
#' @export
family.rctglm <- function(object, ...) {
  stats::family(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
fitted.rctglm <- function(object, ...) {
  stats::fitted(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
model.frame.rctglm <- function(formula, ...) {
  stats::model.frame(formula$glm, ...)
}

#' @rdname rctglm_methods
#' @export
model.matrix.rctglm <- function(object, ...) {
  stats::model.matrix(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
nobs.rctglm <- function(object, ...) {
  stats::nobs(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
residuals.rctglm <- function(object, ...) {
  stats::residuals(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
logLik.rctglm <- function(object, ...) {
  stats::logLik(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
deviance.rctglm <- function(object, ...) {
  stats::deviance(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
AIC.rctglm <- function(object, ..., k = 2) {
  stats::AIC(object$glm, ..., k = k)
}

#' @rdname rctglm_methods
#' @export
terms.rctglm <- function(x, ...) {
  stats::terms(x$glm, ...)
}

#' @rdname rctglm_methods
#' @export
weights.rctglm <- function(object, ...) {
  stats::weights(object$glm, ...)
}

#' @rdname rctglm_methods
#' @export
vcov.rctglm <- function(object, type = c("coefficients", "estimand"), ...) {
  type <- match.arg(type)
  if (type == "coefficients")
    return(stats::vcov(object$glm, ...))
  se <- object$estimand[["Std. Error"]]
  matrix(se^2, nrow = 1L, ncol = 1L,
         dimnames = list("Estimand", "Estimand"))
}

#' @rdname rctglm_methods
#' @export
confint.rctglm <- function(object, parm, level = 0.95, ...) {
  if (!missing(parm) && identical(parm, "coefficients"))
    return(stats::confint(object$glm, level = level, ...))
  s <- summary(object, level = level)
  fixed <- c("Estimate", "Std. Error", "z value", "Pr(>|z|)")
  ci_names <- setdiff(colnames(s$estimand_table), fixed)
  out <- as.matrix(s$estimand_table[, ci_names, drop = FALSE])
  rownames(out) <- "Estimand"
  out
}

#' @rdname rctglm_methods
#' @export
update.rctglm <- function(object, formula., ..., evaluate = TRUE) {
  call <- object$call
  extras <- match.call(expand.dots = FALSE)$...

  if (!missing(formula.))
    call$formula <- stats::update.formula(stats::formula(object), formula.)

  if (length(extras) > 0) {
    existing <- !is.na(match(names(extras), names(call)))
    for (a in names(extras)[existing]) call[[a]] <- extras[[a]]
    if (any(!existing)) {
      call <- c(as.list(call), extras[!existing])
      call <- as.call(call)
    }
  }
  if (evaluate) {
    call_env <- object$call_env
    if (is.null(call_env)) call_env <- parent.frame()
    eval(call, envir = call_env)
  } else {
    call
  }
}
