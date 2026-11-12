**This is 64 bit program**

## Stack Execution Flow
1. **Execution Begins:** 
    The program initializes by moving `100` into register `rax` and `200` into register `rbx`. 
    At this point, the stack pointer (`rsp`) points to the top of the current stack in memory.

2. **First Push (`push rax`):** 
    The stack grows downwards (from high memory to low memory for example for a 16 bit stack, it will decrement from FFFF to FFFE and so on). 
    `rsp` is decremented by 8 bytes (64-bit architecture). 
    The value in `rax` (100) is written to the memory address/location pointed to by `rsp`.

3. **Second Push (`push rbx`):** 
    `rsp` is decremented by another 8 bytes. 
    The value in `rbx` (200) is written to the new memory location pointed to by `rsp`. 
    The stack now holds `200` at the very top (lowest memory address) and `100` immediately below it.

4. **First Pop (`pop rcx`):** 
    The CPU reads the 8-byte value at the current `rsp` address (200) and copies it into `rcx`. 
    `rsp` is then incremented by 8 bytes, moving the `rsp` upwards and effectively removing the 200.

5. **Second Pop (`pop rdx`):** 
    The CPU reads the new top 8-byte value (100) into `rdx`. 
    `rsp` is incremented by another 8 bytes, returning the stack pointer to its exact original position before the pushes began.

6. **Exit**  
    The program gracefully exits using the syscall instruction with `rax` set to 60 (the exit system call number in Linux) and `rdi` set to 0 (the exit status).  

## Observations
The program demonstrates the stack's Last-In-First-Out (LIFO) behavior. Because the stack grows towards lower memory addresses, pushing subtracts from the stack pointer and popping adds to it. 
This mechanism allows the program to seamlessly copy the values from `rax` and `rbx` into `rcx` and `rdx` in reverse order.
Also the values from `rax` and `rbx` were copied into the stack and then into `rcx` and `rdx` without removing them from their original registers.
Also, changing the value of `rax` did not affect the value of `rdx`