cat("Go through this rscript \n",
    " - read carefully the comments in order to understand what you are doing \n",
    " - pay special attention to the stan_fit folder when you are asked to\n",
    "      - if you are using MacOS, f.open.stan_fit() opens the ./stan_fit/ folder for you\n")

source("functions/open.folders.R")
f.open.wd()
f.open.stan_fit()
f.open.stan_code()

# Set up ------------------------------------------------------------------

  # load necessary r packages
  library("rstan") # observe startup messages
  options(mc.cores = parallel::detectCores() - 1)

  # creat timestamp which is used to 
    # - mark our backup of stan code 
    # - mark our simulation of stan
  source("functions/get_timestamp.R")
  tmp.timestamp = get_timestamp() ; tmp.timestamp
  
# Compile stan code -------------------------------------------------------

  # I suppose the stan code is placed in the ./stan_code folder.
  # specify the name of stan code without *.stan extension
  tmp.stanfile.name = "8school"

  source("functions/exists.stanCode.R")
  f.exists.stanCode(stanfile.name = tmp.stanfile.name)

  tmp.stanfile.name = "8schools"
  f.exists.stanCode(stanfile.name = tmp.stanfile.name)
  
  cat ('You may want to give the following name to the compiled stan model :\n', 
       paste0("model_",tmp.stanfile.name), sep = "")
  
  model_8schools = stan_model(stanc_ret = stanc(paste0("stan_code/",tmp.stanfile.name,".stan")))
  
  # tmp.stanCodeBU.name is the file name of the backup we will save along with our simulation
  tmp.stanCodeBU.name = paste0(tmp.stanfile.name,
                               "-timestamp_",tmp.timestamp,
                               '-Backup',".stan")
  
  cat ("The command below save a copy of the stan code to ./stan_fit/ folder\n",
       "   Wang invites you to have a look of ./stan_fit/ folder", sep = "")
  # f.open.stan_fit()

  file.copy(paste0("stan_code/", tmp.stanfile.name,".stan"), 
            paste0("stan_fit/" , tmp.stanCodeBU.name), 
            overwrite = T)
  
  message("Do you see a new backup file created in ./stan_fit/ folder ?\n",
          "   This backup uses the `timestamp` that you previously generate as an ID.")

# Prepare stan input ------------------------------------------------------

  schools_dat <- list(J = 8, 
                      y = c(28,  8, -3,  7, -1,  1, 18, 12),
                      sigma = c(15, 10, 16, 11,  9, 11, 10, 18))
  
# Fit ---------------------------------------------------------------------
  nb.chains = 3
  nb.iter = 2000
  my.seed = tmp.timestamp # provide a random seed for so that your simulation is reproducible
  
  cat("As you may recognize, the timestamp play double roles here :\n",
      " - the time stamp \n",
      " - and the random seed for MCMC")
  cat("Wang considers this to be a good practice for two reasons : \n",
      " each time you run this rscript, your stan code and result are labeled with this timestamp\n",
      " furthermore, you garantee your simulation to be reproducible !!!")

  # load function for naming objects
  
  source("functions/stanFit_Name.R")
  tmp.stanFit.Name = f.stanFit.newName(stanfile.name = tmp.stanfile.name,
                                       timestamp     = tmp.timestamp,
                                       nb.chains     = nb.chains,
                                       nb.iter       = nb.iter,
                                       seed          = my.seed)

  # When `sample_file` is specified, 
    # each iteration will add a new line to a csv file on the hard disk
    # This may slow down your program due to the writing speed of youf hard disk !!!
    # try by yourself, csv is in "stan_fit/" folder
  
  cat ('You may want to give the following name to the fit of stan :\n', 
       paste0("fit_",tmp.stanfile.name), sep = "")
  
  fit_8schools = sampling(
       object      = model_8schools,
       data        = schools_dat,
       chains      = nb.chains,
       sample_file = paste0("stan_fit/",tmp.stanFit.Name,".csv"),
       iter        = nb.iter,
       seed        = my.seed
  )

# Export in rds format ----------------------------------------------------
  # you may want to export your simulation to a r-readable file.
  saveRDS(fit_8schools,
          paste0("stan_fit/",tmp.stanFit.Name, ".rds"),
          compress = F)
  
  # `2_example_stan_post_analysis.R` demo how *.rds can be used for future analysis

# Cleanup -----------------------------------------------------------------
  # The following command deletes all r objects whose name contains 'tmp.', they are : 
  # ls(pattern = "tmp."
  cat("Clean up is not necessary, but if you want to keep your r environment clean, then why not")
  rm(list = ls(pattern = "tmp."))
  
# End ---------------------------------------------------------------------
  # If you want to hear a sound once the simulation is finished.
  # This is for you
  source(("functions/sound_simulation_finished.R"))
