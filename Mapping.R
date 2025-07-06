#read excel
install.packages("readxl")
library(readxl)
#fuzzyjoin
install.packages("fuzzyjoin")
library(dplyr)
library(fuzzyjoin)
library(stringdist)

#export into excel
install.packages("writexl")
library("writexl")

#Using some python packages
install.packages("reticulate")
library(reticulate)


install.packages("fuzzywuzzyR")
library(fuzzywuzzyR)
CSI700_saction_mapping <- read_excel("CSI700_saction_mapping.xlsx", 
                                     +     sheet = "Sheet1")


COB <- read_excel("CSI700_saction_mapping.xlsx",  sheet = "Sheet1")

COB <- COB%>%rename(company=`COB _Entity`)
xx<-stringdist_join(CSI700, COB, 
                    by="company", mode ='left', method="qgram", max_dist =99, distance_col='dist')%>%group_by(company.x)%>%slice_min(order_by=dist, n=1)
xxx<-xx[,c("company.x","company.y","dist")]
write_xlsx(xxx,"/Users/yw/Downloads/almat.xlsx")

