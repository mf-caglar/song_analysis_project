data19 <- csvs[[19]]
data19_reduced <- data19
colnames(data19_reduced) <- tolower(colnames(data19_reduced))
showDataSource(19)

# I omit data19 since there is a better version on the net
rm(data19_reduced)
data19_omitted <- data19
rm(data19)
