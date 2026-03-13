#!/bin/bash

# Check if a file was provided
if [ -z "$1" ]; then
    echo "Usage: ./transcribe.sh path/to/video.mp4"
    exit 1
fi

INPUT_FILE="$1"
OUT_DIR="./transcripts"

# Silence most warnings and run WhisperX
PYTHONWARNINGS="ignore" uvx whisperx "$INPUT_FILE" \
  --model large-v3 \
  --diarize \
  --language en \
  --compute_type float16 \
  --hf_token "$HUGGINGFACE_ACCESS_TOKEN" \
  --output_dir "$OUT_DIR" \
  --print_progress False \
  --log-level error

echo "Transcription complete. Files saved to: $OUT_DIR"