; nasm -f elf32 01_immediate.asm
; ld -m elf_i386 01_immediate.o -o a.out
; ./a.out
; gdb -silent a.out
; lay asm
; lay reg
; break _start
; run

section .text
global _start

_start:

    mov eax, 10
    mov ebx, 20

    add eax, 5

    mov eax, 1
    int 0x80