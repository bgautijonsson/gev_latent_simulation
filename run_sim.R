library(cmdstanr)
library(tidyverse)
library(evd)

N_obs <- 40

N_sim <- 500
P_sim <- 20

mu_true <- 5
sigma_true <- 2
xi_true <- 0.1

y <- rgev(N_obs, mu_true, sigma_true, xi_true)

alpha_sim <- 8
beta_sim <- 0.2
sigma_sim <- 0.2

mu_sim <- rnorm(P_sim, alpha_sim + beta_sim * mu_true, sigma_sim)

X <- matrix(
  nrow = N_sim, 
  ncol = P_sim
)

for (i in seq_len(P_sim)) {
  X[ , i] <- rgev(N_sim, loc = mu_sim[i], scale = sigma_true, shape = xi_true)
}

model <- cmdstan_model("Stan/model.stan", compile = TRUE)

stan_data <- list(
  N_obs = N_obs,
  y = y,
  N_sim = N_sim,
  P_sim = P_sim,
  X = X
)

fit <- model$sample(
  data = stan_data,
  chains = 4,
  parallel_chains = 4,
  iter_warmup = 500,
  iter_sampling = 500
)


fit$summary(c("mu_true", "sigma_true", "xi_true", "alpha_sim", "beta_sim", "sigma_sim"))
