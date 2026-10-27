# Model assessment and reproducibility helpers -----------------------------

#' Floyd River annual flood discharge data
#'
#' Returns the 39 annual flood discharge rates used in the application of
#' Ghosh and Balakrishnan (2017). The values are stored in inst/extdata.
#' @export
floyd_river <- function() {
  f <- system.file("extdata", "floyd_river.csv", package="HiddenTrunc")
  if (!nzchar(f)) stop("Floyd River data file not found.")
  utils::read.csv(f)$discharge
}

#' Kolmogorov-Smirnov diagnostic for a fitted HTPIV model
#' @export
gof_htp4 <- function(x, fit=NULL, B=0, seed=NULL) {
  if (is.null(fit)) fit <- fit_htp4(x)
  p <- coef(fit)
  Fhat <- function(q) phtp4(q,p[1],p[2],p[3],p[4],p[5])
  Fn <- stats::ecdf(x)
  xs <- sort(x)
  D <- max(abs(Fn(xs)-Fhat(xs)),
           abs((seq_along(xs)-1)/length(xs)-Fhat(xs)))
  out <- list(statistic=D, bootstrap_p=NA_real_, B=B)
  if (B > 0) {
    if (!is.null(seed)) set.seed(seed)
    ds <- replicate(B, {
      xb <- rhtp4(length(x),p[1],p[2],p[3],p[4],p[5])
      fb <- tryCatch(fit_htp4(xb,start=p), error=function(e) NULL)
      if (is.null(fb)) return(NA_real_)
      pb <- coef(fb); eb <- stats::ecdf(xb); sb <- sort(xb)
      max(abs(eb(sb)-phtp4(sb,pb[1],pb[2],pb[3],pb[4],pb[5])),
          abs((seq_along(sb)-1)/length(sb)-
              phtp4(sb,pb[1],pb[2],pb[3],pb[4],pb[5])))
    })
    out$bootstrap_p <- mean(ds >= D, na.rm=TRUE)
    out$bootstrap_statistics <- ds
  }
  class(out) <- "htgof"
  out
}

#' Parametric bootstrap confidence intervals for HTPIV parameters
#' @export
boot_ci_htp4 <- function(x, fit=NULL, B=499, level=.95, seed=NULL) {
  if (is.null(fit)) fit <- fit_htp4(x)
  if (!is.null(seed)) set.seed(seed)
  p <- coef(fit)
  draws <- replicate(B, {
    xb <- rhtp4(length(x),p[1],p[2],p[3],p[4],p[5])
    fb <- tryCatch(fit_htp4(xb,start=p), error=function(e) NULL)
    if (is.null(fb)) rep(NA_real_,5) else coef(fb)
  })
  alpha <- (1-level)/2
  ci <- t(apply(draws,1,stats::quantile,c(alpha,1-alpha),na.rm=TRUE))
  colnames(ci) <- c("lower","upper")
  data.frame(parameter=names(p),estimate=as.numeric(p),
             lower=ci[,1],upper=ci[,2],row.names=NULL)
}

#' Print method for hidden-truncation GOF objects
#' @export
print.htgof <- function(x, ...) {
  cat("Kolmogorov-Smirnov diagnostic for fitted HTPIV model\n")
  cat("D =", format(x$statistic,digits=6), "\n")
  if (is.finite(x$bootstrap_p))
    cat("Parametric-bootstrap p-value =", format(x$bootstrap_p,digits=6),
        " (B =", x$B, ")\n")
  invisible(x)
}
