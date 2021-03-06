## 
#' @importFrom jsonlite fromJSON
redmine_request <- function(type = c("GET", "POST", "PUT", "DELETE"), 
    endpoint = "issues.json", query = NULL, simplify = FALSE,
    url = redmine_url(), token = redmine_token(), ...) {
  
  type <- match.arg(type)
  
  endpoint <- gsub("\\.xml$", ".json", endpoint)
  if (!grepl("\\.json$", endpoint))
    endpoint <- paste0(endpoint, ".json")
  
  # if url contains path, do not overwrite it
  if (!is.null(urlPath <- parse_url(url)$path))
    endpoint <- c(urlPath, endpoint)
  
  fullpath <- modify_url(url = url, path = endpoint, query = query)
  
  res <- VERB(type, url = fullpath, add_headers("X-Redmine-API-Key" = token), 
      ...)
  
  if (http_type(res) != "application/json") {
    stop("API did not return JSON", call. = FALSE)
  }
  
  resContent <- content(res, "text")
  # hadle empty response individually
  parsed <- if (nzchar(trimws(resContent))) {
    jsonlite::fromJSON(resContent, simplifyVector = simplify) 
  } else NULL
  
#  stop_for_status(res)
  if (http_error(res)) {
    stop(
        "Redmine API request failed [", status_code(res), "]",
        if (!is.null(parsed$errors)) paste(":\n -", 
              paste(parsed$errors, collapse = "\n - ")),
        call. = FALSE
    )
  }
  
  
  structure(
      list(
          content = parsed,
          url = fullpath,
          response = res
      ), 
      class = "redminer"
  )
  
}

redmine_get <- function(...) {
  redmine_request("GET", ...)
}
redmine_post <- function(...) {
  redmine_request("POST", ...)
}

#' @importFrom utils str
#' @export
print.redminer <- function(x, ...) {
  cat("redmineR API call:", x$url, "\n")
  str(x$content)
  invisible(x)
}
