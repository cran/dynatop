## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- setup-------------------------------------------------------------------
library(dynatop)
data("Swindale")

## ----data_loaded--------------------------------------------------------------
names(Swindale)

## ----sep----------------------------------------------------------------------
swindale_model <- Swindale$model
swindale_obs <- Swindale$obs

## ----model_parts--------------------------------------------------------------
names(swindale_model)

## ----set_map------------------------------------------------------------------
swindale_model$map$hillslope <- system.file("extdata","Swindale.tif",package="dynatop",mustWork=TRUE)
swindale_model$map$channel <- system.file("extdata","channel.shp",package="dynatop",mustWork=TRUE)
swindale_model$map$channel_id <- system.file("extdata","channel_id.tif",package="dynatop",mustWork=TRUE)

## ---- obs---------------------------------------------------------------------
head(swindale_obs)

## ---- set_obs_names-----------------------------------------------------------
head(swindale_model$precip_input)
head(swindale_model$pet_input)

## ---- change_param------------------------------------------------------------
swindale_model$hillslope$r_sfmax <- Inf
swindale_model$hillslope$m <- 0.0063
swindale_model$hillslope$ln_t0 <- 7.46
swindale_model$hillslope$s_rz0 <- 0.98
swindale_model$hillslope$s_rzmax <- 0.1
swindale_model$hillslope$t_d <- 8*60*60
swindale_model$hillslope$c_sf <- 0.4

swindale_model$channel$v_ch <- 0.8

## ----create_object------------------------------------------------------------
ctch_mdl <- dynatop$new(swindale_model)

## ----add_data-----------------------------------------------------------------
ctch_mdl$add_data(swindale_obs)

## ----initialise---------------------------------------------------------------
ctch_mdl$initialise()$plot_state("s_sz")

## ----sim1---------------------------------------------------------------------
sim1 <- ctch_mdl$sim()$get_gauge_flow()

## ----new_states---------------------------------------------------------------
ctch_mdl$plot_state("s_sz")

## ----sim2---------------------------------------------------------------------
sim2 <- ctch_mdl$sim()$get_gauge_flow()
out <- merge( merge(swindale_obs,sim1),sim2)
names(out) <- c(names(swindale_obs),'sim_1','sim_2')
plot(out[,c('Flow','sim_1','sim_2')], main="Discharge",ylab="m3/s",legend.loc="topright")

## ----mass_check---------------------------------------------------------------
mb <- ctch_mdl$get_mass_errors()
plot( mb[,6] , main="Mass Error", ylab="[m^3]")

