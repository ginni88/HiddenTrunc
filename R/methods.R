# S3 methods ---------------------------------------------------------------

#' @export
print.htfit <- function(x,...) {
  cat(x$model,"\n")
  print(x$coefficients)
  cat("logLik:",format(x$logLik,digits=6),
      " convergence:",x$convergence,"\n")
  invisible(x)
}
#' @export
summary.htfit <- function(object,...) {
  se <- if(!is.null(object$vcov)) sqrt(diag(object$vcov)) else rep(NA_real_,object$k)
  tab <- cbind(Estimate=object$coefficients,Std.Error=se)
  out<-list(call=object$call,model=object$model,coefficients=tab,
            logLik=object$logLik,AIC=AIC(object),BIC=BIC(object),
            convergence=object$convergence)
  class(out)<-"summary.htfit"; out
}
print.summary.htfit <- function(x,...) {
  cat(x$model,"\n"); print(x$coefficients)
  cat("logLik =",x$logLik," AIC =",x$AIC," BIC =",x$BIC,"\n")
  invisible(x)
}
#' @export
coef.htfit <- function(object,...) object$coefficients
#' @export
vcov.htfit <- function(object,...) object$vcov
#' @export
logLik.htfit <- function(object,...) structure(object$logLik,df=object$k,nobs=object$n,class="logLik")
#' @export
AIC.htfit <- function(object,...,k=2) -2*object$logLik+k*object$k
#' @export
BIC.htfit <- function(object,...) -2*object$logLik+log(object$n)*object$k
#' @export
plot.htfit <- function(x,which=c("density","cdf","qq"),...) {
  which<-match.arg(which); dat<-sort(x$data); p<-x$coefficients
  if(x$model=="HT Pareto IV") {
    if(which=="density") {
      graphics::hist(dat,probability=TRUE,main="HT Pareto IV fit",xlab="x")
      xx<-seq(min(dat),max(dat),length.out=300)
      graphics::lines(xx,do.call(dhtp4,c(list(x=xx),as.list(p))),lwd=2)
    } else if(which=="cdf") {
      graphics::plot(stats::ecdf(dat),main="Empirical and fitted CDF")
      xx<-seq(min(dat),max(dat),length.out=300)
      graphics::lines(xx,do.call(phtp4,c(list(q=xx),as.list(p))),lwd=2)
    } else {
      qq<-do.call(qhtp4,c(list(p=stats::ppoints(length(dat))),as.list(p)))
      graphics::plot(qq,dat,xlab="Theoretical quantiles",ylab="Sample quantiles")
      graphics::abline(0,1)
    }
  } else stop("Plot method is currently implemented for HT Pareto IV fits.")
  invisible(x)
}
