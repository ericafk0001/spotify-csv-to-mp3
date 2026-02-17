## Quick Start (Windows)

1. Download all files to a folder
2. Double-click `install_dependencies.bat` to install Python packages
3. Install ffmpeg (see below)
4. Export your Spotify playlist CSV (use [Exportify](https://exportify.net/))
5. Double-click `run_downloader.bat` and enter your CSV file path

## Quick Start (Linux/macOS)

1. Download all files to a folder
2. Open terminal in that folder
3. Run `chmod +x install_dependencies.sh run_downloader.sh` to make scripts executable
4. Run `./install_dependencies.sh` to install Python packages
5. Install ffmpeg (see below)
6. Export your Spotify playlist CSV (use [Exportify](https://exportify.net/))
7. Run `./run_downloader.sh` and enter your CSV file path

Songs will be saved in the `downloaded_songs` folder.

---

## Requirements

- Python 3.6+ ([Download](https://www.python.org/downloads/))
- Python packages: `yt-dlp`, `yt-dlp-ejs`, `pandas`
- FFmpeg for MP3 conversion

### FFmpeg Installation (Windows)

- Easiest: `choco install ffmpeg`
- Manual: Download from [FFmpeg Builds](https://github.com/BtbN/FFmpeg-Builds/releases), extract to `C:\ffmpeg`, add `C:\ffmpeg\bin` to PATH

### FFmpeg Installation (Linux)

- Ubuntu/Debian: `sudo apt update && sudo apt install ffmpeg`
- Fedora: `sudo dnf install ffmpeg`
- Arch: `sudo pacman -S ffmpeg`

### FFmpeg Installation (macOS)

- With Homebrew: `brew install ffmpeg`
- With MacPorts: `sudo port install ffmpeg`

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

- MP3 files with embedded album art (YouTube thumbnails)
- SponsorBlock segments removed (unless opted out)
- Files saved to `downloaded_songs`
- Progress and summary shown after download

## Features

- Searches YouTube for each song
- Downloads first result
- Converts to MP3 (192 kbps) with embedded album art
- Automatically embeds YouTube thumbnail as album artwork
- Removes SponsorBlock segments (intros, outros, sponsors, etc.) by default
- Flexible CSV column detection
- Optional cookie file support for restricted videos
- Configurable concurrent fragment downloads

## Download Options

When you run the downloader, you'll be prompted for:

1. **Cookie File** (default: no)
   - Use if you need to download age-restricted videos or find video downloads erroring
   - Press Enter to skip

2. **SponsorBlock Removal** (default: yes)
   - Removes sponsor segments, intros, outros, and other non-music content
   - Press Enter to enable, or type 'n' to keep all segments

3. **Concurrent Fragments** (default: 1)
   - Number of parallel download fragments for faster downloads
   - Higher numbers may speed up downloads but use more bandwidth

## Troubleshooting

- Python not found: Reinstall and add to PATH
- pip not found: `python -m pip install yt-dlp pandas`
- ffmpeg not found: Install as above
- CSV column issues: Check column names
- Downloads fail: Retry or check internet

## Notes

- Audio quality: 192 kbps MP3
- Album art automatically embedded from YouTube thumbnailsyt-dlp-ejs
- SponsorBlock automatically removes intros, outros, sponsors, etc.
- Downloaded files in `downloaded_songs`
- Respect copyright laws
