project(riscv)
enable_language(C ASM)
set(CMAKE_ASM_COMPILER riscv64-zephyr-elf-gcc)

#set(CMAKE_ASM_FLAGS "${CFLAGS} -x assembler-with-cpp")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -nostdlib -T ${CMAKE_SOURCE_DIR}/link.ld")

set(RISCV_SRC reset.s)

add_executable(init.elf ${RISCV_SRC})


add_custom_command(TARGET init.elf POST_BUILD
	COMMAND riscv64-zephyr-elf-objcopy -O binary init.elf init.bin
)

add_custom_target(run
    COMMAND qemu-system-riscv32 -nographic -machine sifive_e -net none -pidfile qemu.pid -chardev stdio,id=con,mux=on -serial chardev:con -mon chardev=con,mode=readline -icount shift=6,align=off,sleep=off -rtc clock=vm -kernel init.elf
    DEPENDS init.elf
    WORKING_DIRECTORY ${CMAKE_PROJECT_DIR}
)

add_custom_target(debug
    COMMAND qemu-system-riscv32 -nographic -machine sifive_e -net none -pidfile qemu.pid -chardev stdio,id=con,mux=on -serial chardev:con -mon chardev=con,mode=readline -icount shift=6,align=off,sleep=off -rtc clock=vm -s -S -kernel init.elf &
    COMMAND riscv64-zephyr-elf-gdb -ex "target remote :1234" init.elf
    DEPENDS init.elf
    WORKING_DIRECTORY ${CMAKE_PROJECT_DIR}
)

add_custom_target(kill
    COMMAND pkill qemu-system-ris*
    WORKING_DIRECTORY ${CMAKE_PROJECT_DIR}
)