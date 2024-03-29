test_that("Dynatop mass errors for exponential profile are <1e-6", {
    data(Swindale)
    dt <- dynatop$new(Swindale$model)$add_data(Swindale$obs)
    dt$initialise()$sim_hillslope()
    tmp <- max(abs(dt$get_mass_errors()[,6]))
    testthat::expect_lt( tmp, 1e-6 )
})

test_that("Dynatop mass errors are correctly computed for substeps and less then <1e-6", {
    data(Swindale)
    dt <- dynatop$new(Swindale$model)$add_data(Swindale$obs)
    dt$initialise()$sim_hillslope(sub_step=300)
    tmp <- max(abs(dt$get_mass_errors()[,6]))
    testthat::expect_lt( tmp, 1e-6 )
})

## currently this is to slow for CRAN - run manually it passes
## test_that("Dynatop mass errors for constant profile are <1e-6", {
##     data(Swindale)
##     mdl <- Swindale$model
##     mdl$hillslope$opt <- "cnst"
##     mdl$hillslope$c_sz<- 0.5; mdl$hillslope$D <- 5
##     dt <- dynatop$new(mdl)$add_data(Swindale$obs)
##     dt$initialise()$sim_hillslope()
##     tmp <- max(abs(dt$get_mass_errors()[,6]))
##     testthat::expect_lt( tmp, 1e-6 )
## })

test_that("Dynatop mass errors for bounded exponential profile are <1e-6", {
    data(Swindale)
    mdl <- Swindale$model
    mdl$hillslope$opt <- "bexp"
    mdl$hillslope$D <- 5
    dt <- dynatop$new(mdl)$add_data(Swindale$obs)
    dt$initialise()$sim_hillslope()
    tmp <- max(abs(dt$get_mass_errors()[,6]))
    testthat::expect_lt( tmp, 1e-6 )
})

test_that("Dynatop mass errors for double exponential are <1e-6", {
    data(Swindale)
    mdl <- Swindale$model
    mdl$hillslope$opt <- "dexp"
    mdl$hillslope$m <- 0.5; mdl$hillslope$m_2 <- 0.01; mdl$hillslope$omega <- 0.5
    dt <- dynatop$new(mdl)$add_data(Swindale$obs)
    dt$initialise()$sim_hillslope()
    tmp <- max(abs(dt$get_mass_errors()[,6]))
    testthat::expect_lt( tmp, 1e-6 )
})

test_that("Dynatop mass errors with RAF are <1e-6", {
    data(Swindale)
    mdl <- Swindale$model
    mdl$hillslope$s_raf <- 0.1
    mdl$hillslope$t_raf <- 10*60*60
    dt <- dynatop$new(mdl)$add_data(Swindale$obs)#[1:2,,drop=FALSE])
    dt$initialise()$sim_hillslope()
    tmp <- max(abs(dt$get_mass_errors()[,6]))
    testthat::expect_lt( tmp, 1e-6 )
})
