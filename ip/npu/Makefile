REPO_ROOT := $(abspath ../..)

.PHONY: nix
nix:
	cd "$(REPO_ROOT)" && nix-shell --run 'cd ip/npu && exec bash --rcfile <(cat "$${HOME}/.bashrc"; printf "%s\n" '\''PS1="\[\\033[01;35m\][nix-shell]\[\\033[00m\] \[\\033[01;32m\]$${USER}@\\h\[\\033[00m\]:\[\\033[01;34m\]\\w\[\\033[00m\]> "'\'') -i'
