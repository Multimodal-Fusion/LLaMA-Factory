#!/bin/bash

# Generate clevrlite configs for different sample sizes
# From base _500.yaml configs, create 1000, 2000, 5000, 10000 variants

SIZES=(4 6 8)
VARIANTS=("sft" "nooptions_sft" "textual-cot" "nooptions_textual-cot")
SAMPLES=(1000 2000 5000 10000)
CONFIG_DIR="configs"

for size in "${SIZES[@]}"; do
    for variant in "${VARIANTS[@]}"; do
        BASE_FILE="${CONFIG_DIR}/qwen25vl_3B_fullsft_clevrlite_${size}_${variant}_500.yaml"

        for sample in "${SAMPLES[@]}"; do
            NEW_FILE="${CONFIG_DIR}/qwen25vl_3B_fullsft_clevrlite_${size}_${variant}_${sample}.yaml"

            # Copy base file and replace max_samples and output_dir
            sed -e "s/max_samples: 500/max_samples: ${sample}/" \
                -e "s/numsamples500/numsamples${sample}/" \
                "${BASE_FILE}" > "${NEW_FILE}"
        done
    done
done

echo "Generated 48 additional config files for clevrlite task"
echo "Total clevrlite configs: 60 (12 base + 48 variants)"
