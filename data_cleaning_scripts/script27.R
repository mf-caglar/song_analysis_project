data27 <- csvs[[27]]
data27_reduced <- data27
colnames(data27_reduced) <- colnames(data27_reduced) %>% tolower()
showDataSource(27)
identical(colnames(data25),colnames(data27)) #yes
as.data.frame(colMeans(is.na(data27_reduced))) # no null
setdiff(colnames(data27_reduced),cmlt_colnames)

data27_reduced <- data27_reduced %>% rename(song = track_name, artist = artist_name, artist_popularity = artist_pop, popularity = track_pop) %>% select(artist,album,song,everything()) %>% distinct(artist,album,song,.keep_all = TRUE) %>% arrange(artist,album,song)
nrow(data27_reduced %>% distinct(artist, album, song))

save_rd_info(data27_reduced)
gather_colnames()
