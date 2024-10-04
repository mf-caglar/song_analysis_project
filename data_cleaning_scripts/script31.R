data31 <- csvs[[31]]
data31_reduced <- data31
colnames(data31_reduced) <- colnames(data31_reduced) %>% tolower()
showDataSource(31)
check_col("sp_track_id")
setdiff(colnames(data31_reduced),cmlt_colnames)
cond <-sapply(data31_reduced$name, function(x){x %in% unique(c(sp_data1_5$song,sp_data2_7$song,sp_data3_13$song))})
x <- data31_reduced[cond,] #89 rows
# the track_ids in this data are corrupted.
# we have 100 rows of corrupted data that we already have 89 of it. So we can pass.
data31_omitted <- data31_reduced
rm(data31_reduced,cond,x)
