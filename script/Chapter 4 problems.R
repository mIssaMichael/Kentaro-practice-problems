##################################
# Author: Michael Issa
# Date : 1/8/2024
# In text code and exercises for
# chapter 4
##################################
library(cmdstanr)
library(coda)

d <- read.csv(file='data/data-salary.csv')
data <- list(N=nrow(d), X=d$X, Y=d$Y)
model <- cmdstan_model(stan_file='model/chapter 4.stan')
fit <- model$sample(data=data, seed=123)

fit$cmdstan_summary()

write.table(fit$summary(), file='output/fit-summary.csv', sep=',', quote=TRUE, row.names=FALSE)


pdf(file='output/fit-plot.pdf')
plot(as_mcmc.list(fit))
dev.off()

# Test different resamplings
init_fun <- function(chain_id) {
  se.seed(chain_id)
  list(a=runif(1,30,50), b=1, sigma=5)
}

fit <- model$sample(data=data, seed=123,
                    init=init_fun,
                    chains=3, iter_warmup=500, iter_sampling=500, thin=2,
                    parallel_chains = 3,
                    save_warmup=TRUE)

d_ms <- fit$draws(format='df')

quantile(d_ms$b, probs=c(.025, .975))

##################################
# 4.2.7
##################################
N_ms <- nrow(d_ms)
y10_base = d_ms$a +d_ms$b * 10
y10_pred <- rnorm(n=N_ms, mean=y10_base, sd=d_ms$sigma)

##################################
# 4.5.1 Exercises
##################################
library(tidyverse)
library(ggplot2)
set.seed(123)
N1 <- 30
N2 <- 20
Y1 <- rnorm(n=N1, mean=0, sd=5)
Y2 <- rnorm(n=N2, mean=1, sd=4)


# Combine data into a data frame
data <- data.frame(
  Group = rep(c("Group 1", "Group 2"), times = c(N1, N2)),
  Value = c(Y1, Y2)
)

# Create a boxplot
ggplot(data, aes(x = Group, y = Value, fill = Group)) +
  geom_boxplot() +
  labs(title = "Comparison of Two Groups",
       x = "Group",
       y = "Value") +
  theme_minimal()

# Compile the Stan model
model <- cmdstan_model(stan_file = 'model/Chapter 4.5.1.stan')

# Prepare data list
data <- list(N1 = N1, N2 = N2, Y1 = Y1, Y2 = Y2)

# Fit the model
fit <- model$sample(data=data, 
                    seed=123, 
                    chains=3, iter_warmup=500, iter_sampling=500, thin=2,
                    parallel_chains = 3)
# Print summary
fit$cmdstan_summary()


#Extract draws
d_ms <- fit$draws(format='df')

prob_mu1_less_than_mu2 <- mean(d_ms$mu1 < d_ms$mu2)

cat("Probability that mu_1 < mu_2", prob_mu1_less_than_mu2) # P = 0.933


# Assume SD are distinct
model <- cmdstan_model(stan_file = 'model/M2Chapter 4.5.1.stan')

# Prepare data list
data <- list(N1 = N1, N2 = N2, Y1 = Y1, Y2 = Y2)

# Fit the model
fit <- model$sample(data=data, 
                    seed=123, 
                    chains=3, iter_warmup=500, iter_sampling=500, thin=2,
                    parallel_chains = 3)
# Print summary
fit$cmdstan_summary()


#Extract draws
d_ms <- fit$draws(format='df')

prob_mu1_less_than_mu2 <- mean(d_ms$mu1 < d_ms$mu2)

cat("Probability that mu_1 < mu_2", prob_mu1_less_than_mu2) # P = 0.936











