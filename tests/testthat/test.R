# source data are prepared in tests directory

test_that("deploy", {
    
    app <- ShinyappDeplooyment$new(KBC_DATADIR)
    
    app$deploy()
    
    # TODO: verify the results
    
})

test_that("archive", {
    
    app <- ShinyappDeplooyment$new(KBC_DATADIR)
    
    app$archive()
    
    # TODO: verify the results
    
})

test_that("list", {
    
    app <- ShinyappDeplooyment$new(KBC_DATADIR)
    
    res <- app$list()
    
    # TODO: verify the results
    
})