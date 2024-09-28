library(lubridate)
data3 <- csvs[[3]]
showDataSource(3)
colnames(data3)
"
year : Year of the ranking (2010 to 2023)
time : Week of the year of the ranking (1 to 53)
rank : Ranking of the song (1 to 200)
song_title : Title of the song
artist : Artists of the song, can be multiple and separated by a comma
album : Album of the song
"
sum(is.na(data3))/(dim(data3)[1]*dim(data3)[2])

data3_reduced <- data3 %>% 
    rename(song = song_title, week_in_year = time) %>% 
    select(year, week_in_year, artist, album, song, rank) %>%
    group_by(artist, album, song) %>% 
    summarize(
        year = year(as.Date(median(as.numeric(as.Date(year))))), 
        rank = round(mean(rank)),                 
        week_in_year = round(mean(week_in_year))                  
    ) %>% 
    ungroup() %>%
    mutate(genre = rep("k-pop", n())) %>%  # Use n() to get the number of rows
    arrange(artist, year, week_in_year) %>% 
    select(year, week_in_year, artist, album, song, rank, genre)
    
save_rd_info(data3_reduced)
gather_colnames()
