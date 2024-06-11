#===============================================================================
# Statistics for Data Science
#
# New Sigmoid-like function better than Fisher z transformation
# 
# Authors: Sana Afreen
#          Naomi Cedeño Manrique
#          Luis Pinto Aleman
#===============================================================================

# [CTRL-Enter] to execute a line

# -----------------------------------------------------------------------------
# Libraries

#install needed packages (just once)
#install.packages("matlib")
#install.packages("scatterplot3d")
#install.packages("tidyverse")

library(matlib)
library(scatterplot3d)
library(tidyverse)

# -----------------------------------------------------------------------------
# Parameters

x_range <- seq(-6, 6, by = 0.1)
k <- 1.701

# -----------------------------------------------------------------------------
# Functions Definition: Phi

phi <- function(x) { # Phi(y)
  pnorm(x)
}

phi_erf <- function(y) {  # erf(x)
  2 * phi(y * sqrt(2)) - 1 # Since y = x / sqrt(2), x = y * sqrt(2)
}

# -----------------------------------------------------------------------------
# Functions Definition: Fisher z Transformation

fisher_z_cdf <- function(x) { # \approx Phi(y)
  0.5 * (((exp(2 * x) - 1) / (exp(2 * x) + 1)) + 1) # y = x / sqrt(2)
}

fisher_z_erf <- function(y) { # \approx erf(x)
  (exp(2 * y * sqrt(2)) - 1) / (exp(2 * y * sqrt(2)) + 1) # Since y = x / sqrt(2), x = y * sqrt(2)
}

# -----------------------------------------------------------------------------
# Functions Definition: Sigmoid-Like

sigmoid_cdf <- function(x, k) { # SY(y)
  1 / (1 + exp(-k * x)) # y = x / sqrt(2)
}

sigmoid_erf <- function(y, k){ # SE(x) = 2 * SY(x) 
  (2 * sigmoid_cdf(y * sqrt(2), k)) - 1 # Since y = x / sqrt(2), x = y * sqrt(2)
}

# -----------------------------------------------------------------------------
# Function Computations: CDF

df_phi <- phi(x_range)
df_sigmoid_cdf <- sigmoid_cdf(x_range, k)
df_fisher_z_cdf <- fisher_z_cdf(x_range)

# -----------------------------------------------------------------------------
# Function Computations: erf

df_phi_erf <- phi_erf(x_range)
df_sigmoid_erf <- sigmoid_erf(x_range, k)
df_fisher_z_erf <- fisher_z_erf(x_range)

# -----------------------------------------------------------------------------
# Collect Results

distributions <- data.frame(x_range = x_range,
                            phi = df_phi,
                            sigmoid = df_sigmoid_cdf,
                            fisher = df_fisher_z_cdf,
                            phi_erf = df_phi_erf,
                            sigmoid_erf = df_sigmoid_erf, 
                            fisher_erf = df_fisher_z_erf) %>% 
  mutate(error_sigmoid_cdf = sigmoid - phi,
         error_fisher_cdf = fisher - phi, 
         error_fisher_erf = fisher_erf - phi_erf,
         error_sigmoid_erf = sigmoid_erf - phi_erf)

# -----------------------------------------------------------------------------
# CDF Plots

ggplot(distributions, aes(x = x_range)) + # CDFs
  geom_line(aes(y = phi, color = "Theoretical CDF")) +
  geom_line(aes(y = sigmoid, color = "Sigmoid-Like Function")) +
  geom_line(aes(y = fisher, color = "Fisher z Transformation")) +
  labs(x = "X", y = "Value", color = "Distribution") +
  ylim(c(-0.2, 1.2)) +
  scale_color_manual(values = c("Theoretical CDF" = "blue", "Sigmoid-Like Function" = "red", "Fisher z Transformation" = "green")) +
  theme_minimal()

ggplot(distributions, aes(x = x_range)) + # Detail of the previous plot
  geom_line(aes(y = phi, color = "Theoretical CDF")) +
  geom_line(aes(y = sigmoid, color = "Sigmoid-Like Function")) +
  geom_line(aes(y = fisher, color = "Fisher z Transformation")) +
  labs(x = "X", y = "Value", color = "Distribution") +
  xlim(c(0.5, 2.5)) +
  ylim(c(0.7, 1)) +
  scale_color_manual(values = c("Theoretical CDF" = "blue", "Sigmoid-Like Function" = "red", "Fisher z Transformation" = "green")) +
  theme_minimal()

ggplot(distributions, aes(x = x_range)) + # Error between custom CDFs with respect to Phi(x)
  geom_line(aes(y = error_sigmoid_cdf, color = "Sigmoid-Like Function")) +
  geom_line(aes(y = error_fisher_cdf, color = "Fisher z Transformation")) +
  labs(x = "X", y = "Value", color = "Distribution") +
  ylim(c(-0.06, 0.06)) +
  scale_color_manual(values = c("Sigmoid-Like Function" = "red", "Fisher z Transformation" = "green")) +
  theme_minimal()

# -----------------------------------------------------------------------------
# Erf Plots

ggplot(distributions, aes(x = x_range)) + # Erfs
  geom_line(aes(y = phi_erf, color = "Theoretical CDF")) +
  geom_line(aes(y = fisher_erf, color = "Fisher z Transformation")) +
  geom_line(aes(y = sigmoid_erf, color = "Sigmoid-Like Function")) +
  labs(x = "X", y = "Value", color = "Distribution") +
  scale_color_manual(values = c("Theoretical CDF" = "blue", "Sigmoid-Like Function" = "red", "Fisher z Transformation" = "green")) +
  theme_minimal()

ggplot(distributions, aes(x = x_range)) + # Error between custom erfs with respect to erf(x)
  geom_line(aes(y = error_fisher_erf, color = "Fisher z Transformation")) +
  geom_line(aes(y = error_sigmoid_erf, color = "Sigmoid-Like Function")) +
  labs(x = "X", y = "Value", color = "Distribution") +
  scale_color_manual(values = c("Sigmoid-Like Function" = "red", "Fisher z Transformation" = "green")) +
  ylim(c(-0.1, 0.1)) +
  theme_minimal()  

# -----------------------------------------------------------------------------
# Minimal Total Error

# Definition

minimal_total_error <- function(k) {
  integrate(function(x) (sigmoid_cdf(x, k) - phi(x))^2, -Inf, Inf)$value
}

# Optimal Value

optimal_mte <- optim(par = 1, fn = minimal_total_error, method = "BFGS") # It is possible to do that also with a which 
                                                                         # by extracting a dataframe of k and total_error
optimal_k <- optimal_mte$par

# Plotting

k_range <- seq(1.20, 2.20, by = 0.0001)
mte_values <- numeric(length(k_range))

mte_values <- sapply(k_range, minimal_total_error)

mte_data <- data.frame(
  k = k_range,
  error = mte_values
)

mte_data_fisher <- mte_data %>% 
  filter(k == 2) %>% 
  pull(error) # Obtain the total error of Fisher's z transformation, just for comparison purposes

ggplot(mte_data, aes(x = k, y = error)) +
  geom_line(color = "blue") +
  geom_hline(aes(yintercept = mte_data_fisher), linetype = "dashed") +
  annotate("text", x = 1.68, y = mte_data_fisher + 0.0009, label = round(mte_data_fisher,6)) +
  labs(x = "k",
       y = "Total error") +
  xlim(c(1.20, 2.20)) +
  theme_minimal()

# -----------------------------------------------------------------------------
# Minimal Maximum Distance

# Definition

minimal_maximum_distance <- function(x, k) {
  abs(sigmoid_cdf(x, k) - phi(x))
}

k_range <- seq(1.20, 2.20, by = 0.0001)
x_values <- seq(-4, 4, 0.01)
mmd_values <- numeric(length(k_range))

mmd_values <- sapply(k_range, function(k) {
  distances <- sapply(x_values, function(x) minimal_maximum_distance(x, k))
  return(max(distances))
})

mmd_data <- data.frame(
  k = k_range,
  max_distance = mmd_values
)

# Optimal Value

optimal_k_mmd <- mmd_data %>% 
  filter(max_distance == min(max_distance)) %>% 
  pull(k) 

# Plotting

mmd_data_fisher <- mmd_data %>% 
  filter(k == 2) %>% 
  pull(max_distance) # Obtain the total error of Fisher's z transformation, just for comparison purposes

ggplot(mmd_data, aes(x = k, y = max_distance)) +
  geom_line(color = "blue") +
  geom_hline(aes(yintercept = mmd_data_fisher), linetype = "dashed") +
  annotate("text", x = 1.68, y = mmd_data_fisher + 0.003, label = round(mmd_data_fisher,6)) +
  labs(x = "k", 
       y = "maximal distance") +
  xlim(c(1.20, 2.20)) +
  theme_minimal() 

# Extremum 2D

mmd_data_mx <- data.frame(k = numeric(), x = numeric(), max_distance = numeric())

for (k in k_range) {
  distances <- sapply(x_values, function(x) minimal_maximum_distance(x, k))
  max_distance <- max(distances)
  x_max <- x_values[which.max(distances)]
  mmd_data_mx <- rbind(mmd_data_mx, data.frame(k = k, x = x_max, max_distance = max_distance))
}

ggplot(mmd_data_mx, aes(x = k, y = x)) +
  geom_point(color = "black") +
  labs(x = "k", y = "Extremum of x") +
  xlim(c(1.6, 1.8)) + 
  ylim(c(-3, 3)) +
  theme_minimal()

# Extremum 3D

scatterplot3d(mmd_data_mx$k, mmd_data_mx$x, mmd_data_mx$max_distance, 
              xlab = "k", 
              ylab = "Extremum of x", 
              zlab = "Maximal Distance", 
              pch = 19, 
              color = "black", 
              # type = "h", 
              angle = 130,
              xlim = c(1.6, 1.8),
              ylim = c(-4, 4),
              zlim = c(0, 0.025))

# -----------------------------------------------------------------------------
# Errors Computation

errors <- mmd_data %>% 
  mutate(k_dec = as.character(k)) %>% 
  filter(k %in% c("1.7009", "1.7017", "1.701")) %>% 
  left_join(mte_data %>% 
              mutate(k =  as.character(k)) %>% 
              rename(total_error = error),
            by = c('k_dec' = 'k')) %>% 
  select(k, total_error, max_distance)
  
rownames(errors) <- c("K_t", "K_d", "K_a")
colnames(errors) <- c("k", "Total error to Phi(x)", "Maximal distance to Phi(x)")

errors
