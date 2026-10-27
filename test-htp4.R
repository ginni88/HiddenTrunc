test_that("HTPIV density integrates to one", {
  z <- integrate(function(x) dhtp4(x,3,2,1,2,3),0,Inf)$value
  expect_equal(z,1,tolerance=1e-5)
})
test_that("HTPIV quantile inverts CDF", {
  p <- c(.1,.5,.9)
  q <- qhtp4(p,3,2,1,2,3)
  expect_equal(phtp4(q,3,2,1,2,3),p,tolerance=1e-6)
})
