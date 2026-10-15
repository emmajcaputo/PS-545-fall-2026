library(tidyverse)
my_data <- read.csv("C:/Users/emmaj/OneDrive/Desktop/PS 545 Fall 2026/ANES Data/anes_timeseries_cdf_csv_20260205/anes_timeseries_cdf_csv_20260205.csv")
my_data
env_reg<-my_data$VCF0842
ggplot(my_data,aes(x=env_reg))+
  geom_bar(fill="steelblue")+
  labs(title="Environmental Regulation Score",x="Score",y="Count")+
  theme_minimal()