#!/bin/bash
# scripts/verify_key_file.sh
# 2026-05-14 | CR

set -e

set -o allexport; . scripts/.env ; set +o allexport ;

if [ ! -f ~/.ssh/${SSH_KEY_FILE} ]; then
    echo "Error: SSH key file does not exist, please generate it with 'make key-gen-and-transfer' target"
    exit 1
fi

echo "SSH key file verified successfully."
