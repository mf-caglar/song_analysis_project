data16 <- csvs[[16]]
showDataSource(16)
data16_reduced <- data16
colnames(data16_reduced) <- tolower(colnames(data16_reduced))
setdiff(colnames(data16_reduced),cmlt_colnames)
for(col in c("release","genre","rate","rating","review","count")){
    for(col_ in seq_len(length(cmlt_colnames))){
        if(grepl(col,cmlt_colnames[col_])){
            print(cmlt_colnames[col_])
        }
    }
}
colMeans(is.na(data16_reduced)) #no null data
rm(col,col_)
data.frame(sapply(data16_reduced, n_distinct)) # this is an album data
data16_reduced <- data16_reduced %>% select(-x, release_type) %>% rename(rank = position, album = release_name, artist = artist_name, genre = primary_genres, secondary_genre = secondary_genres) %>% select(artist,album,release_date,everything()) %>% arrange(artist,album)

save_rd_info(data16_reduced,20)
gather_colnames()
