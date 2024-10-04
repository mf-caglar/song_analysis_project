library(jsonlite)
library(reshape2)
data13 <- csvs[[13]]
data13_reduced <- data13
data13_reduced[data13_reduced == "[]" | data13_reduced == ""] <- NA
colnames(data13_reduced) <- tolower(colnames(data13_reduced))
data13_reduced <- data13_reduced %>% select(-c(album.url, song.url, writers))
data13_reduced <- data13_reduced %>%
    select(-featured.artists) %>%
    rename(release_date = release.date, song = song.title) %>%
    distinct() %>%
    select(artist, album, song, year, everything()) %>%
    arrange(artist, album, song, year)

temp <- data13_reduced[duplicated(data13_reduced[,1:3]) | duplicated(data13_reduced[,1:3], fromLast = TRUE), ]
media_counts <- temp %>%
    group_by(album, artist, song) %>%
    summarize(media_count = n_distinct(media)) %>%
    filter(media_count > 1)

additional_media_rows <- temp %>%
    semi_join(media_counts, by = c("album", "artist", "song"))

rows_omit <- additional_media_rows %>% filter(row_number() %in% c(1, 3, 5))
data13_reduced <- anti_join(data13_reduced, rows_omit, by = "media")

media_df <- get_json_data(data13_reduced,"media","'")
data13_reduced <- bind_cols(data13_reduced,media_df)

na_prop <- sort(colMeans(is.na(data13_reduced)),decreasing = TRUE)
data13_reduced <- data13_reduced %>% select(-c(names(na_prop[na_prop > .7])))
colnames(data13_reduced)
compare_useless_features <- as.data.frame(table(data13_reduced$youtube_start,data13_reduced$youtube_type,data13_reduced$spotify_type))
colnames(compare_useless_features) <- c("youtube_start","youtube_type","spotify_type","Freq")
compare_useless_features[,4][1]/sum(compare_useless_features[,4]) # 90% percent of combinations are the same. we can omit them

data13_reduced <- data13_reduced %>% select(-colnames(compare_useless_features)[1:3])

#spotify native uris and urls seem so similar. let's check

sum(gsub("https://open.spotify.com/track/","",data13_reduced$spotify_url) == gsub("spotify:track:","",data13_reduced$spotify_native_uri),na.rm = TRUE)/nrow(data13_reduced[! is.na(data13_reduced$spotify_native_uri) & ! is.na(data13_reduced$spotify_url),]) #gives 1. they are equal

data13_reduced <- data13_reduced %>% select(-spotify_url) %>% rename(sp_track_id = spotify_native_uri) %>% mutate(sp_track_id = gsub("spotify:track:","",sp_track_id))

temp <- data13_reduced %>% select(artist,album,song,year,sp_track_id,release_date,youtube_url)

#check track_id & release_date
duplicates_check <- temp %>%
    group_by(artist, album, song, year) %>%
    summarise(n_distinct_sp_track_id = n_distinct(sp_track_id),n_distinct_release_date = n_distinct(release_date), n_distinct_youtube_url = n_distinct(youtube_url))
    
nrow(duplicates_check) #0 we can remove year
nrow(duplicates_check %>% filter(n_distinct_sp_track_id > 1)) #0 
nrow(duplicates_check %>% filter(n_distinct_release_date > 1)) #0 
nrow(duplicates_check %>% filter(n_distinct_youtube_url > 1)) #0 

sp_data3_13 <- temp %>% select(artist,album,song,sp_track_id) %>% distinct(artist,album,song,sp_track_id) %>% arrange(artist,album,song) %>% filter(!is.na(sp_track_id))
yt_data2_13 <- temp %>% select(artist,album,song,youtube_url) %>% distinct(artist,album,song,youtube_url) %>% rename(yt_url = youtube_url) %>% arrange(artist,album,song) %>% filter(!is.na(yt_url))

data13_reduced <- data13_reduced %>% select(-c(media,youtube_url,sp_track_id)) %>% select(artist,album,song,release_date,year,rank,lyrics)

data13_reduced <- data13_reduced %>% rename(ranking_year = year)
sum(duplicated(data13_reduced[,c(1,2,3,5)])) #no duplicated artist-album-song triples

save_rd_info(data13_reduced,15)
save_rd_info(sp_data3_13)
save_rd_info(yt_data2_13)
gather_colnames()

rm(additional_media_rows,compare_useless_features,duplicates_check,media_counts,media_df,rows_omit,temp,na_prop)
