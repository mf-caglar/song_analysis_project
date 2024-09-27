library(parallel)
# Function to estimate the key using pitch detection from FFT results
estimate_key <- function(audio_channel, sample_rate = 24000) {
    chunk_size <- sample_rate  # 1-second chunks
    chunks <- split(audio_channel, ceiling(seq_along(audio_channel) / chunk_size))
    num_cores <- detectCores() - 1  # Use all cores minus one to keep system responsive
    cl <- makeCluster(num_cores)
    
    # Use parLapply to apply FFT to each chunk in parallel
    fft_results <- parLapply(cl, chunks, function(chunk) {
        fft(chunk)
    })
    
    # Stop the cluster
    stopCluster(cl)
    
    # Step 1: Extract the amplitude and corresponding frequencies from FFT
    fft_peaks <- lapply(fft_results, function(fft_chunk) {
        # Calculate the magnitude of the FFT result
        magnitude <- abs(fft_chunk)
        
        # Only keep the first half of the FFT result (positive frequencies)
        magnitude <- magnitude[1:(length(magnitude) / 2)]
        
        # Generate the corresponding frequency bins for this chunk
        freq_bins <- seq(0, sample_rate / 2, length.out = length(magnitude))
        
        # Ensure that freq_bins and magnitude are properly structured
        if (any(is.na(freq_bins)) || is.null(freq_bins)) {
            stop("freq_bins contains NA or NULL values")
        }
        if (any(is.na(magnitude)) || is.null(magnitude)) {
            stop("magnitude contains NA or NULL values")
        }
        
        # Check if freq_bins is a vector and its class
        print(paste("Class of freq_bins:", class(freq_bins)))
        print(paste("Length of freq_bins:", length(freq_bins)))
        
        # Ensure the lengths of freq_bins and magnitude are the same
        if (length(magnitude) == length(freq_bins)) {
            # Check if freq_bins is properly structured
            if (!is.null(freq_bins) && !any(is.na(freq_bins))) {
                # Find the peaks in the spectrum
                peaks <- fpeaks(magnitude, f = freq_bins, nmax = 12)  # Get top 12 prominent frequencies
                return(peaks)
            } else {
                stop("freq_bins is not structured correctly for fpeaks()")
            }
        } else {
            stop("Length mismatch between magnitude and frequency bins")
        }
    })
    
    # Step 2: Combine the peaks from all chunks
    all_frequencies <- unlist(lapply(fft_peaks, function(x) x[, 1]))  # Extract the frequency column
    
    # Step 3: Map frequencies to musical notes
    note_names <- c("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B")
    note_freqs <- 440 * 2^((0:11 - 9) / 12)  # Generate frequencies for A4 = 440 Hz
    
    detected_notes <- sapply(all_frequencies, function(freq) {
        note_idx <- which.min(abs(note_freqs - freq))  # Find the closest note
        return(note_names[note_idx])
    })
    
    # Step 4: Analyze the distribution of notes
    note_distribution <- table(detected_notes)
    
    # Return the estimated frequencies, notes, and their distribution
    return(list(frequencies = all_frequencies, notes = detected_notes, distribution = note_distribution))
}


# Apply the function to the left audio channel
key_estimation <- estimate_key(downsampled_audio_left@left, sample_rate = downsampled_audio_left@samp.rate)

# Print the detected frequencies and notes
print(key_estimation$frequencies)
print(key_estimation$notes)
print(key_estimation$distribution)
