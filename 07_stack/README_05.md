## Stack Execution Flow
1. **Execution Begins:** 
    `rax` is loaded with the value that is in the memory address `0x1122334455667788` (in this case the value is 1234605616436508552) 
    and `rbx` with the value that's in the memory address `0x1234` (in this case the value is 4660).

2. **State Preservation (Pushing):**
   - `push rax`: `rsp` is decremented by 8 bytes. The 64-bit value in `rax` is pushed onto the descending stack.
   - `push rbx`: `rsp` is decremented by another 8 bytes. The 64-bit value in `rbx` is pushed on top of `rax`.

3. **State Restoration (Popping):**
   - `pop rbx`: To restore the exact state, the program must pop in reverse order due to LIFO architecture. The top 8 bytes (`0x1234`) are read back into `rbx` and `rsp` increments by 8 bytes.
   - `pop rax`: The next 8 bytes (`0x1122334455667788`) are read back into `rax` and `rsp` increments by 8 bytes, perfectly rebalancing the stack.

## Observations
One can populate the registers using memory addresses
This file highlights the stack's utility for temporary register preservation. By symmetrically mirroring the push and pop order, a program can safely back up data, utilize the registers for other tasks and restore the exact initial state before continuing.