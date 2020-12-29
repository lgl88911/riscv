# __start被放入到.txt.entry段，位于.text的最开始
    .section .text.entry
    .globl __start
# 上电后ROM从__start开始运行：初始化$sp，栈是负增长，所以sp指向boot_stack_top，然后跳回到__start
__start:
    la sp, boot_stack_top
    j __start

    # 要将stack放到bss后面，这里声明字段 .bss.stack 作为启动时的栈
    .section .bss.stack
    .global boot_stack
boot_stack:
    # 4K 启动栈大小
    .space 4096 * 4
    .global boot_stack_top
boot_stack_top:
    # 栈结尾
