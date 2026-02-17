@echo off
echo ============================================================
echo Installing Required Packages for Spotify to YouTube Downloader
echo ============================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo.
    echo Please install Python from https://python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation
    echo.
    pause
    exit /b 1
)

echo Python found: 
python --version
echo.

echo Installing yt-dlp...
pip install yt-dlp
echo.

echo Installing pandas...
pip install pandas
echo.

echo ============================================================
echo Installation complete!
echo ============================================================
echo.
echo Next steps:
echo 1. Install ffmpeg (see README.md for instructions)
echo 2. Run run_downloader.bat or use: python spotify_to_youtube_downloader.py yourfile.csv
echo.
pause
