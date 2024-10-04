file_paths <- list.files("data/data14_amazon_metal_music_rates/", pattern = "\\.csv$", full.names = TRUE)
data38 <- list()
i <- 1

for (file in file_paths) {
    data38[[i]] <- read.csv(file,na.strings = c(NA,"?",".","*"))
    i <- i + 1
}
rm(file, file_paths, i)
unique(sapply(data38, colnames))

data38 <- lapply(data38, function(df) {
    if ("X" %in% colnames(df)) {
        df <- df %>% select(-X)
    }
    return(df)
})
#asin --> Amazon Standard Identification Number
genre_names <- c(
    "thrash and speed metal", 
    "progressive metal", 
    "pop metal", 
    "metal", 
    "death metal", 
    "british metal", 
    "black metal", 
    "alternative metal"
)
data38 <- lapply(1:length(data38), function(i) {
    df <- data38[[i]]
    df$genre <- rep(genre_names[i], nrow(df))
    return(df)
})
# row binding gives error so we check data types
class_list <- lapply(data38,function(i)sapply(i,class))
class_df <- do.call(rbind, lapply(class_list, function(x) as.data.frame(t(x))))
data38[[8]]$review_count <- as.numeric(data38[[8]]$review_count)
data38_reduced <- bind_rows(data38)
data38_reduced <- data38_reduced %>% rename(release_year = year)
summary(data38_reduced$star_rating) #1-5

as.data.frame(colMeans(is.na(data38_reduced)))

data38_reduced <- data38_reduced %>% mutate(across(everything(), ~ifelse(grepl("^\\s*$", .), NA, .))) %>% filter(!is.na(artist)) %>% rename(amz_media = media, amz_review_count = review_count,amz_track_id = asin, amz_star_rating = star_rating, song = title) %>% select(artist,song,release_year,genre,everything()) %>% arrange(artist,song,release_year)


data38_reduced <- data38_reduced %>%
    rename(amz_media_count = amz_media) %>%
    mutate(amz_media_count = sapply(strsplit(amz_media_count, ","), length))

temp <- data38_reduced %>% select(artist,song)
nrow(temp[duplicated(temp),])  #so many duplicates for artist-song pairs. let's see how they do differ

differences <- data38_reduced %>%
    group_by(artist, song) %>%
    summarize(across(everything(), ~ length(unique(.))), .groups = )
data.frame(colMeans(differences[,3:8])) #they differ by genre at most

data38_reduced <- data38_reduced %>% distinct(artist,song,genre,.keep_all = TRUE)

save_rd_info(data38_reduced)
gather_colnames()

