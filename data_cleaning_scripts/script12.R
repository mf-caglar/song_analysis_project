data12 <- csvs[[12]]
colnames(data12) <- tolower(colnames(data12))
# we omit apple data because of no valuable info exists 
#cols about collections may help but they have a little ambiguity
data12_reduced <- data12 %>%
    select(artistname, primarygenrename, releasedate, trackname, tracktimemillis) %>%
    filter(trackname != "Music") %>%
    rename(artist = artistname, genre = primarygenrename, release_date = releasedate, song = trackname, duration_ms = tracktimemillis) %>%
    distinct(artist, song, .keep_all = TRUE) %>%
    arrange(artist, song, release_date, genre, duration_ms) %>%
    select(artist,song,release_date,genre,duration_ms)

save_rd_info(data12_reduced)
gather_colnames()


