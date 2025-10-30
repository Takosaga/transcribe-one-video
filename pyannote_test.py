import torch
import os
from dotenv import load_dotenv
from pyannote.audio import Pipeline
from pyannote.audio.pipelines.utils.hook import ProgressHook
from pathlib import Path

load_dotenv()
HUGGINGFACE_ACCESS_TOKEN = os.getenv('HUGGINGFACE_ACCESS_TOKEN')

# Community-1 open-source speaker diarization pipeline
pipeline = Pipeline.from_pretrained(
    "pyannote/speaker-diarization-community-1",
    token=HUGGINGFACE_ACCESS_TOKEN)

# send pipeline to GPU (when available)
pipeline.to(torch.device("cuda"))

# apply pretrained pipeline (with optional progress hook)
with ProgressHook() as hook:
    output = pipeline('videos/test.wav', hook=hook)  # runs locally

# print the result
for turn, speaker in output.speaker_diarization:
    print(f"start={turn.start:.2f}s stop={turn.end:.2f}s speaker_{speaker}")