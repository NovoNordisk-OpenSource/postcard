

plot_power_marginaleffect <- function(
    desired_power = 0.9,
    ns = 10:250, n_iter = 1,
    prog_formula = Y ~ W,
    train_data = glm_data(
      Y ~ 1+3*sin(W)^2,
      W = runif(1e3, min = -2, max = 2)
    ),
    test_data_fun = function(n) {
      glm_data(
        Y ~ 1+3*sin(W)^2+2*X,
        W = runif(n, min = -2, max = 2),
        X = rnorm(n)
      )
    }) {

  ancova <- glm(prog_formula, data = train_data)
  lrnr <- fit_best_learner(list(mod = prog_formula), data = train_data)

  data_power <- mean_iters_marginaleffect(
    ns = ns, desired_power = desired_power, n_iter = n_iter,
    ancova_fit = ancova, dsl_fit = lrnr,
    train_data = train_data,
    test_data_fun = test_data_fun)

  # Create function to create direct labelling with gggrid
  create_power_plot(data_power)
}

iterate_power_marginaleffect <- function(
    ns = 10:250, fit,
    train_data = NULL,
    test_data_fun = NULL) {

  power <- sapply(ns, FUN = function(n) {
    test_data <- test_data_fun(n)

    if (inherits(fit, "workflow")) preds <- dplyr::pull(predict(fit, new_data = test_data))
    else preds <- predict(fit, newdata = test_data)

    power_marginaleffect(
      response = test_data$Y,
      predictions = preds,
      target_effect = 1.3,
      exposure_prob = 1/2,
      verbose = 0
    )
  })
  data.frame(n = ns, power = power)
}

##############
# Average results from a number of iterations
mean_iters_marginaleffect <- function(ns = 10:250, desired_power = 0.9, n_iter = 1, ancova_fit, dsl_fit, ...) {
  power_iter <- lapply(
    1:n_iter,
    function(i) {
      dplyr::bind_rows(
        iterate_power_marginaleffect(ns = ns, fit = ancova_fit, ...) %>%
          dplyr::mutate(
            model = "ancova",
            model_label = "ANCOVA"
          ),
        iterate_power_marginaleffect(ns = ns, fit = dsl_fit, ...) %>%
          dplyr::mutate(
            model = "prog",
            model_label = "ANCOVA with prognostic score")
      )
    }
  ) %>%
    dplyr::bind_rows()

  power_sum <- power_iter %>%
    dplyr::summarise(power = mean(power), .by = c(n, model, model_label)) %>%
    dplyr::group_by(model) %>%
    dplyr::mutate(n_desired = n[which(power >= desired_power)[1]]) %>%
    dplyr::ungroup()

  return(power_sum)
}

#####################
# Plotting utilities

grid_group_show_npower <- function(data, coords) {
  line <- grid::segmentsGrob(
    x0 = coords$x, x1 = coords$x,
    y0 = 0, y1 = coords$y,
    gp = grid::gpar(
      lty = "dashed",
      col = data$colour
    ))
  group <- unique(data$group)
  if (group == 1)
    y_pos <- grid::unit(coords$y, "npc") - grid::unit(2, "mm")
  else
    y_pos <- grid::unit(0.55, "npc")
  label <- grid::textGrob(
    label = paste0(data$model_label, ": ", ceiling(data$x)),
    x = grid::unit(coords$x, "npc") + grid::unit(2, "mm"),
    y = y_pos,
    just = c(0, 1),
    gp = grid::gpar(col = data$colour)
  )
  grid::grobTree(line, label)
}

# Create the plot
create_power_plot <- function(data_power, desired_power = 0.9,
                              cols = c(ancova = "darkorange1", prog = "dodgerblue4")) {
  data_power %>%
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
      ggplot2::aes(x = n_desired,
                   y = desired_power,
                   model_label = model_label)
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
