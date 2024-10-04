data22 <- csvs[[22]]
data22_reduced <- data22
colnames(data22_reduced) <- colnames(data22_reduced) %>%
    tolower() %>%
    gsub("\\.", "_", .) %>%
    gsub("__", "", .)

# 2. Rename columns based on your updated names
new_column_names <- c(
    "song", "artist", "artist_count", "release_year", "release_month", 
    "release_day", "sp_playlist_count", "sp_chart_count", "sp_streams", 
    "apl_playlist_count", "apl_chart_count", "dz_playlist_count", 
    "dz_chart_count", "shz_chart_count", "bpm", "key", "mode", 
    "danceability", "valence", "energy", "acousticness", "instrumentalness", 
    "liveness", "speechiness"
)

colnames(data22_reduced) <- new_column_names

# 3. Remove any duplicated artist-song combinations
data22_reduced <- data22_reduced %>%
    distinct(artist, song, .keep_all = TRUE)

# 4. Create platform-specific data frames

# Spotify-specific data frame
sp_data5_22 <- data22_reduced %>%
    select(song, artist, sp_playlist_count, sp_chart_count, sp_streams)

# Apple Music-specific data frame
vrs_ptfm_data2_22 <- data22_reduced %>%
    select(song, artist, apl_playlist_count, apl_chart_count, shz_chart_count)

# Deezer-specific data frame
dz_data2_22 <- data22_reduced %>%
    select(song, artist, dz_playlist_count, dz_chart_count)

# 5. Omit platform-specific data from the reduced dataset
data22_reduced <- data22_reduced %>%
    select(song, artist, artist_count, release_year, release_month, 
           release_day, bpm, key, mode, danceability, valence, energy, 
           acousticness, instrumentalness, liveness, speechiness)

save_rd_info(data22_reduced)
save_rd_info(sp_data5_22)
save_rd_info(dz_data2_22)
save_rd_info(vrs_ptfm_data2_22)
gather_colnames()