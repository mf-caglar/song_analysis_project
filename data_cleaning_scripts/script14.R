data14 <- csvs[[14]]
showDataSource(14)
sum(is.na(data14))/(dim(data14)[1]*dim(data14)[2]) #0
data14_reduced <- data14
colnames(data14_reduced) <- tolower(colnames(data14_reduced))
setdiff(colnames(data14_reduced),cmlt_colnames)
data14_reduced <- data14_reduced %>% rename(song = track.name) %>% select(artist,album,song,popularity,image,weather) %>% arrange(artist,album,song)
length(unique(paste0(data14_reduced$artist,data14_reduced$album,data14_reduced$song))) == nrow(data14_reduced) ## artist - album - song triples are unique each

save_rd_info(data14_reduced)
gather_colnames()