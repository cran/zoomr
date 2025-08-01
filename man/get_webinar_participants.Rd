% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_webinar_participants.R
\name{get_webinar_participants}
\alias{get_webinar_participants}
\title{Get Webinar Participants}
\usage{
get_webinar_participants(webinar_id, account_id, client_id, client_secret)
}
\arguments{
\item{webinar_id}{Zoom Webinar Id, typically an 11 digit number.}

\item{account_id}{Account Id granted by the Zoom developer app.}

\item{client_id}{Client Id granted by the Zoom developer app.}

\item{client_secret}{Client secret granted by the Zoom developer app.}
}
\value{
A data frame with data on each participant at a webinar.
}
\description{
Get participant info about a single webinar.
}
\examples{
\dontrun{
dat <- get_webinar_participants(webinar_id = "99911112222",
  your_account_id,
  your_client_id,
  your_client_secret)
}
}
\seealso{
See <https://marketplace.zoom.us/docs/api-reference/zoom-api/> for 
documentation on the Zoom API.
}
