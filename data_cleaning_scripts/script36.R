data36 <- csvs[[36]]
data36_reduced <- data36
colnames(data36_reduced) <- colnames(data36_reduced) %>% tolower()
showDataSource(36)
data36_reduced[data36_reduced == "N/A"] <- NA
colMeans(is.na(data36_reduced))
data36_reduced <- data36_reduced %>% filter(!is.na(music))
#just 23 rows, pass
data36_omitted <- data36_reduced
rm(data36_reduced)
