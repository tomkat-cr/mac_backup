#!/bin/bash
# scripts/copy_env_example.sh
# 2026-05-14 | CR

set -e

if [ -f scripts/.env ]; then
    echo "scripts/.env already exists, skipping..."
    exit 0
fi

echo "Copying .env.example to .env..."
cp scripts/.env.example scripts/.env

echo "scripts/.env created successfully."
