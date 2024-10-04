data24 <- csvs[[24]]
data24_reduced <- data24
colnames(data24_reduced) <- colnames(data24_reduced) %>% tolower()
showDataSource(24)
"
Artist / Artist playing the music.
Music / Music name.
Album / Album name.
Year / Year the song was launched.
Genre / Sub-genre considering it is a classic rock genre playlist.
2022 / Song position in the ranking for that year.
2021 / Song position in the ranking for that year.
2020 / Song position in the ranking for that year.
2019 / Song position in the ranking for that year.
2018 / Song position in the ranking for that year.
"
colnames(data24_reduced) <- c("artist","song","album","release_year","genre","rank_2022","rank_2021","rank_2020","rank_2019","rank_2018","rank_2017","rank_2016","rank_2015")

data.frame(colMeans(is.na(data24_reduced)))
nrow(unique(data24_reduced[,1:3])) - nrow(data24_reduced)

save_rd_info(data24_reduced,36)
gather_colnames()
