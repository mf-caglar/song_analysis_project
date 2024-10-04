data33 <- csvs[[33]]
data33_reduced <- data33
colnames(data33_reduced) <- colnames(data33_reduced) %>% tolower()
showDataSource(33)
# 100 rows of russian songs. pass
data33_omitted <- data33_reduced
rm(data33_reduced)
