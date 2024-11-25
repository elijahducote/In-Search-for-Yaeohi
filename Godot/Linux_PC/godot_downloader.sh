#!/bin/bash

# Function to format file sizes
format_size() {
    local bytes=$1
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt $((1024 * 1024)) ]]; then
        printf "%.1fKB" "$(echo "scale=1; $bytes/1024" | bc)"
    elif [[ $bytes -lt $((1024 * 1024 * 1024)) ]]; then
        printf "%.1fMB" "$(echo "scale=1; $bytes/1024/1024" | bc)"
    else
        printf "%.1fGB" "$(echo "scale=1; $bytes/1024/1024/1024" | bc)"
    fi
}

# Function to download file with progress
download_file() {
    local url="$1"
    local output_file="$2"
    
    echo -e "\033[0;36m \nStarting download of: $output_file \033[0m"
    
    # Get file size first
    local size_header=$(curl -sI "$url" | grep -i content-length)
    local total_size=$(echo "$size_header" | awk '{print $2}' | tr -d '\r')
    
    if [[ $total_size -ne 0 ]]; then
        echo "Total size: $(format_size $total_size)"
    else
        echo "Could not determine file size"
    fi

    # Download with curl showing progress
    curl -L "$url" -o "$output_file" \
        --progress-bar \
        --write-out "\nAverage Speed: %{speed_download}B/s\nTime taken: %{time_total}s\n"
    
    local status=$?
    if [[ $status -eq 0 ]]; then
        echo "Download completed successfully: $output_file"
        # Show final file size
        local final_size=$(stat -f%z "$output_file" 2>/dev/null || stat -c%s "$output_file" 2>/dev/null)
        echo "Final file size: $(format_size $final_size)"
        return 0
    else
        echo "Error during download. Exit code: $status"
        return 1
    fi
}

# Print header
echo "======================================"
echo "Godot Release Downloader"
echo "======================================"

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed"
    exit 1
fi

echo "Fetching latest Godot release information..."

# Get the JSON response from GitHub API
json_response=$(curl -s -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/godotengine/godot/releases/latest")

if [[ -z "$json_response" ]]; then
    echo "Error: Failed to fetch release information from GitHub"
    exit 1
fi

# Extract all browser_download_urls
mapfile -t download_urls < <(echo "$json_response" | grep -o '"browser_download_url": "[^"]*"' | cut -d'"' -f4)

if [[ ${#download_urls[@]} -eq 0 ]]; then
    echo "Error: No download URLs found"
    exit 1
fi

echo "$(tput bold)Found ${#download_urls[@]} total files$(tput sgr0)"
echo -e "\033[0;36m \nSearching for first file (mono_windows, 64, zip)... \033[0m"

# Find first matching URL (mono_windows, 64, zip)
first_match=""
for url in "${download_urls[@]}"; do
    if [[ $url =~ mono_linux && $url =~ _64 && $url =~ zip ]]; then
        first_match="$url"
        filename=$(basename "$url")
        echo "Found matching file: $(tput bold)$filename$(tput sgr0)"
        download_file "$url" "$filename"
        if [[ $? -ne 0 ]]; then
            echo "Error downloading first file"
            exit 1
        fi
        break
    fi
done

if [[ -z "$first_match" ]]; then
    echo "No matching file found for first criteria"
    exit 1
fi

echo -e "\033[0;36m \nSearching for second file (mono, tpz)... \033[0m"

# Find second matching URL (mono, tpz)
second_match=""
for url in "${download_urls[@]}"; do
    if [[ $url =~ mono && $url =~ tpz ]]; then
        second_match="$url"
        filename=$(basename "$url")
        echo "Found matching file: $filename"
        download_file "$url" "$filename"
        if [[ $? -ne 0 ]]; then
            echo "Error downloading second file"
            exit 1
        fi
        break
    fi
done

if [[ -z "$second_match" ]]; then
    echo "No matching file found for second criteria"
fi

echo -e "\nScript completed."
