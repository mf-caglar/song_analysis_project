data14 <- csvs[[14]]
showDataSource(14)
"
Weather: The weather variable to which the song in Spotify belongs,
Track Name: Song / Song name information in Spotify,
Artist: Artist information on Spotify,
Album: Album information with the song on Spotify,
Image: Album cover photo on Spotify,
Popularity: Popularity score is a metric that Spotify calculates based on a variety of factors, such as the number of plays the song is in. (0-100)
"
colMeans(sapply(data14,is.na))
data14_reduced <- data14
colnames(data14_reduced) <- tolower(colnames(data14_reduced))
setdiff(colnames(data14_reduced),cmlt_colnames)
data14_reduced <- data14_reduced %>% rename(song = track.name)
data14_reduced$image[2]
length(unique(paste0(data14_reduced$artist,data14_reduced$album,data14_reduced$song))) # all triples are different
data14_reduced <- data14_reduced %>% select(artist,album,song,popularity,image,weather)
save_rd_info(data14_reduced)
gather_colnames()