redmine_create_version <- function(project_id, name, description = NULL, status = "open" , ...) {

  #  fileTokens <- sapply(files, redmine_upload)
  #  stopifnot(length(fileTokens) == length(files))

  versionList <- list(
    #project_id = project_id,
    name = name,
    description = description,
    status = status
  )

  # remove NULL elements
  versionList <- removeNULL(versionList)

  # add extra arguments
  versionList <- modifyList(versionList, list(...))

  # create issue
  body <- list(version = versionList)

  issueRes <- redmine_post(paste0("/projects/",project_id,"/versions.json"), body = body, encode = "json")

  issueRes$content$version$id
}

redmine_list_versions = function (project_id) {
  redmine_get(paste0("/projects/",project_id,"/versions"), query = NULL)
}


#' Show versiont information
#' 
#' @param version_id Version id 
#' @return a \code{redminer} object with version information
#' @author Felipe Dias
#' @seealso \code{\link{redmine_search_id}} to search for id by subject
#' @examples \dontrun{
#' }
#' @export
redmine_show_version = function (version_id) {
  endpoint = paste0("versions/", version_id, ".json")
  redmine_get(endpoint = endpoint)
}