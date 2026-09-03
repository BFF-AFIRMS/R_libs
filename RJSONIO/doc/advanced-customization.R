## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(RJSONIO)

## ----basic-handler------------------------------------------------------------
handler <- basicJSONHandler()
fromJSON("[1, 3, 10, 19]", handler$update)

handler$value()

## ----callback-handler---------------------------------------------------------
events <- character()

fromJSON('{"a": 1, "b": "x"}', function(type, value) {
  events <<- c(events, names(type))
  TRUE
})

unique(events)

## ----string-fun---------------------------------------------------------------
fromJSON('[1, "abc", "xyz"]',
         stringFun = function(value) sprintf("parsed_%s", value))

fromJSON('["1", "2.3", "3.1415"]',
         stringFun = function(value) as.numeric(value))

## ----as-js-vars---------------------------------------------------------------
js <- asJSVars(a = 1:3, b = "x")
cat(js)

## ----as-js-vars-types---------------------------------------------------------
cat(asJSVars(.vars = list(count = 3L, label = "x"), types = TRUE))

## ----s4-----------------------------------------------------------------------
setClass("RJSONIOVignetteClass",
         representation(id = "integer", label = "character"))

object <- new("RJSONIOVignetteClass", id = 1L, label = "example")
cat(toJSON(object))

## ----custom-method------------------------------------------------------------
setClass("RJSONIOPoint", representation(x = "numeric", y = "numeric"))

setMethod("toJSON", "RJSONIOPoint",
          function(x, container = TRUE, collapse = "\n", ...,
                   .level = 1L, .withNames = TRUE, .na = "null",
                   .escapeEscapes = TRUE, pretty = FALSE, asIs = NA,
                   .inf = " Infinity") {
            toJSON(list(x = x@x, y = x@y),
                   container = container, collapse = collapse, ...,
                   .level = .level, .withNames = .withNames, .na = .na,
                   .escapeEscapes = .escapeEscapes, pretty = pretty,
                   asIs = asIs, .inf = .inf)
          })

point <- new("RJSONIOPoint", x = 1, y = 2)
fromJSON(toJSON(point))

