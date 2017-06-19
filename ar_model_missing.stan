data {
  int T; // number of observations
  int P; // number of lags
  int N_missing; // the number of missing values
  vector[T] Y_raw; // the time series
}
parameters {
  real alpha;
  vector[P] beta;
  vector<lower = 0>[P] lambda;
  real<lower = 0> tau;
  vector[N_missing] missing;
  real<lower = 0> sigma;
}
transformed parameters {
  vector[T] Y; // 
  matrix[T, P] X; // lags matrix
  {
    int count;
    count = 0;
    for(t in 1:T) {
      if(Y_raw[t] == -9.0) {
        count = count + 1;
        Y[t] = missing[count];
      } else {
        Y[t] = Y_raw[t];
      }
    }
  }
  
  for(t in 1:T) {
    if(t<=P) {
      X[t] = rep_row_vector(0, P);
    } else {
      X[t] = Y[(t-P):(t-1)]';
    }
  }
}
model {
  // priors
  
  lambda ~ cauchy(0, 1);
  tau ~ cauchy(0, 1);
  beta ~ normal(0, tau*lambda);
  sigma ~ cauchy(0, 1);
  alpha ~ normal(0, 10);
  missing ~ normal(alpha, 10);
  
  // likelihood
  for(t in (P+1):T) {
    Y[t] ~ normal(alpha + X[t]*beta, sigma);
  }
}
