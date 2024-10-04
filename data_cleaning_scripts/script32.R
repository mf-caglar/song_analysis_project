data32 <- csvs[[32]]
data32_reduced <- data32
colnames(data32_reduced) <- colnames(data32_reduced) %>% tolower()
showDataSource(32)
setdiff(colnames(data32_reduced),cmlt_colnames)
cond <-sapply(data32_reduced$name, function(x){x %in% unique(c(sp_data1_5$song,sp_data2_7$song,sp_data3_13$song))})
x <- data32_reduced[cond,] #94 rows
# the track_ids in this data are corrupted.
# we have 100 rows of corrupted data that we already have 94 of it. So we can pass.
data32_omitted <- data32_reduced
rm(data32_reduced,cond,x)
