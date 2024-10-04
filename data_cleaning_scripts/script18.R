data18 <- csvs[[18]]
showDataSource(18)
"
Track Name: Name of the song. --- song
Album Name: Name of the album the song belongs to. --- album
Artist: Name of the artist(s) of the song. --- artist
Release Date: Date when the song was released. --- release_date
ISRC: International Standard Recording Code for the song. --- omit
All Time Rank: Ranking of the song based on its all-time popularity. --- rank
Track Score: Score assigned to the track based on various factors. --- avg_rating
Spotify Streams: Total number of streams on Spotify. --- sp_streams
Spotify Playlist Count: Number of Spotify playlists the song is included in. --- sp_playlist_count
Spotify Playlist Reach: Reach of the song across Spotify playlists. --- sp_playlist_reach
Spotify Popularity: Popularity score of the song on Spotify. --- sp_popularity
YouTube Views: Total views of the song's official video on YouTube. --- yt_views
YouTube Likes: Total likes on the song's official video on YouTube. --- yt_likes
TikTok Posts: Number of TikTok posts featuring the song. --- ttk_posts
TikTok Likes: Total likes on TikTok posts featuring the song. --- ttk_likes
TikTok Views: Total views on TikTok posts featuring the song. --- ttk_views
YouTube Playlist Reach: Reach of the song across YouTube playlists. --- yt_playlist_reach
Apple Music Playlist Count: Number of Apple Music playlists the song is included in. --- apl_playlist_count
AirPlay Spins: Number of times the song has been played on radio stations. --- airplay_spins
SiriusXM Spins: Number of times the song has been played on SiriusXM. --- omit
Deezer Playlist Count: Number of Deezer playlists the song is included in. --- dz_playlist_count
Deezer Playlist Reach: Reach of the song across Deezer playlists. --- dz_playlist_reach
Amazon Playlist Count: Number of Amazon Music playlists the song is included in. --- amz_playlist_count
Pandora Streams: Total number of streams on Pandora. --- pandora_streams
Pandora Track Stations: Number of Pandora stations featuring the song. ---pandora_stations 
Soundcloud Streams: Total number of streams on Soundcloud. --- omit
Shazam Counts: Total number of times the song has been Shazamed. --- shz_counts
TIDAL Popularity: Popularity score of the song on TIDAL. --- omit
Explicit Track: Indicates whether the song contains explicit content. --- is_explicit
"
# Step 1: Omit or Change the Names of Columns
data18_reduced <- data18
data18_reduced[data18_reduced == ""] <- NA

# Renaming columns based on the descriptions provided
new_column_names <- c(
    "song", "album", "artist", "release_date", 
    "rank", "avg_rating", 
    "sp_streams", "sp_playlist_count", "sp_playlist_reach", "sp_popularity", 
    "yt_views", "yt_likes", 
    "ttk_posts", "ttk_likes", "ttk_views", 
    "yt_playlist_reach", "apl_playlist_count", 
    "airplay_spins", "dz_playlist_count", "dz_playlist_reach", 
    "amz_playlist_count", "pandora_streams", "pandora_stations", 
    "shz_counts", "is_explicit"
)

# Drop unnecessary columns
data18_reduced <- data18_reduced[, -c(5, 20, 27, 28)]  # Drop columns: "isrc", "siriusxm_spins", "soundcloud_streams", "tidal_popularity"

# Rename remaining columns
colnames(data18_reduced) <- new_column_names

# Step 2: Handle duplicates by creating a unique combination of song, album, and artist
data18_reduced_unique <- data18_reduced[!duplicated(paste0(data18_reduced$song, data18_reduced$album, data18_reduced$artist)), ]

# Step 3: Create Platform-Specific Data Frames

# Spotify-specific data frame
sp_data4_18 <- data18_reduced_unique[, c("song", "album", "artist", "sp_streams", "sp_playlist_count", "sp_playlist_reach", "sp_popularity")]

# YouTube-specific data frame
yt_data3_18 <- data18_reduced_unique[, c("song", "album", "artist", "yt_views", "yt_likes", "yt_playlist_reach")]

# TikTok-specific data frame
ttk_data1_18 <- data18_reduced_unique[, c("song", "album", "artist", "ttk_posts", "ttk_likes", "ttk_views")]

# Deezer-specific data frame
dz_data1_18 <- data18_reduced_unique[, c("song", "album", "artist", "dz_playlist_count", "dz_playlist_reach")]

# Amazon-specific data frame
amz_data_18 <- data18_reduced_unique[, c("song", "album", "artist", "amz_playlist_count")]

# Various platform-specific data frame (Apple Music, Pandora, Shazam)
vrs_ptfm_data1_18 <- data18_reduced_unique[, c("song", "album", "artist", "apl_playlist_count", "airplay_spins", "pandora_streams", "pandora_stations", "shz_counts")]

# Step 4: Remove platform-specific columns from the original data frame
data18_reduced <- data18_reduced_unique[, c("song", "album", "artist", "release_date", "rank", "avg_rating", "is_explicit")]

# Output the number of rows and confirm that 41 duplicates were removed
nrow(data18_reduced) - length(unique(paste0(data18_reduced$song, data18_reduced$album, data18_reduced$artist)))

data18_reduced <- data18_reduced %>% select(artist,album,song,everything())

save_rd_info(data18_reduced)
save_rd_info(sp_data4_18)
save_rd_info(yt_data3_18)
save_rd_info(ttk_data1_18)
save_rd_info(dz_data1_18)
save_rd_info(amz_data_18)
save_rd_info(vrs_ptfm_data1_18)
gather_colnames()
rm(data18_reduced_unique)
rm(new_column_names)

