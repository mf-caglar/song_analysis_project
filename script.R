# import data files
data <- dir("data")
data <- data[sapply(data, tools::file_ext) == "csv"]
csvs <- list()
for(i in seq_along(data)){
    csvs[[i]] <- read.csv(paste("data/", data[[i]], sep = ""))
}
dims <- list()
for(i in seq_along(csvs)){
    dims[[i]] <- dim(csvs[[i]])
}
nrows <- unlist(lapply(dims, `[`, 1))  # Convert list to vector
ncols <- unlist(lapply(dims, `[`, 2))  # Convert list to vector
col_names <- list()
for(i in seq_along(csvs)){
    col_names[[i]] <- paste(colnames(csvs[[i]]), collapse = ";")
}
col_names <- unlist(col_names)
data_info <- data.frame(nrow = nrows, ncol = ncols, col_names = col_names)
data_info <- data_info[order(-data_info$nrow),]
data_index <- as.numeric(rownames(data_info))
csvs <- csvs[data_index]
data_info$data <- 1:36
data <- data[as.numeric(rownames(data_info))]
rownames(data_info) <- 1:36
data_index <- 1:50
# function to see info about data
showDataSource <- function(i) {
    dataset_links <- readLines("dataset_links.txt", warn = FALSE)
    if (i > length(dataset_links)) {
        return(paste0("Data file: ", data[[data_index[[i]]]], " Dataset link: ", "Not exists"))
    }else if(length(data)<i){
        return(substring(dataset_links[i],9))
    }else{
        return(paste0("Data file: ", data[[data_index[[i]]]], " Dataset link: ", substring(dataset_links[i],9)))
    }
    
}

# collect info about reduce data
reduced_data_info <- data.frame(data = character(), nrow = numeric(),ncol = numeric(),features = character())

# populate reduced_data_info
save_rd_info <- function(data, change = NA, insert = NA){
    if(! is.na(change)){
        reduced_data_info[change,] <<- c(deparse(substitute(data)),nrow(data),ncol(data),paste(colnames(data),collapse = " , "))
    }else if(! is.na(insert)){
        reduced_data_info <- rbind(reduced_data_info[1:insert-1,],c(deparse(substitute(data)),nrow(data),ncol(data),paste(colnames(data),collapse = " , ")),reduced_data_info[insert:nrow(reduced_data_info),])
    }else{
        reduced_data_info <<- rbind(reduced_data_info,c(deparse(substitute(data)),nrow(data),ncol(data),paste(colnames(data),collapse = " , ")))
    }
}

# collect cumulative colnames
cmlt_colnames <- c()
gather_colnames <- function() {
    cmlt_colnames <<- sort(unique(unlist(strsplit(paste(reduced_data_info$features, collapse = " , "), split = " , "))))
}

# see which dfs have a specific column 
check_col <- function(col){
    cols_df <- reduced_data_info %>%
        filter(sapply(strsplit(features, " , "), function(x) col %in% x))
    
    return(unique(na.omit(cols_df$data)))
}

# add json data in a column as separate columns to a df
get_json_data <- function(data, column, parser){
    null_count <- 0
    col <- data[, column]
    json_df <- data.frame()
    
    parse_json <- function(value_str){
        if (is.na(value_str)) {
            null_count <<- null_count + 1
            
            
            if (ncol(json_df) > 0) {
                na_row <- as.data.frame(matrix(NA, nrow = 1, ncol = ncol(json_df)))
                colnames(na_row) <- colnames(json_df)
            } else {
                na_row <- data.frame()  
            }
            return(na_row)
        } else {
            json_string <- gsub(parser, "\"", value_str)
            json_list <- fromJSON(json_string)
            json_df <- as.data.frame(json_list)
            json_melted <- melt(json_df, id.vars = "provider", na.rm = TRUE)
            new_colnames <- paste(json_melted$provider, json_melted$variable, sep = "_")
            new_values <- t(json_melted$value)
            colnames(new_values) <- new_colnames
            final_df <- as.data.frame(new_values)
            return(final_df)
        }
    }
    
    for (i in seq_len(length(col))) {
        parsed_row <- parse_json(col[i])
        json_df <- bind_rows(json_df, parsed_row)
    }
    
    print(paste("There are", null_count, "null values in the column."))
    return(json_df)
}


rm(ncols,nrows,col_names,i,dims)

reduced_data_info <- reduced_data_info %>% mutate(nrow = as.numeric(nrow),ncol = as.numeric(ncol))





