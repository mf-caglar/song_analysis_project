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
        # mean of rank
        mean_rank = round(mean(rank)),
        # max peak.rank (weight by weeks.on.board)
        peak_rank = max(peak.rank),
        # Total weeks on board
        weeks_on_board = max(weeks.on.board)
    ) %>%
    ungroup() %>% select(date,artist,song,mean_rank,peak_rank,weeks_on_board) %>%
    arrange(artist,song,date)


save_rd_info(data1_reduced,1)
colnames(reduced_data_info) <- c("data","nrow","ncol","features")
gather_colnames()


