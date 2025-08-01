% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_webinar_registrants.R
\name{get_webinar_registrants}
\alias{get_webinar_registrants}
\title{Get Webinar Registrants}
\usage{
get_webinar_registrants(
  webinar_id,
  account_id,
  client_id,
  client_secret,
  registrant_status = c("approved")
)
}
\arguments{
\item{webinar_id}{Zoom Webinar Id, typically an 11 digit number.}

\item{account_id}{Account Id granted by the Zoom developer app.}

\item{client_id}{Client Id granted by the Zoom developer app.}

\item{client_secret}{Client secret granted by the Zoom developer app.}

\item{registrant_status}{One or more of "approved", "pending", or
"denied". Default is "approved" only.}
}
\value{
A data frame with data on all the registrants for a webinar.
}
\description{
Get registrant info about a single webinar.
}
\examples{
\dontrun{
dat <- get_webinar_registrants(webinar_id = "99911112222",
  your_account_id,
  your_client_id,
  your_client_secret,
  c("approved", "denied", "pending"))
}
}
\seealso{
See <https://marketplace.zoom.us/docs/api-reference/zoom-api/> for 
documentation on the Zoom API.
}
