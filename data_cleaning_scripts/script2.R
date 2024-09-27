data2 <- csvs[[2]]
sapply(data2,class)
showDataSource(2)
object.size(data2)/10^6
colnames(data1)
colnames(data2)
"
Username: Consists of the name of the user.
Artist: Name of the artists that the user had heard.
Track: Consists of track/song name by that particular artist.
Album: Consists of names of the albums.
Date: Consists of the days ranging from January 1st to January 31st, 2021.
Time: Consists of the time of a particular day when the user had heard a particular track.
"
colnames(data2) <- tolower(colnames(data2))
data2 <- data2 %>% select(-x) %>% rename(song = track)

# a useless data :(

data2_reduced <- data2 %>% group_by(artist,album,song) %>% 
    summarize(
        artist = unique(artist),
        album = unique(album),
        song = unique(song)
    ) %>%
    arrange(artist,album,song) %>% select(artist,album,song) %>% ungroup()

save_rd_info(data1_reduced,2)
gather_colnames()
