#!/bin/bash

# Generate maze and tetris configs for different sample sizes
# Usage: ./generate_maze_tetris_configs.sh

set -e

CONFIG_DIR="configs"
SAMPLE_SIZES=(1000 2000 5000 10000)

# Define all variants for maze (note: mazesmall in filenames)
MAZE_VARIANTS=(
    "mazesmall_sft"
    "mazesmall_nooptions_sft"
    "mazesmall_textual-cot"
    "mazesmall_nooptions_textual-cot"
)

# Define all variants for tetris (note: tetris_small in filenames)
TETRIS_VARIANTS=(
    "tetris_small_sft"
    "tetris_small_nooptions_sft"
    "tetris_small_textual-cot"
    "tetris_small_nooptions_textual-cot"
)

echo "Generating maze and tetris config files..."

# Generate maze configs
for variant in "${MAZE_VARIANTS[@]}"; do
    source_file="$CONFIG_DIR/qwen25vl_3B_fullsft_${variant}_500.yaml"

    if [ ! -f "$source_file" ]; then
        echo "Error: Source file $source_file not found"
        exit 1
    fi

    for samples in "${SAMPLE_SIZES[@]}"; do
        output_file="$CONFIG_DIR/qwen25vl_3B_fullsft_${variant}_${samples}.yaml"

        # Read source, replace max_samples and output_dir, write to new file
        sed -e "s/max_samples: 500/max_samples: $samples/" \
            -e "s/numsamples500/numsamples$samples/" \
            "$source_file" > "$output_file"

        echo "Created: $output_file"
    done
done

# Generate tetris configs
for variant in "${TETRIS_VARIANTS[@]}"; do
    source_file="$CONFIG_DIR/qwen25vl_3B_fullsft_${variant}_500.yaml"

    if [ ! -f "$source_file" ]; then
        echo "Error: Source file $source_file not found"
        exit 1
    fi

    for samples in "${SAMPLE_SIZES[@]}"; do
        output_file="$CONFIG_DIR/qwen25vl_3B_fullsft_${variant}_${samples}.yaml"

        # Read source, replace max_samples and output_dir, write to new file
        sed -e "s/max_samples: 500/max_samples: $samples/" \
            -e "s/numsamples500/numsamples$samples/" \
            "$source_file" > "$output_file"

        echo "Created: $output_file"
    done
done

maze_count=$(( ${#MAZE_VARIANTS[@]} * ${#SAMPLE_SIZES[@]} ))
tetris_count=$(( ${#TETRIS_VARIANTS[@]} * ${#SAMPLE_SIZES[@]} ))
total_count=$(( maze_count + tetris_count ))

echo ""
echo "Done! Created $total_count config files:"
echo "  - Maze: $maze_count files"
echo "  - Tetris: $tetris_count files"
