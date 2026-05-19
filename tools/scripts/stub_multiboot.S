.section .multiboot
.align 4
.long 0x1BADB002             # Magic number Multiboot v1
.long 0x00000000             # Flags
.long -(0x1BADB002 + 0x00000000) # Checksum (harus berjumlah 0)
