#!/usr/bin/env python3
"""
Test script to verify CSV parsing works with Exportify format
"""

import pandas as pd
import sys

def test_csv_parsing(csv_file):
    """Test if the CSV file can be parsed correctly."""
    
    print("=" * 60)
    print("Testing CSV File Parsing")
    print("=" * 60)
    print(f"\nFile: {csv_file}\n")
    
    try:
        # Read CSV file
        df = pd.read_csv(csv_file)
        print(f"✓ Successfully loaded CSV file")
        print(f"✓ Total rows: {len(df)}")
        print(f"\n{'='*60}")
        print("Available Columns:")
        print("='*60")
        for i, col in enumerate(df.columns, 1):
            print(f"{i}. {col}")
        
        # Check for song and artist columns
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
        
        print(f"\n{'='*60}")
        print("Column Detection:")
        print("='*60")
        
        if song_col:
            print(f"✓ Song column found: '{song_col}'")
        else:
            print("✗ Song column NOT found")
        
        if artist_col:
            print(f"✓ Artist column found: '{artist_col}'")
        else:
            print("✗ Artist column NOT found")
        
        if song_col and artist_col:
            print(f"\n{'='*60}")
            print("Sample Songs (first 5):")
            print("='*60")
            for index, row in df.head(5).iterrows():
                song = str(row[song_col]).strip()
                artist = str(row[artist_col]).strip()
                print(f"{index + 1}. {song} - {artist}")
            
            print(f"\n{'='*60}")
            print("✓ CSV FILE IS COMPATIBLE!")
            print("='*60")
            print(f"\nThe script will be able to process {len(df)} songs from this file.")
            return True
        else:
            print(f"\n{'='*60}")
            print("✗ CSV FILE NOT COMPATIBLE")
            print("='*60")
            print("\nRequired columns not found.")
            return False
            
    except Exception as e:
        print(f"\n✗ Error reading CSV: {str(e)}")
        return False

if __name__ == "__main__":
    if len(sys.argv) > 1:
        csv_file = sys.argv[1]
    else:
        csv_file = "/mnt/user-data/uploads/red.csv"
    
    test_csv_parsing(csv_file)
