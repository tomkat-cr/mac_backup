# mac_backup

Automated macOS-to-Linux file backup using `rsync` over SSH, with optional daily scheduling via `launchd`. It handles backups with deletion tracking.

## Requirements

- macOS with `rsync`, `make`, and `ssh-keygen` available (both ship with macOS)
- A Linux server accessible over SSH on your local network

## Setup

**1. Clone the repository**

```bash
cd ~
mkdir -p scripts
cd scripts
git clone https://github.com/tomkat-cr/mac_backup.git
```

**2. Install**

```bash
make install
```

This makes all scripts executable and copies `.env.example` to `scripts/.env`.

**3. Configure**

Edit `scripts/.env` with your values:

```bash
SOURCE_DIR="/Users/yourname/Documents/"   # local directory to back up
REMOTE_USER="linux_user"                  # SSH user on the Linux server
REMOTE_HOST="192.168.1.100"               # IP or hostname of the Linux server
TARGET_DIR="/home/linux_user/backups/mac" # destination path on the server
TARGET_DELETED_FILES_DIR="/home/linux_user/backups/mac_deleted_files" # destination path for deleted files on the server
LOG_FILE="/Users/yourname/logs/backup.log" # local path for the backup log
SSH_KEY_FILE="id_ed25519"                  # key filename (loaded from ~/.ssh/)
```

**4. Generate and copy SSH key**

```bash
make key-gen-and-transfer
```

Generates an `ed25519` key pair at `~/.ssh/$SSH_KEY_FILE` and copies the public key to the remote host via `ssh-copy-id`. You will be prompted for your remote password once.

**5. Run a manual backup**

```bash
make backup
```

## Automated scheduling (launchd)

To run backups automatically at 8:00 AM daily:

```bash
make setup-launchd
```

This installs a launchd plist at `~/Library/LaunchAgents/com.user.macbackup.plist`.

> **Note:** `setup_launchd.sh` expects the backup script to be at `~/scripts/mac_backup/backup.sh`. Either copy/symlink the repo there, or edit `SCRIPT_PATH` in `scripts/setup_launchd.sh` before running this target.

Manage the scheduled job:

```bash
make run-launchd      # trigger immediately
make check-launchd    # check status (exit code 0 = last run succeeded)
make disable-launchd  # unload the agent
```

## How it works

`backup.sh` uses `rsync` in archive + mirror mode:

```
rsync -avz --delete --exclude='.DS_Store' --exclude='.Trash' \
  -e ssh -i ~/.ssh/<key> \
  <SOURCE_DIR> <REMOTE_USER>@<REMOTE_HOST>:<TARGET_DIR>
```

- `--delete` keeps the remote a mirror: files removed locally are also removed remotely.
- `--exclude` skips macOS system noise (`.DS_Store`, `.Trash`).
- Results are appended to `$LOG_FILE` on each run.

## Reference

| Command | Description |
|---|---|
| `make install` | Make scripts executable, create `scripts/.env` |
| `make verify-envs` | Validate `.env` is populated with real values |
| `make key-gen-and-transfer` | Generate SSH key and copy it to remote host |
| `make backup` | Run backup immediately |
| `make setup-launchd` | Install and load daily launchd job |
| `make run-launchd` | Trigger launchd job manually |
| `make check-launchd` | Check last launchd run status |
| `make disable-launchd` | Unload launchd agent |

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## Credits

This project is developed and maintained by [Carlos J. Ramirez](https://www.carlosjramirez.com). For more information or to contribute to the project, visit [Mac Backup on GitHub](https://github.com/tomkat-cr/mac_backup).

Happy Coding!
