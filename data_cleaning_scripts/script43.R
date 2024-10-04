songs <- read.csv("data/data47_beats_dataset/beatsdataset_songs.csv")
beats2016 <- read.csv("data/data47_beats_dataset/beatsdataset2016nov_full.csv")
beats2018 <- read.csv("data/data47_beats_dataset/beatsdataset2018feb_full.csv")
#relate to paper for detailed explanation of features: https://www.tandfonline.com/doi/full/10.1080/09298215.2020.1761399

# a clean data already. but it's useless for us since it's old and lacks song data for newer data set. 
data43_songs <- songs
data43_old_beats <- beats2016
data43_new_beats <- beats2018

rm(songs,beats2016,beats2018)