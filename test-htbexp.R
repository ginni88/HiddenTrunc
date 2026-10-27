test_that("HTBEXP density integrates to one", {
  z <- integrate(function(x) dhtbexp(x,1,1.2,.25,.2,1.5),0,Inf)$value
  expect_equal(z,1,tolerance=1e-5)
})
