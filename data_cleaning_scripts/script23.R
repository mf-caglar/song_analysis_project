library(lubridate)
data23 <- csvs[[23]]
data23_reduced <- data23
colnames(data23_reduced) <- colnames(data23_reduced) %>% tolower()
showDataSource(23)
"
title
Song Title

description
Song Description

appears on
Where did it appear

artist
Artist/s who sang the song

writers
The song writer/s

producer
The song producer

released
Release date

streak
How long it was in the top list.

position
Song position during it's streak"
data.frame(colMeans(is.na(data23_reduced)))
table(data23_reduced$streak)
data23_reduced$streak <- as.numeric(gsub(" weeks","",data23_reduced$streak))
data23_reduced$release_date <- parse_date_time(data23_reduced$released, orders = "my")
data23_reduced$release_month <- month(data23_reduced$release_date, label = TRUE)
data23_reduced$release_year <- year(data23_reduced$release_date)
data23_reduced <- data23_reduced[,-c(7,10)]
data23_reduced$position <- as.numeric(gsub("No. ","",data23_reduced$position))
setdiff(colnames(data23_reduced),cmlt_colnames)
data23_reduced <- data23_reduced %>% select(-appears.on) %>% rename(song = title, weeks_on_board = streak, lyricist_s = writers, rank = position) %>% select(artist,song,everything()) %>% distinct(artist,song,lyricist_s,.keep_all = TRUE) %>% arrange(artist,song)

data.frame(colMeans(is.na(data23_reduced)))

save_rd_info(data23_reduced)
gather_colnames()

