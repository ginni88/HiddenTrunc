test_that("Floyd River data are available", {
  x <- floyd_river()
  expect_length(x,39)
  expect_true(all(x > 0))
  expect_equal(max(x),71500)
})
test_that("HTPIV CDF has correct boundaries", {
  expect_equal(phtp4(0,3,2,1,2,3),0)
  expect_equal(phtp4(Inf,3,2,1,2,3),1)
})
