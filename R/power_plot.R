function(desired_power = 0.9,
         ns = 1:250, n_iter = 1,
         prog_formula = Y ~ W,
         glm_data_train_formula = Y ~ 1+3*sin(W)^2, glm_data_test_formula = Y ~ 1+3*sin(W)^2,
         glm_data_vars_list = list(W = runif(1e3, min = -2, max = 2)),
         glm_data_train_family = gaussian(), glm_data_train_family_args = NULL,
         glm_data_test_family = gaussian(), glm_data_test_family_args = NULL) {

  train_gaus <- glm_data(
    glm_data_train_formula,
    glm_data_vars_list,
    family = glm_data_train_family,
    family_args = glm_data_train_family_args
  )


  ancova <- glm(prog_formula, data = train_gaus)
  lrnr <- fit_best_learner(list(mod = prog_formula), data = train_gaus)

  iterate_power <- function(ns = 1:250, prog_model = c("dsl", "ancova")) {
    prog_model <- match.arg(prog_model)
    power <- sapply(ns, FUN = function(n) {

      test_gaus <- glm_data(
        Y ~ b0+b1*sin(W)^2,
        W = runif(n, min = -2, max = 2),
        family = gaussian # Default value
      )

      if (prog_model == "ancova")
        preds <- predict(ancova, newdata = test_gaus)
      else if (prog_model == "dsl")
        preds <- dplyr::pull(predict(lrnr, new_data = test_gaus))

      power_marginaleffect(
        response = test_gaus$Y,
        predictions = preds,
        target_effect = 1.3,
        exposure_prob = 1/2,
        verbose = 0
      )
    }
    )
    data.frame(n = ns, power = power)
  }

  mean_iters <- function(ns = 10:250, desired_power = 0.9, n_iter = 1) {
    power_iter <- lapply(
      1:n_iter,
      function(i) {
        dplyr::bind_rows(
          iterate_power(ns = ns, prog_model = "ancova") %>%
            dplyr::mutate(
              model = "ancova",
              model_label = "ANCOVA"
            ),
          iterate_power(ns = ns, prog_model = "dsl") %>%
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

  data_power <- mean_iters(ns = 10:250, desired_power = desired_power, n_iter = 50)

  model_cols <- c(ancova = "darkorange1", prog = "dodgerblue4")

  # Create function to create direct labelling with gggrid
  show_npower <- function(data, coords) {
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
  p <- data_power %>%
    ggplot2::ggplot(ggplot2::aes(x = n, y = power, color = model)) +
    ggplot2::geom_line(linewidth = 1.2, alpha = 0.8,
                       show.legend = FALSE) +
    ggplot2::geom_hline(
      yintercept = desired_power,
      color = "grey40",
      linetype = "dashed"
    ) +
    gggrid::grid_group(
      show_npower,
      ggplot2::aes(x = n_desired,
                   y = desired_power,
                   model_label = model_label)
    ) +
    ggplot2::scale_color_manual(
      name = "",
      values = model_cols) +
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

  p
}

function(n = 100, fit,
         glm_data_train,
         glm_data_test_formula = Y ~ 1+3*sin(W)^2,
         glm_data_vars_list = list(W = runif(1e3, min = -2, max = 2)),
         glm_data_test_family = gaussian(), glm_data_test_family_args = NULL) {

  test_gaus <- glm_data(
    glm_data_test_formula,
    glm_data_vars_list,
    family = glm_data_test_family,
    family_args = glm_data_test_family_args
  )

  preds <- dplyr::pull(predict(fit, new_data = test_gaus))

  power_marginaleffect(
    response = test_gaus$Y,
    predictions = preds,
    target_effect = 1.3,
    exposure_prob = 1/2,
    verbose = 0
  )
}
