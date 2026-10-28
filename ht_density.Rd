\name{ht_density}
\alias{ht_density}
\alias{dhidden}
\alias{phidden}
\alias{rhidden}
\alias{ht_loglik}
\alias{ht_mle}
\title{Generic hidden-truncation utilities}
\description{Generic construction of hidden-truncated densities and inference using an explicit baseline density and selection probability.}
\usage{
ht_density(x, fx, selection_prob, normalizer, log = FALSE, ...)
dhidden(x, fx, selection_prob, normalizer, ...)
phidden(q, fx, selection_prob, normalizer, lower = 0, ...)
rhidden(n, fx, selection_prob, normalizer,
        lower = 0, upper_start = 1, ...)
ht_loglik(par, x, density, ...)
ht_mle(par, x, loglik, transform = exp, ...)
}
\arguments{
\item{x}{Numeric evaluation points or observed data, depending on the function.}
\item{q}{Quantiles at which to evaluate the CDF.}
\item{n}{Number of random observations.}
\item{fx}{Callable function for the baseline density.}
\item{selection_prob}{Callable function for conditional selection probabilities.}
\item{normalizer}{Positive normalization probability for the selection model.}
\item{log}{Logical; return the log-density when TRUE.}
\item{lower}{Lower integration/inversion bound.}
\item{upper_start}{Positive starting upper bound for inverse CDF search.}
\item{par}{Parameter vector for optimization or likelihood evaluation.}
\item{density}{Density function accepting observations and a parameter vector.}
\item{loglik}{Log-likelihood function for maximum likelihood estimation.}
\item{transform}{Transformation mapping optimization coordinates to parameters.}
\item{...}{Additional arguments passed to the density, selection, or likelihood functions.}
}
\value{Density/CDF values, random observations, log-likelihood, or an optimization result, as appropriate.}
