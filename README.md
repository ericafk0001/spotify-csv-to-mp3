# Spotify Playlist to YouTube Downloader

This Python script downloads songs from YouTube based on a CSV file containing Spotify playlist data.

## Quick Start for Windows 10

1. **Download all files** to a folder (e.g., `C:\Music\Downloader`)
2. **Double-click `install_dependencies.bat`** to install required Python packages
3. **Install ffmpeg** (see detailed instructions below)
4. **Get your Spotify playlist CSV** (use https://exportify.net/)
5. **Double-click `run_downloader.bat`** and enter your CSV file path

That's it! Your songs will be downloaded to the `downloaded_songs` folder.

---

## Requirements

1. **Python 3.6+**
   - Download from https://www.python.org/downloads/
   - **Important:** During installation, check "Add Python to PATH"

2. **Python packages:**
   ```bash
   pip install yt-dlp pandas
   ```

3. **FFmpeg** (required for MP3 conversion):
   
   ### Windows 10 Installation (Choose one method):
   
   **Method 1: Using Chocolatey (Easiest)**
   ```bash
   choco install ffmpeg
   ```
   
   **Method 2: Manual Installation**
   1. Download from https://github.com/BtbN/FFmpeg-Builds/releases
   2. Download `ffmpeg-master-latest-win64-gpl.zip`
   3. Extract to `C:\ffmpeg`
   4. Add `C:\ffmpeg\bin` to your PATH:
      - Press `Win + X` → System
      - Click "Advanced system settings"
      - Click "Environment Variables"
      - Under "System variables", find "Path"
      - Click "Edit" → "New"
      - Add: `C:\ffmpeg\bin`
      - Click OK on all windows
      - Restart Command Prompt
   
   **Other OS:**
   - **Ubuntu/Debian:** `sudo apt install ffmpeg`
   - **macOS:** `brew install ffmpeg`

## CSV File Format

Your CSV file should have columns for song names and artist names. The script supports various common column names:

### ✅ Fully Compatible with Exportify
This script has been tested and confirmed to work with CSV files exported from https://exportify.net/

Exportify CSV files contain these columns (and many more):
- **Track Name** - Song title
- **Artist Name(s)** - Artist(s) who performed the song
- Album Name, Release Date, Duration, Popularity, etc.

The script will automatically detect and use the correct columns!

### Accepted column names:
- **Song columns:** `Track Name`, `track_name`, `Song`, `Title`, `Name`
- **Artist columns:** `Artist Name(s)`, `Artist Name`, `artist_name`, `Artist`, `Artists`

### Example CSV format:

```csv
Track Name,Artist Name
Bohemian Rhapsody,Queen
Stairway to Heaven,Led Zeppelin
Hotel California,Eagles
```

Or:

```csv
Song,Artist
Smells Like Teen Spirit,Nirvana
Wonderwall,Oasis
```

## How to Get Your Spotify Playlist as CSV

### Method 1: Using Exportify (Recommended) ✅
1. Go to https://exportify.net/
2. Login with your Spotify account
3. Select the playlist you want to export
4. Click "Export" to download as CSV

**✅ This script is fully tested and compatible with Exportify CSV exports!**

### Method 2: Manual Creation
Create a CSV file manually with your song data in any text editor or spreadsheet application.

## Testing Your CSV File

Before running the downloader, you can test if your CSV file is compatible:

**Windows:**
```bash
python test_csv.py "C:\path\to\your\playlist.csv"
```

**Linux/Mac:**
```bash
python3 test_csv.py /path/to/your/playlist.csv
```

This will check if your CSV has the correct columns and show you a preview of the songs that will be downloaded.

## Usage

### Windows 10:

**Option 1: Using Command Prompt**
1. Press `Win + R`, type `cmd`, press Enter
2. Navigate to the folder with the script:
   ```bash
   cd C:\Users\YourUsername\Downloads
   ```
3. Run the script:
   ```bash
   python spotify_to_youtube_downloader.py playlist.csv
   ```

**Option 2: Using the batch file**
1. Double-click `run_downloader.bat`
2. Enter the path to your CSV file when prompted

**Option 3: Drag and drop**
1. Hold `Shift` and right-click on the folder containing the script
2. Click "Open PowerShell window here" or "Open Command window here"
3. Run:
   ```bash
   python spotify_to_youtube_downloader.py playlist.csv
   ```

### Linux/Mac:

```bash
python3 spotify_to_youtube_downloader.py playlist.csv
```

Or run and enter path when prompted:
```bash
python3 spotify_to_youtube_downloader.py
```

## Output

- Songs are downloaded as MP3 files to a folder called `downloaded_songs`
- The script shows progress for each song
- A summary is displayed at the end showing successful/failed downloads

## Features

- Automatically searches YouTube for each song
- Downloads the first matching result
- Converts to MP3 format (192 kbps)
- Flexible CSV column detection
- Progress tracking
- Error handling for failed downloads

## Troubleshooting

### Windows 10 Specific Issues

**"Python is not recognized as an internal or external command"**
- Python is not installed or not in PATH
- Solution: Reinstall Python from https://python.org and check "Add Python to PATH"

**"'pip' is not recognized"**
- Run: `python -m pip install yt-dlp pandas` instead

**Antivirus blocking downloads**
- Some antivirus software may flag yt-dlp
- Add the script folder to your antivirus exclusions

**Path issues with spaces**
- If your CSV path has spaces, make sure to use quotes:
  ```bash
  python spotify_to_youtube_downloader.py "C:\My Music\playlist.csv"
  ```

**Can't find downloaded songs**
- They're in the `downloaded_songs` folder in the same location as the script
- Check: `C:\Users\YourUsername\Downloads\downloaded_songs`

### General Issues

**"yt-dlp is not installed"**
```bash
pip install yt-dlp
```

**"ffmpeg not found"**
Install ffmpeg using the commands in the Requirements section.

**"Could not find song/artist columns"**
Check that your CSV has properly named columns. The script will show you available columns.

**Downloads failing**
- Check your internet connection
- Some songs may not be available on YouTube
- Try running the script again for failed downloads
- YouTube may temporarily block requests - wait a few minutes and retry

## Notes

- The script searches for the first matching result on YouTube
- Audio quality is set to 192 kbps MP3
- Make sure you have sufficient disk space for downloads
- Respect copyright laws in your jurisdiction

## Example Output

```
============================================================
Spotify Playlist to YouTube Downloader
============================================================
Output folder: /path/to/downloaded_songs

Loaded 50 songs from CSV file.

Using columns: 'Track Name' and 'Artist Name'

============================================================
Starting downloads...
============================================================

[1/50] Processing: Bohemian Rhapsody - Queen

Searching for: Queen Bohemian Rhapsody audio
✓ Successfully downloaded: Bohemian Rhapsody - Queen

[2/50] Processing: Stairway to Heaven - Led Zeppelin
...

============================================================
Download Summary:
============================================================
✓ Successful: 48
✗ Failed: 2
📁 Files saved to: /path/to/downloaded_songs
============================================================
```
