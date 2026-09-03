## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(RJSONIO)

## ----parse-text---------------------------------------------------------------
fromJSON("[1, 3, 10, 19]")

fromJSON('{"a": 1, "b": true, "c": "value"}')

## ----parse-as-is--------------------------------------------------------------
fromJSON(I("[3.1415]"))

## ----parse-file---------------------------------------------------------------
path <- system.file("sampleData", "keys.json", package = "RJSONIO")
parsed <- fromJSON(path)

names(parsed)
names(parsed$menu)

## ----parse-connection---------------------------------------------------------
con <- textConnection(c("[[1, 2, 3, 4],", "[5, 6, 7, 8]]"))
parsed <- fromJSON(con)
close(con)

parsed

## ----parse-null---------------------------------------------------------------
fromJSON("[1, null, 4]", simplify = FALSE)
fromJSON("[1, null, 4]", simplify = TRUE, nullValue = -999)

## ----parse-simplify-----------------------------------------------------------
fromJSON('[1, "2.3", "abc"]', simplify = Strict)
fromJSON('[1, "2.3", "abc"]', simplify = TRUE)
fromJSON('{"a": 1, "b": 2}', simplify = Strict)
fromJSON('{"a": 1, "b": 2}', simplify = FALSE)

## ----sample-data--------------------------------------------------------------
sample_dir <- system.file("sampleData", package = "RJSONIO")
head(list.files(sample_dir, pattern = "[.]json$"))

widget <- fromJSON(file.path(sample_dir, "widget.json"))
names(widget)

