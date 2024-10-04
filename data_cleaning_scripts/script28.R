data28 <- csvs[[28]]
data28_reduced <- data28
colnames(data28_reduced) <- colnames(data28_reduced) %>% tolower()
showDataSource(28)
identical(colnames(data25),colnames(data28)) #yes
as.data.frame(colMeans(is.na(data28_reduced))) # no null
setdiff(colnames(data28_reduced),cmlt_colnames)

data28_reduced <- data28_reduced %>% rename(song = track_name, artist = artist_name, artist_popularity = artist_pop, popularity = track_pop) %>% select(artist,album,song,everything()) %>% distinct(artist,album,song,.keep_all = TRUE) %>% arrange(artist,album,song)
nrow(data28_reduced %>% distinct(artist, album, song))

save_rd_info(data28_reduced)
gather_colnames()
