song_info <- read.csv("data/data27_spotify_19000_songs/song_info.csv")
song_data <- read.csv("data/data27_spotify_19000_songs/song_data.csv",na.strings=c(NA,"","?"))
identical(song_info$song_name,song_data$song_name)
data40 <- bind_cols(song_info,song_data[,2:ncol(song_data)])
rm(song_info,song_data)
data40_reduced <- data40
setdiff(colnames(data40_reduced),cmlt_colnames)
data40_reduced <- data40_reduced %>% rename(song = song_name, artist = artist_name, album = album_names, sp_playlist = playlist, sp_popularity = song_popularity, duration_ms = song_duration_ms, mode = audio_mode, valence = audio_valence) %>% select(artist,song,album,sp_playlist,everything()) %>% arrange(artist,song,album)
nrow(data40_reduced) - nrow(data40_reduced %>% distinct(artist,song,album,sp_playlist)) #7
data40_reduced <- data40_reduced %>% distinct(artist,song,album,sp_playlist,.keep_all = TRUE)
save_rd_info(data40_reduced)
gather_colnames()

