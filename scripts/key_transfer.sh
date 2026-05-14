#!/bin/bash
# scripts/key_transfer.sh
# 2026-05-14 | CR

set -e
set -o allexport; . scripts/.env ; set +o allexport ;

echo ""
echo "Copying key to the server..."
echo "Executing: ssh-copy-id -i ~/.ssh/${SSH_KEY_FILE} ${REMOTE_USER}@${REMOTE_HOST}"
echo ""

ssh-copy-id -i ~/.ssh/${SSH_KEY_FILE} ${REMOTE_USER}@${REMOTE_HOST}

echo ""
echo "Key copied to the server successfully."
