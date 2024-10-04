library(data.table)
data44 <- fread("data/data48_spotify_huge_database/DatabasetoCalculatePopularity.csv",na.strings = c(""," ",NA,"?","*","."))
final <- read.csv("data/data48_spotify_huge_database/FinalDatabase.csv")

data44_reduced <- data44 %>% select(-V1)
format(data.frame(colMeans(is.na(data44_reduced))),scientific = FALSE) # just omit nulls
data44_reduced <- na.omit(data44_reduced)
data44_reduced[] <- lapply(data44_reduced, function(x) {
    if (is.character(x)) {
        trimws(x)
    } else {
        x
    }
})
setdiff(colnames(data44_reduced),cmlt_colnames)
data44_reduced <- data44_reduced %>% select(-track) %>% rename(sp_track_id = uri, song =title, chart_date = date) %>% mutate(sp_track_id = unlist(strsplit(sp_track_id,split = "/"))[5])

nrow(data44_reduced %>% distinct(artist,song,country,chart_date,position)) #equal to nrow
length(unique(data44_reduced$position))

data44_reduced <- data44_reduced %>% select(artist,song,country,chart_date,position,sp_track_id) %>% arrange(artist,song,country,chart_date,position)

colnames(final) <- tolower(colnames(final))
setdiff(colnames(final),cmlt_colnames)

# there are so many columns in final dataset more than we need and most of them are dummies. there are valus given by different sentiment analysis measures and normalizations of these etc. so I will omit most of the columns and give a complete reference for initial column names to go back later as needed.

#complete column descriptions:
# Column descriptions for the Spotify dataset

# 1. country: Country where the song is charting (or 'global' for global charts) --- retain
# 2. uri: Unique Spotify URI (Uniform Resource Indicator) for the track --- retain (mutate to sp_track_id by applying unlist(strsplit(uri,split = "/"))[5] and remove the original one)
# 3. popularity: Custom popularity score based on song’s chart position and duration in the Top 200 ---dismiss
# 4. title: The title of the song --- retain (rename to song)
# 5. artist: Name of the artist performing the song --- retain
# 6. album.single: Indicates whether the track is part of an album, single, or compilation --- retain(rename to album_type)
# 7. genre: The main genre of the artist, as classified by Spotify --- retain
# 8. artist_followers: Number of followers the artist had on Spotify as of November 5, 2020 --- retain (rename to followers)
# 9. explicit: Whether the track is marked as explicit (TRUE/FALSE) --- retain (rename to is_explicit)
# 10. album: Name of the album the track belongs to --- retain
# 11. release_date: The original release date of the track --- retain
# 12. track_number: Position of the track on its album --- dismiss
# 13. tracks_in_album: Total number of tracks in the album --- dismiss
# 14. danceability: Value (0.0 to 1.0) indicating how danceable the track is --- retain
# 15. energy: Measure (0.0 to 1.0) representing track's intensity and activity --- retain
# 16. key: Musical key of the track (integer corresponding to standard pitch class notation) --- retain
# 17. loudness: Average loudness of the track in decibels (dB) --- retain
# 18. mode: Modality of the track (1 for major, 0 for minor) --- retain
# 19. speechiness: Measures the presence of spoken words in the track --- retain
# 20. acoustics: Confidence measure (0.0 to 1.0) that the track is acoustic  --- retain (rename to acousticness)
# 21. instrumentalness: Value predicting whether the track contains no vocals (0.0 to 1.0) --- retain
# 22. liveliness: Detects if the track was performed live (values over 0.8 suggest live performance) --- retain
# 23. valence: Value (0.0 to 1.0) describing how positive the track sounds --- retain
# 24. tempo: The overall tempo of the track in beats per minute (BPM) --- retain
# 25. duration_ms: Duration of the track in milliseconds --- retain
# 26. time_signature: Estimated overall time signature (number of beats per measure) --- retain
# 27. genre_new: Reclassification of the artist's predominant genre based on Spotify’s genres --- dismiss
# 28. days_since_release: Number of days since the track's release --- retain
# 29. released_after_2017: Dummy variable (1 if released after 2017, 0 otherwise) --- dismiss
# 30. explicit_false: Binary flag for non-explicit tracks --- dismiss
# 31. explicit_true: Binary flag for explicit tracks --- dismiss
# 32. album: Duplicate of the album column (possible mix-up) --- dismiss
# 33. compilation: Binary flag indicating if the track belongs to a compilation  --- dismiss
# 34. single: Binary flag indicating if the track was released as a single  --- dismiss
# 35. bolero: Binary flag indicating if the track belongs to the Bolero genre  --- dismiss
# 36. boy.band: Binary flag indicating if the track is performed by a boy band --- dismiss
# 37. country: Duplicate of the country column  --- dismiss
# 38. dance.electronic: Binary flag for tracks belonging to the dance/electronic genre --- dismiss
# 39. else.: Catch-all category for tracks that don't fit predefined genres --- dismiss
# 40. funk: Binary flag indicating if the track belongs to the funk genre --- dismiss
# 41. hip.hop: Binary flag for hip-hop tracks --- dismiss
# 42. house: Binary flag for house tracks --- dismiss
# 43. indie: Binary flag for indie tracks --- dismiss
# 44. jazz: Binary flag for jazz tracks --- dismiss
# 45. k.pop: Binary flag for K-pop tracks --- dismiss
# 46. latin: Binary flag for Latin tracks --- dismiss
# 47. metal: Binary flag for metal tracks --- dismiss
# 48. opm: Binary flag for Original Pilipino Music (OPM) genre --- dismiss
# 49. pop: Binary flag for pop tracks --- dismiss
# 50. r.b.soul: Binary flag for R&B/soul tracks --- dismiss
# 51. rap: Binary flag for rap tracks --- dismiss
# 52. reggae: Binary flag for reggae tracks --- dismiss
# 53. reggaeton: Binary flag for reggaeton tracks --- dismiss
# 54. rock: Binary flag for rock tracks --- dismiss
# 55. trap: Binary flag for trap tracks --- dismiss

# Sentiment Analysis and NLP-based Features
# 56. syuzhet_norm: Normalized sentiment score based on the Syuzhet library (-1 to 1 scale) --- dismiss
# 57. bing_norm: Normalized sentiment score using Bing lexicon --- dismiss
# 58. afinn_norm: Normalized sentiment score using AFINN lexicon --- dismiss
# 59. nrc_norm: Normalized sentiment score using NRC lexicon --- dismiss
# 60. syuzhet: Raw sentiment score using Syuzhet library --- dismiss
# 61. bing: Raw sentiment score using Bing lexicon --- dismiss
# 62. afinn: Raw sentiment score using AFINN lexicon --- dismiss
# 63. nrc: Raw sentiment score using NRC lexicon --- dismiss
# 64. anger: Number of words related to anger (NRC lexicon) --- dismiss
# 65. anticipation: Number of words related to anticipation (NRC lexicon) --- dismiss
# 66. disgust: Number of words related to disgust (NRC lexicon) --- dismiss
# 67. fear: Number of words related to fear (NRC lexicon) --- dismiss
# 68. joy: Number of words related to joy (NRC lexicon) --- dismiss
# 69. sadness: Number of words related to sadness (NRC lexicon) --- dismiss
# 70. surprise: Number of words related to surprise (NRC lexicon) --- dismiss
# 71. trust: Number of words related to trust (NRC lexicon) --- dismiss
# 72. negative: Count of negative words from sentiment lexicons --- dismiss
# 73. positive: Count of positive words from sentiment lexicons --- dismiss
# 74. n_words: Total number of words in the lyrics --- dismiss

# Normalized Emotion Scores (NRC Lexicon)
# 75. anger_norm: Normalized count of anger-related words --- dismiss
# 76. anticipation_norm: Normalized count of anticipation-related words --- dismiss
# 77. disgust_norm: Normalized count of disgust-related words --- dismiss
# 78. fear_norm: Normalized count of fear-related words --- dismiss
# 79. joy_norm: Normalized count of joy-related words --- dismiss
# 80. sadness_norm: Normalized count of sadness-related words --- dismiss
# 81. surprise_norm: Normalized count of surprise-related words --- dismiss
# 82. trust_norm: Normalized count of trust-related words --- dismiss
# 83. negative_norm: Normalized count of negative words --- dismiss
# 84. positive_norm: Normalized count of positive words --- dismiss

# Additional Normalized Emotion Scores (Secondary Calculations)
# 85. anger_norm2: Secondary normalized score for anger-related words --- dismiss
# 86. anticipation_norm2: Secondary normalized score for anticipation-related words --- dismiss
# 87. disgust_norm2: Secondary normalized score for disgust-related words --- dismiss
# 88. fear_norm2: Secondary normalized score for fear-related words --- dismiss
# 89. joy_norm2: Secondary normalized score for joy-related words --- dismiss
# 90. sadness_norm2: Secondary normalized score for sadness-related words --- dismiss
# 91. surprise_norm2: Secondary normalized score for surprise-related words --- dismiss
# 92. trust_norm2: Secondary normalized score for trust-related words --- dismiss
# 93. negative_norm2: Secondary normalized score for negative words --- dismiss
# 94. positive_norm2: Secondary normalized score for positive words --- dismiss

# Bayesian Sentiment and Topic Analysis
# 95. negative_bog_jr: Bayesian score for negative sentiment (bag-of-words model) --- dismiss
# 96. positive_bog_jr: Bayesian score for positive sentiment (bag-of-words model) --- dismiss
# 97. bayes: Tone of the lyrics according to Bayesian approach (-1 to 1 scale) --- dismiss
# 98. negative_bayes: Bayesian probability of negative sentiment --- dismiss
# 99. neutral_bayes: Bayesian probability of neutral sentiment --- dismiss
# 100. positive_bayes: Bayesian probability of positive sentiment --- dismiss
# 101. lda_topic: Topic assignment using Latent Dirichlet Allocation (LDA) --- dismiss

# LDA-based Topics in English-speaking countries
# 102-109. celebrate, desire, explore, fun, hope, love, nostalgia, thug: Binary flags for topics related to song lyrics based on LDA analysis  --- dismiss

# Country-specific Features
# 103-139. Country flags (e.g., argentina, brazil, usa, uk, etc.): Binary flags indicating if the track charted in that specific country ---dismiss

# Track Popularity and Clustering
# 140. popu_max: Highest position the track reached in the charts --- retain(rename to peak_rank)
# 141. top10_dummy: Binary flag indicating if the track reached the Top 10  --- dismiss
# 142. top50_dummy: Binary flag indicating if the track reached the Top 50 --- dismiss
# 143. cluster: Clustering assignment for the track (likely related to popularity or genre)  --- dismiss

final <- final %>% select(-c(32,37))
# Modify the final dataset based on the instructions
data44_final_reduced <- final %>%
    # Retain necessary columns, rename as needed
    select(
        country,                             # Retain
        uri,                                 # Retain, mutate later
        title,                               # Retain and rename to song
        artist,                              # Retain
        album.single,                        # Retain and rename to album_type
        genre,                               # Retain
        artist_followers,                    # Retain and rename to followers
        explicit,                            # Retain and rename to is_explicit
        album,                               # Retain
        release_date,                        # Retain
        danceability,                        # Retain
        energy,                              # Retain
        key,                                 # Retain
        loudness,                            # Retain
        mode,                                # Retain
        speechiness,                         # Retain
        acoustics,                           # Retain and rename to acousticness
        instrumentalness,                    # Retain
        liveliness,                          # Retain
        valence,                             # Retain
        tempo,                               # Retain
        duration_ms,                         # Retain
        time_signature,                      # Retain
        days_since_release,                  # Retain
        popu_max                             # Retain and rename to peak_rank
    ) %>%
    # Renaming the columns
    rename(
        sp_track_id = uri,
        song = title,
        album_type = album.single,
        followers = artist_followers,
        is_explicit = explicit,
        acousticness = acoustics,
        peak_rank = popu_max
    ) %>%
    # Mutate sp_track_id: extracting the 5th part of the URI
    mutate(sp_track_id = unlist(lapply(strsplit(sp_track_id, "/"), `[`, 5)))

data44_final_reduced <- na.omit(data44_final_reduced)
data44_final <- final
rm(final)
rm(data44_reduced)

save_rd_info(data44_reduced)
save_rd_info(data44_final_reduced)
gather_colnames()

