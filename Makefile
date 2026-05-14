# PHONY: help install

help:
	cat Makefile

install:
	bash scripts/make_scripts_executable.sh
	bash scripts/copy_env_example.sh

verify-envs:
	bash scripts/verify_envs.sh

key-generation: verify-envs
	bash scripts/key_generation.sh

verify-key-file:
	bash scripts/verify_key_file.sh

key-transfer: verify-envs verify-key-file
	bash scripts/key_transfer.sh

key-gen-and-transfer: verify-envs key-generation key-transfer
	echo "Key generated and transferred successfully."

setup-launchd: verify-envs
	bash scripts/setup_launchd.sh

run-launchd: verify-envs
	launchctl start com.user.macbackup

disable-launchd: verify-envs
	launchctl unload ~/Library/LaunchAgents/com.user.macbackup.plist

check-launchd: verify-envs
	launchctl list | grep macbackup
	# If the second column is `0`, the last run was successful. If it's a non-zero number, it's the exit error code

backup: verify-envs verify-key-file
	bash scripts/backup.sh
