\name{dhtbexp}
\alias{dhtbexp}
\alias{phtbexp}
\alias{qhtbexp}
\alias{rhtbexp}
\title{Two-sided hidden-truncated Arnold-Strauss exponential distribution}
\usage{
dhtbexp(x,a,b,c,d1,d2,log=FALSE)
phtbexp(q,a,b,c,d1,d2,lower.tail=TRUE,log.p=FALSE)
qhtbexp(p,a,b,c,d1,d2)
rhtbexp(n,a,b,c,d1,d2)
}
\description{Functions for two-sided hidden-truncated arnold-strauss exponential distribution.}
\arguments{
\item{x, q, p, n}{Data, quantiles, probabilities, or sample size as appropriate.}
\item{...}{Additional arguments passed to the underlying function.}
}
\value{Numeric values, simulated observations, or a fitted-model object depending on the function.}
