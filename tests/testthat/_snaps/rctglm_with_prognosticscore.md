# `rctglm_with_prognosticscore` snapshot tests

    Code
      ate <- withr::with_seed(42, {
        rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A,
        exposure_prob = exposure_prob, data = dat_treat, family = gaussian(),
        estimand_fun = "ate", data_hist = dat_notreat, learners = learners,
        cv_variance = TRUE, verbose = 2)
      })
    Message
      
      -- Fitting prognostic model --
      
      i Created formula for fitting prognostic model as: Y ~ .
      i Fitting learners
      * mod_mars
      * mod_lm
      i	No tuning parameters. `fit_resamples()` will be attempted
      i 1 of 2 resampling: mod_mars
      v 1 of 2 resampling: mod_mars ()
      i	No tuning parameters. `fit_resamples()` will be attempted
      i 2 of 2 resampling: mod_lm
      v 2 of 2 resampling: mod_lm ()
      i Model with lowest RMSE: mod_lm
      i Investigate trained learners and fitted model in `prognostic_info` list element
      
      -- Symbolic differentiation of estimand function --
      
      i Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
      * Alternatively, specify the derivative through the argument
      `estimand_fun_deriv0`
      i Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
      * Alternatively, specify the derivative through the argument
      `estimand_fun_deriv1`

---

    Code
      ate_wo_cvvariance <- withr::with_seed(42, {
        rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A,
        exposure_prob = exposure_prob, data = dat_treat, family = gaussian(),
        estimand_fun = "ate", data_hist = dat_notreat, learners = learners,
        cv_variance = FALSE, verbose = 0)
      })

---

    Code
      rr_pois_wo_cvvariance
    Output
      
      Object of class rctglm_prog 
      
      Call:  rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A, 
          exposure_prob = exposure_prob, data = dat_treat_pois, family = poisson(), 
          estimand_fun = "rate_ratio", cv_variance = FALSE, data_hist = dat_notreat_pois, 
          learners = learners, verbose = 0)
      
      Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: 37.45
      Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: 274.4
      Estimand function r: psi1/psi0
      Estimand (r(psi_1, psi_0)) estimate (SE): 7.327 (0.206)

---

    Code
      rr_pois_with_cvvariance
    Output
      
      Object of class rctglm_prog 
      
      Call:  rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A, 
          exposure_prob = exposure_prob, data = dat_treat_pois, family = poisson(), 
          estimand_fun = "rate_ratio", cv_variance = TRUE, data_hist = dat_notreat_pois, 
          learners = learners, verbose = 0)
      
      Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: 37.45
      Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: 274.4
      Estimand function r: psi1/psi0
      Estimand (r(psi_1, psi_0)) estimate (SE): 7.327 (0.2111)

---

    Code
      rr_nb_wo_cvvariance
    Output
      
      Object of class rctglm_prog 
      
      Call:  rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A, 
          exposure_prob = exposure_prob, data = dat_treat_pois, family = MASS::negative.binomial(2), 
          estimand_fun = "rate_ratio", cv_variance = FALSE, data_hist = dat_notreat_pois, 
          learners = learners, verbose = 0)
      
      Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: 36.66
      Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: 282.9
      Estimand function r: psi1/psi0
      Estimand (r(psi_1, psi_0)) estimate (SE): 7.717 (0.2389)

---

    Code
      rr_nb_with_cvvariance
    Output
      
      Object of class rctglm_prog 
      
      Call:  rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A, 
          exposure_prob = exposure_prob, data = dat_treat_pois, family = MASS::negative.binomial(2), 
          estimand_fun = "rate_ratio", cv_variance = TRUE, data_hist = dat_notreat_pois, 
          learners = learners, verbose = 0)
      
      Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: 36.66
      Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: 282.9
      Estimand function r: psi1/psi0
      Estimand (r(psi_1, psi_0)) estimate (SE): 7.717 (0.2446)

