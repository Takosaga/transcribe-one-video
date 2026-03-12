#!/bin/bash

# Default values
DIARIZE_FLAG="--diarize"
URL=""

# 1. Parse Arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --no-diarize) DIARIZE_FLAG=""; shift ;;
        *) URL="$1"; shift ;;
    esac
done

# Validation
if [ -z "$URL" ]; then
    echo "Usage: $0 [--no-diarize] <YouTube-URL>"
    exit 1
fi

AUDIO_DIR="./videos"
TRANSCRIPT_DIR="./transcripts"

mkdir -p "$AUDIO_DIR" "$TRANSCRIPT_DIR"

# 2. Extract Video ID
VIDEO_ID=$(yt-dlp --get-id "$URL")

if [ -z "$VIDEO_ID" ]; then
    echo "Error: Could not retrieve Video ID."
    exit 1
fi

EXPECTED_FILE="$AUDIO_DIR/$VIDEO_ID.wav"

# 3. Download and Convert
echo "--- Downloading audio for: $VIDEO_ID ---"
yt-dlp -x --audio-format wav -P "$AUDIO_DIR" -o "%(id)s.%(ext)s" "$URL"

# 4. Transcribe with WhisperX
if [ -f "$EXPECTED_FILE" ]; then
    echo "--- Starting Transcription (Diarization: ${DIARIZE_FLAG:-off}) ---"
    
    # We pass the $DIARIZE_FLAG variable directly into the command
    PYTHONWARNINGS="ignore" uvx whisperx "$EXPECTED_FILE" \
      --model large-v3 \
      $DIARIZE_FLAG \
      --language en \
      --compute_type float16 \
      --hf_token "$HUGGINGFACE_ACCESS_TOKEN" \
      --output_dir "$TRANSCRIPT_DIR" \
      --print_progress True \
      --verbose False \
      --log-level error

    echo "--- Success! ---"
else
    echo "Error: Downloaded file not found at $EXPECTED_FILE"
    exit 1
fi