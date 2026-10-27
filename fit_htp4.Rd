\name{fit_htp4}
\alias{fit_htp4}
\alias{loglik_htp4}
\alias{lrt_htp4}
\alias{sim_htp4}
\title{Inference for hidden-truncated Pareto IV}
\usage{
fit_htp4(x, start = NULL, method = "Nelder-Mead", control = list(maxit=5000), hessian = TRUE)
loglik_htp4(par, x, transformed = FALSE)
lrt_htp4(x, fit = NULL, B = 0, seed = NULL)
sim_htp4(n=c(50,100,200), R=100, par=c(alpha=3,sigma=2,theta=1,delta1=2,delta2=3), seed=NULL)
}
\description{Functions for inference for hidden-truncated pareto iv.}
\arguments{
\item{x, q, p, n}{Data, quantiles, probabilities, or sample size as appropriate.}
\item{...}{Additional arguments passed to the underlying function.}
}
\value{Numeric values, simulated observations, or a fitted-model object depending on the function.}
