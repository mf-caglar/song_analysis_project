library(Spectrum)
library(tuneR)
library(seewave)
library(av)
# Calculate RMS Energy
calculate_energy <- function(audio_channel) {
    # Normalize the audio channel to avoid overflow
    normalized_audio <- audio_channel / max(abs(audio_channel))
    
    # Calculate RMS energy: sqrt of the mean of squared amplitudes
    rms_energy <- sqrt(mean(normalized_audio^2))
    
    return(rms_energy)
}

# Apply the function to both left and right channels
energy_left <- calculate_energy(audio@left)
energy_right <- calculate_energy(audio@right)

# Average the energy of both channels (if stereo)
mean_energy <- mean(c(energy_left, energy_right))

# Output the energy score
print(paste("Energy of the left channel:", energy_left))
print(paste("Energy of the right channel:", energy_right))
print(paste("Mean energy of the song:", mean_energy))


# Function to calculate spectral flux
calculate_spectral_flux <- function(audio_channel, sample_rate = 24000) {
    # Compute the spectrogram using seewave::spectro
    spectrogram <- spectro(audio_channel, f = sample_rate, plot = FALSE)
    
    # Get the amplitude matrix from the spectrogram
    amplitude_matrix <- abs(spectrogram$amp)
    
    # Calculate the spectral flux as the difference between consecutive columns (time frames)
    flux <- sqrt(rowSums(diff(amplitude_matrix)^2))
    
    # Return the sum of flux values
    return(sum(flux))
}

# Apply spectral flux calculation to left and right channels
spectral_flux_left <- calculate_spectral_flux(audio@left, sample_rate = audio@samp.rate)
spectral_flux_right <- calculate_spectral_flux(audio@right, sample_rate = audio@samp.rate)

# Output the spectral flux
print(paste("Spectral flux (left):", spectral_flux_left))
print(paste("Spectral flux (right):", spectral_flux_right))

# Average spectral flux for stereo
mean_spectral_flux <- mean(c(spectral_flux_left, spectral_flux_right))
print(paste("Mean spectral flux:", mean_spectral_flux))

composite_energy <- (0.5 * mean_energy) + (0.5 * mean_spectral_flux)
print(paste("Composite energy of the song:", composite_energy))


# Function to calculate temporal energy over time
calculate_temporal_energy <- function(audio_channel, frame_size = 1024, hop_size = 512, sample_rate = 24000) {
    # Break the audio into frames (overlapping chunks)
    num_frames <- ceiling((length(audio_channel) - frame_size) / hop_size)
    
    # Initialize vector to store energy for each frame
    temporal_energy <- numeric(num_frames)
    
    # Loop over each frame to calculate RMS energy
    for (i in 1:num_frames) {
        start_idx <- (i - 1) * hop_size + 1
        end_idx <- start_idx + frame_size - 1
        if (end_idx > length(audio_channel)) {
            end_idx <- length(audio_channel)
        }
        
        # Extract the frame
        frame <- audio_channel[start_idx:end_idx]
        
        # Calculate RMS energy for this frame
        temporal_energy[i] <- sqrt(mean(frame^2))
    }
    
    # Create a time vector corresponding to the midpoints of each frame
    time_vector <- seq(0, (num_frames - 1) * hop_size / sample_rate, length.out = num_frames)
    
    return(list(energy = temporal_energy, time = time_vector))
}

# Apply the function to the left and right channels
temporal_energy_left <- calculate_temporal_energy(audio@left, sample_rate = audio@samp.rate)
temporal_energy_right <- calculate_temporal_energy(audio@right, sample_rate = audio@samp.rate)

# Average the energy for stereo channels (if stereo)
temporal_energy <- (temporal_energy_left$energy + temporal_energy_right$energy) / 2

# Plot the temporal energy over time
plot(temporal_energy_left$time, temporal_energy, type = "l", col = "blue", 
     xlab = "Time (seconds)", ylab = "Energy", main = "Temporal Energy Over Time")

