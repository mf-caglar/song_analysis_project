data45 <- fread("data/data49_spotify_onemillion.csv")
sapply(da)
setdiff(colnames(data45),cmlt_colnames)
data45_reduced <- data45 %>% rename(sp_track_id = id, song = name, sp_album_id = album_id, artist = artists, sp_artist_id = artist_ids, is_explicit = explicit, release_year = year) %>% select(-c(track_number,disc_number)) %>% arrange(artist,release_date,song) %>% select(artist,song,release_date,everything())
data45_reduced$artist <- gsub("\\]","",gsub("\\[","",gsub("\"","",data45_reduced$artist)))
data45_reduced$sp_artist_id <- gsub("\\]","",gsub("\\[","",gsub("\'","",data45_reduced$sp_artist_id)))
data.frame(colMeans(is.na(data45_reduced))) #no null, we save after a last check
setdiff(colnames(data45_reduced),cmlt_colnames) #1 feature gain
save_rd_info(data45_reduced)
gather_colnames()
