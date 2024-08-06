#!/bin/bash

LOG_DIR="/tmp/logs"
MAX_SIZE=500000 # Size in kilobytes (500 MB)

# Calculate the total size of the directory, including subdirectories, in kilobytes
TOTAL_SIZE=$(du -sk "$LOG_DIR" | cut -f1)

# While the total size exceeds the limit, remove the oldest file
while [ "$TOTAL_SIZE" -gt "$MAX_SIZE" ]; do
    # Find the oldest file in the entire directory tree
    OLDEST_FILE=$(find "$LOG_DIR" -type f \( -name "*.log" -o -name "*.csv" -o -name "*.html" \) -printf '%T+ %p\n' | sort | head -n 1 | awk '{print $2}')
    
    # Check if an oldest file is found and remove it
    if [ -n "$OLDEST_FILE" ]; then
        rm -f "$OLDEST_FILE"
        echo "Removed: $OLDEST_FILE"

        # Recalculate the total size after deletion
        TOTAL_SIZE=$(du -sk "$LOG_DIR" | cut -f1)
    else
        # Exit the loop if no files are found
        break
    fi
done
