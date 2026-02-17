#!/usr/bin/env python3
"""
Spotify Playlist to YouTube Downloader
Reads a CSV file containing Spotify playlist songs and downloads them from YouTube.
"""

import pandas as pd
import os
import sys
from pathlib import Path

try:
    import yt_dlp
except ImportError:
    print("Error: yt-dlp is not installed. Install it with: pip install yt-dlp")
    sys.exit(1)


def search_and_download(song_name, artist_name, output_folder, cookies_file=None, concurrent_fragments=1, remove_sponsorblock=True):
    """
    Search for a song on YouTube and download it as MP3.
    
    Args:
        song_name (str): Name of the song
        artist_name (str): Name of the artist
        output_folder (str): Folder to save the downloaded file
        cookies_file (str): Optional path to cookies file to use on retry
        concurrent_fragments (int): Number of concurrent fragments to download (default: 1)
        remove_sponsorblock (bool): Whether to remove sponsorblock segments (default: True)
    
    Returns:
        bool: True if download successful, False otherwise
    """
    # Create search query
    search_query = f"{artist_name} {song_name} audio"
    
    # Configure yt-dlp options
    ydl_opts = {
        'format': 'bestaudio/best',
        'postprocessors': [
            {
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',
                'preferredquality': '192',
            },
            {
                'key': 'EmbedThumbnail',
                'already_have_thumbnail': False,
            },
            {
                'key': 'FFmpegMetadata',
                'add_metadata': True,
            },
        ],
        'writethumbnail': True,
        'outtmpl': os.path.join(output_folder, '%(title)s.%(ext)s'),
        'quiet': False,
        'no_warnings': False,
        'default_search': 'ytsearch1',  # Search YouTube and get first result
        'nocheckcertificate': True,
        'concurrent_fragment_downloads': concurrent_fragments,
    }
    
    # Add sponsorblock options if enabled
    if remove_sponsorblock:
        ydl_opts['sponsorblock_remove'] = ['all']
    
    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            print(f"\nSearching for: {search_query}")
            ydl.download([search_query])
            print(f"✓ Successfully downloaded: {song_name} - {artist_name}")
            return True
    except Exception as e:
        # Retry with cookies if available
        if cookies_file and os.path.exists(cookies_file):
            print(f"⚠️  Initial download failed, retrying with cookies...")
            try:
                ydl_opts['cookiefile'] = cookies_file
                with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                    print(f"Searching for: {search_query}")
                    ydl.download([search_query])
                    print(f"✓ Successfully downloaded: {song_name} - {artist_name}")
                    return True
            except Exception as e2:
                print(f"✗ Error downloading {song_name} - {artist_name} (with cookies): {str(e2)}")
                return False
        else:
            print(f"✗ Error downloading {song_name} - {artist_name}: {str(e)}")
            return False


def main():
    """Main function to process CSV and download songs."""
    
    try:
        # Get CSV file path from user
        while True:
            if len(sys.argv) > 1:
                csv_file = sys.argv[1]
            else:
                csv_file = input("Enter the path to your CSV file: ").strip()
            
            # Remove quotes if present (from drag and drop)
            csv_file = csv_file.strip('"').strip("'")
            
            # Check if file exists
            if os.path.exists(csv_file):
                print(f"✓ CSV file found: {csv_file}")
                break
            else:
                print(f"❌ Error: File '{csv_file}' not found.")
                print("Please check:")
                print("  - The file path is correct")
                print("  - The file exists in that location")
                print("  - You included the .csv extension")
        
        # Ask for optional cookies file
        cookies_file = None
        use_cookies = input("\nDo you have a cookies file to use for downloads? (y/N): ").strip().lower()
        if not use_cookies:
            use_cookies = 'n'
        if use_cookies == 'y':
            while True:
                cookies_file = input("Enter the path to your cookies file: ").strip()
                cookies_file = cookies_file.strip('"').strip("'")
                if os.path.exists(cookies_file):
                    print(f"✓ Cookies file found: {cookies_file}")
                    break
                else:
                    print(f"❌ Error: Cookies file '{cookies_file}' not found.")
                    print("Please check the path and try again, or enter a valid path.")
        
        # Ask if user wants to remove sponsorblock segments
        remove_sponsorblock = True
        sponsorblock_input = input("\nRemove sponsorblock segments (intro, outro, sponsor, etc.)? (Y/n): ").strip().lower()
        if not sponsorblock_input:
            sponsorblock_input = 'y'
        remove_sponsorblock = (sponsorblock_input == 'y')
        
        # Ask for concurrent fragments setting
        concurrent_fragments = 1
        while True:
            concurrent_fragments_input = input("\nNumber of concurrent fragments to download (default: 1): ").strip()
            if not concurrent_fragments_input:
                concurrent_fragments = 1
                break
            try:
                concurrent_fragments = int(concurrent_fragments_input)
                if concurrent_fragments < 1:
                    print("⚠️  Please enter a number greater than or equal to 1.")
                    continue
                break
            except ValueError:
                print("⚠️  Invalid input. Please enter a valid number or press Enter for default (1).")
        
        # Create output folder
        output_folder = "downloaded_songs"
        Path(output_folder).mkdir(parents=True, exist_ok=True)
        print(f"Output folder: {os.path.abspath(output_folder)}")
        
        # Read CSV file
        try:
            df = pd.read_csv(csv_file)
            print(f"\n✓ Loaded {len(df)} songs from CSV file.")
        except Exception as e:
            print(f"\n❌ Error reading CSV file: {str(e)}")
            print("\nPlease check:")
            print("  - The file is a valid CSV file")
            print("  - The file is not corrupted")
            print("  - The file is not open in another program")
            input("\nPress Enter to exit...")
            sys.exit(1)
        
        # Check for required columns (flexible column name detection)
        # Common Spotify export column names
        possible_song_cols = ['Track Name', 'track_name', 'Song', 'song', 'Title', 'title', 'Name', 'name']
        possible_artist_cols = ['Artist Name(s)', 'Artist Name', 'artist_name', 'Artist', 'artist', 'Artists', 'artists']
        
        song_col = None
        artist_col = None
        
        for col in possible_song_cols:
            if col in df.columns:
                song_col = col
                break
        
        for col in possible_artist_cols:
            if col in df.columns:
                artist_col = col
                break
        
        if not song_col or not artist_col:
            print("\n❌ Error: Could not find song/artist columns in CSV.")
            print(f"\nAvailable columns: {', '.join(df.columns)}")
            print("\nPlease ensure your CSV has columns like:")
            print("  - 'Track Name' or 'Song' or 'Title' (for song names)")
            print("  - 'Artist Name' or 'Artist' (for artist names)")
            input("\nPress Enter to exit...")
            sys.exit(1)
        
        print(f"\n✓ Using columns: '{song_col}' and '{artist_col}'")
        
        # Track statistics
        successful = 0
        failed = 0
        
        # Download each song
        print(f"\n{'='*60}")
        print("Starting downloads...")
        print(f"{'='*60}")
        
        for index, row in df.iterrows():
            song_name = str(row[song_col]).strip()
            artist_name = str(row[artist_col]).strip()
            
            # Skip empty rows
            if pd.isna(row[song_col]) or pd.isna(row[artist_col]):
                continue
            
            print(f"\n[{index + 1}/{len(df)}] Processing: {song_name} - {artist_name}")
            
            if search_and_download(song_name, artist_name, output_folder, cookies_file, concurrent_fragments, remove_sponsorblock):
                successful += 1
            else:
                failed += 1
        
        # Print summary
        print(f"\n{'='*60}")
        print("Download Summary:")
        print(f"{'='*60}")
        print(f"✓ Successful: {successful}")
        print(f"✗ Failed: {failed}")
        print(f"📁 Files saved to: {os.path.abspath(output_folder)}")
        print(f"{'='*60}")
        
    except KeyboardInterrupt:
        print("\n\n⚠️  Download interrupted by user.")
        print("Partially downloaded songs may be incomplete.")
        input("\nPress Enter to exit...")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ Unexpected error: {str(e)}")
        import traceback
        traceback.print_exc()
        input("\nPress Enter to exit...")
        sys.exit(1)


if __name__ == "__main__":
    print("=" * 60)
    print("Spotify Playlist to YouTube Downloader")
    print("=" * 60)
    
    # Check for ffmpeg
    try:
        import subprocess
        subprocess.run(['ffmpeg', '-version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except FileNotFoundError:
        print("\n⚠️  Warning: ffmpeg not found. It's required for MP3 conversion.")
        print("Install it with:")
        print("  - Ubuntu/Debian: sudo apt install ffmpeg")
        print("  - macOS: brew install ffmpeg")
        print("  - Windows: Download from https://ffmpeg.org/")
        print("\nContinuing anyway (downloads may be in different format)...\n")
    
    main()
    
    # Keep window open on Windows
    if sys.platform == "win32":
        input("\nPress Enter to exit...")
