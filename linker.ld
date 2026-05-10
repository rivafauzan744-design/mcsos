/* Output sebagai format 64-bit ELF */
OUTPUT_FORMAT(elf64-x86-64)
ENTRY(kmain)

/* Program Headers: Menentukan hak akses segmen memori */
PHDRS
{
    /* Code (Read + Execute) */
    text    PT_LOAD FLAGS(5); 
    /* Constants (Read Only) */
    rodata  PT_LOAD FLAGS(4); 
    /* Variables (Read + Write) */
    data    PT_LOAD FLAGS(6); 
}

SECTIONS
{
    /* Kernel diletakkan di Higher Half Memory (standar kernel 64-bit) */
    . = 0xffffffff80000000;

    __kernel_start = .;

    /* Bagian instruksi kode */
    .text : ALIGN(4096)
    {
        *(.text .text.*)
    } :text

    /* Bagian data yang hanya bisa dibaca (seperti string) */
    .rodata : ALIGN(4096)
    {
        *(.rodata .rodata.*)
    } :rodata

    /* Bagian data yang bisa diubah (variabel global yang sudah diinisialisasi) */
    .data : ALIGN(4096)
    {
        *(.data .data.*)
    } :data

    /* Bagian memori untuk variabel yang belum diinisialisasi (nol) */
    .bss : ALIGN(4096)
    {
        *(COMMON)
        *(.bss .bss.*)
    } :data

    __kernel_end = .;
}
