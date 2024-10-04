albums <- read.csv("data/data44_albums_artists/albums.csv",na.strings = c(""," ",NA,"?","."))
artists <- read.csv("data/data44_albums_artists/artists.csv",na.strings = c(""," ",NA,"?","."))
length(setdiff(albums$artist_id,artists$id)) # no album of an unknown artist
table(artists$role) # all related music
intersect(colnames(artists),colnames(albums))
artists_albums <- artists %>% full_join(albums, by = join_by("id" == "artist_id"),suffix = c("_art","_alb"))
colnames(artists_albums)
artists_albums <- artists_albums %>% select(-c(id,year_of_birth,city,email,zip_code,id_alb)) %>% rename(artist = real_name, album = album_title, release_year = year_of_pub, num_tracks = num_of_tracks, sales = num_of_sales) %>% select(artist,art_name,country,album,everything()) %>% arrange(artist)
sum(is.na(artists_albums))/(nrow(artists_albums) * ncol(artists_albums))
colMeans(is.na(artists_albums))
#now it's cleaned
data42 <- list(artists,albums)
data42_reduced <- artists_albums
rm(artists,albums,artists_albums)
save_rd_info(data42_reduced)
gather_colnames()
cmlt_colnames
