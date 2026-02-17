#!/bin/bash

# Color codes for better visibility
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define all functions first
check_install() {
    clear
    echo "============================================================"
    echo "Checking Installation..."
    echo "============================================================"
    echo ""
    
    # Check Python
    echo "Checking python..."
    if python --version &>/dev/null 2>&1; then
        echo -e "${GREEN}[OK]${NC} python is installed"
    else
        echo -e "${RED}[X]${NC} python is NOT installed or not in PATH"
        echo "     Download from: https://python.org/downloads/ or install via package manager"
    fi
    echo ""
    
    # Check yt-dlp
    echo "Checking yt-dlp..."
    if python -c "import yt_dlp; print('yt-dlp version:', yt_dlp.version.__version__)" 2>/dev/null; then
        echo -e "${GREEN}[OK]${NC} yt-dlp is installed"
    else
        echo -e "${RED}[X]${NC} yt-dlp is NOT installed"
        echo "     Run option 2 to install it"
    fi
    echo ""
    
    # Check yt-dlp-ejs
    echo "Checking yt-dlp-ejs..."
    if python -c "import yt_dlp_ejs" 2>/dev/null; then
        echo -e "${GREEN}[OK]${NC} yt-dlp-ejs is installed"
    else
        echo -e "${RED}[X]${NC} yt-dlp-ejs is NOT installed"
        echo "     Run option 2 to install it"
    fi
    echo ""
    
    # Check pandas
    echo "Checking pandas..."
    if python -c "import pandas; print('pandas version:', pandas.__version__)" 2>/dev/null; then
        echo -e "${GREEN}[OK]${NC} pandas is installed"
    else
        echo -e "${RED}[X]${NC} pandas is NOT installed"
        echo "     Run option 2 to install it"
    fi
    echo ""
    
    # Check ffmpeg
    echo "Checking ffmpeg..."
    if command -v ffmpeg &> /dev/null; then
        echo -e "${GREEN}[OK]${NC} ffmpeg is installed"
    else
        echo -e "${RED}[X]${NC} ffmpeg is NOT installed or not in PATH"
        echo "     See README.md for installation instructions"
    fi
    echo ""
    echo "============================================================"
    read -p "Press Enter to continue..."
}

install_deps() {
    clear
    echo "============================================================"
    echo "Installing Dependencies..."
    echo "============================================================"
    echo ""
    
    if ! command -v python &> /dev/null; then
        echo "ERROR: python is not installed!"
        echo "Please install python first:"
        echo "- Ubuntu/Debian: sudo apt install python python-pip"
        echo "- macOS: brew install python"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Create or activate virtual environment
    if [ -d "venv" ]; then
        echo "Virtual environment found. Activating..."
    else
        echo "Creating virtual environment..."
        python -m venv venv
    fi
    source venv/bin/activate
    echo ""
    
    echo "Installing yt-dlp..."
    pip install --upgrade yt-dlp
    echo ""
    
    echo "Installing yt-dlp-ejs..."
    pip install --upgrade yt-dlp-ejs
    echo ""
    
    echo "Installing pandas..."
    pip install --upgrade pandas
    echo ""
    
    echo "============================================================"
    echo "Installation complete!"
    echo "============================================================"
    read -p "Press Enter to continue..."
}

run_downloader() {
    clear
    echo "============================================================"
    echo "Run Downloader"
    echo "============================================================"
    echo ""
    
    # Check if Python script exists
    if [ ! -f "spotify_to_youtube_downloader.py" ]; then
        echo "ERROR: spotify_to_youtube_downloader.py not found!"
        echo ""
        echo "Make sure this script is in the same folder as"
        echo "spotify_to_youtube_downloader.py"
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    
    # Activate virtual environment if it exists
    if [ -d "venv" ]; then
        source venv/bin/activate
    else
        echo "WARNING: Virtual environment not found."
        echo "Please run option 2 to install dependencies first."
        read -p "Press Enter to continue..."
        return
    fi
    echo ""
    echo ""
    echo "Tips:"
    echo "- Type or paste the full path"
    echo "- Use Ctrl+V to paste"
    echo ""
    echo "Example: /home/user/Downloads/my_playlist.csv"
    echo ""
    
    # Get CSV file path
    while true; do
        read -p "CSV file path: " csv_path
        
        # Remove quotes if present
        csv_path="${csv_path%\"}"
        csv_path="${csv_path#\"}"
        
        # Check if path is empty
        if [ -z "$csv_path" ]; then
            echo ""
            echo "ERROR: No path entered!"
            echo ""
            read -p "Try again? (Y/N): " retry
            if [[ "$retry" == "Y" || "$retry" == "y" ]]; then
                continue
            else
                return
            fi
        fi
        
        # Check if file exists
        if [ ! -f "$csv_path" ]; then
            echo ""
            echo "ERROR: File not found!"
            echo "Path entered: \"$csv_path\""
            echo ""
            echo "Please check:"
            echo "- The file path is correct"
            echo "- The file exists in that location"
            echo "- You included the .csv extension"
            echo ""
            read -p "Try again? (Y/N): " retry
            if [[ "$retry" == "Y" || "$retry" == "y" ]]; then
                continue
            else
                return
            fi
        fi
        
        break
    done
    
    echo ""
    echo "============================================================"
    echo "File found! Starting download..."
    echo "============================================================"
    echo ""
    
    # Run the Python script
    python spotify_to_youtube_downloader.py "$csv_path"
    
    exit_code=$?
    echo ""
    echo "============================================================"
    if [ $exit_code -eq 0 ]; then
        echo "Download process completed!"
        echo "Check the 'downloaded_songs' folder for your music."
    else
        echo "An error occurred during download."
        echo "Check the error messages above for details."
    fi
    echo "============================================================"
    echo ""
    read -p "Press Enter to continue..."
}

end_script() {
    clear
    echo ""
    echo "Thanks for using the Spotify to YouTube Downloader!"
    echo ""
    sleep 2
    exit 0
}

# Main menu loop
while true; do
    clear
    echo "============================================================"
    echo "     Spotify Playlist to YouTube Downloader"
    echo "============================================================"
    echo ""
    echo "This script will download songs from YouTube based on your"
    echo "Spotify playlist CSV file."
    echo ""
    echo "============================================================"
    echo ""
    echo "Select an option:"
    echo ""
    echo "1. Run the downloader"
    echo "2. Install/Update dependencies (yt-dlp, pandas)"
    echo "3. Check if everything is installed correctly"
    echo "4. Exit"
    echo ""
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            run_downloader
            ;;
        2)
            install_deps
            ;;
        3)
            check_install
            ;;
        4)
            end_script
            ;;
        *)
            echo "Invalid choice. Please try again."
            sleep 2
            ;;
    esac
done
