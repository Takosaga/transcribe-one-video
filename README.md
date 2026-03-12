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

Diarization & Transcribing
---

The two processes of diarization and transcribing are seperate. Looking at a write up by [BrassTranscripts Best Speakers Diarization Models Compared[2026]](https://brasstranscripts.com/blog/speaker-diarization-models-comparison) leads me to test out [WhisperX](https://github.com/m-bain/whisperX)

```bash
uvx whisperx
```

With `transcribe.sh` to run whisperx to video
```
./transcribe.sh path/to/video.mp4
```

Whisperx outputs 5 files extension and they do not have exact outputs in each file

| Extension | Name | Description | Best Use Case |
| :--- | :--- | :--- | :--- |
| **.srt** | SubRip Subtitles | The industry standard for video players. Includes timestamps and speaker IDs. | YouTube, VLC, and social media video. |
| **.vtt** | WebVTT | Similar to SRT but with extra metadata capabilities. | HTML5 web-based video players. |
| **.txt** | Plain Text | A raw transcript with no timestamps or formatting. | Reading or feeding into an LLM for summarization. |
| **.json** | JSON | Data-heavy file containing word-level timestamps and speaker probabilities. | Developers and API integrations. |
| **.tsv** | Tab-Separated | A spreadsheet-friendly version with start, end, and text columns. | Data analysis in Excel or Google Sheets. |