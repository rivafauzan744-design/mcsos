.RECIPEPREFIX := >
SHELL := /usr/bin/env bash

# 1. Konfigurasi Dasar
ARCH      := x86_64
BUILD_DIR := build
KERNEL    := $(BUILD_DIR)/kernel.elf
MAP       := $(BUILD_DIR)/kernel.map

# 2. Toolchain (Menggunakan LLVM/Clang)
CC        := clang
LD        := ld.lld
OBJDUMP   := objdump
READELF   := readelf
NM        := nm

# 3. Compiler Flags (Optimization & Freestanding)
# Menargetkan kernel x86_64 murni tanpa fitur OS host
CFLAGS := --target=x86_64-unknown-none-elf -std=c17 \
          -ffreestanding -fno-stack-protector -fno-stack-check \
          -fno-pic -fno-pie -fno-lto -m64 -march=x86-64 -mabi=sysv \
          -mno-red-zone -mno-mmx -mno-sse -mno-sse2 \
          -mcmodel=kernel -Wall -Wextra -Werror \
          -Ikernel/arch/x86_64/include

# 4. Linker Flags
LDFLAGS := -nostdlib -static -z max-page-size=0x1000 -T linker.ld -Map=$(MAP)

# 5. Deteksi Source & Object Files
SRC_C  := $(shell find kernel -name '*.c' | LC_ALL=C sort)
OBJ    := $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRC_C))

# ------------------------------------------------------------------------------
# TARGETS
# ------------------------------------------------------------------------------

.PHONY: all build inspect image run debug check-prev check-src \
        check-scripts grade clean distclean

all: build

# Pengecekan prasyarat M1 dan Toolchain
check-prev:
>./tools/scripts/m2_preflight.sh

check-src:
>$(CC) --version | head -n 1
>$(LD) --version | head -n 1
>test -f linker.ld
>test -d kernel/core
>test -d kernel/lib
>test -d kernel/arch/x86_64/include

check-scripts:
>for s in tools/scripts/*.sh; do bash -n "$$s"; done
>@if command -v shellcheck >/dev/null 2>&1; then \
     shellcheck tools/scripts/*.sh; \
 else \
     echo "WARN: shellcheck tidak tersedia"; \
 fi

# Proses Kompilasi
build: $(KERNEL)

$(BUILD_DIR)/%.o: %.c
>mkdir -p $(dir $@)
>$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL): $(OBJ) linker.ld
>mkdir -p $(BUILD_DIR)
>$(LD) $(LDFLAGS) -o $@ $(OBJ)
>@echo "Successfully linked kernel: $@"

# Automasi Workflow (Opsional, memerlukan script di tools/scripts/)
inspect: $(KERNEL)
>./tools/scripts/inspect_kernel.sh

image: $(KERNEL)
>./tools/scripts/make_iso.sh

run: image
>./tools/scripts/run_qemu.sh

debug: image
>./tools/scripts/run_qemu_debug.sh

grade: check-src check-scripts build inspect image run
>./tools/scripts/grade_m2.sh

# Pembersihan
clean:
>rm -rf $(BUILD_DIR)/kernel $(BUILD_DIR)/*.elf $(BUILD_DIR)/*.map $(BUILD_DIR)/inspect
>@echo "Build artifacts cleaned."

distclean:
>rm -rf $(BUILD_DIR) iso_root
>@echo "All generated files and directories removed."

meta:
	mkdir -p .mcsos/metadata
	echo "milestone: m1" > .mcsos/metadata/m1.txt
	touch .mcsos/metadata/m1_done
	echo "m1" > .mcsos/metadata/current_milestone
