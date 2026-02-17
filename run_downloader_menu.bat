@echo off
title Spotify to YouTube Downloader
color 0A

:menu
cls
echo ============================================================
echo     Spotify Playlist to YouTube Downloader - Windows 10
echo ============================================================
echo.
echo This script will download songs from YouTube based on your
echo Spotify playlist CSV file.
echo.
echo ============================================================
echo.
echo Select an option:
echo.
echo 1. Run the downloader
echo 2. Install/Update dependencies (yt-dlp, pandas)
echo 3. Check if everything is installed correctly
echo 4. Exit
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto run_downloader
if "%choice%"=="2" goto install_deps
if "%choice%"=="3" goto check_install
if "%choice%"=="4" goto end
echo Invalid choice. Please try again.
timeout /t 2 >nul
goto menu

:check_install
cls
echo ============================================================
echo Checking Installation...
echo ============================================================
echo.

echo Checking Python...
python --version 2>nul
if %errorlevel% neq 0 (
    echo [X] Python is NOT installed or not in PATH
    echo     Download from: https://python.org/downloads/
) else (
    echo [OK] Python is installed
)
echo.

echo Checking yt-dlp...
python -c "import yt_dlp; print('yt-dlp version:', yt_dlp.version.__version__)" 2>nul
if %errorlevel% neq 0 (
    echo [X] yt-dlp is NOT installed
    echo     Run option 2 to install it
) else (
    echo [OK] yt-dlp is installed
)
echo.

echo Checking yt-dlp-ejs...
python -c "import yt_dlp_ejs" 2>nul
if %errorlevel% neq 0 (
    echo [X] yt-dlp-ejs is NOT installed
    echo     Run option 2 to install it
) else (
    echo [OK] yt-dlp-ejs is installed
)
echo.

echo Checking pandas...
python -c "import pandas; print('pandas version:', pandas.__version__)" 2>nul
if %errorlevel% neq 0 (
    echo [X] pandas is NOT installed
    echo     Run option 2 to install it
) else (
    echo [OK] pandas is installed
)
echo.

echo Checking ffmpeg...
ffmpeg -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] ffmpeg is NOT installed or not in PATH
    echo     See README.md for installation instructions
) else (
    echo [OK] ffmpeg is installed
)
echo.
echo ============================================================
pause
goto menu

:install_deps
cls
echo ============================================================
echo Installing Dependencies...
echo ============================================================
echo.

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed!
    echo Please install Python first from https://python.org
    pause
    goto menu
)

REM Create or activate virtual environment
if exist venv (
    echo Virtual environment found. Activating...
) else (
    echo Creating virtual environment...
    python -m venv venv
)
call venv\Scripts\activate.bat
echo.

echo Installing yt-dlp...
pip install --upgrade yt-dlp
echo.

echo Installing yt-dlp-ejs...
pip install --upgrade yt-dlp-ejs
echo.

echo Installing pandas...
pip install --upgrade pandas
echo.

echo ============================================================
echo Installation complete!
echo ============================================================
pause
goto menu

:run_downloader
cls
echo ============================================================
echo Run Downloader
echo ============================================================
echo.

REM Check if Python script exists
if not exist "spotify_to_youtube_downloader.py" (
    echo ERROR: spotify_to_youtube_downloader.py not found!
    echo.
    echo Make sure this batch file is in the same folder as
    echo spotify_to_youtube_downloader.py
    echo.
    pause
    goto menu
)

REM Activate virtual environment if it exists
if exist venv (
    call venv\Scripts\activate.bat
) else (
    echo WARNING: Virtual environment not found.
    echo Please run option 2 to install dependencies first.
    pause
    goto menu
)
echo.

echo Enter the full path to your CSV file.
echo.
echo Tips:
echo - You can drag and drop the CSV file into this window
echo - Or type/paste the full path
echo - Press Ctrl+V to paste
echo.
echo Example: C:\Users\YourName\Downloads\my_playlist.csv
echo.

:get_csv_path
set "csv_path="
set /p csv_path="CSV file path: "

REM Remove quotes if present
set csv_path=%csv_path:"=%

REM Check if path is empty
if "%csv_path%"=="" (
    echo.
    echo ERROR: No path entered!
    echo.
    set /p retry="Try again? (Y/N): "
    if /i "%retry%"=="Y" goto get_csv_path
    goto menu
)

REM Check if file exists
if not exist "%csv_path%" (
    echo.
    echo ERROR: File not found!
    echo Path entered: "%csv_path%"
    echo.
    echo Please check:
    echo - The file path is correct
    echo - The file exists in that location
    echo - You included the .csv extension
    echo.
    set /p retry="Try again? (Y/N): "
    if /i "%retry%"=="Y" goto get_csv_path
    goto menu
)

echo.
echo ============================================================
echo File found! Starting download...
echo ============================================================
echo.

REM Run the Python script
python spotify_to_youtube_downloader.py "%csv_path%"

echo.
echo ============================================================
if %errorlevel% equ 0 (
    echo Download process completed!
    echo Check the 'downloaded_songs' folder for your music.
) else (
    echo An error occurred during download.
    echo Check the error messages above for details.
)
echo ============================================================
echo.
pause
goto menu

:end
echo.
echo Thanks for using the Spotify to YouTube Downloader!
echo.
timeout /t 2 >nul
exit
