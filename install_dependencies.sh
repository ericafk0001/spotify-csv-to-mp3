#!/bin/bash

echo "============================================================"
echo "Installing Required Packages for Spotify to YouTube Downloader"
echo "============================================================"
echo ""

# Check if Python is installed
if ! command -v python &> /dev/null; then
    echo "ERROR: python is not installed or not in PATH"
    echo ""
    echo "Please install python:"
    echo "- Ubuntu/Debian: sudo apt install python python-pip"
    echo "- macOS: brew install python"
    echo "- Windows: Download from https://python.org/downloads/"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi

echo "Python found:"
python --version
echo ""

# Create virtual environment
echo "Creating virtual environment..."
if [ -d "venv" ]; then
    echo "Virtual environment already exists. Using existing one."
else
    python -m venv venv
    echo "Virtual environment created."
fi
echo ""

# Activate virtual environment
source venv/bin/activate
echo ""

echo "Installing packages..."
echo "Installing yt-dlp..."
pip install yt-dlp
echo ""

echo "Installing yt-dlp-ejs..."
pip install yt-dlp-ejs
echo ""

echo "Installing pandas..."
pip install pandas
echo ""

echo "============================================================"
echo "Installation complete!"
echo "============================================================"
echo ""
echo "Next steps:"
echo "1. Install ffmpeg (see README.md for instructions)"
echo "2. Run ./run_downloader.sh or use: python spotify_to_youtube_downloader.py yourfile.csv"
echo ""
read -p "Press Enter to exit..."
