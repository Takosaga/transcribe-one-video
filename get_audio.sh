#!/bin/bash

# Check if a URL was provided
if [ -z "$1" ]; then
    echo "Usage: ./get_audio.sh <URL>"
    exit 1
fi

URL="$1"
OUT_DIR="./videos"

# Create the directory if it doesn't exist
mkdir -p "$OUT_DIR"

echo "Downloading audio to $OUT_DIR..."

# -x: Extract audio
# --audio-format wav: Convert to WAV
# -P: Set the download path
# -o: Use the video ID for the filename
yt-dlp -x --audio-format wav -P "$OUT_DIR" -o "%(id)s.%(ext)s" "$URL"

echo "Done! File saved as: $OUT_DIR/(video_id).wav"