# `rctglm_with_prognosticscore` snapshot tests

    Code
      ate <- fit_prognostic_ate(dat_treat = dat_treat, dat_notreat = dat_notreat,
        verbose = 2)
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
      ate_wo_cvvariance <- fit_prognostic_ate(dat_treat = dat_treat, dat_notreat = dat_notreat,
        cv_variance = FALSE, verbose = 0)

---

    Code
      rr_pois_wo_cvvariance
    Output
      
      Object of class rctglm_prog 
      
      Call:  rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A, 
          exposure_prob = exposure_prob, data = dat_treat, family = family, 
          estimand_fun = estimand_fun, cv_variance = cv_variance, data_hist = dat_notreat, 
          learners = learners, verbose = 0)
      
      Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: 39.03
      Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: 299.4
      Estimand function r: psi1/psi0
      Estimand (r(psi_1, psi_0)) estimate (SE): 7.671 (0.1969)

---

    Code
      rr_pois_with_cvvariance
    Output
      
      Object of class rctglm_prog 
      
      Call:  rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A, 
          exposure_prob = exposure_prob, data = dat_treat, family = family, 
          estimand_fun = estimand_fun, cv_variance = cv_variance, data_hist = dat_notreat, 
          learners = learners, verbose = 0)
      
      Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: 39.03
      Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: 299.4
      Estimand function r: psi1/psi0
      Estimand (r(psi_1, psi_0)) estimate (SE): 7.671 (0.2011)

---

    Code
      rr_nb_wo_cvvariance
    Output
      
      Object of class rctglm_prog 
      
      Call:  rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A, 
          exposure_prob = exposure_prob, data = dat_treat, family = family, 
          estimand_fun = estimand_fun, cv_variance = cv_variance, data_hist = dat_notreat, 
          learners = learners, verbose = 0)
      
      Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: 39.17
      Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: 306
      Estimand function r: psi1/psi0
      Estimand (r(psi_1, psi_0)) estimate (SE): 7.812 (0.2594)

---

    Code
      rr_nb_with_cvvariance
    Output
      
      Object of class rctglm_prog 
      
      Call:  rctglm_with_prognosticscore(formula = Y ~ ., exposure_indicator = A, 
          exposure_prob = exposure_prob, data = dat_treat, family = family, 
          estimand_fun = estimand_fun, cv_variance = cv_variance, data_hist = dat_notreat, 
          learners = learners, verbose = 0)
      
      Counterfactual control mean (psi_0=E[Y|X, A=0]) estimate: 39.17
      Counterfactual active mean (psi_1=E[Y|X, A=1]) estimate: 306
      Estimand function r: psi1/psi0
      Estimand (r(psi_1, psi_0)) estimate (SE): 7.812 (0.2635)

