data10 <- csvs[[10]]
colnames(data10) <- tolower(colnames(data10))
setdiff(colnames(data10),cmlt_colnames)
data10_reduced <- data10 %>% rename(song=track, duration_ms = duration) %>% select(artist,song,everything()) %>% distinct() %>% arrange(artist,song,year)

save_rd_info(data10_reduced,12)
gather_colnames()
