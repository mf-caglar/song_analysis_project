# Create a function to process a single channel
calculate_acousticness <- function(audio_channel, sample_rate = 24000) {
    chunk_size <- sample_rate  # 1 second chunks
    chunks <- split(audio_channel, ceiling(seq_along(audio_channel) / chunk_size))
    num_cores <- detectCores() - 1  # Use all cores minus one to keep system responsive
    cl <- makeCluster(num_cores)
    
    # Use parLapply to apply FFT to each chunk in parallel
    fft_results <- parLapply(cl, chunks, function(chunk) fft(chunk))
    
    # Stop the cluster
    stopCluster(cl)
    
    # Calculate FFT magnitudes
    fft_magnitudes <- lapply(fft_results, function(fft_chunk) abs(fft_chunk))
    
    # Spectral centroid calculation
    spectral_centroid <- function(fft_chunk, sample_rate) {
        freqs <- seq(0, length(fft_chunk) - 1) * (sample_rate / length(fft_chunk))  # Frequency bins
        magnitudes <- abs(fft_chunk)  # Magnitudes
        sum(magnitudes * freqs) / sum(magnitudes)  # Weighted mean of frequencies
    }
    
    # Spectral flatness calculation
    spectral_flatness <- function(fft_chunk) {
        magnitudes <- abs(fft_chunk)
        exp(mean(log(magnitudes))) / mean(magnitudes)
    }
    
    # Low/high frequency ratio calculation
    low_high_ratio <- function(fft_chunk, sample_rate, cutoff_freq = 2000) {
        freqs <- seq(0, length(fft_chunk) - 1) * (sample_rate / length(fft_chunk))
        magnitudes <- abs(fft_chunk)
        
        # Low frequency energy (< cutoff_freq)
        low_freq_energy <- sum(magnitudes[freqs <= cutoff_freq])
        
        # High frequency energy (> cutoff_freq)
        high_freq_energy <- sum(magnitudes[freqs > cutoff_freq])
        
        return(low_freq_energy / high_freq_energy)
    }
    
    # Apply calculations to each chunk
    centroids <- sapply(fft_results, spectral_centroid, sample_rate = sample_rate)
    flatness <- sapply(fft_results, spectral_flatness)
    ratios <- sapply(fft_results, low_high_ratio, sample_rate = sample_rate)
    
    # Calculate mean values
    mean_centroid <- mean(centroids, na.rm = TRUE)
    mean_flatness <- mean(flatness, na.rm = TRUE)
    mean_ratio <- mean(ratios, na.rm = TRUE)
    
    # Determine if the channel is acoustic or synthetic
    if (mean_centroid < 2000 && mean_flatness < 0.3 && mean_ratio > 2) {
        return("acoustic")
    } else {
        return("synthetic or electronic")
    }
}