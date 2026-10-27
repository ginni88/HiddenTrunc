\name{dhtp4}
\alias{dhtp4}
\alias{phtp4}
\alias{qhtp4}
\alias{rhtp4}
\alias{hhtp4}
\title{Hidden-truncated Pareto IV distribution}
\usage{
dhtp4(x, alpha, sigma, theta, delta1, delta2, log = FALSE)
phtp4(q, alpha, sigma, theta, delta1, delta2, lower.tail = TRUE, log.p = FALSE)
qhtp4(p, alpha, sigma, theta, delta1, delta2, lower.tail = TRUE, log.p = FALSE)
rhtp4(n, alpha, sigma, theta, delta1, delta2)
hhtp4(x, alpha, sigma, theta, delta1, delta2)
}
\description{Functions for hidden-truncated pareto iv distribution.}
\arguments{
\item{x, q, p, n}{Data, quantiles, probabilities, or sample size as appropriate.}
\item{...}{Additional arguments passed to the underlying function.}
}
\value{Numeric values, simulated observations, or a fitted-model object depending on the function.}
