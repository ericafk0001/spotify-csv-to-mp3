# Spotify Playlist to YouTube Downloader

Download songs from YouTube using a Spotify playlist CSV.

## Quick Start (Windows)

1. Download all files to a folder
2. Double-click `install_dependencies.bat` to install Python packages
3. Install ffmpeg (see below)
4. Export your Spotify playlist CSV (use [Exportify](https://exportify.net/))
5. Double-click `run_downloader.bat` and enter your CSV file path

Songs will be saved in the `downloaded_songs` folder.

---

## Requirements

- Python 3.6+ ([Download](https://www.python.org/downloads/))
- Python packages: `yt-dlp`, `pandas`
- FFmpeg for MP3 conversion

### FFmpeg Installation (Windows)

- Easiest: `choco install ffmpeg`
- Manual: Download from [FFmpeg Builds](https://github.com/BtbN/FFmpeg-Builds/releases), extract to `C:\ffmpeg`, add `C:\ffmpeg\bin` to PATH

## CSV Format

View sample_playlist.csv

- Song column: `Track Name`, `Song`, `Title`, etc.
- Artist column: `Artist Name(s)`, `Artist`, etc.

Example:

```csv
Track Name,Artist Name
Bohemian Rhapsody,Queen
Stairway to Heaven,Led Zeppelin
```

Exportify CSVs are fully supported.

## Output

- MP3 files saved to `downloaded_songs`
- Progress and summary shown after download

## Features

- Searches YouTube for each song
- Downloads first result
- Converts to MP3 (192 kbps)
- Flexible CSV column detection

## Troubleshooting

- Python not found: Reinstall and add to PATH
- pip not found: `python -m pip install yt-dlp pandas`
- ffmpeg not found: Install as above
- CSV column issues: Check column names
- Downloads fail: Retry or check internet

## Notes

- Audio quality: 192 kbps MP3
- Downloaded files in `downloaded_songs`
- Respect copyright laws

```

```
