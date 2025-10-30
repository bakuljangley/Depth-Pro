#!/bin/bash

# --- Shared dataset root and pairs base path ---
VBR_ROOT="/datasets/vbr_slam/"
PAIRS_BASE_PATH="/home/bjangley/VPR/mast3r-v2/pairs_finetuning"

# --- Base output directory ---
OUTPUT_BASE_DIR="/home/bjangley/VPR/depthpro_vbr"  # Changed folder suffix to 'depthpro_vbr_output'

# --- List of scenes to process ---
SCENES=("ciampino_train1" "campus_train0" "campus_train1") #"spagna_train0" "ciampino_train0" 

# --- Model and Inference Settings ---
SAVE_TYPE="depth"  # or "3d"

# --- Device config ---
export CUDA_VISIBLE_DEVICES=5
export OMP_NUM_THREADS=4
export MKL_NUM_THREADS=4
export NUMEXPR_NUM_THREADS=4
export OPENBLAS_NUM_THREADS=4
for SCENE_NAME in "${SCENES[@]}"
do
    echo "Processing scene: $SCENE_NAME"
    PAIRS_FILE="$PAIRS_BASE_PATH/$SCENE_NAME/all_pairs.txt"
    OUTPUT_DIR="$OUTPUT_BASE_DIR/$SCENE_NAME"  # Keep per-scene output folder organization
    mkdir -p "$OUTPUT_DIR"

    CMD=(python vbr_depthmaps.py  # Assume this is your depth_pro inference script filename
        --vbr_scene "$SCENE_NAME"
        --vbr_root "$VBR_ROOT"
        --pairs_file "$PAIRS_FILE"
        --output_dir "$OUTPUT_DIR"
        --save "$SAVE_TYPE"
    )

    # Execute the assembled command safely
    "${CMD[@]}"

    echo "Finished processing $SCENE_NAME"
done
