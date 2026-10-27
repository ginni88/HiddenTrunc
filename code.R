## Replication script for the HiddenTrunc JSS article
## Run from a clean R session after installing HiddenTrunc >= 0.2.0.
## All manuscript tables/figures are written to ./results.

dir.create("results", showWarnings=FALSE, recursive=TRUE)
library(HiddenTrunc)

## 1. Basic distribution validation
pars <- c(alpha=3,sigma=2,theta=1,delta1=2,delta2=3)
int <- integrate(function(z) dhtp4(z,pars[1],pars[2],pars[3],pars[4],pars[5]),
                 lower=0, upper=Inf)
write.csv(data.frame(integral=int$value, abs.error=int$abs.error),
          "results/density_integral.csv", row.names=FALSE)

pp <- c(.01,.05,.10,.25,.50,.75,.90,.95,.99)
qq <- qhtp4(pp,pars[1],pars[2],pars[3],pars[4],pars[5])
pq <- phtp4(qq,pars[1],pars[2],pars[3],pars[4],pars[5])
write.csv(data.frame(p=pp,q=qq,Fq=pq,error=pq-pp),
          "results/pq_validation.csv",row.names=FALSE)

## 2. Reproducible Monte Carlo study
## Increase R to 1000 for the final submitted run if computationally feasible.
set.seed(2026)
sim <- sim_htp4(n=c(50,100,200,400), R=250, par=pars, seed=2026)
write.csv(sim,"results/simulation_htp4.csv",row.names=FALSE)

pdf("results/simulation_rmse.pdf",width=7,height=5)
mat <- reshape(sim[,c("n","parameter","rmse")],
               idvar="n",timevar="parameter",direction="wide")
matplot(mat$n,mat[,-1],type="b",log="x",xlab="Sample size",
        ylab="RMSE",lty=1,pch=1:ncol(mat[,-1]))
legend("topright",legend=sub("rmse.","",names(mat)[-1]),
       lty=1,pch=1:ncol(mat[,-1]),bty="n")
dev.off()

## 3. Floyd River application
floyd <- floyd_river()
fit.floyd <- fit_htp4(floyd)
capture.output(summary(fit.floyd),file="results/floyd_fit.txt")
write.csv(data.frame(parameter=names(coef(fit.floyd)),
                     estimate=as.numeric(coef(fit.floyd))),
          "results/floyd_estimates.csv",row.names=FALSE)
write.csv(data.frame(logLik=as.numeric(logLik(fit.floyd)),
                     AIC=AIC(fit.floyd),BIC=BIC(fit.floyd)),
          "results/floyd_fit_statistics.csv",row.names=FALSE)

gof <- gof_htp4(floyd,fit.floyd,B=199,seed=2026)
capture.output(print(gof),file="results/floyd_gof.txt")

## Parametric bootstrap intervals: increase B for final publication run.
ci <- boot_ci_htp4(floyd,fit.floyd,B=199,level=.95,seed=2026)
write.csv(ci,"results/floyd_bootstrap_ci.csv",row.names=FALSE)

pdf("results/floyd_cdf.pdf",width=7,height=5)
plot(fit.floyd,which="cdf")
dev.off()
pdf("results/floyd_density.pdf",width=7,height=5)
plot(fit.floyd,which="density")
dev.off()
pdf("results/floyd_qq.pdf",width=7,height=5)
plot(fit.floyd,which="qq")
dev.off()

## 4. Published benchmark values from Ghosh and Balakrishnan (2017)
## These are reference values from Table 3, not recomputed package output.
published <- data.frame(
 parameter=c("alpha","sigma1","theta","delta1","delta2"),
 MLE=c(1.30218,1.7791,0.3213,1.5925,1.07893),
 QM=c(1.3146,1.7684,0.3175,1.6036,1.0809),
 MOM=c(1.3306,1.7695,0.3204,1.5927,1.07653)
)
write.csv(published,"results/published_floyd_benchmark.csv",row.names=FALSE)

## 5. Computational details
capture.output(sessionInfo(),file="results/sessionInfo.txt")
