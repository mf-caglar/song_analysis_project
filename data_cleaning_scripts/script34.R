data34 <- csvs[[34]]
data34_reduced <- data34
colnames(data34_reduced) <- colnames(data34_reduced) %>% tolower()
showDataSource(34)
data.frame(colMeans(is.na(data34_reduced)))
length(unique(paste0(data34_reduced$artist,data34_reduced$song.title))) #same with df
setdiff(colnames(data34_reduced),cmlt_colnames)
data34_reduced <- data34_reduced %>% rename(song = song.title, release_year = release.year) %>% select(artist,album,song,release_year,genre,lyrics)

save_rd_info(data34_reduced)
gather_colnames()
