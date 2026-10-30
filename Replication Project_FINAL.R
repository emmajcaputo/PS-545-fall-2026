### Replication Project ###

library(RStata)
library(haven)
library(foreign)

## Set options to read Stata program into R ##

#This tells R what version of Stata it will be using (Stata 19)

options("RStata.StataVersion" = 19)

#This is where I selected the pathway to the Stata application

chooseStataBin()
options("RStata.StataPath")
# [1] "\"C:/Program Files/StataNow19/StataBE-64\""

#This is where I stored the application path in the variable stata_path so that I could use it in subsequent code

# explicit path
stata_path = "\"C:/Program Files/StataNow19/StataBE-64\""

## Create dataframe from Stata dataset so that it can be used in R ##
# I used the data.frame function to create a dataframe from the Stata dataset and then I stored it in x so that I could use it in subsequent code

x <- data.frame("C:/Users/emmaj/OneDrive/Desktop/PS 545 Fall 2026/Part 1 - Replication/anes_timeseries_2020_stata_20220210.dta")

## Run Stata code through R ##
# The command that R uses to run Stata code is "stata"
# The first argument is the Stata .do file that it will be using
# The second argument is the data that the code will be acting on
# The third argument specifies that the Stata output should be displayed in R
# The fourth argument is the pathway to the Stata application
# The last argument specifies the Stata version again

stata("C:/Users/emmaj/OneDrive/Desktop/PS 545 Fall 2026/Part 1 - Replication/ANES analysis.do",
      data.in=x,
      data.out=TRUE,
      stata.path=stata_path,
      stata.version=19)
