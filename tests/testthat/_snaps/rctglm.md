# `rctglm` snapshot tests

    Code
      estimand(ate_with_cv)
    Output
        Estimate Std. Error
      1 1.762089  0.1871503

---

    Code
      estimand(ate_wo_cv)
    Output
        Estimate Std. Error
      1 1.762089  0.1846456

---

    Code
      estimand(rr_with_cv)
    Output
        Estimate Std. Error
      1 50.35502   8.677974

---

    Code
      estimand(rr_wo_cv)
    Output
        Estimate Std. Error
      1 50.35502   8.597313

# `estimand_fun_derivX` can be left as NULL or specified manually

    Code
      ate_auto <- fit_rctglm_ate(dat_gaus, verbose = 1)
    Message
      
      -- Symbolic differentiation of estimand function --
      
      i Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi0' as: '-1'.
      * Alternatively, specify the derivative through the argument
      `estimand_fun_deriv0`
      i Symbolically deriving partial derivative of the function 'psi1 - psi0' with respect to 'psi1' as: '1'.
      * Alternatively, specify the derivative through the argument
      `estimand_fun_deriv1`

