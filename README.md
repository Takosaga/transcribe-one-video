# Understanding transcribing one video

Has there been a time when you have watched or listened to a video/podcast and you wanted to go back to a topic that was talked about?
This is a project to build something that can solve this problem and document the process.

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
