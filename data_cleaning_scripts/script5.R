data5 <- csvs[[5]]
showDataSource(5)
colnames(data5)
sum(is.na(data5))
data5 <- na.omit(data5)
data5 <- data5[!duplicated(data5),]
data5 <- data5 %>% rename(
    song = track_name,
    artist = track_artist,
    popularity = track_popularity,
    album = track_album_name,
    date = track_album_release_date
) %>%
    arrange(artist, song, album) %>%
    select(artist, song, album, popularity, duration_ms, everything())
spotify_cols <- c("track_id","track_album_id","playlist_name","playlist_id","playlist_genre","playlist_subgenre","popularity")
sp_data1_5 <- data5 %>% select(c(artist,album,song,spotify_cols)) %>% distinct(artist,album,song,.keep_all = TRUE)
colnames(sp_data1_5) <- sapply(colnames(sp_data1_5),function(x){gsub(" ","",paste("sp_",x))})
sp_data1_5 <- sp_data1_5 %>% rename(artist = sp_artist,album = sp_album, song = sp_song)
data5_reduced <-  data5 %>% select(-spotify_cols) %>% distinct(artist,song,.keep_all = TRUE) %>% select(artist,album,song,everything()) %>% arrange(artist,album,song) 

data5_reduced <- data5_reduced %>% rename(release_date = date)



save_rd_info(data5_reduced,5)
save_rd_info(sp_data1_5,6)
gather_colnames()
rm(spotify_cols)
