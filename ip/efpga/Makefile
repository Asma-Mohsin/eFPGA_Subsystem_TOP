eFPGA_DIR := $(abspath .)
NIX_ROOT := /mnt/SSD4TB/OWAS_NOV/librelane_plugin_fabulous
PDK ?= ihp-sg13cmos5l
PDK_ROOT ?= $(abspath ../../IHP-Open-PDK)
COMMON_CONFIG ?= Tile/include/common.yaml
TILE_DIR ?= Tile
TILES ?= LUT4AB

TILE_PATHS := $(addprefix $(TILE_DIR)/,$(TILES))
TILE_PATHS_OPENROAD := $(addsuffix -openroad,$(TILE_PATHS))
TILE_PATHS_KLAYOUT := $(addsuffix -klayout,$(TILE_PATHS))

.PHONY: all-tiles
all-tiles: $(TILE_PATHS)

$(TILE_PATHS):
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --manual-pdk $(COMMON_CONFIG) $@/config.yaml
.PHONY: $(TILE_PATHS)

$(TILE_PATHS_OPENROAD):
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --manual-pdk $(COMMON_CONFIG) $(subst -openroad,,$@)/config.yaml --last-run --flow OpenInOpenROAD
.PHONY: $(TILE_PATHS_OPENROAD)

$(TILE_PATHS_KLAYOUT):
	librelane --pdk $(PDK) --pdk-root $(PDK_ROOT) --manual-pdk $(COMMON_CONFIG) $(subst -klayout,,$@)/config.yaml --last-run --flow OpenInKLayout
.PHONY: $(TILE_PATHS_KLAYOUT)

.PHONY: nix
nix:
	cd "$(NIX_ROOT)" && nix-shell --run 'cd "$(eFPGA_DIR)" && exec bash --rcfile <(cat "$${HOME}/.bashrc"; printf "%s\n" '\''PS1="\[\\033[01;35m\][nix-shell]\[\\033[00m\] \[\\033[01;32m\]$${USER}@\\h\[\\033[00m\]:\[\\033[01;34m\]\\w\[\\033[00m\]> "'\'') -i'

