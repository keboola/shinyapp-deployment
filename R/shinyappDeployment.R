# Shinyapps.io client
# Basic API actions:
#   list - returns a list of deployed KBC applications
#   run - (default) Asynchronous.  May perform either of the following according to the --command option
#   deploy - deploys the application as per request configuration
#   archive - archives application as per request configuration

#' @import methods
#' @import keboola.r.docker.application
#' @import rsconnect
#' @export ShinyappDeployment
#' @exportClass ShinyappDeployment
ShinyappDeployment <- setRefClass(
    'CustomApplicationExample',
    contains = c("DockerApplication"),
    fields = list(
        action = 'character',
        params = 'list'
    ),
    methods = list(
        init = function(args) {
            callSuper(args)
            .self$readConfig(args)
            action <<- .self$getAction()
            params <<- .self$getParameters()
            # initialize shinyapps stuff here...
            # call into shinyapps with keboola account credentials
            rsconnect::setAccountInfo(
                name=.self$params$account, 
                token=.self$params$token, 
                secret=.self$params$secret
            )
        },
        
        run = function() {
            if (.self$params$command == "deploy") {
                # install packages
                if (length(.self$params$cranPackages) > 0) {
                    .self$installPackages(.self$params$cranPackages,"CRAN")
                }
                if (length(.self$params$githubPackages) > 0) {
                    .self$installPackages(.self$params$githubPackages, "github")
                }
                .self$deploy(.self$params$appName)
            } else if (.self$params$command == "archive") {
                .self$archive(.self$params$appName)
            }
        },
        
        list = function() {
            rsconnect::deployments()
        },
    
        deploy = function() {
            tryCatch({
                rsconnect::deployApp(appDir="/home/app", appName=.self$params$appName)        
            }, error = function(e) {
                write(paste("Error deploying application:", e),stderr())
                stop(paste("shinyapp.deployment deploy error:", e))
            })
        }, 
        
        archive = function() {
            tryCatch({
                rsconnect::terminateApp(.self$params$appName)
            }, error = function(e) {
                write(paste("Error archiving application", e), stderr())
                stop(paste("shinyapp.deployment archive error:", e))
            })
        },
        
        installPackages = function(packages, source = "CRAN") {
            # we need to install any github packages that we've been told to.
            packageList <- .self$trim(unlist(strsplit(packages,",")))
            
            lapply(packages, function(x){
                print(paste("Installing package",x,"from", source))
                if (source == "github") {
                    devtools::install_github(x, quiet = TRUE)    
                } else if (source == "CRAN") {
                    install.packages(x, verbose=FALSE, quiet=TRUE)   
                } else {
                    stop(paste("Sorry, I don't know how to install R packages from", source));
                }
            })
        },
        
        trim = function(x) {
            gsub("^\\s+|\\s+$", "", x)
        }
    )
)
