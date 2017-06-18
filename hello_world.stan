data {
  int N; // the number of observations
  int P; // the number of covariates
  matrix[N, P] X; // our covariates
  vector[N] y; // the data outcomes
}
parameters {
  vector[P] beta; // regression coefficients
  real<lower= 0> sigma; // standard deviation of the residuals
}
model {
  // priors
  beta ~ normal(0, 1);
  sigma ~ cauchy(0, 2);
  
  // likelihood
  y ~ normal(X*beta, sigma);
}