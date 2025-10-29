#!/bin/bash

# Generate frozenlake configs for different sample sizes
# Usage: ./generate_frozenlake_configs.sh

set -e

CONFIG_DIR="configs"
SAMPLE_SIZES=(1000 2000 5000)
VARIANTS=(
    "sft"
    "nooptions_sft"
    "textual-cot"
    "nooptions_textual-cot"
)

# Map variant names to their source files
declare -A VARIANT_FILES=(
    ["sft"]="qwen25vl_3B_fullsft_frozenlake_4_sft_500.yaml"
    ["nooptions_sft"]="qwen25vl_3B_fullsft_frozenlake_4_nooptions_sft_500.yaml"
    ["textual-cot"]="qwen25vl_3B_fullsft_frozenlake_4_textual-cot_500.yaml"
    ["nooptions_textual-cot"]="qwen25vl_3B_fullsft_frozenlake_4_nooptions_textual-cot_500.yaml"
)

# Map variant names to their output file patterns
declare -A VARIANT_OUTPUT=(
    ["sft"]="qwen25vl_3B_fullsft_frozenlake_4_sft"
    ["nooptions_sft"]="qwen25vl_3B_fullsft_frozenlake_4_nooptions_sft"
    ["textual-cot"]="qwen25vl_3B_fullsft_frozenlake_4_textual-cot"
    ["nooptions_textual-cot"]="qwen25vl_3B_fullsft_frozenlake_4_nooptions_textual-cot"
)

echo "Generating frozenlake config files..."

for variant in "${VARIANTS[@]}"; do
    source_file="$CONFIG_DIR/${VARIANT_FILES[$variant]}"

    if [ ! -f "$source_file" ]; then
        echo "Error: Source file $source_file not found"
        exit 1
    fi

    for samples in "${SAMPLE_SIZES[@]}"; do
        output_file="$CONFIG_DIR/${VARIANT_OUTPUT[$variant]}_${samples}.yaml"

        # Read source, replace max_samples and output_dir, write to new file
        sed -e "s/max_samples: 500/max_samples: $samples/" \
            -e "s/numsamples500/numsamples$samples/" \
            "$source_file" > "$output_file"

        echo "Created: $output_file"
    done
done

echo "Done! Created $(( ${#VARIANTS[@]} * ${#SAMPLE_SIZES[@]} )) config files."
