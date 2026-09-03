## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(RJSONIO)

## ----atomic-vectors-----------------------------------------------------------
toJSON(c(1, 2, 3))
toJSON(c(TRUE, FALSE))
toJSON(c("abc", "xyz"))

## ----named-vectors------------------------------------------------------------
toJSON(c(a = 1, b = 2))
fromJSON(toJSON(c(a = 1, b = 2)))

## ----lists--------------------------------------------------------------------
value <- list(
  name = "example",
  flags = c(TRUE, FALSE),
  nested = list(x = 1, y = "two")
)

cat(toJSON(value, pretty = TRUE))

## ----data-frames--------------------------------------------------------------
data <- data.frame(id = 1:2, label = c("a", "b"))

cat(toJSON(data, pretty = TRUE))
cat(toJSON(data, byrow = TRUE, colNames = TRUE, pretty = TRUE))

## ----matrices-arrays----------------------------------------------------------
mat <- matrix(1:4, nrow = 2)
cat(toJSON(mat))

arr <- array(1:8, dim = c(2, 2, 2))
isValidJSON(I(toJSON(arr)))

## ----missing-empty------------------------------------------------------------
toJSON(c("a", NA, "b"))
fromJSON(toJSON(c("a", NA, "b")), nullValue = NA, simplify = TRUE)

toJSON(list())
toJSON(emptyNamedList)

## ----digits-------------------------------------------------------------------
toJSON(c(pi, exp(1)), digits = 4)
toJSON(c(pi, exp(1)), digits = 8)

