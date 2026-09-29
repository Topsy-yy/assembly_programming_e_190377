; nasm -f elf64 01_immediate.asm -o 01_immediate.o &&
; ld 01_immediate.o -o a.out &&
; ./a.out &&
; gdb -silent a.out &&
; layout asm &&
; layout regs &&
; break _start &&
; run


section .text
global _start

_start:

    mov rax, 10
    mov rbx, 20

    add rax, 5

    mov rax, 60
    xor rdi, rdi
    syscall