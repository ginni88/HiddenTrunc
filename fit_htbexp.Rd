\name{fit_htbexp}
\alias{fit_htbexp}
\alias{loglik_htbexp}
\alias{bayes_htbexp}
\title{Inference for two-sided hidden-truncated exponential model}
\usage{
fit_htbexp(x,start=NULL,control=list(maxit=5000))
loglik_htbexp(par,x,transformed=FALSE)
bayes_htbexp(x,niter=10000,burn=2000,thin=5,init=c(a=1,b=1,c=.2,d1=.1,d2=1),gamma_shape=c(1,1,1),gamma_rate=c(1,1,1),delta=max(10,init[5]*2),proposal_sd=rep(.12,5),seed=NULL)
}
\description{Functions for inference for two-sided hidden-truncated exponential model.}
\arguments{
\item{x, q, p, n}{Data, quantiles, probabilities, or sample size as appropriate.}
\item{...}{Additional arguments passed to the underlying function.}
}
\value{Numeric values, simulated observations, or a fitted-model object depending on the function.}
