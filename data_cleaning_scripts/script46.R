options(scipen = 999)
data46 <- fread("data/data50_universal_top_spotify_songs.csv",na.strings = c("",NA))
as.data.frame(colMeans(is.na(data46)))
data46_reduced <- na.omit(data46)
nrow(data46_reduced %>% distinct(artists,name)) / nrow(data46_reduced) # ~12500 unique artist-song pairs
unique(data46_reduced$country)
data46_reduced$country[data46_reduced$country == ""] = NA #impossible to know which country they are
data46_reduced$country[is.na(data46_reduced$country)] = "Unknown"
sum(is.na(data46_reduced$country))/nrow(data46_reduced)
unique(data46_reduced$snapshot_date)
as.numeric(as.Date(max(data46_reduced$snapshot_date)) - as.Date(min(data46_reduced$snapshot_date))) # the data is collected for every day between 2023-10-18 and 2024-09-30

data46_reduced <- data46_reduced %>%
    group_by(artists, album_name, album_release_date, name, spotify_id, country) %>%
    summarise(across(
        .cols = c(-snapshot_date, -daily_movement, -weekly_movement),
        .fns = mean,
        .names = "mean_{.col}"
    )) %>%
    ungroup()

colnames(data46_reduced)

colnames(data46_reduced) <- gsub("mean_","",colnames(data46_reduced))
colnames(data46_reduced)
data46_reduced <- data46_reduced %>% rename(artist = artists, album = album_name, release_date = album_release_date, song = name, sp_track_id = spotify_id, mean_rank = daily_rank,) %>% select(artist,album,release_date,song,everything()) %>% arrange(artist,album,release_date,song)

save_rd_info(data46_reduced)
gather_colnames()
