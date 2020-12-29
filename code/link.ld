/* 目标架构 */
OUTPUT_ARCH("riscv")
OUTPUT_FORMAT("elf32-littleriscv")

/* 存储器信息 */
MEMORY
{
    ROM (rx) : ORIGIN = 541065216, LENGTH = 12582912
    RAM (rwx) : ORIGIN = 0x80000000, LENGTH = ((16) << 10)
    IDT_LIST (wx) : ORIGIN = 0xFFFFF7FF, LENGTH = 2K
}

/* 程序入口__start */
ENTRY("__start")

SECTIONS
{
    image_start = .;

    text_start = .;

    /* .text section, 代码段被放入ROM中 */
    .text : {
        /* 入口函数所在段，放到最开始 */
        *(.text.entry)
        /* 被链接的文件的可执行代码段全部放这里 */
        *(.text .text.*)
    } > ROM

    rodata_start = .;

    /* .rodata section, 只读数据段被放入ROM中*/
    .rodata : {
         /* 被链接的文件的只读数据段全部放这里 */
        *(.rodata .rodata.*)
    } > ROM

    data_start = .;

    /* .data section, 有初始化值数据段被放入RAM中 */
    .data : {
        /* 被链接的文件中经过初始化的数据全部放这里 */
        *(.data .data.*)
    } > RAM

    bss_start = .;

    /* .bss section, 未初始化数据段被放入RAM中 */
    .bss : {
        /* 被链接的文件中经过初始化的数据全部放这里 */
        *(.sbss .bss .bss.*)
    } > RAM

    image_end = .;
}
	