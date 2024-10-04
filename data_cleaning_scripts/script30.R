data30 <- csvs[[30]]
data30_reduced <- data30
colnames(data30_reduced) <- colnames(data30_reduced) %>% tolower()
showDataSource(30)
#pass, irrelevant data 
data30_omitted <- data30_reduced
rm(data30_reduced)
