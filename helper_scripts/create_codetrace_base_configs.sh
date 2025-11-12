#!/bin/bash

# Create base config files for codetrace task
# 3 sizes (4, 6, 8) × 4 variants (sft, nooptions_sft, textual-cot, nooptions_textual-cot) = 12 configs

SIZES=(4 6 8)
CONFIG_DIR="configs"

for size in "${SIZES[@]}"; do
    # 1. Regular sft
    cat > "${CONFIG_DIR}/qwen25vl_3B_fullsft_codetrace_${size}_sft_500.yaml" << EOF
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
dataset: codetrace_${size}[sft]
template: qwen2_vl
cutoff_len: 2048
max_samples: 500
overwrite_cache: true
preprocessing_num_workers: 16
dataloader_num_workers: 4

### output
output_dir: saves/qwen25vl_3B_fullsft_codetrace_${size}_sft_numsamples500_epoch3_lr1en5-v1
logging_steps: 10
save_steps: 1000000000
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

    # 2. Nooptions sft
    cat > "${CONFIG_DIR}/qwen25vl_3B_fullsft_codetrace_${size}_nooptions_sft_500.yaml" << EOF
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
dataset: codetrace_${size}_nooptions[sft]
template: qwen2_vl
cutoff_len: 2048
max_samples: 500
overwrite_cache: true
preprocessing_num_workers: 16
dataloader_num_workers: 4

### output
output_dir: saves/qwen25vl_3B_fullsft_codetrace_${size}_nooptions_sft_numsamples500_epoch3_lr1en5-v1
logging_steps: 10
save_steps: 1000000000
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

    # 3. Regular textual-cot
    cat > "${CONFIG_DIR}/qwen25vl_3B_fullsft_codetrace_${size}_textual-cot_500.yaml" << EOF
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
dataset: codetrace_${size}[textual-cot]
template: qwen2_vl
cutoff_len: 2048
max_samples: 500
overwrite_cache: true
preprocessing_num_workers: 16
dataloader_num_workers: 4

### output
output_dir: saves/qwen25vl_3B_fullsft_codetrace_${size}_textual-cot_numsamples500_epoch3_lr1en5-v1
logging_steps: 10
save_steps: 1000000000
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

    # 4. Nooptions textual-cot
    cat > "${CONFIG_DIR}/qwen25vl_3B_fullsft_codetrace_${size}_nooptions_textual-cot_500.yaml" << EOF
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
dataset: codetrace_${size}_nooptions[textual-cot]
template: qwen2_vl
cutoff_len: 2048
max_samples: 500
overwrite_cache: true
preprocessing_num_workers: 16
dataloader_num_workers: 4

### output
output_dir: saves/qwen25vl_3B_fullsft_codetrace_${size}_nooptions_textual-cot_numsamples500_epoch3_lr1en5-v1
logging_steps: 10
save_steps: 1000000000
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

done

echo "Created 12 base config files for codetrace task"
