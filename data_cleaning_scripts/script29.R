data29 <- csvs[[29]]
data29_reduced <- data29
colnames(data29_reduced) <- colnames(data29_reduced) %>% tolower()
showDataSource(29)
colnames(data29_reduced)
cmlt_colnames
cmlt_colnames[grepl("subscr", cmlt_colnames)]
check_col("yt_channel")
data.frame(sapply(data29_reduced,class))
#since some songs are from irrelevant youtube channels we'll get only channels named same with singers.
artists <- character()
for(data_ in sapply(check_col("artist"),get)){ ### it corrupts global variable data otherwise!!!
    artists <<- c(artists,data_$artist)
}
artists <- unique(artists)
encoded_artists <- artists <- iconv(artists, from = "UTF-8", to = "UTF-8", sub = "")
encoded_channels <- iconv(data29_reduced$channelname, from = "UTF-8", to = "UTF-8", sub = "")
a <- sapply(tolower(encoded_channels),function(x){x %in% tolower(encoded_artists)})
sum(a)
sum(a)/nrow(data29_reduced) # so we only get 50% of the data
data29_reduced <- data29_reduced[a,]
check_col("yt_descript")
data29_reduced$title <- data29_reduced$title %>%
    # Split the text at the first occurrence of a dash or hyphen (assumes the format "Artist - Song Title")
    gsub(".* - ", "", .) %>%
    gsub(".* – ", "", .) %>%
    # Remove phrases like (Official Music Video), [Official Music Video], (official video), etc.
    gsub("\\(.*[Oo]fficial.*[Vv]ideo.*\\)", "", .) %>%
    gsub("\\[.*[Oo]fficial.*[Vv]ideo.*\\]", "", .) %>%
    # Remove "feat." and everything that follows
    gsub("feat\\..*", "", .) %>%
    # Remove extra spaces at the beginning or end
    trimws()
#There are so few data here so we directly omit not informing and work-required columns
data29_reduced <- data29_reduced %>% select(-c(channelurl,date,details,id,text,dislikes,numberofsubscribers)) %>% rename(
    artist = channelname, duration_ms = duration, yt_likes = likes, song = title, yt_url = url, yt_views = viewcount
) %>% select(artist,song,everything()) %>% arrange(artist,song)
# Function to convert "min:sec" to milliseconds
convert_to_ms <- function(time) {
    # Split the time by ":"
    parts <- strsplit(time, ":")[[1]]
    # Convert minutes to milliseconds and seconds to milliseconds, then sum them
    minutes_in_ms <- as.numeric(parts[1]) * 60 * 1000
    seconds_in_ms <- as.numeric(parts[2]) * 1000
    total_ms <- minutes_in_ms + seconds_in_ms
    return(total_ms)
}

# Apply the function to the entire 'duration_ms' column
data29_reduced$duration_ms <- sapply(data29_reduced$duration_ms, convert_to_ms)
setdiff(colnames(data29_reduced),cmlt_colnames)
yt_data4_29 <- data29_reduced
rm(data29_reduced)
rm(x)
rm(a,artists,b,encoded_artists,encoded_channels)
rm(data_)
save_rd_info(yt_data4_29)
