# Approximate: shading starts at the first grid point past the critical value
power_area_from_plot <- function(p) {
  shade <- p$layers[[1]]$data
  sum(diff(shade$x) * (utils::head(shade$density, -1) + utils::tail(shade$density, -1)) / 2)
}

sim_power_marginaleffect <- function() {
  withr::local_seed(42)
  dat <- glm_data(Y ~ X1 + 2*A,
                  X1 = rnorm(100),
                  A = rbinom(100, 1, 1/2))
  preds <- predict(glm(Y ~ X1 + A, data = dat), newdata = dat)
  power_marginaleffect(
    response = dat$Y,
    predictions = preds,
    target_effect = 0.5,
    exposure_prob = 1/2
  )
}

test_that("`std_error` is consistent with the reported power", {
  pgs <- power_gs(variance = 6, ate = 1, n = 200, r = 2, margin = 0.5)
  expect_equal(
    pgs$power,
    pnorm((pgs$target_effect - pgs$margin) / pgs$std_error - qnorm(0.975))
  )

  pnc <- power_nc(variance = 6, ate = 1, n = 200, r = 2, margin = 0.5, df = 197)
  expect_equal(
    pnc$power,
    1 - pt(qt(0.975, df = 197), df = 197,
           ncp = (pnc$target_effect - pnc$margin) / pnc$std_error)
  )

  pme <- sim_power_marginaleffect()
  expect_equal(
    pme$power,
    pnorm((pme$target_effect - pme$margin) / pme$std_error - qnorm(0.975)),
    tolerance = 1e-6
  )
})

test_that("`print.postcard_power` prints assumptions and returns input invisibly", {
  pgs <- power_gs(variance = 6, ate = 1, n = 200)
  expect_output(out <- print(pgs), "Power approximation \\(class postcard_power\\)")
  expect_identical(out, pgs)
  expect_output(print(pgs), "Sample size:\\s+200")
  expect_false(any(grepl("Degrees of freedom", capture.output(print(pgs)))))

  pnc <- power_nc(variance = 6, ate = 1, n = 200, df = 197)
  expect_output(print(pnc), "Degrees of freedom:\\s+197")
})

test_that("`summary.postcard_power` adds class and prints estimand function", {
  pgs <- power_gs(variance = 6, ate = 1, n = 200)
  s <- summary(pgs)
  expect_s3_class(s, c("summary.postcard_power", "postcard_power"), exact = TRUE)
  expect_equal(unclass(s), unclass(pgs))
  expect_output(out <- print(s), "Summary of power approximation")
  expect_identical(out, s)
  expect_output(print(s), "Estimand function:\\s+psi1 - psi0")
})

test_that("`print` and `summary` for `postcard_samplesize`", {
  ss <- samplesize_gs(variance = 6, ate = 1, power = 0.8)
  expect_output(out <- print(ss), "Sample size approximation \\(class postcard_samplesize\\)")
  expect_identical(out, ss)
  expect_output(print(ss), "Desired power:\\s+0.8")

  s <- summary(ss)
  expect_s3_class(s, c("summary.postcard_samplesize", "postcard_samplesize"), exact = TRUE)
  expect_output(out <- print(s), "Summary of sample size approximation")
  expect_identical(out, s)
  expect_output(print(s), "Estimand function:\\s+psi1 - psi0")
})

test_that("`plot.postcard_power` returns ggplot with shaded area equal to power", {
  pgs <- power_gs(variance = 6, ate = 1, n = 100, margin = 0.2)
  p_gs <- plot(pgs)
  expect_s3_class(p_gs, "ggplot")
  expect_length(p_gs$layers, 3)
  expect_equal(power_area_from_plot(p_gs), pgs$power, tolerance = 0.05)
  expect_equal(
    p_gs$layers[[3]]$data$xintercept,
    qnorm(0.975, mean = pgs$margin, sd = pgs$std_error)
  )

  pnc <- power_nc(variance = 6, ate = 1, n = 100, df = 97)
  p_nc <- plot(pnc)
  expect_s3_class(p_nc, "ggplot")
  expect_equal(power_area_from_plot(p_nc), pnc$power, tolerance = 0.05)
  expect_equal(
    p_nc$layers[[3]]$data$xintercept,
    pnc$margin + pnc$std_error * qt(0.975, df = 97)
  )

  pme <- sim_power_marginaleffect()
  p_me <- plot(pme)
  expect_equal(power_area_from_plot(p_me), pme$power, tolerance = 0.05)

  # summary objects inherit the plot method
  expect_s3_class(plot(summary(pgs)), "ggplot")
})

test_that("`plot.postcard_power` snapshot", {
  pgs <- power_gs(variance = 6, ate = 1, n = 100, margin = 0.2)
  expect_doppelganger("plot_postcard_power_gs", plot(pgs))

  pnc <- power_nc(variance = 6, ate = 1, n = 100, df = 97)
  expect_doppelganger("plot_postcard_power_nc", plot(pnc))
})
