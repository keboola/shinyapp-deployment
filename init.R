# install packages
install.packages(c('optparse'), repos = 'http://cran.us.r-project.org', dependencies = c("Depends", "Imports", "LinkingTo"), INSTALL_opts = c("--no-html"))

library('devtools')

# install the libraries required for shiny applications
devtools::install_github('cloudyr/aws.signature', ref = "master")
devtools::install_github('rstudio/rsconnect', ref = "master")

devtools::install_github('keboola/sapi-r-client', ref = "master")
devtools::install_github('keboola/provisioning-r-client', ref = "master")
devtools::install_github('keboola/redshift-r-client', ref = "master")
devtools::install_github('keboola/shiny-lib', ref = "master")