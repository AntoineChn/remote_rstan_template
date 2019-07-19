
# Detect the plateform in use
source("functions/get_os.R")
tmp.os = get_os()

# if on macos then play a sound
if(tmp.os == "osx"){
  system("say Simulation finished!")
}else{
  if(!require(beepr)) install.packages('beepr')
  if(tmp.os != "linux") beepr::beep()
}

rm(tmp.os, get_os)
   
