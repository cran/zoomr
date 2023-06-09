#' Get List of Webinars for a User.
#' 
#' Get list of webinars for a User. This is used to get the webinar Id's to
#' pass into other functions.
#' 
#' @param user_id Zoom User Id.
#' @param account_id Account Id granted by the Zoom developer app.
#' @param client_id Client Id granted by the Zoom developer app.
#' @param client_secret Client secret granted by the Zoom developer app.
#' 
#' @importFrom dplyr "select"
#' @importFrom magrittr "%>%"
#' @importFrom janitor "clean_names"
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#' 
#' @return A data frame with all of the webinars hosted by a specific user.
#' 
#' @seealso See <https://marketplace.zoom.us/docs/api-reference/zoom-api/> for 
#' documentation on the Zoom API.
#' @export
#' @examples
#' \dontrun{
#' dat <- get_webinar_details(user_id = "user_id_string",
#'   your_account_id,
#'   your_client_id,
#'   your_client_secret)
#' }

list_webinars <- function(user_id,
                                account_id,
                                client_id,
                                client_secret)
{
  
  . <- NA # prevent variable binding note for the dot
  
  # Get new access token
  access_token <- get_access_token(account_id, client_id, client_secret)
  
  # Function-specific API stuff
  api_url <- generate_url(query = "listwebinars",
                          user_id = user_id)
  
  # Send GET request to specific survey
  resp <- zoom_api_request(verb = "GET", url = api_url, token = access_token, query_params = list(page_size = 300))
  
  # get into a data frame
  dat<-as.data.frame(jsonlite::fromJSON(httr::content(resp, "text"), flatten = TRUE)) %>%
    janitor::clean_names() %>%
    dplyr::select(-c(
      .data$page_size,
      .data$next_page_token,
      .data$total_records
    )
    )
  
}
