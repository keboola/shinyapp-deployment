library(keboola.shinyapp.deployment)
app <- ShinyappDeployment$new(Sys.getenv("KBC_DATADIR"))
# config is read in the above init method # app$readConfig()
write(paste("Recieved Config", jsonlite::toJSON(app$configData)), stderr())

if (app$action == "list") {
    print("begin list")
    res <- app$list()
    # convert the result to json and return it.
    print(paste("return object", jsonlite::toJSON(res, auto_unbox = TRUE)))
    jsonlite::toJSON(res, auto_unbox = TRUE)
} else { 
    # perform default action -- run
    print("begin run")
    if (app$params == "archive") {
        app$archive() 
    } else if (app$params == "deploy") {
        app$deploy()
    }
}
