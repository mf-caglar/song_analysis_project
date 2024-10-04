data25 <- csvs[[25]]
data25_reduced <- data25
colnames(data25_reduced) <- colnames(data25_reduced) %>% tolower()
showDataSource(25)
"
track_name
Name of the track

artist_name
Name of the artist

artist_pop
Popularity of the artist

album
Name of the album

track_pop
Popularity of the track

danceability
Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable.

energy
Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale. Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy.

loudness
The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks. Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). Values typically range between -60 and 0 db.

mode
Mode indicates the modality (major or minor) of a track, the type of scale from which its melodic content is derived. Major is represented by 1 and minor is 0.

key
The key the track is in. Integers map to pitches using standard Pitch Class notation.
"
as.data.frame(colMeans(is.na(data25_reduced))) # no null
setdiff(colnames(data25_reduced),cmlt_colnames)
data25_reduced <- data25_reduced %>% rename(song = track_name, artist = artist_name, artist_popularity = artist_pop, popularity = track_pop) %>% select(artist,album,song,everything()) %>% distinct(artist,album,song,.keep_all = TRUE) %>% arrange(artist,album,song)

save_rd_info(data25_reduced,37)
gather_colnames()
