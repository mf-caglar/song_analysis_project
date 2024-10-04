data21 <- csvs[[21]]
data21_reduced <- data21
colnames(data21_reduced) <- tolower(colnames(data21_reduced))
showDataSource(21)
"
Rank: Rank given by JazzStandards.com to each of the standards. (See: https://www.jazzstandards.com/overview.ranking.html)
Title: Title of the jazz standard.
Year: The year of that the song was first published.
Composer(s): Composer(s) of the jazz standard.
Lyricisit(s): Lyricist(s) of the jazz standard.
URL: URL of the jazz standard on JazzStandards.com website.
"
colnames(data21_reduced) <- c("rank","song","release_year","composer_s","lyricist_s","url")
data21_reduced$genre <- rep("jazz",nrow(data21_reduced))
save_rd_info(data21_reduced)
gather_colnames()
