cat("Suppose you have a clean r environment : \n",
    " - non loaded package \n",
    " - non user defined r objects")

# Set up ------------------------------------------------------------------

  library("rstan") # pay attention to the startup messages

# Load previous simulations -----------------------------------------------
  # source("functions/open.folders.R")
  # f.open.stan_fit()
  
  tmp.stanfile.name = "8schools"

  # list all files in ./stan_fit/ folder whose name contains "8schools"
  list.files("stan_fit", pattern = tmp.stanfile.name)

  # read out the different time-stamp
  source("functions/stanFit_Name.R")
  f.stanFit.filter.timestamp(pattern = tmp.stanfile.name
                             ,newest.first = F
                             # ,as.num = F
                             )

  # Let's choose "1907182101" the most recent one in the example.zip
  intersect(list.files("stan_fit", pattern = tmp.stanfile.name),
            list.files("stan_fit", pattern = "1907182101"))
  # In this (the original) example , we have here two files : 
      # the backup of stan code *.stan
      # the result of stan simulation *.rds
  
  fit_8schools = 
    readRDS(paste0("stan_fit/",
                   "8schools-timestamp_1907182101-Chain_3-iter_2000-seed_1907182101.rds"))

# Analysis of posterior ---------------------------------------------------
  # It's your turn 
  # You are free to play with it
  # Here are some suggestions
  
  # Shinystan
  shinystan::launch_shinystan(fit_8schools)
  
  # default hmc diagnostic
  check_hmc_diagnostics(fit_8schools)
  
  # Trance plot
    # read out the name of different parameters
    names(fit_8schools)
  
    tmp.pars.name = c("theta[1]",
                      "theta[2]",
                      "theta[3]",
                      "theta[4]",
                      "theta[5]",
                      "theta[6]",
                      "theta[7]",
                      "theta[8]")
    stan_trace(fit_8schools,
               pars = tmp.pars.name)  

