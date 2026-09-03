## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(RJSONIO)

## ----file-path----------------------------------------------------------------
path <- system.file("sampleData", "keys.json", package = "RJSONIO")
parsed <- fromJSON(path)

names(parsed)

## ----text-connection----------------------------------------------------------
con <- textConnection("[1, 2, 3,\n4]")
parsed <- fromJSON(con)
close(con)

parsed

## ----file-connection----------------------------------------------------------
path <- system.file("sampleData", "usaPolygons.as", package = "RJSONIO")
con <- file(path)
parsed <- fromJSON(con)
close(con)

length(parsed)

## ----parser-callback----------------------------------------------------------
events <- character()

result <- fromJSON(path, function(type, value) {
  events <<- c(events, names(type))
  TRUE
})

result
head(events)

## ----read-json-stream---------------------------------------------------------
tmp <- tempfile(fileext = ".json")
writeLines("[1, 2, 3]", tmp, useBytes = TRUE)

con <- file(tmp, open = "rb")
streamed <- readJSONStream(con)
close(con)
unlink(tmp)

streamed

