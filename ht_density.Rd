\name{ht_density}
\alias{ht_density}
\alias{dhidden}
\alias{phidden}
\alias{rhidden}
\alias{ht_loglik}
\alias{ht_mle}
\title{Generic hidden-truncation utilities}
\usage{
ht_density(x, fx, selection_prob, normalizer, log=FALSE, ...)
dhidden(x, fx, selection_prob, normalizer, ...)
phidden(q, fx, selection_prob, normalizer, lower=0, ...)
rhidden(n, fx, selection_prob, normalizer, lower=0, upper_start=1, ...)
ht_loglik(par,x,density,...)
ht_mle(par,x,loglik,transform=exp,...)
}
\description{Functions for generic hidden-truncation utilities.}
\arguments{
\item{x, q, p, n}{Data, quantiles, probabilities, or sample size as appropriate.}
\item{...}{Additional arguments passed to the underlying function.}
}
\value{Numeric values, simulated observations, or a fitted-model object depending on the function.}
