data7 <- csvs[[7]]
colnames(data7) <- tolower(colnames(data7))
# Existing code to clean and rename columns
data7 <- data7 %>% 
    select(-x) %>% 
    rename(
        sp_stream = stream, 
        sp_track_id = uri, 
        sp_url = url_spotify, 
        yt_channel = channel, 
        yt_comments = comments, 
        yt_descript = description, 
        yt_licensed = licensed, 
        yt_likes = likes, 
        yt_is_official = official_video, 
        yt_title = title, 
        yt_url = url_youtube, 
        yt_views = views, 
        song = track
    ) %>% 
    mutate(sp_track_id = gsub("spotify:track:", "", sp_track_id))

# Adding artist, song, and album to sp_data2_7 and yt_data2_7
sp_data2_7 <- data7 %>%
    select(artist, song, album, starts_with("sp_"))

yt_data1_7 <- data7 %>%
    select(artist, song, album, starts_with("yt_"))

# Processing other data
temp <- data7 %>% select(-starts_with("sp_"),starts_with("yt_"))

temp2 <- temp %>%
    group_by(artist, song) %>%
    filter(n() > 1) %>%
    ungroup() %>% 
    arrange(artist, song) # Handle duplicates due to different versions of the same song

# Checking for duplicates
sum(duplicated(temp2[, c("artist", "song", "album")])) # 0

data7_reduced <- temp2
rm(temp, temp2)
save_rd_info(data7_reduced)
save_rd_info(sp_data2_7)
save_rd_info(yt_data1_7)
gather_colnames()