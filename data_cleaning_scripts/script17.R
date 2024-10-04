data17 <- csvs[[17]]
data17_reduced <- data17
colnames(data17_reduced) <- tolower(colnames(data17_reduced))
showDataSource(17)
"
Artist
The name of the artist who performed the song.

Title
The title of the song.

Year
The year in which the song was released.

Sales
The total sales figure for the song.

Streams
The number of streams the song has received.

Downloads
The number of downloads for the song.

Radio Plays
The number of times the song has been played on the radio.

Rating
A numerical rating or score associated with the song.
"

setdiff(colnames(data17_reduced),cmlt_colnames)
check_col("year")
for(col_ in seq_len(length(cmlt_colnames))){
    if(grepl("stream",cmlt_colnames[col_])){
        print(cmlt_colnames[col_])
    }
}
colMeans(is.na(data17_reduced)) # no null data
nrow(data17_reduced) - length(unique(paste0(data17_reduced$artist,data17_reduced$title))) # unique artist-song pairs
data17_reduced <- data17_reduced %>% rename(song = title, release_year = year,radio_plays = radio.plays, avg_rating = rating) %>% select(artist,song,release_year,everything()) %>% arrange(artist,song,release_year)

save_rd_info(data17_reduced)
gather_colnames()
rm(col_)
