# Two-sided hidden-truncated Arnold-Strauss bivariate exponential -----------

.htb_check <- function(a,b,c,d1,d2) {
  if(any(!is.finite(c(a,b,c,d1,d2))) || a<=0 || b<=0 || c<=0 ||
     d1<0 || d2<=d1) stop("Require a,b,c>0 and 0 <= d1 < d2.")
}

.htb_M <- function(a,b,c,d1,d2) {
  stats::integrate(function(y) exp(-b*y)/(a+c*y),
                   lower=d1,upper=d2,rel.tol=1e-9)$value
}

#' Density of two-sided hidden-truncated bivariate exponential model
#' @export
dhtbexp <- function(x,a,b,c,d1,d2,log=FALSE) {
  .htb_check(a,b,c,d1,d2)
  ans <- rep(0,length(x)); ok <- is.finite(x) & x>0
  M <- .htb_M(a,b,c,d1,d2)
  if(any(ok)) {
    bx <- b+c*x[ok]
    num <- exp(-a*x[ok])*(exp(-bx*d1)-exp(-bx*d2))
    ans[ok] <- num/(bx*M)
  }
  if(log) { z<-rep(-Inf,length(ans)); z[ans>0]<-log(ans[ans>0]); return(z) }
  ans
}

#' CDF of two-sided hidden-truncated bivariate exponential model
#' @export
phtbexp <- function(q,a,b,c,d1,d2,lower.tail=TRUE,log.p=FALSE) {
  .htb_check(a,b,c,d1,d2)
  M <- .htb_M(a,b,c,d1,d2)
  one <- function(z) {
    if(z<=0) return(0)
    if(is.infinite(z)) return(1)
    stats::integrate(function(x) dhtbexp(x,a,b,c,d1,d2),
                     0,z,rel.tol=1e-8)$value
  }
  ans <- vapply(q,one,numeric(1))
  ans <- pmin(1,pmax(0,ans))
  if(!lower.tail) ans <- 1-ans
  if(log.p) ans <- log(ans)
  ans
}

#' Quantiles of two-sided hidden-truncated bivariate exponential model
#' @export
qhtbexp <- function(p,a,b,c,d1,d2) {
  if(any(p<0|p>1,na.rm=TRUE)) stop("p must be in [0,1].")
  vapply(p,function(pp) {
    if(pp==0) return(0); if(pp==1) return(Inf)
    hi <- 1/a
    f <- function(z) phtbexp(z,a,b,c,d1,d2)-pp
    while(f(hi)<0) hi <- hi*2
    stats::uniroot(f,c(0,hi),tol=1e-9)$root
  },numeric(1))
}

#' Random generation from two-sided HT bivariate exponential model
#' @export
rhtbexp <- function(n,a,b,c,d1,d2) qhtbexp(stats::runif(n),a,b,c,d1,d2)

#' Log-likelihood for two-sided HT bivariate exponential model
#' @export
loglik_htbexp <- function(par,x,transformed=FALSE) {
  if(transformed) {
    a<-exp(par[1]); b<-exp(par[2]); cc<-exp(par[3])
    d1<-exp(par[4]); d2<-d1+exp(par[5])
  } else { a<-par[1];b<-par[2];cc<-par[3];d1<-par[4];d2<-par[5] }
  if(any(x<=0)) return(-Inf)
  sum(dhtbexp(x,a,b,cc,d1,d2,log=TRUE))
}

#' MLE for two-sided hidden-truncated bivariate exponential model
#' @export
fit_htbexp <- function(x,start=NULL,control=list(maxit=5000)) {
  x<-as.numeric(x)
  if(any(x<=0|!is.finite(x))) stop("x must be positive finite.")
  if(is.null(start)) start<-c(a=1/mean(x),b=1,c=0.2,d1=0.1,d2=1)
  lp0 <- c(log(start[1:4]),log(start[5]-start[4]))
  obj <- function(lp) -loglik_htbexp(lp,x,TRUE)
  o <- stats::optim(lp0,obj,method="Nelder-Mead",control=control)
  a<-exp(o$par[1]);b<-exp(o$par[2]);cc<-exp(o$par[3])
  d1<-exp(o$par[4]);d2<-d1+exp(o$par[5])
  est<-c(a=a,b=b,c=cc,d1=d1,d2=d2)
  H <- .num_hessian(obj,o$par)
  V <- tryCatch(solve(H),error=function(e) NULL)
  structure(list(call=match.call(),model="Two-sided HT Arnold-Strauss exponential",
                 data=x,coefficients=est,logLik=-o$value,vcov_transformed=V,
                 vcov=NULL,convergence=o$convergence,message=o$message,
                 optim=o,n=length(x),k=5L),class="htfit")
}

#' Bayesian inference for two-sided HT bivariate exponential model
#'
#' Random-walk Metropolis sampler on an unconstrained parameterization.
#' Gamma(shape, rate) priors are used for a,b,c. The d1 prior is proportional
#' to (1+d1)^-2 and d2|d1 is uniform on (d1, delta).
#' @export
bayes_htbexp <- function(x, niter=10000, burn=2000, thin=5,
                         init=c(a=1,b=1,c=.2,d1=.1,d2=1),
                         gamma_shape=c(1,1,1), gamma_rate=c(1,1,1),
                         delta=max(10,init[5]*2), proposal_sd=rep(.12,5),
                         seed=NULL) {
  if(!is.null(seed)) set.seed(seed)
  if(delta<=init[5]) stop("delta must exceed initial d2.")
  to_z <- function(p) c(log(p[1:3]), qlogis(p[4]/delta),
                         qlogis((p[5]-p[4])/(delta-p[4])))
  from_z <- function(z) {
    abc<-exp(z[1:3]); d1<-delta*plogis(z[4])
    d2<-d1+(delta-d1)*plogis(z[5])
    c(a=abc[1],b=abc[2],c=abc[3],d1=d1,d2=d2)
  }
  logpost_z <- function(z) {
    p<-from_z(z)
    ll<-loglik_htbexp(p,x)
    if(!is.finite(ll)) return(-Inf)
    lp<-sum(stats::dgamma(p[1:3],gamma_shape,gamma_rate,log=TRUE)) -
        2*log1p(p[4]) - log(delta-p[4])
    # Jacobian of z -> (a,b,c,d1,d2)
    s4<-plogis(z[4]); s5<-plogis(z[5])
    jac<-sum(z[1:3]) + log(delta*s4*(1-s4)) +
         log((delta-p[4])*s5*(1-s5))
    ll+lp+jac
  }
  z<-to_z(init); cur<-logpost_z(z)
  keep<-matrix(NA_real_,niter,5); acc<-logical(niter)
  for(i in seq_len(niter)) {
    zp<-z+stats::rnorm(5,0,proposal_sd); pr<-logpost_z(zp)
    if(log(stats::runif(1)) < pr-cur) {z<-zp;cur<-pr;acc[i]<-TRUE}
    keep[i,]<-from_z(z)
  }
  idx<-seq.int(burn+1,niter,by=thin)
  draws<-keep[idx,,drop=FALSE]; colnames(draws)<-names(init)
  structure(list(draws=draws, posterior_mean=colMeans(draws),
                 posterior_sd=apply(draws,2,stats::sd),
                 credible_interval=apply(draws,2,stats::quantile,c(.025,.975)),
                 acceptance=mean(acc), call=match.call()),
            class="htbayes")
}
