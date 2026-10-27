# Generic hidden-truncation utilities --------------------------------------

#' Construct a hidden-truncation density
#'
#' Implements f_X(x) P(Y in M | X=x) / P(Y in M).
#' @export
ht_density <- function(x, fx, selection_prob, normalizer, log=FALSE, ...) {
  z <- fx(x,...)*selection_prob(x,...)/normalizer
  if(log) log(z) else z
}

#' Generic hidden-truncation density alias
#' @export
dhidden <- function(x, fx, selection_prob, normalizer, ...)
  ht_density(x,fx,selection_prob,normalizer,...)

#' Generic hidden-truncation CDF by numerical integration
#' @export
phidden <- function(q, fx, selection_prob, normalizer,
                    lower=0, ...) {
  vapply(q,function(z) stats::integrate(function(xx)
    ht_density(xx,fx,selection_prob,normalizer,...),
    lower,z)$value,numeric(1))
}

#' Generic hidden-truncation random generator by inverse CDF
#' @export
rhidden <- function(n, fx, selection_prob, normalizer,
                    lower=0, upper_start=1, ...) {
  u<-stats::runif(n)
  F<-function(z) phidden(z,fx,selection_prob,normalizer,lower,...)
  vapply(u,function(p) {
    hi<-upper_start
    while(F(hi)<p) hi<-2*hi
    stats::uniroot(function(z) F(z)-p,c(lower,hi))$root
  },numeric(1))
}

#' Generic hidden-truncation log likelihood
#' @export
ht_loglik <- function(par,x,density,...) sum(log(density(x,par,...)))

#' Generic maximum likelihood optimizer
#' @export
ht_mle <- function(par,x,loglik,transform=exp,...) {
  o<-stats::optim(log(par),function(z)-loglik(transform(z),x,...),
                  method="Nelder-Mead")
  list(coefficients=transform(o$par),logLik=-o$value,optim=o)
}
