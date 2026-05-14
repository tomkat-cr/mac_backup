#!/bin/bash
# scripts/key_generation.sh
# 2026-05-14 | CR

set -e
set -o allexport; . scripts/.env ; set +o allexport ;

echo ""
echo "Generating a key..."
echo "Press enter through the prompts."
echo ""

ssh-keygen -t ed25519 -f ~/.ssh/${SSH_KEY_FILE}

echo ""
echo "Key generated successfully."

echo ""
echo "Adding key to the agent..."
echo ""

ssh-add ~/.ssh/${SSH_KEY_FILE}

echo ""
echo "Key added to the agent successfully."

# echo "Copying key to the clipboard..."
# cat ~/.ssh/${SSH_KEY_FILE}.pub | pbcopy

# echo "Key copied to the clipboard successfully."
