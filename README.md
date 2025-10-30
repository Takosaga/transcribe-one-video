# Understanding transcribing one video

Has there been a time when you have watched or listened to a video/podcast and you wanted to go back to a topic that was talked about?
This is a project to build something that can solve this problem and document the process. Local machine was used along with a RTX 5060 16 GB Ti.

Dowloading and converting audio
-----
To download a video/audio [yt-dlp](https://github.com/yt-dlp/yt-dlp) was used
```
yt-dlp [OPTIONS] [--] URL [URL...]
```
To convert to 16-bit WAV files, [ffmpeg](https://ffmpeg.org/) was used
```
ffmpeg -i input.mp3 -ar 16000 -ac 1 -c:a pcm_s16le output.wav
```

Diarization
-----
Diarization is the process of partitioning an audio stream into segments according to the identity of the speaker. Essentially, it answers the question "Who spoke when?"

Pyannote [Community-1 model from hf](https://huggingface.co/pyannote/speaker-diarization-community-1). `pyannote_test.py` using `test.wav` in videos folder. Agreeing to pyannote on hugging face along with hf token.

```
uv run python pyannote_test.py
```

Transcribing
-----
Transcription is the computational process of converting spoken language in an audio or video file into written text. This process is generally performed by an Automatic Speech Recognition (ASR) system.

[whisper.cpp](https://github.com/ggml-org/whisper.cpp) was used to transcribe along with large-v3-turbo model 
```
whisper.cpp/build/bin/whisper-cli -m whisper.cpp/models/ggml-large-v3-turbo.bin -f videos/test.wav
```
