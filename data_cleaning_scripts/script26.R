data26 <- csvs[[26]]
data26_reduced <- data26
colnames(data26_reduced) <- colnames(data26_reduced) %>% tolower()
showDataSource(26)
identical(colnames(data25),colnames(data26)) #yes
as.data.frame(colMeans(is.na(data26_reduced))) # no null
setdiff(colnames(data26_reduced),cmlt_colnames)

data26_reduced <- data26_reduced %>% rename(song = track_name, artist = artist_name, artist_popularity = artist_pop, popularity = track_pop) %>% select(artist,album,song,everything()) %>% distinct(artist,album,song,.keep_all = TRUE) %>% arrange(artist,album,song)

save_rd_info(data26_reduced)
gather_colnames()
