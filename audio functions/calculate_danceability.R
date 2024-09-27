## calculating danceability

# Calculate tempo using autocorrelation

calculate_tempo <- function(audio_channel, sample_rate = 24000) {
    # Check if the audio channel is valid and has length
    if (!is.numeric(audio_channel) || length(audio_channel) == 0) {
        return(NA)
    }
    
    # Perform autocorrelation on the audio signal
    ac <- tryCatch({
        autoc(audio_channel, f = sample_rate)
    }, error = function(e) {
        message("Error in autocorrelation: ", e)
        return(NA)
    })
    
    # Ensure that ac is a valid object
    if (is.na(ac[1])) {
        return(NA)
    }
    
    # Find peaks in autocorrelation to estimate the fundamental frequency
    peaks <- tryCatch({
        fpeaks(ac)
    }, error = function(e) {
        message("Error in peak detection: ", e)
        return(NA)
    })
    
    # Check if valid peaks were found
    if (is.null(peaks) || length(peaks) == 0) {
        message("No peaks detected in autocorrelation.")
        return(NA)
    }
    
    # Convert the first peak to a fundamental frequency (assuming periodicity)
    fundamental_freq <- 1 / peaks[1, 1]  # First peak gives the strongest periodicity
    
    # Convert the fundamental frequency to BPM
    bpm <- fundamental_freq * 60  # Convert to BPM
    
    return(bpm)
}



# Function to detect beats
detect_beats <- function(audio_channel, sample_rate = 24000) {
    # Calculate the envelope of the signal
    env_signal <- env(audio_channel, f = sample_rate, fastdisp = TRUE)  # Use fast display for performance
    
    # Normalize the envelope
    env_signal <- env_signal / max(env_signal, na.rm = TRUE)
    
    # Apply threshold and detect local maxima
    threshold <- 0.1  # Define a threshold to detect significant peaks
    # Use diff twice to detect peaks (local maxima)
    first_diff <- diff(env_signal)
    second_diff <- diff(sign(first_diff))
    
    # Ensure correct length matching by using -2 index shift properly
    peaks <- which(second_diff == -2 & env_signal[-(1:2)] > threshold)
    
    # Return the number of peaks as an indicator of beat strength
    return(length(peaks))
}



# Calculate danceability as a combination of tempo, beat strength, and regularity
calculate_danceability <- function(audio_channel, sample_rate = 24000) {
    tempo <- calculate_tempo(audio_channel, sample_rate)
    beat_strength <- detect_beats(audio_channel, sample_rate)
    
    # Combine these factors into a weighted score (adjust weights as needed)
    if (!is.na(tempo) && beat_strength > 0) {
        danceability_score <- (0.4 * tempo / 120) + (0.6 * beat_strength / max(beat_strength))
        return(min(danceability_score, 1))  # Cap danceability score at 1
    } else {
        return(NA)
    }
}