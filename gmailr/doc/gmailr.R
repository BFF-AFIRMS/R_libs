## -----------------------------------------------------------------------------
can_decrypt <- gargle::secret_has_key("GMAILR_KEY")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  error = TRUE,
  purl = can_decrypt,
  eval = can_decrypt
)

## -----------------------------------------------------------------------------
# message("No token available. Code chunks will not be evaluated.")

## -----------------------------------------------------------------------------
gmailr:::gm_auth_testing()

## -----------------------------------------------------------------------------
library(gmailr)

## -----------------------------------------------------------------------------
# library(gmailr)
# gm_auth_configure("path/to/your/oauth_client.json")
# 
# gm_auth(
#   "target.user@example.com",
#   scopes = "gmail.readonly",
#   cache = "some/nice/directory/"
# )

## -----------------------------------------------------------------------------
gm_profile()

## -----------------------------------------------------------------------------
# test_email <-
#   gm_mime() |>
#   gm_to("PUT_A_VALID_EMAIL_ADDRESS_THAT_YOU_CAN_CHECK_HERE") |>
#   gm_subject("this is just a gmailr test") |>
#   gm_text_body("Can you hear me now?")

## -----------------------------------------------------------------------------
test_email <-
  gm_mime() |>
  gm_to("gargle-testuser@posit.co") |>
  gm_subject("this is just a gmailr test") |>
  gm_text_body("Can you hear me now?")

## -----------------------------------------------------------------------------
tmp <- tempfile("mtcars-", fileext = ".csv")
write.csv(mtcars, tmp)
test_email <- gm_attach_file(test_email, tmp)

## -----------------------------------------------------------------------------
d <- gm_create_draft(test_email)

## -----------------------------------------------------------------------------
gm_send_draft(d)

## -----------------------------------------------------------------------------
# gm_send_message(test_email)

## -----------------------------------------------------------------------------
my_threads <- gm_threads(num_results = 10)

## -----------------------------------------------------------------------------
# retrieve the latest thread by retrieving the first ID
latest_thread <- gm_thread(gm_id(my_threads)[[1]])

## -----------------------------------------------------------------------------
my_msg <- latest_thread$messages[[1]]

gm_date(my_msg)
gm_subject(my_msg)
gm_body(my_msg)

## -----------------------------------------------------------------------------
tmp2 <- tempfile("attachments-")
dir.create(tmp2)
gm_save_attachments(my_msg, path = tmp2)

# let's take a peek
tmp2 |>
  list.files(full.names = TRUE, pattern = "[.]csv$") |>
  read.csv() |>
  head()

## -----------------------------------------------------------------------------
unlink(tmp)
unlink(tmp2, recursive = TRUE)

