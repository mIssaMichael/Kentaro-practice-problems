##################################
# Author: Michael Issa
# Date : 1/10/2024
# In text code and exercises for
# chapter 5
##################################

# Load libraries and set seed
library(cmdstanr)
set.seed(123)

# Load data
d <- read.csv(file='Chapter 5/data/data-shopping-1.csv')

# Generate simulated data
d$income <- d$Income/100
N <-nrow(d)
Y_sim_mean <- .2 + .15 * d$Sex + .4 * d$Income/100
Y_sim <- rnorm(N, mean=Y_sim_mean, sd=.1)

# Simulated and real data lists
data_sim <- list(N=N, Sex=d$Sex, Income=d$Income, Y=Y_sim)
data <- list(N=N, Sex=d$Sex, Income=d$Income, Y=Y_sim)

# Fit Model
model <- cmdstan_model(stan_file='Chapter 5/models/model5.3.stan')
fit_sim <-model$sample(data=data_sim, seed=123,
                     parallel_chains=4)
fit <- model$sample(data=data, seed=123, parallel_chains=4)

# Summary
fit$summary()




