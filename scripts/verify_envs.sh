#!/bin/bash
# scripts/verify_envs.sh
# 2026-05-14 | CR

set -e

echo "Verifying environment variables..."

if [ ! -f scripts/.env ]; then
    echo "Error: scripts/.env does not exist"
    exit 0
fi

set -o allexport; . scripts/.env ; set +o allexport ;

if [ -z "$SOURCE_DIR" ] || [ -z "$REMOTE_USER" ] || [ -z "$REMOTE_HOST" ] || [ -z "$TARGET_DIR" ] || [ -z "$LOG_FILE" ] || [ -z "$SSH_KEY_FILE" ]; then
    echo "Error: Missing environment variables"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist"
    exit 1
fi

if [ "$SOURCE_DIR" = "/Users/yourname/Documents/" ]; then
    echo "Error: Source directory is not set"
    exit 1
fi

if [ "$REMOTE_USER" = "linux_user" ]; then
    echo "Error: Remote user is not set"
    exit 1
fi

if [ "$REMOTE_HOST" = "192.168.1.XX" ]; then
    echo "Error: Remote host is not set"
    exit 1
fi

if [ "$TARGET_DIR" = "/home/linux_user/backups/macbook/" ]; then
    echo "Error: Target directory is not set"
    exit 1
fi

if [ "$LOG_FILE" = "/Users/yourname/logs/backup.log" ]; then
    echo "Error: Log file is not set"
    exit 1
fi

echo "Environment variables verified successfully."