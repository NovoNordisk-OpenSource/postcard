#' Plot power curves calculated using `power_marginaleffect` for a list of models
#'
#' Iterate a process of simulating test data from `test_data_fun`, making predictions
#' using models in `model_list`, and calculating power using `power_marginaleffect()`
#' across a number of sample sizes `ns` and iterations `n_iter`. The results are averaged
#' and used to create a plot of the resulting power curves.
#'
#' @param target_effect Passed to [power_marginaleffect()]
#' @param exposure_prob Passed to [power_marginaleffect()]
#' @param desired_power a `numeric` between 0 and 1 indicating the desired power level
#' @param ns a `numeric` vector of sample sizes
#' @param n_iter a `numeric` indicating a number of iterations to process and average over
#' @param model_list a named `list` of models used to get predictions on generated test
#' data sets that are then passed to [power_marginaleffect()] as `predictions`. As such,
#' the elements of `model_list` need to have an existing `predict()` method.
#' @param test_data_fun a `function` with a single argument `n` that generates test
#' data sets for the sample sizes `ns` specified
#' @param ... additional arguments passed to [power_marginaleffect()]
#'
#' @returns a `ggplot2` object
#' @export
#'
#' @examples
#' # A simple use case with default models and test data
#' plot_power_marginaleffect(target_effect = 1.3, exposure_prob = 0.5)
#'
#' # Specify a margin with the ellipsis argument
#' plot_power_marginaleffect(target_effect = 1.3, exposure_prob = 0.5, margin = 1.3)
#'
#' iterate_formulas_power_linear(list(ANCOVA = Y ~ W, prog = Y ~ 1), ate = 2, train_data = glm_data(Y ~ W, W = rnorm(10)))
plot_power_marginaleffect <- function(
    target_effect, exposure_prob,
    model_list = default_power_model_list(),
    test_data_fun = function(n) {
      glm_data(
        Y ~ 1+3*sin(W)^2+2*X,
        W = runif(n, min = -2, max = 2),
        X = rnorm(n)
      )
    },
    desired_power = 0.9,
    ns = 10:250, n_iter = 1,
    ...) {

  args <- c(as.list(environment()), list(...))
  args_remove_train_data <- args[!names(args) %in% "train_data"]

  data_power <- do.call(mean_iters_marginaleffect, args_remove_train_data)

  create_power_plot(data_power)
}

default_power_model_list <- function(n = 1e3) {
  train_data <- glm_data(
    Y ~ 1+3*sin(W)^2,
    W = runif(n, min = -2, max = 2)
  )
  model_list <- list(
    "ANCOVA" = glm(Y ~ W, data = train_data),
    "ANCOVA with prognostic score" = fit_best_learner(
      list(mod = Y ~ W),
      data = train_data,
      verbose = 0),
    TEST = glm(Y ~ W - 1, data = train_data %>% dplyr::mutate(W = W + 20)),
    TEST1 = glm(Y ~ W - 1, data = train_data %>% dplyr::mutate(W = W + 20)),
    TEST2 = glm(Y ~ W - 1, data = train_data %>% dplyr::mutate(W = W + 20))
  )
}

#############
# Simulate data and calculate power for a range of sample sizes
iterate_n_power_marginaleffect <- function(
    target_effect, exposure_prob, model, test_data_fun, ns = 10:250, ...) {

  newdata_arg_name <- get_newdata_arg_name(model)
  predict_args <- setNames(vector("list", 2), c("object", newdata_arg_name))

  power <- sapply(ns, FUN = function(n) {
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
  data.frame(n = ns, power = power)
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
        model = cur_model_name
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
  power_iter <- lapply(
    1:n_iter,
    function(i) {
      iterate_models_power_marginaleffect(
        model_list = model_list,
        target_effect = target_effect, exposure_prob = exposure_prob,
        test_data_fun = test_data_fun,
        ns = ns,
        ...
      ) %>%
        dplyr::bind_rows()
    }
  ) %>%
    dplyr::bind_rows()

  power_sum <- power_iter %>%
    dplyr::summarise(power = mean(power), .by = c(n, model)) %>%
    dplyr::mutate(desired_power = desired_power,
                  flag_achieve_power = power >= desired_power)

  return(power_sum)
}

#####################
# Plotting utilities
add_plot_info_data_power <- function(data_power) {
  data_power_plot_info <- data_power %>%
    dplyr::summarise(
      n_achieve_power = n[which(flag_achieve_power)[1]],
      flag_group_achieve_power = any(flag_achieve_power),
      .by = "model"
    ) %>%
    dplyr::mutate(
      n_achieve_power = dplyr::case_when(
        is.na(n_achieve_power) ~ Inf,
        TRUE ~ n_achieve_power),
      n_model_group = dplyr::n_distinct(model),
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
    gp = grid::gpar(fill = colour, col = colour)
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
create_power_plot <- function(data_power, desired_power = 0.9,
                              cols = NULL) {
  if (is.null(cols)) {
    n_models <- length(unique(data_power$model))
    cols <- scales::pal_hue()(n_models)
  }

  add_plot_info_data_power(data_power) %>%
    ggplot2::ggplot(ggplot2::aes(x = n, y = power, color = model)) +
    ggplot2::geom_line(linewidth = 1.2, alpha = 0.8,
                       show.legend = FALSE) +
    ggplot2::geom_hline(
      yintercept = desired_power,
      color = "grey40",
      linetype = "dashed"
    ) +
    gggrid::grid_group(
      grid_group_show_npower,
      ggplot2::aes(x = n_achieve_power,
                   y = desired_power,
                   model = model,
                   flag_group_achieve_power  = flag_group_achieve_power ,
                   n_model_group = n_model_group,
                   group_id_achieve_power = group_id_achieve_power)
    ) +
    ggplot2::scale_color_manual(
      name = "",
      values = cols) +
    ggplot2::scale_y_continuous(
      breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1),
      labels = function(x) paste0(x*100, "%")
    ) +
    ggplot2::labs(x = "Total sample size", y = "Power") +
    ggplot2::theme(plot.title = ggplot2::element_text(
      face = "bold",
      size = 16
    )) +
    ggplot2::theme_minimal()
}
