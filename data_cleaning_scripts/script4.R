data4 <- csvs[[4]]
showDataSource(4)
colnames(data4)
colnames(data4) <- c("artist","song","link","lyrics")
data4 <- data4 %>% select(-link)
sum(is.na(data1))/(dim(data1)[1]*dim(data1)[2])
length(unique(data4$lyrics)) == nrow(data4)
length(unique(data4$song)) == nrow(data4)
dup_lyr <- data4$lyrics[duplicated(data4$lyrics)]
length(dup_lyr) #same lyrics for same songs singed by different artists
data4_reduced <- data4 %>%
    distinct(artist,song,.keep_all = TRUE) %>% select(song,artist,lyrics) %>% arrange(song,artist,lyrics)

save_rd_info(data4_reduced,4)
gather_colnames()
rm(dup_lyr)
