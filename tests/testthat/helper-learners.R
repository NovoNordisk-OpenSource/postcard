# Shared learner specification (MARS + linear model) reused across tests that
# fit discrete super learners / prognostic models.
example_learners <- function() {
  list(
    mars = list(
      model = parsnip::set_engine(
        parsnip::mars(mode = "regression", prod_degree = 3),
        "earth"
      )
    ),
    lm = list(
      model = parsnip::set_engine(parsnip::linear_reg(), "lm")
    )
  )
}
