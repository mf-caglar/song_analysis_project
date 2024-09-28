data8 <- csvs[[8]]
showDataSource(8)
gather_colnames()
cmlt_colnames
setdiff(colnames(data8),cmlt_colnames)
check_col("popularity")
hist(data5_reduced$popularity) #high frequency of zeros ???
hist(data8$song_popularity)
data8_reduced <- data8 %>% rename(song = song_name, popularity = song_popularity, duration_ms = song_duration_ms, mode = audio_mode, valence = audio_valence) %>% arrange(song) %>% distinct()
setdiff(colnames(data8),cmlt_colnames)
length(unique(data8_reduced$song))
nrow(data8) - sum(duplicated(data8))

save_rd_info(data8_reduced)
gather_colnames()
