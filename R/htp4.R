# Hidden-truncated Pareto type IV -------------------------------------------

.htp4_check <- function(alpha, sigma, theta, delta1, delta2) {
  if (any(!is.finite(c(alpha,sigma,theta,delta1,delta2))) ||
      any(c(alpha,sigma,theta,delta1,delta2) <= 0))
    stop("alpha, sigma, theta, delta1 and delta2 must be positive.")
}

.htp4_psi <- function(alpha, theta, delta2) {
  1 - (1 + theta^(1/delta2))^(-alpha)
}

#' Hidden-truncated Pareto IV density
#'
#' Density of X conditional on Y <= c under the bivariate Pareto IV model,
#' using theta = c/sigma2 and zero location parameters.
#' @export
dhtp4 <- function(x, alpha, sigma, theta, delta1, delta2, log = FALSE) {
  .htp4_check(alpha,sigma,theta,delta1,delta2)
  ans <- rep(0, length(x))
  ok <- is.finite(x) & x > 0
  if (any(ok)) {
    z <- (x[ok]/sigma)^(1/delta1)
    psi <- .htp4_psi(alpha,theta,delta2)
    dif <- (1+z)^(-(alpha+1)) -
      (1 + theta^(1/delta2) + z)^(-(alpha+1))
    ans[ok] <- alpha/(sigma*delta1*psi) *
      (x[ok]/sigma)^(1/delta1-1) * dif
  }
  if (log) {
    out <- rep(-Inf,length(ans)); pos <- ans > 0
    out[pos] <- log(ans[pos]); return(out)
  }
  ans
}

#' CDF of the hidden-truncated Pareto IV distribution
#' @export
phtp4 <- function(q, alpha, sigma, theta, delta1, delta2,
                  lower.tail=TRUE, log.p=FALSE) {
  .htp4_check(alpha,sigma,theta,delta1,delta2)
  ans <- rep(0,length(q))
  ok <- is.finite(q) & q > 0
  if(any(ok)) {
    z <- (q[ok]/sigma)^(1/delta1)
    t <- theta^(1/delta2)
    psi <- .htp4_psi(alpha,theta,delta2)
    surv <- ((1+z)^(-alpha) - (1+t+z)^(-alpha))/psi
    ans[ok] <- pmin(1,pmax(0,1-surv))
  }
  ans[is.infinite(q) & q > 0] <- 1
  if(!lower.tail) ans <- 1-ans
  if(log.p) ans <- log(ans)
  ans
}

#' Quantiles of the hidden-truncated Pareto IV distribution
#' @export
qhtp4 <- function(p, alpha, sigma, theta, delta1, delta2,
                  lower.tail=TRUE, log.p=FALSE) {
  .htp4_check(alpha,sigma,theta,delta1,delta2)
  if(log.p) p <- exp(p)
  if(!lower.tail) p <- 1-p
  if(any(p < 0 | p > 1, na.rm=TRUE)) stop("p must be in [0,1].")
  vapply(p, function(pp) {
    if(is.na(pp)) return(NA_real_)
    if(pp==0) return(0)
    if(pp==1) return(Inf)
    f <- function(x) phtp4(x,alpha,sigma,theta,delta1,delta2)-pp
    hi <- sigma
    while(f(hi) < 0 && hi < .Machine$double.xmax/4) hi <- hi*2
    stats::uniroot(f,c(0,hi),tol=1e-10)$root
  }, numeric(1))
}

#' Random generation from hidden-truncated Pareto IV
#' @export
rhtp4 <- function(n, alpha, sigma, theta, delta1, delta2) {
  qhtp4(stats::runif(n),alpha,sigma,theta,delta1,delta2)
}

#' Hazard function
#' @export
hhtp4 <- function(x, alpha, sigma, theta, delta1, delta2) {
  d <- dhtp4(x,alpha,sigma,theta,delta1,delta2)
  s <- phtp4(x,alpha,sigma,theta,delta1,delta2,lower.tail=FALSE)
  d/s
}

#' Log-likelihood for hidden-truncated Pareto IV
#' @export
loglik_htp4 <- function(par, x, transformed=FALSE) {
  if(transformed) par <- exp(par)
  if(length(par)!=5L) stop("par = c(alpha, sigma, theta, delta1, delta2).")
  if(any(par<=0) || any(x<=0) || any(!is.finite(x))) return(-Inf)
  sum(dhtp4(x,par[1],par[2],par[3],par[4],par[5],log=TRUE))
}

.num_hessian <- function(fn, x, eps=1e-4) {
  n <- length(x); H <- matrix(0,n,n); f0 <- fn(x)
  h <- eps * pmax(1,abs(x))
  for(i in seq_len(n)) {
    ei <- rep(0,n); ei[i] <- h[i]
    H[i,i] <- (fn(x+ei)-2*f0+fn(x-ei))/h[i]^2
    if(i<n) for(j in (i+1):n) {
      ej <- rep(0,n); ej[j] <- h[j]
      H[i,j] <- H[j,i] <- (fn(x+ei+ej)-fn(x+ei-ej)-
                           fn(x-ei+ej)+fn(x-ei-ej))/(4*h[i]*h[j])
    }
  }
  H
}

#' Identifiable four-parameter maximum likelihood fit
#'
#' The distribution identifies t = theta^(1/delta2), not theta and delta2
#' separately. delta2 is fixed for compatibility with five-parameter calls.
#' @export
fit_htp4 <- function(x, start=NULL, method="L-BFGS-B",
                     control=list(maxit=3000), hessian=TRUE,
                     delta2_fixed=3, n_starts=5) {
  x <- as.numeric(x)
  if(length(x)<10 || any(!is.finite(x)) || any(x<=0))
    stop("x must contain at least 10 positive finite values")
  if(!is.finite(delta2_fixed) || delta2_fixed<=0)
    stop("delta2_fixed must be positive")
  if(is.null(start)) start <- c(alpha=2,sigma=stats::median(x),
                                theta=1,delta1=1,delta2=delta2_fixed)
  if(length(start)!=5 || any(!is.finite(start)) || any(start<=0))
    stop("start must contain five positive finite entries")
  # Work in the identifiable coordinate t, with log parameters.
  p0 <- c(alpha=start[1],sigma=start[2],t=start[3]^(1/start[5]),delta1=start[4])
  names(p0) <- c("alpha","sigma","t","delta1")
  # Conservative numerical bounds are regularization, not mathematical constraints.
  # They should be varied in sensitivity analyses.
  lower <- log(c(.05, max(min(x)*.001,1e-8), .02, .10))
  upper <- log(c(100, max(x)*100, 100, 20))
  stable_ll <- function(lp) {
    if(any(!is.finite(lp))) return(-1e100)
    z <- exp((log(x)-lp[2])/exp(lp[4]))
    a <- exp(lp[1]); t <- exp(lp[3]); d <- exp(lp[4])
    if(any(!is.finite(z))) return(-1e100)
    # Stable subtraction using log(1-exp(-u))
    log1 <- log1p(z)
    log2 <- log1p(t+z)
    u <- (a+1)*(log2-log1)
    normu <- a*log1p(t)
    if(any(!is.finite(u)) || any(u<=0) || !is.finite(normu) || normu<=0)
      return(-1e100)
    logdif <- -(a+1)*log1 + log(-expm1(-u))
    logpsi <- log(-expm1(-normu))
    val <- sum(log(a)-lp[2]-log(d)-logpsi +
               (1/d-1)*(log(x)-lp[2])+logdif)
    if(is.finite(val)) val else -1e100
  }
  objective <- function(lp) -stable_ll(lp)
  center <- pmin(upper-1e-6,pmax(lower+1e-6,log(p0)))
  starts <- list(center)
  if(n_starts>1) for(i in seq_len(n_starts-1)) {
    shift <- c((i%%3-1)*.6,0, ((i+1)%%3-1)*.8,(i%%2-.5)*.5)
    starts[[length(starts)+1L]] <- pmin(upper-1e-6,pmax(lower+1e-6,center+shift))
  }
  opts <- lapply(starts,function(st) tryCatch(
    stats::optim(st,objective,method="L-BFGS-B",lower=lower,upper=upper,
                 control=control),error=function(e) NULL))
  good <- Filter(function(o) !is.null(o) && is.finite(o$value) && o$value<1e99,opts)
  if(!length(good)) stop("All optimization starts failed")
  opt <- good[[which.min(vapply(good,function(o) o$value,numeric(1)))]]
  est4 <- exp(opt$par); names(est4) <- names(p0)
  est <- c(alpha=est4[1],sigma=est4[2],
           theta=est4[3]^delta2_fixed,delta1=est4[4],delta2=delta2_fixed)
  names(est) <- c("alpha","sigma","theta","delta1","delta2")
  H <- if(hessian) tryCatch(stats::optimHess(opt$par,objective),error=function(e) NULL) else NULL
  V <- NULL
  if(!is.null(H) && all(is.finite(H))) {
    inv <- tryCatch(solve(H),error=function(e) NULL)
    if(!is.null(inv)) {
      J <- diag(est4); J[3,3] <- delta2_fixed*est[3]
      V4 <- J %*% inv %*% J
      V <- matrix(0,5,5,dimnames=list(names(est),names(est)))
      V[1:4,1:4] <- V4
      V[5,] <- NA_real_; V[,5] <- NA_real_
    }
  }
  at_bound <- any(abs(opt$par-lower)<1e-3 | abs(opt$par-upper)<1e-3)
  structure(list(call=match.call(),model="HT Pareto IV",data=x,
                 coefficients=est,logLik=-opt$value,vcov=V,
                 convergence=if(at_bound) 1L else opt$convergence,
                 message=if(at_bound) "Boundary solution: assess sensitivity" else opt$message,
                 optim=opt,n=length(x),k=4L,
                 identifiable=c(alpha=TRUE,sigma=TRUE,theta=TRUE,
                                delta1=TRUE,delta2=FALSE),
                 delta2_fixed=delta2_fixed,t=unname(est4[3])),class="htfit")
}

#' Likelihood-ratio comparison of HT Pareto IV with ordinary Pareto IV
#'
#' The null fit is the limiting non-hidden-truncation Pareto IV density.
#' A bootstrap p-value is recommended because the truncation null is nonstandard.
#' @export
lrt_htp4 <- function(x, fit=NULL, B=0, seed=NULL) {
  if(is.null(fit)) fit <- fit_htp4(x)
  dpareto4 <- function(x,a,s,d) {
    z <- (x/s)^(1/d)
    a/(s*d)*(x/s)^(1/d-1)*(1+z)^(-(a+1))
  }
  obj0 <- function(lp) {
    p <- exp(lp)
    -sum(log(dpareto4(x,p[1],p[2],p[3])))
  }
  o0 <- stats::optim(log(c(2,stats::median(x),1)),obj0,method="Nelder-Mead")
  ll0 <- -o0$value
  stat <- max(0,2*(fit$logLik-ll0))
  out <- list(statistic=stat, logLik_null=ll0, logLik_alt=fit$logLik,
              null_par=exp(o0$par), bootstrap_p=NA_real_)
  if(B>0) {
    if(!is.null(seed)) set.seed(seed)
    p0 <- exp(o0$par)
    rpareto4 <- function(n,a,s,d) s*((1-stats::runif(n))^(-1/a)-1)^d
    bs <- replicate(B,{
      xb <- rpareto4(length(x),p0[1],p0[2],p0[3])
      f1 <- tryCatch(fit_htp4(xb),error=function(e) NULL)
      if(is.null(f1)) return(NA_real_)
      oo <- stats::optim(log(p0), function(lp) {
        pp<-exp(lp); -sum(log(dpareto4(xb,pp[1],pp[2],pp[3])))
      })
      max(0,2*(f1$logLik + oo$value))
    })
    out$bootstrap_p <- mean(bs >= stat,na.rm=TRUE)
    out$bootstrap_statistics <- bs
  }
  class(out) <- "htlrt"; out
}

#' Monte Carlo study for identifiable HT Pareto IV MLE
#' @export
sim_htp4 <- function(n=c(50,100,200), R=100,
                     par=c(alpha=3,sigma=2,theta=1,delta1=2,delta2=3),
                     seed=NULL) {
  if(!is.null(seed)) set.seed(seed)
  ans <- lapply(n,function(nn) {
    est <- replicate(R,{
      x <- rhtp4(nn,par[1],par[2],par[3],par[4],par[5])
      fit <- tryCatch(fit_htp4(x,start=par,delta2_fixed=par[5],
                               hessian=FALSE),error=function(e) NULL)
      if(is.null(fit) || fit$convergence!=0) rep(NA_real_,5)
      else unname(coef(fit))
    })
    if(is.null(dim(est))) est <- matrix(est,nrow=5)
    valid <- is.finite(est[1,])
    m <- if(any(valid)) rowMeans(est[,valid,drop=FALSE]) else rep(NA_real_,5)
    rmse <- if(any(valid)) sqrt(rowMeans((est[,valid,drop=FALSE]-as.numeric(par))^2)) else rep(NA_real_,5)
    m[5] <- NA_real_; rmse[5] <- NA_real_
    data.frame(n=nn,parameter=names(par),true=as.numeric(par),
               mean=m,bias=m-as.numeric(par),rmse=rmse,
               successful=sum(valid),attempted=R)
  })
  do.call(rbind,ans)
}
