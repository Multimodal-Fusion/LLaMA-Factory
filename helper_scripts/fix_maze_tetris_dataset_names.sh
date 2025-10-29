#!/bin/bash

# Fix maze and tetris dataset names in config files
# Changes maze_small -> maze_4 and tetris_small -> tetris_4

set -e

CONFIG_DIR="configs"

# Find all maze and tetris config files
maze_configs=$(find "$CONFIG_DIR" -name "*mazesmall*.yaml")
tetris_configs=$(find "$CONFIG_DIR" -name "*tetris_small*.yaml")

echo "Updating maze config files..."
for config in $maze_configs; do
    sed -i 's/dataset: maze_small\[/dataset: maze_4[/g' "$config"
    sed -i 's/dataset: maze_small_nooptions\[/dataset: maze_4_nooptions[/g' "$config"
    echo "  Updated: $config"
done

echo ""
echo "Updating tetris config files..."
for config in $tetris_configs; do
    sed -i 's/dataset: tetris_small\[/dataset: tetris_4[/g' "$config"
    sed -i 's/dataset: tetris_small_nooptions\[/dataset: tetris_4_nooptions[/g' "$config"
    echo "  Updated: $config"
done

maze_count=$(echo "$maze_configs" | wc -l)
tetris_count=$(echo "$tetris_configs" | wc -l)
total_count=$((maze_count + tetris_count))

echo ""
echo "Done! Updated $total_count config files:"
echo "  - Maze configs: $maze_count"
echo "  - Tetris configs: $tetris_count"
