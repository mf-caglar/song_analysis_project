library(lubridate)
data35 <- csvs[[35]]
data35_reduced <- data35
colnames(data35_reduced) <- colnames(data35_reduced) %>% tolower()
showDataSource(35)
data.frame(sapply(data35_reduced,class))
colnames(data35_reduced) <- gsub("\\.","_",colnames(data35_reduced))
data35_reduced$year <- gsub("/.*","",data35_reduced$month)
data35_reduced$month <- gsub(".*/","",data35_reduced$month)
data35_reduced$month <- as.numeric(data35_reduced$month)
data35_reduced$month <- month(data35_reduced$month,label = TRUE)



music <- data35_reduced$music
artists <- character()

for (data_ in sapply(check_col("artist"), get)) {
    artists <- c(artists, data_$artist)
}

artists <- unique(artists)
encoded_artists <- iconv(artists, from = "UTF-8", to = "UTF-8", sub = "")
encoded_music <- iconv(music, from = "UTF-8", to = "UTF-8", sub = "")
encoded_artists <- encoded_artists[!is.na(encoded_artists) & encoded_artists != "" & encoded_artists != " " & length(strsplit(encoded_artists,""))[[1]] >2]

b <- sapply(encoded_music, function(song) {
    matched_artists <- encoded_artists[sapply(encoded_artists, function(artist) grepl(artist, song, fixed = TRUE,ignore.case = TRUE))]
    if (length(matched_artists) > 0) {
        matched_artist <- matched_artists[which.max(nchar(matched_artists))]
        return(matched_artist)
    } else {
        return(NA)
    }
})

b <- na.omit(b)
data35_reduced$artist <- b[data35_reduced$music]
data35_reduced <- data35_reduced %>%
    filter(!is.na(music) & !is.na(artist)) %>%
    filter(nchar(artist) > 2) %>% mutate(video_length_in_s = video_length_in_s*1000) %>%
    rename(trend_month = month, trend_year = year, song = music, duration_ms = video_length_in_s, genre = music_genre)

save_rd_info(data35_reduced)
gather_colnames()
rm(artists,b,encoded_artists,encoded_music,music)
