#' Get Webinar Registrants
#' 
#' Get registrant info about a single webinar.
#' 
#' @param webinar_id Zoom Webinar Id, typically an 11 digit number.
#' @param account_id Account Id granted by the Zoom developer app.
#' @param client_id Client Id granted by the Zoom developer app.
#' @param client_secret Client secret granted by the Zoom developer app.
#' @param registrant_status One or more of "approved", "pending", or
#' "denied". Default is "approved" only.
#' 
#' @importFrom magrittr "%>%"
#' @importFrom tidyselect "everything"
#' @import dplyr
#' @importFrom janitor "clean_names"
#' @importFrom purrr "map_dfr"
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#' 
#' @return A data frame with data on all the registrants for a webinar.
#' 
#' @seealso See <https://marketplace.zoom.us/docs/api-reference/zoom-api/> for 
#' documentation on the Zoom API.
#' @export
#' @examples
#' \dontrun{
#' dat <- get_webinar_registrants(webinar_id = "99911112222",
#'   your_account_id,
#'   your_client_id,
#'   your_client_secret,
#'   c("approved", "denied", "pending"))
#' }

get_webinar_registrants <- function(webinar_id,
                                    account_id,
                                    client_id,
                                    client_secret,
                                    registrant_status = 
                                      c("approved")
                                    )
{

  . <- NA # prevent variable binding note for the dot

  # Get new access token
  access_token <- get_access_token(account_id, client_id, client_secret)

  # Function-specific API stuff
  api_url <- generate_url(query = "getwebinarregistrants",
                          webinar_id = webinar_id)

  elements <- list()
  next_token <- ""
  skip <- ""
  status_options <- registrant_status

  get_data_for_each_status <- function(.x){
    while (next_token != "STOP") {
      resp <- zoom_api_request(verb = "GET",
                               url = api_url,
                               token = access_token,
                               query_params = list(page_size = 300,
                                                   next_page_token = next_token,
                                                   status = .x)
      )
      if(jsonlite::fromJSON(httr::content(resp, "text"), flatten = TRUE)$total_records == 0) {
        message(paste0("Webinar Id is found but there are not any registrants",
                       " with status '", .x, "'."))
        next_token <- "STOP"
        skip <- "YES"
      } else {
        resp2 <- jsonlite::fromJSON(httr::content(resp, "text"), flatten = TRUE)
        next_token <- dplyr::if_else(resp2$next_page_token == "", "STOP", resp2$next_page_token)
        elements <- append(elements, httr::content(resp, "text"))
        skip <- "NO"
      }
    }

    if(skip != "YES"){
      list_to_df <- function(.x) {
        df <- as.data.frame(jsonlite::fromJSON(.x, flatten = TRUE)) %>%
          dplyr::mutate(dplyr::across(.cols = tidyselect::everything(), as.character))
      }
      df <- purrr::map_dfr(elements, list_to_df) %>%
        janitor::clean_names() %>%
        dplyr::select(-c(
          .data$registrants_custom_questions,
          .data$page_size,
          .data$next_page_token,
          .data$total_records
        ))
      return(df)
    }
  }

  final_df <- purrr::map_dfr(status_options, get_data_for_each_status)
  return(final_df)

}
