#!/bin/bash

echo "============================================================"
echo "Spotify Playlist to YouTube Downloader"
echo "============================================================"
echo ""

# Check if Python is installed
if ! command -v python &> /dev/null; then
    echo "ERROR: Python is not installed or not in PATH"
    echo "Please install python:"
    echo "- Ubuntu/Debian: sudo apt install python"
    echo "- macOS: brew install python"
    echo "- Windows: Download from https://python.org/downloads/"
    read -p "Press Enter to exit..."
    exit 1
fi

echo "Python is installed:"
python --version
echo ""

# Create or activate virtual environment
if [ -d "venv" ]; then
    echo "Virtual environment found. Activating..."
else
    echo "Creating virtual environment..."
    python -m venv venv
fi
source venv/bin/activate
echo ""

# Check if required packages are installed
echo "Checking for required Python packages..."

if ! python -c "import yt_dlp" 2>/dev/null; then
    echo "Installing yt-dlp..."
    pip install yt-dlp
fi

if ! python -c "import yt_dlp_ejs" 2>/dev/null; then
    echo "Installing yt-dlp-ejs..."
    pip install yt-dlp-ejs
fi

if ! python -c "import pandas" 2>/dev/null; then
    echo "Installing pandas..."
    pip install pandas
fi

echo ""
echo "============================================================"
echo "All Python packages are installed!"
echo "============================================================"
echo ""

# Check for ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo ""
    echo "WARNING: ffmpeg is not installed or not in PATH"
    echo "ffmpeg is required for MP3 conversion"
    echo ""
    echo "To install ffmpeg:"
    echo "- Ubuntu/Debian: sudo apt install ffmpeg"
    echo "- macOS: brew install ffmpeg"
    echo "- Windows: Download from https://ffmpeg.org/ or use: choco install ffmpeg"
    echo ""
    read -p "Press Enter to continue anyway..."
else
    echo "ffmpeg is installed!"
    echo ""
fi

echo "============================================================"
echo "Ready to download songs!"
echo "============================================================"
echo ""

# Get CSV file path
while true; do
    echo ""
    read -p "Enter the full path to your CSV file: " csv_path
    
    # Remove quotes if present
    csv_path="${csv_path%\"}"
    csv_path="${csv_path#\"}"
    
    # Check if path is empty
    if [ -z "$csv_path" ]; then
        echo "ERROR: No path entered. Please try again."
        continue
    fi
    
    # Check if file exists
    if [ ! -f "$csv_path" ]; then
        echo ""
        echo "ERROR: File not found: \"$csv_path\""
        echo ""
        echo "Please check the path and try again."
        echo "Make sure to include the full path with .csv extension"
        echo "Example: /home/user/Downloads/playlist.csv"
        echo ""
        continue
    fi
    
    break
done

echo ""
echo "File found! Starting download process..."
echo ""
echo "============================================================"
echo ""

# Run the Python script
python spotify_to_youtube_downloader.py "$csv_path"

# Check if Python script ran successfully
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo ""
    echo "============================================================"
    echo "ERROR: The script encountered an error!"
    echo "============================================================"
    echo ""
    echo "Common solutions:"
    echo "1. Make sure pandas is installed: pip install pandas"
    echo "2. Make sure yt-dlp is installed: pip install yt-dlp"
    echo "3. Make sure yt-dlp-ejs is installed: pip install yt-dlp-ejs"
    echo "4. Check your CSV file format matches the requirements"
    echo ""
else
    echo ""
    echo "============================================================"
    echo "Process complete!"
    echo "============================================================"
    echo ""
    echo "Your songs should be in the 'downloaded_songs' folder"
    echo ""
fi

read -p "Press Enter to exit..."
