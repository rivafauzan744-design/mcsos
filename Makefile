# === Configuration ===
BUILD_DIR := build
SMOKE_DIR := smoke
TOOLS_DIR := tools
META_DIR  := $(BUILD_DIR)/meta

# Compiler Flags untuk x86_64 Freestanding
CFLAGS := --target=x86_64-unknown-none \
          -std=c17 \
          -ffreestanding \
          -fno-stack-protector \
          -fno-pic \
          -mno-red-zone \
          -mno-mmx -mno-sse -mno-sse2 \
          -Wall -Wextra -Werror

.PHONY: all meta check smoke qemu-version clean distclean tree

all: check smoke

# === Target Utama ===

meta:
	@mkdir -p $(META_DIR)
	@bash $(TOOLS_DIR)/check_env.sh

check:
	@shellcheck $(TOOLS_DIR)/check_env.sh
	@bash $(TOOLS_DIR)/check_env.sh

smoke:
	@mkdir -p $(BUILD_DIR)/smoke
	clang $(CFLAGS) -c $(SMOKE_DIR)/freestanding.c -o $(BUILD_DIR)/smoke/freestanding.o
	readelf -h $(BUILD_DIR)/smoke/freestanding.o | tee $(BUILD_DIR)/smoke/readelf-header.txt
	objdump -drwC $(BUILD_DIR)/smoke/freestanding.o | tee $(BUILD_DIR)/smoke/objdump.txt >/dev/null
	file $(BUILD_DIR)/smoke/freestanding.o | tee $(BUILD_DIR)/smoke/file.txt

qemu-version:
	@qemu-system-x86_64 --version
	@echo "QEMU exists. M0 does not boot a kernel image."

tree:
	@tree -a -L 3 -I ".git"

# === Cleanup ===

clean:
	rm -rf $(BUILD_DIR)/smoke

# distclean menghapus seluruh folder build termasuk metadata
distclean:
	rm -rf $(BUILD_DIR)
