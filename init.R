library('devtools')

print("installing via github")

# install the libraries required for shiny applications
devtools::install_github('cloudyr/aws.signature', ref = "master")
devtools::install_github('rstudio/rsconnect', ref = "master")

devtools::install_github('keboola/sapi-r-client', ref = "master")
devtools::install_github('keboola/provisioning-r-client', ref = "master")
devtools::install_github('keboola/redshift-r-client', ref = "master")
devtools::install_github('keboola/shiny-lib', ref = "0.2")
