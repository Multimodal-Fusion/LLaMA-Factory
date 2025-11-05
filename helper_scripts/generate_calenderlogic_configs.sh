#!/bin/bash

# Generate calenderlogic configs for different sample sizes
# Usage: ./generate_calenderlogic_configs.sh

set -e

CONFIG_DIR="configs"
SAMPLE_SIZES=(1000 2000 5000 10000)
CALENDERLOGIC_SIZES=(4 6 8)

# Define all variants
VARIANTS=(
    "sft"
    "nooptions_sft"
    "textual-cot"
    "nooptions_textual-cot"
)

echo "Generating calenderlogic config files..."

for size in "${CALENDERLOGIC_SIZES[@]}"; do
    echo ""
    echo "Processing calenderlogic_${size}..."

    for variant in "${VARIANTS[@]}"; do
        source_file="$CONFIG_DIR/qwen25vl_3B_fullsft_calenderlogic_${size}_${variant}_500.yaml"

        if [ ! -f "$source_file" ]; then
            echo "Error: Source file $source_file not found"
            exit 1
        fi

        for samples in "${SAMPLE_SIZES[@]}"; do
            output_file="$CONFIG_DIR/qwen25vl_3B_fullsft_calenderlogic_${size}_${variant}_${samples}.yaml"

            # Read source, replace max_samples and output_dir, write to new file
            sed -e "s/max_samples: 500/max_samples: $samples/" \
                -e "s/numsamples500/numsamples$samples/" \
                "$source_file" > "$output_file"

            echo "  Created: $output_file"
        done
    done
done

total_count=$((${#CALENDERLOGIC_SIZES[@]} * ${#VARIANTS[@]} * ${#SAMPLE_SIZES[@]}))

echo ""
echo "Done! Created $total_count config files:"
echo "  - calenderlogic_4: $(( ${#VARIANTS[@]} * ${#SAMPLE_SIZES[@]} )) files"
echo "  - calenderlogic_6: $(( ${#VARIANTS[@]} * ${#SAMPLE_SIZES[@]} )) files"
echo "  - calenderlogic_8: $(( ${#VARIANTS[@]} * ${#SAMPLE_SIZES[@]} )) files"
