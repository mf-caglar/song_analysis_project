data20 <- csvs[[20]]
data20_reduced <- data20
colnames(data20_reduced) <- tolower(colnames(data20_reduced))
showDataSource(20)
as.data.frame(colMeans(is.na(data20_reduced))) # all 0
setdiff(colnames(data20_reduced),cmlt_colnames)

data20_reduced <- data20_reduced %>% select(-c(x,target)) %>% rename(song = song_title) %>% select(artist, song,everything()) %>% arrange(artist,song)

data20_reduced <- data20_reduced %>%
    group_by(artist, song) %>%
    summarize(across(.cols = -all_of(c("key","mode","time_signature")), mean, na.rm = TRUE),   # Mean for all columns except excluded ones
              across(all_of(c("key","mode","time_signature")), function(x){round(mean(as.numeric(x)))})) %>% ungroup() 

save_rd_info(data20_reduced)
gather_colnames()

