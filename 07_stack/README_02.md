## Stack Execution Flow
1. **Function Call (`call work`):** 
    Execution begins in `_start`. 
    The `call` instruction automatically pushes the 64-bit return address (the address of `mov rax, 60`) onto the stack. 
    `rsp` decrements by 8 bytes. 
    Control jumps to the `work` label.

2. **Stack Frame Prologue:** 
   - `push rbp`: The caller's base pointer is saved to the stack.
   - `rsp` decrements by 8.
   - `mov rbp, rsp`: The base pointer (`rbp`) is updated to equal `rsp`. This establishes a fixed reference point (a frame pointer) for the `work` function.

3. **Local Variable Allocation (`sub rsp, 16`):** 
    The stack pointer is manually shifted 16 bytes further down into lower memory (16 bits decremented). 
    This reserves space on the stack for local variables without overwriting existing data.

4. **Memory Operations:** 
    `100` is moved into `[rbp - 8]` and `200` is moved into `[rbp - 16]`. 
    These values are stored within the allocated stack frame and then successfully read back into `rax` and `rbx`.

5. **Stack Frame:**
   - `mov rsp, rbp`: The stack pointer is instantly moved back to the base of the frame, deallocating the 16 bytes of local variables.
   - `pop rbp`: The caller's original base pointer is restored from the stack into `rbp`. 
   - `rsp` increments by 8.

6. **Return (`ret`):** 
    The CPU pops the 8-byte return address from the top of the stack into the instruction pointer (`rip`). 
    `rsp` increments by 8, and execution resumes in `_start`.

## Observations
This program illustrates a standard 64-bit C-calling convention. The stack is not only used for data but can be manipulated via `rbp` and `rsp` to create and destroy isolated memory workspaces (stack frames) for subroutines.
one can have the return call at the very beginning of the program. 
when you use the call function the next command is pushed onto the stack so that the call function can be executed first and then popped out and executed afterwards.
Therefore, a stack can hold commands `temporarily` as they `await execution`