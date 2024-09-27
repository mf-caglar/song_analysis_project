# List CSV files in the "data" directory
data <- dir("data")

# Filter only CSV files
data <- data[sapply(data, tools::file_ext) == "csv"]

# Initialize lists
csvs <- list()

# Load CSVs into the list
for(i in seq_along(data)){
    csvs[[i]] <- read.csv(paste("data/", data[[i]], sep = ""))
}

dims <- list()
for(i in seq_along(csvs)){
    dims[[i]] <- dim(csvs[[i]])
}
# Extract number of rows and columns
nrows <- unlist(lapply(dims, `[`, 1))  # Convert list to vector
ncols <- unlist(lapply(dims, `[`, 2))  # Convert list to vector

# Initialize col_names list
col_names <- list()

# Concatenate column names of each CSV into a single string separated by ";"
for(i in seq_along(csvs)){
    col_names[[i]] <- paste(colnames(csvs[[i]]), collapse = ";")
}

# Convert col_names list to a character vector
col_names <- unlist(col_names)

# Create the data frame
data_info <- data.frame(nrow = nrows, ncol = ncols, col_names = col_names)

data_info <- data_info[order(-data_info$nrow),]
data_index <- as.numeric(rownames(data_info))
csvs <- csvs[data_index]
rm(dims)


showDataSource <- function(i) {
    # Read dataset links from the file
    dataset_links <- readLines("dataset_links.txt", warn = FALSE)
    
    # Ensure i is within bounds of dataset_links
    if (i > length(dataset_links)) {
        return(paste0("Data file: ", data[[data_index[[i]]]], " Dataset link: ", "Not exists"))
    }
    
    # Assuming data and index are defined globally or elsewhere in the code
    return(paste0("Data file: ", data[[data_index[[i]]]], " Dataset link: ", substring(dataset_links[i],9)))
}

rm(ncols,nrows,col_names)
rm(i)


cmlt_colnames <- c()
gather_colnames <- function() {
    cmlt_colnames <<- sort(unique(unlist(strsplit(paste(reduced_data_info$features, collapse = " , "), split = " , "))))
}

reduced_data_info <- data.frame(data = rep(NA,50), nrow = rep(NA,50),ncol = rep(NA,50),features = rep(NA,50))

save_rd_info <- function(data,i){
    reduced_data_info[i,] <<- c(deparse(substitute(data)),nrow(data),ncol(data),paste(colnames(data),collapse = " , "))
}

get_json_data <- function(data, column, parser){
    null_count <- 0
    col <- data[, column]
    json_df <- data.frame()
    
    parse_json <- function(value_str){
        if (is.na(value_str)) {
            null_count <<- null_count + 1
            
            # Return a row of NAs with the correct number of columns (same as json_df)
            if (ncol(json_df) > 0) {
                na_row <- as.data.frame(matrix(NA, nrow = 1, ncol = ncol(json_df)))
                colnames(na_row) <- colnames(json_df)
            } else {
                na_row <- data.frame()  # Return empty if json_df is empty
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



check_col <- function(col){
    cols_df <- reduced_data_info %>%
        filter(sapply(strsplit(features, " , "), function(x) col %in% x))
    
    return(unique(na.omit(cols_df$data)))
}






