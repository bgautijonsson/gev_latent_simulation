# GEV Latent Simulation

A Bayesian framework for integrating climate model simulations with limited observational data using Generalized Extreme Value (GEV) distributions and latent variable modeling.

## Overview

This project implements statistical methods for analyzing extreme climate events by combining sparse observational data (`y`) with abundant climate model simulations (`X`). The approach is inspired by the climate modeling frameworks of Rougier and Chandler, addressing the challenge of making inference about extreme events when observational records are limited but simulation data is plentiful.

### Key Features

- **Hierarchical Bayesian modeling** using Stan for parameter estimation
- **GEV distribution modeling** for extreme value analysis
- **Latent variable framework** linking simulation parameters to true climate parameters
- **Linear relationship enforcement** between simulated and observed parameters

## Methodology

The statistical framework assumes:

1. **Few observations** `y` following a GEV distribution with true parameters `(μ_true, σ_true, ξ_true)`
2. **Many simulations** `X` (matrix of size `N_sim × P_sim`) from climate models
3. **Linear relationship** between simulation and true parameters:
   ```
   μ_sim = α_sim + β_sim × μ_true + ε
   ```

This hierarchical structure allows the model to:
- Borrow strength from simulation data to inform observational inference
- Quantify uncertainty in the relationship between simulated and observed extremes
- Provide robust estimates of extreme event probabilities

## Repository Structure

```
├── Stan/
│   ├── model.stan          # Main Bayesian model specification
│   └── model               # Compiled Stan model
├── run_sim.R               # Main simulation script
├── README.md               # This file
└── gev_latent_simulation.Rproj  # RStudio project file
```

## Installation & Requirements

### R Dependencies
```r
library(cmdstanr)
library(tidyverse)
library(evd)
```

### Stan Installation
This project requires CmdStan. Follow the installation guide at [mc-stan.org](https://mc-stan.org/users/interfaces/cmdstan).

## Usage

### Basic Example

```r
# Source the main script
source("run_sim.R")

# The script will:
# 1. Generate synthetic observational data (N_obs = 40)
# 2. Create climate model simulations (N_sim × P_sim matrix)
# 3. Fit the hierarchical Bayesian model
# 4. Display parameter estimates and diagnostics
```

### Model Parameters

- `N_obs`: Number of observational data points (default: 40)
- `N_sim`: Number of simulations per model (default: 100) 
- `P_sim`: Number of climate model runs (default: 20)
- `mu_true`, `sigma_true`, `xi_true`: True GEV parameters for observations
- `alpha_sim`, `beta_sim`, `sigma_sim`: Relationship parameters linking simulations to truth

### Key Model Components

1. **Observational Model**: 
   ```
   y_i ~ GEV(μ_true, σ_true, ξ_true)
   ```

2. **Simulation Model**:
   ```
   X_ij ~ GEV(μ_sim[j], σ_true, ξ_true)
   μ_sim[j] = α_sim + β_sim × μ_true + σ_sim × z_j
   ```