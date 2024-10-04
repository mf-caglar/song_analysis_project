raw_data <- read.csv("data/data17_classic_rock/classic-rock-raw-data.csv")
song_list <- read.csv("data/data17_classic_rock/classic-rock-song-list.csv",na.strings=c(NA,"","?"))
showDataSource(39)
data39 <- song_list
rm(raw_data,song_list)
data39_reduced <- data39
colnames(data39_reduced) <- gsub("\\.","_",tolower(colnames(data39_reduced)))
as.data.frame(colMeans(is.na(data39_reduced)))
nrow(data39_reduced %>% distinct(song_clean,artist_clean)) #no duplicated artist-song
colnames(data39_reduced)
cmlt_colnames[grepl("count",cmlt_colnames)] #leave playcount as is
data39_reduced <- data39_reduced %>% select(artist_clean,song_clean,release_year,playcount) %>% rename(song = song_clean,artist = artist_clean) %>% arrange(artist,song)

save_rd_info(data39_reduced)
gather_colnames()


