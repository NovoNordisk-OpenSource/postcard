#' Create data and plot power curves calculated using [power_marginaleffect()] for a list of models
#'
#' Iterate a process of simulating test data from `test_data_fun`, making predictions
#' using models in `model_list`, and calculating power using [power_marginaleffect()]
#' across a number of sample sizes `ns` and iterations `n_iter`. The results are averaged
#' and used to create a plot of the resulting power curves.
#'
#' @param target_effect Passed to [power_marginaleffect()]
#' @param exposure_prob Passed to [power_marginaleffect()]
#' @param desired_power a `numeric` between 0 and 1 indicating the desired power level
#' @param ns a `numeric` vector of sample sizes
#' @param n_iter a `numeric` indicating a number of iterations to process and average over
#' @param model_list a named `list` of models used to get predictions on generated test
#' data sets that are then passed to [power_marginaleffect()] as `predictions`. The
#' elements of `model_list` need to have an existing `predict()` method. The default is
#' an ANCOVA and a prognostic model fitted with [fit_best_learner()] to a simple data set
#' of 1000 observations generated with a non-linear effect of a single covariate using
#' [glm_data()].
#' @param test_data_fun a `function` with a single argument `n` that generates test
#' data sets for the sample sizes `ns` specified. The default generates data using
#' [glm_data()] with the same data generating process as the training
#' data used to fit the default models in `model_list`.
#' @param ... additional arguments passed to [power_marginaleffect()]
#'
#' @seealso [repeat_power_linear()] for a similar implementation to iterate the process
#' of approximating power with the functions in [power_linear()]
#'
#' @returns `repeat_power_marginal` returns an object of class `postcard_rpm`, which is
#' just a `data.frame` with a `plot` method defined. The `plot` method returns a
#' `ggplot2` object.
#' @export
#'
#' @examples
#' # A simple use case with default models and test data
#' rpm1305 <- repeat_power_marginaleffect(target_effect = 1.3, exposure_prob = 0.5)
#'
#' # Specify a margin with the ellipsis argument
#' repeat_power_marginaleffect(target_effect = 1.3, exposure_prob = 0.5, margin = 1.3)
#'
repeat_power_marginaleffect <- function(
    target_effect, exposure_prob,
    model_list = default_power_model_list(),
    test_data_fun = function(n) {
      glm_data(
        Y ~ 1+3*sin(W)^2,
        W = stats::runif(n, min = -2, max = 2)
      )
    },
    ns = seq(5, 100, 5), desired_power = 0.9, n_iter = 1,
    ...) {

  args <- c(as.list(environment()), list(...))
  args_remove_train_data <- args[!names(args) %in% "train_data"]

  out <- do.call(mean_iters_marginaleffect, args_remove_train_data) %>%
    add_power_assumption_params_to_data(
      target_effect = target_effect,
      exposure_prob = exposure_prob,
      ...)
  structure(
    out,
    class = c("postcard_rpm", class(out))
  )
}

#' @export
#'
#' @param x an object of class `postcard_rpm` created by `repeat_power_marginaleffect()`
#' @param cols a (potentially named) `character` vector of colors for the different models
#' in `model_list`
#'
#' @rdname repeat_power_marginaleffect
plot.postcard_rpm <- function(x, cols = NULL, ...) {
  create_power_plot(x, cols = cols)
}

#############
# Define default list of models
default_power_model_list <- function(n = 1e3) {
  train_data <- glm_data(
    Y ~ 1+3*sin(W)^2,
    W = stats::runif(n, min = -2, max = 2)
  )
  model_list <- list(
    "ANCOVA" = glm(Y ~ W, data = train_data),
    "ANCOVA with prognostic score" = fit_best_learner(
      list(mod = Y ~ W),
      data = train_data,
      verbose = 0)
  )
}

#############
# Simulate data and calculate power for a range of sample sizes
iterate_n_power_marginaleffect <- function(
    target_effect, exposure_prob, model, test_data_fun, ns = 10:250, ...) {

  newdata_arg_name <- get_newdata_arg_name(model)
  predict_args <- stats::setNames(vector("list", 2), c("object", newdata_arg_name))

  pow <- sapply(ns, FUN = function(n) {
    test_data <- test_data_fun(n)

    predict_args[1:2] <- list(model, test_data)

    preds <- do.call(predict, args = predict_args)
    if (inherits(preds, "data.frame")) preds <- dplyr::pull(preds)

    power_marginaleffect(
      response = test_data$Y,
      predictions = preds,
      target_effect = target_effect,
      exposure_prob = exposure_prob,
      verbose = 0,
      ...
    )
  })
  data.frame(n = ns, power = pow)
}

##############
# Iterate over index of model list
iterate_models_power_marginaleffect <- function(model_list, ...) {
  lapply(1:length(model_list), function(k) {
    cur_model <- model_list[[k]]
    cur_model_name <- names(model_list)[k]
    iterate_n_power_marginaleffect(
      model = cur_model,
      ...
    ) %>%
      dplyr::mutate(
        model = cur_model_name,
        .after = "n"
      )
  })
}

#############
# Average results from a number of iterations
mean_iters_marginaleffect <- function(
    target_effect, exposure_prob,
    model_list, test_data_fun,
    ns = 10:250, desired_power = 0.9, n_iter = 1,
    ...) {
  cli::cli_progress_bar(
    format = paste0(
      "Estimating power across sample sizes `n_iter` times {cli::pb_bar} {cli::pb_current}/{cli::pb_total}"),
    total = n_iter)
  power_iter <- lapply(
    1:n_iter,
    function(i) {
      out <- iterate_models_power_marginaleffect(
        model_list = model_list,
        target_effect = target_effect, exposure_prob = exposure_prob,
        test_data_fun = test_data_fun,
        ns = ns,
        ...
      ) %>%
        dplyr::bind_rows()
      cli::cli_progress_update(.envir = parent.frame(2))
      return(out)
    }
  ) %>%
    dplyr::bind_rows()

  cli::cli_process_done()
  power_sum <- power_iter %>%
    dplyr::group_by(dplyr::across(-power)) %>%
    dplyr::summarise(power = mean(.data$power)) %>%
    dplyr::ungroup() %>%
    dplyr::relocate("power") %>%
    dplyr::mutate(desired_power = desired_power) %>%
    dplyr::mutate(flag_achieve_power = .data$power >= .data$desired_power, .before = "desired_power")

  return(power_sum)
}

#' Create data and plot power curves calculated using functions in [power_linear()] for a list of formulas/models
#'
#' Estimate a variance for power approximation using [variance_ancova()] for each formula
#' in `formula_list` on `train_data`. Then calculate power using the function with name
#' specified in `power_fun` across a number of sample sizes `ns` for an assumed average
#' treatment effect of `ate`.
#'
#' @inheritParams repeat_power_marginaleffect
#' @param ate Passed to [power_gs()] or [power_nc()]
#' @param formula_list a named `list` of formulas that are element wise passed to
#' [variance_ancova()]
#' @param train_data Passed as the `data` argument in [variance_ancova()]
#' @param power_fun a `character` string with value `"power_gs"` or `"power_nc"`,
#' specifying what function in the [power_linear()] topic to use
#' @param ... Arguments passed to [variance_ancova()] and [power_gs()] or [power_nc()]
#'
#' @returns `repeat_power_linear` returns an object of class `postcard_rpl`, which is
#' just a `data.frame` with a `plot` method defined. The `plot` method returns a
#' `ggplot2` object.
#' @export
#'
#' @seealso [repeat_power_marginaleffect()] for a similar implementation to iterate the
#' process of approximating power with the [power_marginaleffect()]
#'
#' @examples
#' train_data <- glm_data(
#'   Y ~ 1+1.5*sin(W)+2*X,
#'   W = runif(1e3, min = -2, max = 2),
#'   X = rnorm(1e3, sd = 3)
#' )
#' rpl <- repeat_power_linear(
#'   ate = 1.3,
#'   formula_list = list("ANCOVA 1 covariate" = Y ~ X, "ANCOVA 2 covariates" = Y ~ W + X),
#'   train_data = train_data)
#'
#' rpl_nc <- repeat_power_linear(
#'   ate = 1.3,
#'   formula_list = list("ANCOVA 1 covariate" = Y ~ X, "ANCOVA 2 covariates" = Y ~ W + X),
#'   train_data = train_data,
#'   power_fun = "power_nc",
#'   df = 1e3-3,
#'   deflation = 0.8,
#'   margin = 0.2,
#'   r = 2)
#'
#' \dontrun{
#' plot(rpl)
#'
#' plot(rpl_nc)
#' }
repeat_power_linear <- function(
    ate, formula_list, train_data,
    power_fun = c("power_gs", "power_nc"),
    ns = 5:100, desired_power = 0.9,
    ...) {
  power_fun <- match.arg(power_fun)
  args <- c(as.list(environment()), list(...))

  out <- do.call(iterate_formulas_power_linear, args) %>%
    add_power_assumption_params_to_data(
      ate = ate, power_fun = power_fun,
      ...)
  structure(
    out,
    class = c("postcard_rpl", class(out))
  )
}

#' @export
#'
#' @param x an object of class `postcard_rpl` created by `repeat_power_linear()`
#' @param cols a (potentially named) `character` vector of colors for the different models
#' in `formula_list`
#'
#' @rdname repeat_power_linear
plot.postcard_rpl <- function(x, cols = NULL, ...) {
  create_power_plot(x, cols = cols)
}

#############
# Simulate data and calculate power for a range of sample sizes
iterate_n_power_linear <- function(
    ate, formula, train_data, power_fun = c("power_gs", "power_nc"), ns = 10:250, ...) {
  power_fun <- match.arg(power_fun)
  power_fun <- utils::getFromNamespace(power_fun, ns = "postcard")

  extra_args <- list(...)
  extra_args_to_variance_ancova <- extra_args[names(extra_args) %in% names(formals(variance_ancova))]

  var <- do.call(
    variance_ancova,
    args = c(list(formula = formula,
                  data = train_data),
             extra_args_to_variance_ancova)
  )

  extra_args_to_power_fun <- extra_args[names(extra_args) %in% names(formals(power_fun))]
  power <- sapply(ns, FUN = function(n) {
    do.call(
      power_fun,
      args = c(list(variance = var, ate = ate, n = n),
               extra_args_to_power_fun))
  })
  data.frame(n = ns, power = power)
}

#############
# Simulate data and calculate power for a range of sample sizes
iterate_formulas_power_linear <- function(formula_list, desired_power = 0.9, ...) {
  lapply(1:length(formula_list), function(k) {
    cur_formula <- formula_list[[k]]
    cur_model_name <- names(formula_list)[k]
    iterate_n_power_linear(
      formula = cur_formula,
      ...
    ) %>%
      dplyr::mutate(
        model = cur_model_name,
        .after = "n"
      )
  }) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(desired_power = desired_power) %>%
    dplyr::mutate(flag_achieve_power = .data$power >= .data$desired_power, .before = "desired_power")
}

#####################
# Plotting utilities
add_plot_info_data_power <- function(data_power) {
  data_power_plot_info <- data_power %>%
    dplyr::summarise(
      n_achieve_power = .data$n[which(.data$flag_achieve_power)[1]],
      flag_group_achieve_power = any(.data$flag_achieve_power),
      .by = "model"
    ) %>%
    dplyr::mutate(
      n_achieve_power = dplyr::case_when(
        is.na(.data$n_achieve_power) ~ Inf,
        TRUE ~ .data$n_achieve_power),
      n_model_group = dplyr::n_distinct(.data$model),
      group_id_achieve_power = dplyr::row_number(),
      .by = "flag_group_achieve_power")

  data_power %>%
    dplyr::left_join(data_power_plot_info, by = "model")
}

create_background_grob <- function(label_grob, x_pos, y_pos, colour, hjust = 0) {
  wdt <- grid::grobWidth(label_grob)
  hgt <- grid::grobHeight(label_grob)
  rect_grob <- grid::roundrectGrob(
    x = x_pos + ifelse(hjust, 1, -1) * grid::unit(1.5, "mm"),
    y = y_pos,
    width = wdt + grid::unit(3, "mm"),
    height = hgt + grid::unit(3, "mm"),
    just = c(hjust, 0.5),
    r = grid::unit(0.2, "snpc"),
    gp = grid::gpar(fill = colour, col = colour, alpha = 0.8)
  )
}

grid_group_show_npower <- function(data, coords) {
  group_num <- unique(data$group_id_achieve_power)
  n_groups <- unique(data$n_model_group)

  model_achieves_desired_power <- unique(data$flag_group_achieve_power)
  if (!model_achieves_desired_power) {
    x_pos <- grid::unit(0.3, "npc") / n_groups * group_num
    y_pos <- grid::unit(0.15, "npc") / n_groups * group_num
    label_grob <- grid::textGrob(
      label = paste0(data$model, ": Desired power not reached"),
      x = x_pos,
      y = y_pos,
      just = c(0, 0.5)
    )
    rect_grob <- create_background_grob(
      label_grob, x_pos = x_pos, y_pos = y_pos, colour = data$colour, hjust = 0
    )
    return(
      grid::grobTree(rect_grob, label_grob)
    )
  }

  line_grob <- grid::segmentsGrob(
    x0 = coords$x, x1 = coords$x,
    y0 = 0, y1 = coords$y,
    gp = grid::gpar(
      lty = "dashed",
      col = data$colour
    ))
  x_pos <- grid::unit(unique(coords$x), "npc") - grid::unit(3, "mm")
  y_pos <- grid::unit(unique(coords$y), "npc") - grid::unit(0.1, "npc") * (1 + group_num)
  label_grob <- grid::textGrob(
    label = paste0(data$model, ": ", ceiling(data$x)),
    x = x_pos,
    y = y_pos,
    just = c(1, 0.5)
  )
  rect_grob <- create_background_grob(
    label_grob, x_pos = x_pos, y_pos = y_pos, colour = data$colour, hjust = 1
  )

  return(
    grid::grobTree(line_grob, rect_grob, label_grob)
  )
}

# Create the plot
create_power_plot <- function(data_power, cols = NULL) {
  if (is.null(cols)) {
    n_models <- length(unique(data_power$model))
    cols <- scales::pal_hue()(n_models)
  }

  plot_data <- add_plot_info_data_power(data_power)
  desired_power <- unique(plot_data$desired_power)

  yaxis_breaks <- unique(sort(c(desired_power, c(0, 0.2, 0.4, 0.6, 0.8, 1))))

  plot_data %>%
    ggplot2::ggplot(ggplot2::aes(x = .data$n, y = .data$power, color = .data$model)) +
    ggplot2::geom_line(linewidth = 1.2, alpha = 0.8,
                       show.legend = FALSE) +
    ggplot2::geom_hline(
      yintercept = desired_power,
      color = "grey40",
      linetype = "dashed"
    ) +
    gggrid::grid_group(
      grid_group_show_npower,
      ggplot2::aes(x = .data$n_achieve_power,
                   y = .data$desired_power,
                   model = .data$model,
                   flag_group_achieve_power = .data$flag_group_achieve_power ,
                   n_model_group = .data$n_model_group,
                   group_id_achieve_power = .data$group_id_achieve_power)
    ) +
    ggplot2::scale_color_manual(
      name = "",
      values = cols) +
    ggplot2::scale_y_continuous(
      breaks = yaxis_breaks,
      labels = function(x) paste0(x*100, "%")
    ) +
    ggplot2::coord_cartesian(ylim = c(0,1)) +
    ggplot2::labs(x = "Total sample size", y = "Power") +
    ggplot2::theme(plot.title = ggplot2::element_text(
      face = "bold",
      size = 16
    )) +
    ggplot2::theme_minimal()
}
