#!/bin/bash

# Rename maze and tetris config files to use numbered naming
# mazesmall -> maze_4, tetris_small -> tetris_4

set -e

CONFIG_DIR="configs"

echo "Renaming maze config files..."

# Find and rename maze configs
for old_file in "$CONFIG_DIR"/qwen25vl_3B_fullsft_mazesmall_*.yaml; do
    if [ -f "$old_file" ]; then
        # Get the new filename by replacing mazesmall with maze_4
        new_file=$(echo "$old_file" | sed 's/mazesmall/maze_4/')

        # Update the output_dir inside the file before renaming
        sed -i 's/mazesmall/maze_4/g' "$old_file"

        # Rename the file
        mv "$old_file" "$new_file"
        echo "  Renamed: $(basename $old_file) -> $(basename $new_file)"
    fi
done

echo ""
echo "Renaming tetris config files..."

# Find and rename tetris configs
for old_file in "$CONFIG_DIR"/qwen25vl_3B_fullsft_tetris_small_*.yaml; do
    if [ -f "$old_file" ]; then
        # Get the new filename by replacing tetris_small with tetris_4
        new_file=$(echo "$old_file" | sed 's/tetris_small/tetris_4/')

        # Update the output_dir inside the file before renaming
        sed -i 's/tetris_small/tetris_4/g' "$old_file"

        # Rename the file
        mv "$old_file" "$new_file"
        echo "  Renamed: $(basename $old_file) -> $(basename $new_file)"
    fi
done

echo ""
echo "Done! All config files have been renamed to use numbered naming convention."
