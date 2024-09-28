data6 <- csvs[[6]]
showDataSource(6)
colnames(data6)

# see paper: https://sol.sbc.org.br/index.php/eniac/article/view/12155

data6_reduced <- data6 %>% select(-c(X,age,lyrics)) %>% rename(
    artist = artist_name,
    song = track_name,
    year = release_date,
    duration_ms = len
) %>% mutate(duration_ms = duration_ms * 10^3)

temp <- data6_reduced[,1:2][duplicated(data6_reduced[,1:2]),]
nrow(temp) #no duplicated artist-song pair
rm(temp)

save_rd_info(data6_reduced)
gather_colnames()
