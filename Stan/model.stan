functions {
  real gev_lpdf(real y, real mu, real sigma, real xi) {
    if (sigma <= 0) {
      reject("Scale parameter sigma must be positive.");
    }
    real z = (y - mu) / sigma;
    if (xi == 0) {
      return -log(sigma) - z - exp(-z);
    } else {
      real t = 1 + xi * z;
      if (t <= 0) {
        reject("Invalid value for t: 1 + xi * (y - mu) / sigma must be positive.");
      }
      return -log(sigma) - (1/xi + 1) * log(t) - pow(t, -1/xi);
    }
  }
}

data {
  int<lower = 1> N_obs; // number of observations
  vector[N_obs] y; // observations
  int<lower = 1> N_sim; // number of simulations per model
  int<lower = 1> P_sim; // number of models
  matrix[N_sim, P_sim] X; // simulations
}

parameters {
  real mu_true;
  real<lower = 0> sigma_true;
  real<lower = -0.5, upper = 0.5> xi_true;
  
  
  vector[P_sim] z_mu_sim;
  real alpha_sim;
  real beta_sim;
  real<lower = 0> sigma_sim;

}

transformed parameters {
  vector[P_sim] mu_sim = alpha_sim + beta_sim * mu_true + sigma_sim * z_mu_sim;
}

model {
  for (i in 1:N_obs) {
    target += gev_lpdf(y[i] | mu_true, sigma_true, xi_true);
  }

  for (j in 1:P_sim) {
    z_mu_sim[j] ~ normal(0, 1);
    for (i in 1:N_sim) {
      target += gev_lpdf(X[i, j] | mu_sim[j], sigma_true, xi_true);
    }
  }

  alpha_sim ~ normal(mu_true, 2);
  beta_sim ~ normal(0, 1);
  sigma_sim ~ exponential(1);
}


