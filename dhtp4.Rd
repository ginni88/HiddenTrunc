\name{dhtp4}
\alias{dhtp4}
\alias{phtp4}
\alias{qhtp4}
\alias{rhtp4}
\alias{hhtp4}
\title{Hidden-truncated Pareto IV distribution}
\description{Density, cumulative distribution, quantile, random generation, and hazard functions for the hidden-truncated Pareto IV model.}
\usage{
dhtp4(x, alpha, sigma, theta, delta1, delta2, log = FALSE)
phtp4(q, alpha, sigma, theta, delta1, delta2,
      lower.tail = TRUE, log.p = FALSE)
qhtp4(p, alpha, sigma, theta, delta1, delta2,
      lower.tail = TRUE, log.p = FALSE)
rhtp4(n, alpha, sigma, theta, delta1, delta2)
hhtp4(x, alpha, sigma, theta, delta1, delta2)
}
\arguments{
\item{x}{Numeric evaluation points (for the density or hazard).}
\item{q}{Numeric quantiles for the CDF.}
\item{p}{Numeric probabilities for the quantile function.}
\item{n}{Non-negative number of observations to generate.}
\item{alpha}{Positive Pareto IV tail-shape parameter.}
\item{sigma}{Positive scale parameter.}
\item{theta}{Positive selection parameter.}
\item{delta1}{Positive power parameter.}
\item{delta2}{Positive parameter controlling the hidden-selection transform.}
\item{log}{Logical; return logarithm of the density.}
\item{lower.tail}{Logical; return lower-tail probabilities when TRUE.}
\item{log.p}{Logical; probabilities are on the logarithmic scale when TRUE.}
}
\value{Numeric vector of evaluated values, quantiles, simulated observations, or hazards.}
