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
path_to_python <- "/anaconda/bin/python"
use_python(path_to_python)

install.packages("fuzzywuzzyR")
library(fuzzywuzzyR)

ISIN <- read_excel("xxx.xlsx",sheet= 2)
HK <- read_excel("xxx.xlsx", sheet = 5, skip=1) #skip=1 will delete the first row


# joined_dists <- ISIN %>% stringdist_inner_join(HK, by = c(misspelling = c("entity_name_en","Description"), max_dist = 2, distance_col = "distance")) <- doesn't work

#Have to rename first
ISIN <- ISIN%>%rename(company=entity_name_en)
HK <- HK%>%rename(company=Description)


mm<-stringdist_join(ISIN, HK, 
                by="company", mode ='left', method="jw", max_dist =99, distance_col='dist')%>%group_by(company.x)%>%slice_min(order_by=dist, n=1)
                        
mmm<-mm[,c("company.x","company.y","dist","Local Symbol")]
           
matched <- subset(mmm, dist==0.000000000)
unmatched <- subset(mmm, dist!=0.000000000)
al_mat<- subset(unmatched, dist<0.1)

write_xlsx(al_mat,"/Users/yw/Downloads/almat.xlsx")



sanction <- read_excel("CSI700_saction_mapping.xlsx")
CSI700 <- read_excel("CSI700_saction_mapping.xlsx",  sheet = "CSI700")

sanction <- sanction%>%rename(company=Entity_EN)
CSI700 <- CSI700%>%rename(company=entity_name_en)

mm<-stringdist_join(CSI700, sanction, 
                    by="company", mode ='left', method="qgram", max_dist =99, distance_col='dist')%>%group_by(company.x)%>%slice_min(order_by=dist, n=1)
mmm<-mm[,c("company.x","company.y","dist","Match MSCI - Direct Exposure")]


write_xlsx(al_mat,"/Users/yw/Downloads/almat.xlsx")

#load Python modules
DIFFLIB <- reticulate::import("difflib")
#reticulate::py_config()
POLYFUZZ <- reticulate::import("polyfuzz")

#Fuzzy string matching

### Define two vectors of string to be matched
sanc_vc<-sanction$company
CSI_vc<-CSI700$company
#difflib
#create function that gets the best matches for two vectors
# Create function that gets the best matches for two vectors of strings, using difflib
get_best_matches <- function(from_vec, to_vec) {
  
  # Non-vectorized version of the function
  get_best_match <- function(from_string, to_vec) {
    return(DIFFLIB$get_close_matches(from_string, to_vec, 1L, cutoff = 0))
  }
  
  # Vectorize the function
  unlist(lapply(from_vec, function(from_vec) get_best_match(from_vec, to_vec)))
}
difflib_matches <- get_best_matches(sanc_vc, CSI_vc)

# Create function that computes the similarity score between two sets of strings, using difflib
get_score <- function(strings1, strings2) {
  return(SequenceMatcher$new(strings1, strings2)$ratio())
}
get_score <- Vectorize(get_score)
 difflib_scores <- get_score(sanc_vc, difflib_matches)
#fuzzywuzzy


 # Use polyfuzz to perform fuzzy string matching
 # EditDistance
 editdistance_results <- POLYFUZZ$PolyFuzz("EditDistance")$match(sanc_vc, CSI_vc)$get_matches()
 
 # TF-IDF
 tfidf_results <- POLYFUZZ$PolyFuzz("TF-IDF")$match(from_vec, to_vec)$get_matches()
