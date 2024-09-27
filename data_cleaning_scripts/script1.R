library(dplyr)
data1 <- csvs[[1]]
object.size(data1)/10^6


head(data1)
showDataSource(1)
sum(is.na(data1))/(dim(data1)[1]*dim(data1)[2])
data1 <- na.omit(data1)

# reduce data to unique artist-song pairs

data1_reduced <- data1 %>%
    group_by(song, artist) %>%
    summarize(
        # Use middle date for simplicity
        date = as.Date(median(as.numeric(as.Date(date)))), 
        # Weighted mean of last.week (weight by weeks.on.board)
        mean_rank = round(mean(rank)),
        # Weighted mean of peak.rank (weight by weeks.on.board)
        peak_rank = max(rank),
        # Total weeks on board
        weeks.on.board = max(weeks.on.board)
    ) %>%
    ungroup() %>% select(date,artist,song,mean_rank,peak_rank,weeks.on.board) %>%
    arrange(artist,song,date)

save_rd_info(data1_reduced,1)
gather_colnames()


