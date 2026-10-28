\name{floyd_river}
\alias{floyd_river}
\alias{gof_htp4}
\alias{boot_ci_htp4}
\title{Floyd River data and Pareto IV model assessments}
\description{Access Floyd River annual discharge data; compute a Kolmogorov-Smirnov discrepancy with optional parametric bootstrap; or obtain percentile bootstrap confidence intervals.}
\usage{
floyd_river()
gof_htp4(x, fit = NULL, B = 0, seed = NULL)
boot_ci_htp4(x, fit = NULL, B = 499,
             level = 0.95, seed = NULL)
}
\arguments{
\item{x}{Positive numeric sample used to fit or assess the model.}
\item{fit}{Optional htfit object. If NULL, fit_htp4 is called.}
\item{B}{Number of parametric bootstrap replicates. Zero disables the bootstrap in gof_htp4.}
\item{seed}{Optional seed for reproducibility.}
\item{level}{Confidence level strictly between zero and one.}
}
\value{floyd_river returns a numeric vector; gof_htp4 returns an htgof object; boot_ci_htp4 returns a data frame of confidence bounds.}
