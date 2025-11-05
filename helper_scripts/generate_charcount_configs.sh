#!/bin/bash

# Generate charcount configs for different sample sizes
# Usage: ./generate_charcount_configs.sh

set -e

CONFIG_DIR="configs"
SAMPLE_SIZES=(1000 2000 5000 10000)
CHARCOUNT_SIZES=(4 6 8)

# Define all variants
VARIANTS=(
    "sft"
    "nooptions_sft"
    "textual-cot"
    "nooptions_textual-cot"
)

echo "Generating charcount config files..."

for size in "${CHARCOUNT_SIZES[@]}"; do
    echo ""
    echo "Processing charcount_${size}..."

    for variant in "${VARIANTS[@]}"; do
        source_file="$CONFIG_DIR/qwen25vl_3B_fullsft_charcount_${size}_${variant}_500.yaml"

        if [ ! -f "$source_file" ]; then
            echo "Error: Source file $source_file not found"
            exit 1
        fi

        for samples in "${SAMPLE_SIZES[@]}"; do
            output_file="$CONFIG_DIR/qwen25vl_3B_fullsft_charcount_${size}_${variant}_${samples}.yaml"

            # Read source, replace max_samples and output_dir, write to new file
            sed -e "s/max_samples: 500/max_samples: $samples/" \
                -e "s/numsamples500/numsamples$samples/" \
                "$source_file" > "$output_file"

            echo "  Created: $output_file"
        done
    done
done

total_count=$((${#CHARCOUNT_SIZES[@]} * ${#VARIANTS[@]} * ${#SAMPLE_SIZES[@]}))

echo ""
echo "Done! Created $total_count config files:"
echo "  - charcount_4: $(( ${#VARIANTS[@]} * ${#SAMPLE_SIZES[@]} )) files"
echo "  - charcount_6: $(( ${#VARIANTS[@]} * ${#SAMPLE_SIZES[@]} )) files"
echo "  - charcount_8: $(( ${#VARIANTS[@]} * ${#SAMPLE_SIZES[@]} )) files"
