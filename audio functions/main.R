library(tuneR)
library(seewave)
library(av)
library(parallel)

# Convert audio file to WAV
av_audio_convert("camila_cabello_havana.mp3", output = "camila_cabello_havana.wav")
audio <- readWave("camila_cabello_havana.wav")


check_stereo <- function(audio){
    if (identical(audio@left, audio@right)) {
        print("The audio is mono.")
    } else {
        print("The audio is stereo.")
    }
}

check_stereo(audio)

get_durationms <- function(audio){
    return(round((length(audio@left)/audio@samp.rate)*1000))
}

# Downsample both left and right channels
downsampled_audio_left <- downsample(audio, samp.rate = 24000)
downsampled_audio_right <- downsample(audio, samp.rate = 24000)

sp_data <- data1_sp_song_attributes
colnames(sp_data)

