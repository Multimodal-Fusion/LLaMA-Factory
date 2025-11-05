#!/bin/bash

# Create 12 base visualpemdas config files (_500.yaml)
# Usage: ./create_visualpemdas_base_configs.sh

set -e

CONFIG_DIR="configs"
VISUALPEMDAS_SIZES=(4 6 8)

create_config() {
    local size=$1
    local variant=$2
    local dataset_name=$3
    local save_steps=$4

    local filename="${CONFIG_DIR}/qwen25vl_3B_fullsft_visualpemdas_${size}_${variant}_500.yaml"

    cat > "$filename" << EOF
### model
model_name_or_path: Qwen/Qwen2.5-VL-3B-Instruct
# model_name_or_path: Qwen/Qwen2.5-VL-7B-Instruct
image_max_pixels: 262144
video_max_pixels: 16384
trust_remote_code: true

### method
stage: sft
do_train: true
finetuning_type: full
freeze_vision_tower: true
freeze_multi_modal_projector: true
freeze_language_model: false
deepspeed: examples/deepspeed/ds_z2_config.json # options: [ds_z2_config.json, ds_z3_config.json, ds_z0_config.json, ds_z2_offload_config.json,  ds_z3_offload_config.json]

### dataset
# dataset: mllm_demo,identity,alpaca_en_demo
dataset: ${dataset_name}
template: qwen2_vl
cutoff_len: 2048
max_samples: 500
overwrite_cache: true
preprocessing_num_workers: 16
dataloader_num_workers: 4

### output
output_dir: saves/qwen25vl_3B_fullsft_visualpemdas_${size}_${variant}_numsamples500_epoch3_lr1en5-v1
logging_steps: 10
save_steps: ${save_steps}
plot_loss: true
overwrite_output_dir: true
save_only_model: true
report_to: none  # choices: [none, wandb, tensorboard, swanlab, mlflow]

### train
flash_attn: fa2
enable_liger_kernel: true
use_unsloth_gc: true
per_device_train_batch_size: 1
gradient_accumulation_steps: 2
learning_rate: 1.0e-5
num_train_epochs: 3.0
lr_scheduler_type: cosine
warmup_ratio: 0.1
bf16: true
ddp_timeout: 180000000
resume_from_checkpoint: null

### eval
# val_size: 0.1
# per_device_eval_batch_size: 1
# eval_strategy: steps
# eval_steps: 500
EOF

    echo "Created: $filename"
}

echo "Creating visualpemdas base config files..."

for size in "${VISUALPEMDAS_SIZES[@]}"; do
    echo ""
    echo "Creating configs for visualpemdas_${size}..."

    # sft variant
    create_config "$size" "sft" "visualpemdas_${size}[sft]" "1000000000"

    # nooptions_sft variant
    create_config "$size" "nooptions_sft" "visualpemdas_${size}_nooptions[sft]" "1000000000"

    # textual-cot variant
    create_config "$size" "textual-cot" "visualpemdas_${size}[textual-cot]" "1000000000"

    # nooptions_textual-cot variant
    create_config "$size" "nooptions_textual-cot" "visualpemdas_${size}_nooptions[textual-cot]" "1000000000"
done

echo ""
echo "Done! Created 12 base config files."
