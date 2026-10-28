\name{fit_htp4}
\alias{fit_htp4}
\alias{loglik_htp4}
\alias{lrt_htp4}
\alias{sim_htp4}
\title{Inference and simulation for hidden-truncated Pareto IV}
\description{Maximum likelihood fitting, log-likelihood, likelihood-ratio comparison, and Monte Carlo simulation under the Pareto IV hidden-truncation model.}
\usage{
fit_htp4(x, start = NULL, method = "L-BFGS-B",
          control = list(maxit = 3000), hessian = TRUE,
          delta2_fixed = 3, n_starts = 5)
loglik_htp4(par, x, transformed = FALSE)
lrt_htp4(x, fit = NULL, B = 0, seed = NULL)
sim_htp4(n = c(50, 100, 200), R = 100,
         par = c(alpha = 3, sigma = 2, theta = 1,
                 delta1 = 2, delta2 = 3), seed = NULL)
}
\arguments{
\item{x}{Positive numeric sample.}
\item{start}{Optional positive five-parameter starting vector for optimization.}
\item{method}{Optimization algorithm passed to the fitter.}
\item{control}{List of optimization control parameters.}
\item{hessian}{Logical; whether to compute a numerical Hessian.}
\item{delta2_fixed}{Positive value fixed for the non-identifiable delta2 coordinate.}
\item{n_starts}{Number of optimization starting points.}
\item{par}{Five-parameter model vector; for loglik_htp4, optionally on log scale.}
\item{transformed}{Logical; whether par contains log-transformed parameters.}
\item{fit}{Previously fitted htfit model; if NULL a model is fitted.}
\item{B}{Number of bootstrap replications for the likelihood ratio test.}
\item{seed}{Optional random seed.}
\item{n}{Vector of simulated sample sizes.}
\item{R}{Number of simulation replications.}
}
\value{fit_htp4 returns an htfit object; loglik_htp4 returns a log-likelihood; lrt_htp4 returns a test object; sim_htp4 returns a simulation summary.}
