library(lubridate)
library(stringr)
library(purrr)
files <- list.files("data/data28_billboard_9920")
data41 <- list()
for(i in seq_len(length(files))){
    data41[[i]] <- read.csv(paste0("data/data28_billboard_9920/",files[i]),na.strings = c(NA,""," ","?","."))
}

#all for 1999-2019
artists <- data41[[1]]
billboardHot100 <- data41[[2]]
grammyAlbums <- data41[[3]]
grammySongs <- data41[[4]]
riaaAlbumCerts <- data41[[5]]
riaaSingleCerts <- data41[[6]]
songAttributes <- data41[[7]]
spWeeklyTop200 <- data41[[8]]
sapply(data41,nrow)
sapply(data41,ncol)
sapply(data41,colnames)

#clean artists

colnames(artists) <- gsub("\\.","_",tolower(colnames(artists)))
artists <- artists %>% select(-c(x,yearfirstalbum,numalbums,group_solo)) %>% select(artist,followers,genres,gender) %>% arrange(artist)
nrow(artists) == nrow(artists %>% distinct(artist))
sum(duplicated(artists$artist)) #1
artists <- artists %>% distinct(artist,.keep_all = TRUE)
colMeans(is.na(artists))
colnames(artists) <- c("artist", "followers", "genre", "gender")

#clean billboardHot100
colnames(billboardHot100)
colnames(billboardHot100) <- tolower(gsub("\\.","_",colnames(billboardHot100)))
data.frame(colMeans(is.na(billboardHot100)))
billboardHot100 <- billboardHot100 %>% mutate(featured = as.integer(!is.na(features)))

billboardHot100 <- billboardHot100 %>% select(-c(x,writing_credits)) %>% rename(artist = artists, song = name, rank = weekly_rank, peak_rank = peak_position, date = week, release_date = date, weeks_on_board = weeks_on_chart) %>% select(artist,song,genre, everything()) %>% arrange(artist,song)

differences <- billboardHot100 %>%
    group_by(artist,song) %>%
    summarize(across(everything(), ~ length(unique(.))), .groups = )

data.frame(colMeans(differences[3:ncol(differences)])) # lyrics, release_date and genres are nearly unique for artist-song pairs. so little corruption like 1.000139*nrow(data) = 13 duplicates.


#now we will use same strategy we used before at data1_reduced which was also a billboard chart data
billboardHot100 <- billboardHot100 %>% 
    group_by(artist, song) %>%
    mutate(
        
        date = as.Date(median(as.numeric(as.Date(date)))), 
        
        mean_rank = round(mean(rank, na.rm = TRUE)),
        
        peak_rank = ifelse(all(is.na(peak_rank)), NA, max(peak_rank, na.rm = TRUE)),
        
        weeks_on_board = ifelse(all(is.na(weeks_on_board)), NA, max(weeks_on_board, na.rm = TRUE))
    ) %>%
    select(-rank) %>% 
    distinct(artist, song, .keep_all = TRUE) %>%
    ungroup()
data.frame(colMeans(is.na(billboardHot100)))

#clean grammyAlbums

data.frame(colMeans(is.na(grammyAlbums))) # 3% of artists are null
colnames(grammyAlbums) <- tolower(colnames(grammyAlbums))
grammyAlbums <- grammyAlbums %>% select(-x) %>% filter(!is.na(artist)) %>% rename(grammy_year = grammyyear, grammy_award = award) %>% select(artist,genre,album,grammy_year,grammy_award) %>% arrange(artist)

#clean grammySongs

colnames(grammySongs) <- tolower(colnames(grammySongs))
grammySongs <- grammySongs[,3:7]
grammySongs <- grammySongs %>% rename(song = name, grammy_year = grammyyear, grammy_award = grammyaward) %>% select(artist,song,genre,grammy_year,grammy_award)
sum(duplicated(grammySongs[,c(1,2,4,5)])) #no meaningless duplicated artist-song-year-award quadruples
grammySongs <- grammySongs %>% arrange(artist,song,grammy_year,grammy_award)

colMeans(is.na(grammySongs)) # ~10 NULL artist names, just omit
grammySongs <- grammySongs %>% filter(!is.na(artist))
#no NULL now
# clean riaaAlbumCerts, riaaSingleCerts
# we don't need this certs
rm(riaaAlbumCerts)
rm(riaaSingleCerts)

# clean songAttributes
colnames(songAttributes) <- tolower(colnames(songAttributes))
data.frame(sapply(songAttributes,class))
songAttributes[,c("acousticness","instrumentalness")] <- format(songAttributes[,c("acousticness","instrumentalness")], scientific = FALSE)
songAttributes <- songAttributes %>% mutate(explicit = ifelse(explicit == "False",0,1)) %>% select(-x) %>% rename(song = name, duration_ms = duration,time_signature = timesignature, is_explicit = explicit) %>% select(artist,album,song,everything()) %>% arrange(artist,album,song)

sum(duplicated(songAttributes[,c("artist","album","song")]))/nrow(songAttributes) # 0.2% duplicate artist-album-song triples so we take distincts
data.frame(colMeans(is.na(songAttributes))) #0.0006 % NULL for songs
songAttributes <- songAttributes %>% filter(!is.na(song)) %>% distinct(artist,album,song,.keep_all = TRUE)


# clean spWeeklyTop200
showDataSource(41)
spWeeklyTop200$Week <- paste(as.character(year((as.Date(spWeeklyTop200$Week)))),as.character(week((as.Date(spWeeklyTop200$Week)))),sep = "/")
colnames(spWeeklyTop200) <- tolower(colnames(spWeeklyTop200))
colnames(spWeeklyTop200)
spWeeklyTop200 <- spWeeklyTop200 %>% select(-x) %>% rename(song = name, stream_week = week,) %>% mutate(featured = as.numeric(!is.na(features))) %>% select(artist,song,featured,features,streams,stream_week) %>% arrange(artist,song)
data.frame(colMeans(is.na(spWeeklyTop200)))
sapply(spWeeklyTop200,class)
spWeeklyTop200 <- spWeeklyTop200 %>%
    mutate(
        stream_year = map_chr(str_split(stream_week, "/"), 1), # Extract the year part
        stream_week = map_chr(str_split(stream_week, "/"), 2)  # Extract the week part
    ) %>% select(artist,song,featured,features,streams,stream_year,stream_week)
sum(duplicated(spWeeklyTop200[,c(1,2,6,7)]))/nrow(spWeeklyTop200) # 0.1% duplicated artist-song-stream_year-stream_week quadruples. so we just take distincts
spWeeklyTop200 <- spWeeklyTop200 %>% distinct(artist,song,stream_year,stream_week,.keep_all = TRUE)

colMeans(is.na(spWeeklyTop200 %>% select(-features))) #all 0


# List of dataframes with their actual names
dfs <- list(artists = artists, 
            billboardHot100 = billboardHot100, 
            grammyAlbums = grammyAlbums, 
            grammySongs = grammySongs, 
            songAttributes = songAttributes, 
            spWeeklyTop200 = spWeeklyTop200)

# Create a summary dataframe with information about each dataframe
df_info <- lapply(dfs, function(df) {
    data.frame(
        n_rows = nrow(df),
        n_cols = ncol(df),
        col_names = paste(colnames(df), collapse = ", ")
    )
})

# Combine the list into a single dataframe
df_info <- do.call(rbind, df_info)
df_info <- data.frame(df_name = rownames(df_info), df_info, row.names = NULL)

#let's analyze dfs together and first see the numbers of shared artist-song pairs

df_info$n_artist_song <- sapply(df_info$df_name,function(x){
    ifelse("song" %in% colnames(get(x)),return(n_distinct(get(x)[,c("artist","song")])),return(n_distinct(get(x)[,"artist"])))
})

df_info <- df_info %>% arrange(-n_artist_song)

sort(unique(strsplit(gsub(" ","",paste(df_info$col_names,collapse=",")),split = ",")[[1]])) #flagged: genres!


df_info$new_columns <- rep(NA,nrow(df_info))
for(i in seq_len(nrow(df_info))){
    if(i == 1){
        next
    }else{
        df_info[i,]$new_columns = paste(setdiff(strsplit(df_info[i,]$col_names,", ")[[1]],strsplit(paste(df_info[2:i-1,]$col_names, collapse = ", "),", ")[[1]]), collapse = ", ")
    }
}

df_info$repeated_columns <- rep(NA,nrow(df_info))
for(i in seq_len(nrow(df_info))){
    if(i == 1){
        next
    }else{
        df_info[i,]$repeated_columns = paste(intersect(strsplit(df_info[i,]$col_names,", ")[[1]],strsplit(paste(df_info[2:i-1,]$col_names, collapse = ", "),", ")[[1]]), collapse = ", ")
    }
}

# Now we combine dfs using outer joins and obtain reduced data41
combined_df <- get(df_info$df_name[1]) %>% full_join(get(df_info$df_name[2]),by = c("artist","song"),relationship = "many-to-many") %>% full_join(get(df_info$df_name[3]),by = c("artist","song"),relationship = "many-to-many", suffix = c("_bb","_sp")) %>% full_join(get(df_info$df_name[4]),by = "artist",relationship = "many-to-many", suffix = c("_bb","_art")) %>% full_join(get(df_info$df_name[5]),by = "artist",relationship = "many-to-many", suffix = c("_sa_bb_art", "_ga")) %>% full_join(get(df_info$df_name[6]),by = c("artist","song"),relationship = "many-to-many", suffix = c("_sa_bb_art_ga","_gs"))

data41_reduced <- combined_df %>% distinct()
nulls <- data.frame(colMeans(is.na(data41_reduced)))
nulls <- nulls %>% rename(prop = colMeans.is.na.data41_reduced..)
selected_columns <- rownames(nulls %>% filter(prop < 0.7)) # we omit colums with null prop >= 0.7
data41_reduced <- data41_reduced %>% select(all_of(selected_columns))
setdiff(colnames(data41_reduced),cmlt_colnames)
data41_reduced <- data41_reduced %>% rename(album = album_sa_bb_art, genre = genre_art)
sum(duplicated(data41_reduced %>% distinct(artist, album, song))) #no duplicated artist-album-song triples

# Most of the data came from songAttributes data frame and we got gender, genre and followers from artists data frame. this is normal because of low number of artist-album-song triples in other data frames. however we will keep this data since further analysis needs might occur with new data

# artists <- data41[[1]]
# billboardHot100 <- data41[[2]]
# grammyAlbums <- data41[[3]]
# grammySongs <- data41[[4]]
# riaaAlbumCerts <- data41[[5]]
# riaaSingleCerts <- data41[[6]]
# songAttributes <- data41[[7]]
# spWeeklyTop200 <- data41[[8]]

data41_artists <- artists
data41_billboardHot100 <- billboardHot100
data41_grammyAlbums <- grammyAlbums
data41_grammySongs <- grammySongs
data41_songAttributes <- songAttributes
data41_spWeeklyTop200 <- spWeeklyTop200
rm(artists,billboardHot100,grammyAlbums,grammySongs,songAttributes,spWeeklyTop200)

rm(combined_df,df_info,dfs,differences,nulls,sorted_dfs,x,files,i,selected_columns)

sapply(sapply(ls(pattern = "data41_"),get),save_rd_info)
reduced_data_info[47:53,]$data <- ls(pattern = "data41_")



