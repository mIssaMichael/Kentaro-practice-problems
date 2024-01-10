  data {
    int<lower=0> N1;  // Number of observations in Group 1
    int<lower=0> N2;  // Number of observations in Group 2
    vector[N1] Y1;    // Data for Group 1
    vector[N2] Y2;    // Data for Group 2
  }

  parameters {
    real mu1;             // Mean for Group 1
    real mu2;             // Mean for Group 2
    real<lower=0> sigma1;  // SD for Group 1
    real<lower=0> sigma2;  // SD for Group 2
    real<lower=0> nu1;     // Degrees of freedom  
    real<lower=0> nu2;     // Degrees of freedom 
  }

  model {
    // Priors
    mu1 ~ normal(0, 10);
    mu2 ~ normal(0, 10);
    sigma1 ~ cauchy(0, 5);
    sigma2 ~ cauchy(0, 5);
    nu1 ~ gamma(2, 0.1);
    nu2 ~ gamma(2, 0.1);
  
    // Likelihood
    Y1 ~ student_t(nu1, mu1, sigma1);
    Y2 ~ student_t(nu2, mu2, sigma2);
  }
