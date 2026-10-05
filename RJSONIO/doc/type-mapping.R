## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(RJSONIO)

## ----json-to-r-table, echo = FALSE--------------------------------------------
data.frame(
  JSON = c("object", "array", "string", "number", "true/false", "null"),
  R = c("named list or simplified named vector",
        "list or simplified vector/matrix",
        "character",
        "numeric",
        "logical",
        "NULL or the value supplied through nullValue"),
  check.names = FALSE
)

## ----json-to-r-examples-------------------------------------------------------
str(fromJSON('{"a": 1, "b": 2}', simplify = FALSE))
str(fromJSON("[1, 2, 3]"))
str(fromJSON('["a", "b", "c"]'))
str(fromJSON("[true, false]"))
str(fromJSON("[1, null, 3]", nullValue = NA, simplify = TRUE))

## ----r-to-json-table, echo = FALSE--------------------------------------------
data.frame(
  R = c("named list", "unnamed list", "atomic vector", "named atomic vector",
        "matrix", "data.frame", "NA", "NULL"),
  JSON = c("object", "array", "array", "object", "nested array",
           "object by column, or array by row", "null", "null"),
  check.names = FALSE
)

## ----r-to-json-examples-------------------------------------------------------
toJSON(list(a = 1, b = TRUE))
toJSON(list(1, TRUE, "x"))
toJSON(c(1, 2, 3))
toJSON(c(a = 1, b = 2))
toJSON(matrix(1:4, nrow = 2))
toJSON(data.frame(a = 1:2, b = c("x", "y")))
toJSON(NA)
toJSON(NULL)

## ----empty-containers---------------------------------------------------------
toJSON(list())
toJSON(emptyNamedList)

fromJSON("[]")
fromJSON("{}")

## ----simplify-constants-------------------------------------------------------
Strict
StrictNumeric
StrictCharacter
StrictLogical

fromJSON('[1, true]', simplify = Strict)
fromJSON('[1, true]', simplify = TRUE)

