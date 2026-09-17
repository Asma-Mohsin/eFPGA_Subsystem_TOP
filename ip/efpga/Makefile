EFPG_DIR := $(abspath .)
NIX_ROOT := /mnt/SSD4TB/OWAS_NOV/librelane_plugin_fabulous

.PHONY: nix
nix:
	cd "$(NIX_ROOT)" && nix-shell --run 'cd "$(EFPG_DIR)" && exec bash --rcfile <(cat "$${HOME}/.bashrc"; printf "%s\n" '\''PS1="\[\\033[01;35m\][nix-shell]\[\\033[00m\] \[\\033[01;32m\]$${USER}@\\h\[\\033[00m\]:\[\\033[01;34m\]\\w\[\\033[00m\]> "'\'') -i'
