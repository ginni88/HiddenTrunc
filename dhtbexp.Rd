\name{dhtbexp}
\alias{dhtbexp}
\alias{phtbexp}
\alias{qhtbexp}
\alias{rhtbexp}
\title{Hidden-truncated Arnold-Strauss exponential distribution}
\description{Functions for the two-sided hidden-truncated Arnold-Strauss bivariate exponential construction.}
\usage{
dhtbexp(x, a, b, c, d1, d2, log = FALSE)
phtbexp(q, a, b, c, d1, d2,
        lower.tail = TRUE, log.p = FALSE)
qhtbexp(p, a, b, c, d1, d2)
rhtbexp(n, a, b, c, d1, d2)
}
\arguments{
\item{x}{Numeric evaluation points for density.}
\item{q}{Numeric quantiles for the CDF.}
\item{p}{Numeric probabilities for the quantile function.}
\item{n}{Number of generated observations.}
\item{a}{Positive exponential rate parameter.}
\item{b}{Positive exponential rate parameter.}
\item{c}{Positive interaction parameter.}
\item{d1}{Lower hidden truncation bound, non-negative.}
\item{d2}{Upper hidden truncation bound, strictly larger than d1.}
\item{log}{Logical; if TRUE, return log-density.}
\item{lower.tail}{Logical; use the lower tail when TRUE.}
\item{log.p}{Logical; return log-probabilities when TRUE.}
}
\value{Numeric vector of density, CDF, quantile, or random values.}
