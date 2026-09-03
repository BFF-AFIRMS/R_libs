## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(RJSONIO)

## ----parse-basic--------------------------------------------------------------
fromJSON('{"name": "RJSONIO", "active": true, "values": [1, 2, 3]}')

## ----parse-file---------------------------------------------------------------
path <- system.file("sampleData", "keys.json", package = "RJSONIO")
names(fromJSON(path))

## ----write-basic--------------------------------------------------------------
value <- list(
  id = 1,
  name = "RJSONIO",
  values = c(1, 2, 3),
  active = TRUE
)

json <- toJSON(value, pretty = TRUE)
cat(json)

## ----roundtrip-basic----------------------------------------------------------
fromJSON(json)

## ----validate-basic-----------------------------------------------------------
candidate <- toJSON(list(name = "RJSONIO", version = "2.0.3"))
isValidJSON(I(candidate))
isValidJSON(I("{not valid json}"))

## ----roundtrip----------------------------------------------------------------
value <- list(a = 1, b = c(TRUE, FALSE), c = c("x", "y"))
parsed <- fromJSON(toJSON(value))

identical(parsed, value)
parsed

