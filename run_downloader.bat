@echo off
echo ============================================================
echo Spotify Playlist to YouTube Downloader - Windows Setup
echo ============================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

echo Python is installed: 
python --version
echo.

REM Create or activate virtual environment
if exist venv (
    echo Virtual environment found. Activating...
) else (
    echo Creating virtual environment...
    python -m venv venv
)
call venv\Scripts\activate.bat
echo.

REM Check if required packages are installed
echo Checking for required Python packages...
python -c "import yt_dlp" >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing yt-dlp...
    pip install yt-dlp
)

python -c "import yt_dlp_ejs" >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing yt-dlp-ejs...
    pip install yt-dlp-ejs
)

python -c "import pandas" >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing pandas...
    pip install pandas
)

echo.
echo ============================================================
echo All Python packages are installed!
echo ============================================================
echo.

REM Check for ffmpeg
ffmpeg -version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo WARNING: ffmpeg is not installed or not in PATH
    echo ffmpeg is required for MP3 conversion
    echo.
    echo To install ffmpeg:
    echo 1. Download from: https://github.com/BtbN/FFmpeg-Builds/releases
    echo 2. Extract to C:\ffmpeg
    echo 3. Add C:\ffmpeg\bin to your PATH environment variable
    echo.
    echo Or install with Chocolatey: choco install ffmpeg
    echo.
    echo Press any key to continue anyway...
    pause >nul
) else (
    echo ffmpeg is installed!
    echo.
)

echo ============================================================
echo Ready to download songs!
echo ============================================================
echo.

REM Get CSV file path
:get_path
echo.
set /p csv_path="Enter the full path to your CSV file (or drag and drop it here): "

REM Remove quotes if present (handles drag and drop)
set csv_path=%csv_path:"=%

REM Check if path is empty
if "%csv_path%"=="" (
    echo.
    echo ERROR: No path entered. Please try again.
    goto get_path
)

REM Check if file exists
if not exist "%csv_path%" (
    echo.
    echo ERROR: File not found: "%csv_path%"
    echo.
    echo Please check the path and try again.
    echo Make sure to include the full path with .csv extension
    echo Example: C:\Users\YourName\Downloads\playlist.csv
    echo.
    pause
    goto get_path
)

echo.
echo File found! Starting download process...
echo.
echo ============================================================
echo.

REM Run the Python script and capture errors
python spotify_to_youtube_downloader.py "%csv_path%"

REM Check if Python script ran successfully
if %errorlevel% neq 0 (
    echo.
    echo ============================================================
    echo ERROR: The script encountered an error!
    echo ============================================================
    echo.
    echo Common solutions:
    echo 1. Make sure pandas is installed: pip install pandas
    echo 2. Make sure yt-dlp is installed: pip install yt-dlp
    echo 3. Make sure yt-dlp-ejs is installed: pip install yt-dlp-ejs
    echo 4. Check your CSV file format matches the requirements
    echo.
) else (
    echo.
    echo ============================================================
    echo Process complete!
    echo ============================================================
    echo.
    echo Your songs should be in the 'downloaded_songs' folder
    echo.
)

pause
