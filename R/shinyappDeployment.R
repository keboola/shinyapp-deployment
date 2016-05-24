# Shinyapps.io client
# Basic API actions:
#   list - returns a list of deployed KBC applications
#   run - (default) Asynchronous.  May perform either of the following according to the --command option
#   deploy - deploys the application as per request configuration
#   archive - archives application as per request configuration

#' @import methods
#' @import keboola.r.docker.application
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
            shinyapps::setAccountInfo(
                name=.self$params$account, 
                token=.self$params$token, 
                secret=.self$params$secret
            )
        },
        
        run = function(args) {
            if (args$command == "deploy") {
                # install packages
                if (args$cranPackages) {
                    .self$installPackages(args$cranPackages,"CRAN")
                }
                if (args$githubPackages) {
                    .self$installPackages(args$githubPackages, "github")
                }
                .self$deploy(args$appName)
            } else if (args$command == "archive") {
                .self$archive(args$appName)
            }
        },
        
        list = function() {
            apps <- shinyapps::applications()
            jsonlite::toJSON(apps)
        },
        
        deploy = function(name) {
            tryCatch({
                shinyapps::deployApp(appDir="/home/app", appName=name)        
            }, error = function(e) {
                write(paste("Error deploying application:", e),stderr())
                stop(e)
            })
        }, 
        
        archive = function(args) {
            tryCatch({
                shinyapps::archiveApp(appName)
            }, error = function(e) {
                write(paste("Error archiving application", e), stderr())
            })
        },
        
        installPackages = function(packages, source = "CRAN") {
            # we need to install any github packages that we've been told to.
            packageList <- .self$trim(unlist(strsplit(packages,",")))
            print(packageList)
            lapply(githubPackages, function(x){
                print(paste("Installing package",x,"from", source))
                if (source == "github") {
                    devtools::install_github(x, quiet = TRUE)    
                } else {
                    install.packages(x, verbose=FALSE, quiet=TRUE)   
                }
            })
        },
        
        trim = function(x) {
            gsub("^\\s+|\\s+$", "", x)
        }
    )
)
