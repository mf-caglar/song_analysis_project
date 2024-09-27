data11 <- csvs[[11]]
"
Position - Spotify Ranking
Artist Name - Artist Name
Song Name - Song Name
Days - No of days since the release of the song (Updated)
Top 10 (xTimes) - No of times inside top 10
Peak Position - Peak position attained
Peak Position (xTimes) - No of times Peak position attained
Peak Streams - Total no of streams during Peak position
**Total Streams **- Total song streams
***sp_stream conversion is uncertain***
"

colnames(data11) <- sapply(colnames(data11), function(x) gsub("\\.", "", tolower(x)))
sum(duplicated(data11[,2:3])) #139? meaningless for ranked data
data11_reduced <- data11 %>% rename(artist = artistname, song = songname, days_old = days, top10_times = top10xtimes, peak_position = peakposition, peak_position_times = peakpositionxtimes, peak_streams = peakstreams, sp_stream = totalstreams) %>%
    mutate(peak_position_times = as.numeric(gsub("[(x)]","",peak_position_times))) %>%
    arrange(position) %>% distinct()
setdiff(colnames(data11_reduced),cmlt_colnames)

save_rd_info(data11_reduced,13)
gather_colnames()
