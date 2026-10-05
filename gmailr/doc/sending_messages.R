## -----------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(gmailr)

## -----------------------------------------------------------------------------
text_msg <- gm_mime() |>
  gm_to("james.f.hester@gmail.com") |>
  gm_from("me@somewhere.com") |>
  gm_text_body("Gmailr is a very handy package!")

## -----------------------------------------------------------------------------
strwrap(as.character(text_msg))

## -----------------------------------------------------------------------------
html_msg <- gm_mime() |>
  gm_to("james.f.hester@gmail.com") |>
  gm_from("me@somewhere.com") |>
  gm_html_body("<b>Gmailr</b> is a <i>very</i> handy package!")

## -----------------------------------------------------------------------------
write.csv(file = "iris.csv", iris)

msg <- html_msg |>
  gm_subject("Here are some flowers") |>
  gm_attach_file("iris.csv")

## -----------------------------------------------------------------------------
msg <- html_msg |>
  gm_attach_part(part = charToRaw("attach me!"), name = "please")

## -----------------------------------------------------------------------------
# First create a plot to send, and save it to mtcars.png
mtcars$gear <- as.factor(mtcars$gear)

png("mtcars.png", width = 400, height = 400, pointsize = 12)
with(
  mtcars,
  plot(hp,
    mpg,
    col = as.factor(gear),
    pch = 19,
    xlab = "Horsepower",
    ylab = "Miles / gallon"
  )
)
legend("topright",
  title = "# gears",
  pch = 19,
  col = seq_along(levels(mtcars$gear)),
  legend = levels(mtcars$gear)
)
dev.off()

# Next create an HTML email that references the plot as 'foobar'
email <- gm_mime() |>
  gm_to("someaddress@somewhere.com") |>
  gm_from("someaddress@somewhere.com") |>
  gm_subject("Cars report") |>
  gm_html_body(
    '<h1>A plot of <b>MotorTrend</b> data <i>(1974)</i></h1>
    <br><img src="cid:foobar">'
  ) |>
  gm_attach_file("mtcars.png", id = "foobar")

## -----------------------------------------------------------------------------
unlink("mtcars.png")

## -----------------------------------------------------------------------------
# gm_create_draft(file_attachment)

## -----------------------------------------------------------------------------
# gm_insert_message(file_attachment)

## -----------------------------------------------------------------------------
# gm_import_message(file_attachment)

## -----------------------------------------------------------------------------
# my_drafts <- gm_drafts()
# 
# gm_send_draft(gm_id(my_drafts, "draft_id")[1])

## -----------------------------------------------------------------------------
# gm_send_message(file_attachment)

## -----------------------------------------------------------------------------
unlink("iris.csv")

