data15 <- csvs[[15]]
showDataSource(15)
"
rank	rank of the song in this specific week
artist	artist or group of artists that worked on the song
song	title of the song
rank last week	rank of the song in the last weeks chart, first appearing songs are labeled with a 0
peak rank	highest rank so far
weeks on chart	number of weeks were the song was in the charts
date	date of week, starting on Saturday
"
data15_reduced <- data15
setdiff(colnames(data15_reduced),cmlt_colnames)
check_col("peak_rank")
colnames(data1_reduced)

colMeans(is.na(data15_reduced))
nrow(data15_reduced) - length(unique(paste0(data15_reduced$artist,data15_reduced$song)))
# very similar to data 1 - so we will use the reduction there
data15_reduced <- data15 %>%
    select(-X, -rank_last_week) %>%
    group_by(song, artist) %>%
    summarize(
        # Use middle date for simplicity
        date = as.Date(median(as.numeric(as.Date(date)))), 
        # mean of rank
        mean_rank = round(mean(rank)),
        # max peak.rank (weight by weeks.on.board)
        peak_rank = max(peak_rank),
        # Total weeks on board
        weeks_on_board = max(weeks_on_chart)
    ) %>%
    ungroup() %>% select(date,artist,song,mean_rank,peak_rank,weeks_on_board) %>%
    arrange(artist,song,date)
colnames(data15_reduced)
setdiff(colnames(data15_reduced),cmlt_colnames)

save_rd_info(data15_reduced)
gather_colnames()


