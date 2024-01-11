data {
  int<lower=0> N1;  // Number of observations in Group 1
  int<lower=0> N2;  // Number of observations in Group 2
  vector[N1] Y1;    // Data for Group 1
  vector[N2] Y2;    // Data for Group 2
}

parameters {
  real mu1;             // Mean for Group 1
  real mu2;             // Mean for Group 2
  real<lower=0> sigma;  // Common standard deviation
  real<lower=0> nu;     // Degrees of freedom for Student's t-distribution
}

model {
  // Priors
  mu1 ~ normal(0, 10);
  mu2 ~ normal(0, 10);
  sigma ~ cauchy(0, 5);
  nu ~ gamma(2, 0.1);  // Setting shape and rate parameters for gamma distribution

  // Likelihood
  Y1 ~ student_t(nu, mu1, sigma);
  Y2 ~ student_t(nu, mu2, sigma);
}



