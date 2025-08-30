#' Plot power curves calculated using `power_marginaleffect` for a list of models
#'
#' @param target_effect Passed to [power_marginaleffect()]
#' @param exposure_prob Passed to [power_marginaleffect()]
#' @param desired_power a `numeric` between 0 and 1 indicating the desired power level
#' @param ns a `numeric` vector of sample sizes
#' @param n_iter a `numeric` indicating a number of iterations to process and average over
#' @param model_list a named `list` of models used to get predictions on generated test
#' data sets that are then passed to [power_marginaleffect()] as `predictions`
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
iterate_power_marginaleffect <- function(
    target_effect, exposure_prob, model, test_data_fun, ns = 10:250, ...) {

  power <- sapply(ns, FUN = function(n) {
    test_data <- test_data_fun(n)

    if (inherits(model, "workflow")) preds <- dplyr::pull(predict(model, new_data = test_data))
    else preds <- predict(model, newdata = test_data)

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
# Average results from a number of iterations
mean_iters_marginaleffect <- function(
    target_effect, exposure_prob,
    model_list, test_data_fun,
    ns = 10:250, desired_power = 0.9, n_iter = 1,
    ...) {
  power_iter <- lapply(
    1:n_iter,
    function(i) {
      lapply(1:length(model_list), function(k) {
        cur_model <- model_list[[k]]
        cur_model_name <- names(model_list)[k]
        iterate_power_marginaleffect(
          target_effect = target_effect, exposure_prob = exposure_prob,
          model = cur_model, test_data_fun = test_data_fun,
          ns = ns,
          ...
        ) %>%
          dplyr::mutate(
            model = cur_model_name,
            model_label = cur_model_name
          )
      }) %>%
        dplyr::bind_rows()
    }
  ) %>%
    dplyr::bind_rows()

  power_sum <- power_iter %>%
    dplyr::summarise(power = mean(power), .by = c(n, model, model_label)) %>%
    dplyr::mutate(desired_power = desired_power,
                  flag_achieve_power = power >= desired_power,
                  .by = "model")

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

create_background_grob <- function(label_grob, x_pos, y_pos, colour) {
  wdt <- grid::grobWidth(label_grob)
  hgt <- grid::grobHeight(label_grob)
  rect_grob <- grid::roundrectGrob(
    x = x_pos - grid::unit(1.5, "mm"),
    y = y_pos,
    width = wdt + grid::unit(3, "mm"),
    height = hgt + grid::unit(3, "mm"),
    just = c(0, 0.5),
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
      label = paste0(data$model_label, ": Desired power not reached"),
      x = x_pos,
      y = y_pos,
      just = c(0, 0.5)
    )
    rect_grob <- create_background_grob(
      label_grob, x_pos = x_pos, y_pos = y_pos, colour = data$colour
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
  x_pos <- grid::unit(unique(coords$x), "npc") + grid::unit(3, "mm")
  y_pos <- grid::unit(unique(coords$y), "npc") - grid::unit(0.1, "npc") * (0.5 + group_num)
  label_grob <- grid::textGrob(
    label = paste0(data$model_label, ": ", ceiling(data$x)),
    x = x_pos,
    y = y_pos,
    just = c(0, 0.5)
  )
  rect_grob <- create_background_grob(
    label_grob, x_pos = x_pos, y_pos = y_pos, colour = data$colour
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
                   model_label = model_label,
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
