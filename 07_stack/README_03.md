## Stack Execution Flow
1. **Execution Begins:** 
    `rax` is loaded with `10`.

2. **The Call (`call calculate`):** 
    The `call` instruction pushes the address of the next sequential instruction (`after_call:`) onto the stack, decrementing `rsp` by 8 bytes. The processor then jumps execution to the `calculate` label.

3. **Subroutine Execution:** 
    Inside `calculate`, `add rax, 5` executes. 
    the value inside register `rax` becomes `15`
    The stack remains completely untouched during this arithmetic operation.

4. **The Return (`ret`):** 
    The `ret` instruction retrieves the 8-byte address currently at the top of the stack (`rsp`) and loads it into the instruction pointer (`rip`). `rsp` is incremented by 8 bytes, cleaning up the stack.

5. **Resumption:** 
    Execution picks up exactly at `after_call:`, running the `nop` and subsequent exit syscall.

## Observations
Unlike standard functions, `calculate` does not set up a base pointer (`rbp`) or allocate local variables. This shows that the stack's most fundamental role in control flow is simply preserving return addresses to ensure the program knows where to go after a subroutine finishes.