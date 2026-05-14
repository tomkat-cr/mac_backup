# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A macOS-to-Linux backup system using `rsync` over SSH, with optional `launchd` scheduling for daily automated runs. All scripts live in `scripts/` and all user configuration is in `scripts/.env` (not committed — copied from `scripts/.env.example`).

## Setup flow

```bash
make install          # make scripts executable + copy .env.example → scripts/.env
# edit scripts/.env with real values (see env vars below)
make key-gen-and-transfer   # generate ed25519 key and copy it to remote host
make setup-launchd    # install launchd plist at ~/Library/LaunchAgents/com.user.macbackup.plist
```

## Common commands

```bash
make backup           # run rsync backup immediately
make run-launchd      # trigger the launchd job manually
make disable-launchd  # unload the launchd agent
make check-launchd    # confirm launchd status (exit code 0 = last run succeeded)
make verify-envs      # validate scripts/.env is populated with real values
make verify-key-file  # confirm SSH key exists at ~/.ssh/$SSH_KEY_FILE
```

All `make` targets that touch the remote host depend on `verify-envs` (and most also on `verify-key-file`), so misconfigured `.env` values fail fast.

## Environment variables (`scripts/.env`)

| Variable | Description |
|---|---|
| `SOURCE_DIR` | Local path to back up (must exist) |
| `REMOTE_USER` | SSH user on the Linux server |
| `REMOTE_HOST` | IP or hostname of the Linux server |
| `TARGET_DIR` | Destination path on the remote host |
| `TARGET_DELETED_FILES_DIR` | Destination path for deleted files on the remote host |
| `LOG_FILE` | Local path for the backup log |
| `SSH_KEY_FILE` | Filename only (e.g. `id_ed25519`) — key loaded from `~/.ssh/` |

`verify_envs.sh` rejects placeholder values (e.g. `linux_user`, `192.168.1.XX`) so the template values cannot slip through.

## Architecture

Scripts load `.env` via `set -o allexport; . scripts/.env ; set +o allexport` and must be run from the repo root (paths like `scripts/.env` are relative).

- **`backup.sh`** — core rsync call with `--delete` (mirror semantics), `--backup` (to keep deleted files), and `--exclude` for `.DS_Store`/`.Trash`; appends results to `$LOG_FILE`. It also creates the deleted files directory on the remote host if it doesn't exist.
- **`setup_launchd.sh`** — writes a plist to `~/Library/LaunchAgents/com.user.macbackup.plist` scheduled for 08:00 daily; `SCRIPT_PATH` is hardcoded to `$HOME/scripts/mac_backup/backup.sh` (not the repo path), so the script must be copied/linked there separately.
- **`key_generation.sh`** — runs `ssh-keygen -t ed25519` then `ssh-add`.
- **`key_transfer.sh`** — runs `ssh-copy-id` to authorize the key on the remote host.

## Important constraint

`setup_launchd.sh` hardcodes `SCRIPT_PATH="$HOME/scripts/mac_backup/backup.sh"`. If the repo lives elsewhere, either update that path in the script or symlink it to `~/scripts/mac_backup/backup.sh` before running `make setup-launchd`.
