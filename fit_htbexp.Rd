\name{fit_htbexp}
\alias{fit_htbexp}
\alias{loglik_htbexp}
\alias{bayes_htbexp}
\title{Inference for hidden-truncated exponential distribution}
\description{Maximum likelihood estimation, likelihood evaluation, and Bayesian sampling for the two-sided hidden-truncated exponential model.}
\usage{
fit_htbexp(x, start = NULL, control = list(maxit = 5000))
loglik_htbexp(par, x, transformed = FALSE)
bayes_htbexp(x, niter = 10000, burn = 2000, thin = 5,
             init = c(a = 1, b = 1, c = 0.2, d1 = 0.1, d2 = 1),
             gamma_shape = c(1, 1, 1),
             gamma_rate = c(1, 1, 1),
             delta = max(10, init[5] * 2),
             proposal_sd = rep(0.12, 5), seed = NULL)
}
\arguments{
\item{x}{Positive numeric observations.}
\item{start}{Optional five-parameter starting vector for MLE.}
\item{control}{Optimization control list.}
\item{par}{Parameter vector for the log-likelihood.}
\item{transformed}{Logical; use transformed optimization coordinates when TRUE.}
\item{niter}{Total number of MCMC iterations.}
\item{burn}{Number of initial draws to discard.}
\item{thin}{Thinning interval.}
\item{init}{Initial positive five-parameter MCMC state with ordered truncation bounds.}
\item{gamma_shape}{Shape hyperparameters for three Gamma priors.}
\item{gamma_rate}{Rate hyperparameters for three Gamma priors.}
\item{delta}{Upper MCMC truncation bound, exceeding the initial d2.}
\item{proposal_sd}{Standard deviations for five Gaussian random-walk proposals.}
\item{seed}{Optional random seed.}
}
\value{A fitted-model object, numeric log-likelihood, or a list containing posterior draws and diagnostics.}
