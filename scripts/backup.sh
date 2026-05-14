#!/bin/bash
# scripts/backup.sh
# 2026-05-14 | CR

set -e
set -o allexport; . scripts/.env ; set +o allexport ;

# ---------------------
echo ""
echo "Backup using the following environment variables:"
echo ""
echo "SOURCE_DIR=${SOURCE_DIR}"
echo "REMOTE_USER=${REMOTE_USER}"
echo "REMOTE_HOST=${REMOTE_HOST}"
echo "TARGET_DIR=${TARGET_DIR}"
echo "LOG_FILE=${LOG_FILE}"
echo "SSH_KEY_FILE=${SSH_KEY_FILE}"
echo ""
# ---------------------

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

echo "--- Backup Started..."
echo "" >> "$LOG_FILE"
echo "--- Backup Started: $(date) ---" >> "$LOG_FILE"

if [ -z "$SOURCE_DIR" ] || [ -z "$REMOTE_USER" ] || [ -z "$REMOTE_HOST" ] || [ -z "$TARGET_DIR" ] || [ -z "$LOG_FILE" ] || [ -z "$SSH_KEY_FILE" ]; then
    echo ""
    echo "Error: Missing environment variables" >> "$LOG_FILE"
    echo "Error: Missing environment variables"
    echo ""
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo ""
    echo "Error: Source directory does not exist" >> "$LOG_FILE"
    echo "Error: Source directory does not exist"
    echo ""
    exit 1
fi

# rsync flags:
# -a: Archive mode (preserves symlinks, permissions, etc.)
# -v: Verbose
# -z: Compress data during transfer
# --delete: Delete files on Pi that no longer exist on Mac (Mirroring)
# --exclude: Skip hidden system files/caches

echo ""
echo "Executing:"
echo "rsync -avz --verbose --delete --exclude='.DS_Store' --exclude='.Trash' -e ssh -i ~/.ssh/${SSH_KEY_FILE} --rsync-path=\"mkdir -p ${TARGET_DIR} && rsync\" \"${SOURCE_DIR}\" \"${REMOTE_USER}@${REMOTE_HOST}:${TARGET_DIR}\""
echo ""

rsync \
    -avz \
    --verbose \
    --delete \
    --exclude='.DS_Store' \
    --exclude='.Trash' \
    -e ssh -i ~/.ssh/${SSH_KEY_FILE} \
    --rsync-path="mkdir -p ${TARGET_DIR} && rsync" \
    "${SOURCE_DIR}" "${REMOTE_USER}@${REMOTE_HOST}:${TARGET_DIR}" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Backup Successful: $(date)" >> "$LOG_FILE"
    echo ""
    echo "Backup Successful..."
    echo ""
else
    echo "Backup FAILED: $(date)" >> "$LOG_FILE"
    echo ""
    echo "Backup FAILED: $(date)"
    echo ""
fi

echo "---------------------------------" >> "$LOG_FILE"
