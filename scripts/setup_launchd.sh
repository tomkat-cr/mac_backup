#!/bin/bash
# scripts/setup_launchd.sh
# 2026-05-14 | CR
 
# --- CONFIGURATION ---
# The unique label for your service
LABEL="com.user.macbackup"
# Path to your existing backup script
SCRIPT_PATH="$HOME/scripts/mac_backup/scripts/backup.sh"
# Where you want the plist to live
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
# Log paths
STDOUT_LOG="$HOME/logs/backup.launchd.out.log"
STDERR_LOG="$HOME/logs/backup.launchd.err.log"
# ---------------------

echo "Creating launchd plist at $PLIST_PATH..."

# Ensure log directory exists
mkdir -p "$HOME/logs"

# Use a Heredoc to write the XML content
cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_PATH</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>8</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

    <key>RunAtLoad</key>
    <true/>

    <key>StandardOutPath</key>
    <string>$STDOUT_LOG</string>

    <key>StandardErrorPath</key>
    <string>$STDERR_LOG</string>
</dict>
</plist>
EOF

# Set permissions (standard for LaunchAgents)
chmod 644 "$PLIST_PATH"

# Load the agent
echo "Loading agent into launchctl..."
launchctl load "$PLIST_PATH"

echo "Done! Your backup is scheduled for 8:00 AM daily (and will run on load/wake)."
