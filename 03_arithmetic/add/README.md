# add/ — ADD and ADC flag behavior

Files run in gdb (`nasm -f elf32 -g -F dwarf <file>.asm -o <file>.o && ld -m elf_i386 <file>.o -o <file>`,
then `gdb -batch -ex "break <file>:<line>" -ex run -ex "info registers eflags"`).

## add2.asm — `add ax, [num2]` (32000 + 500)

Result: `AX = 0x7EF4` (32500)

Flags: `eflags 0x202  [ IF ]`

- No flag other than the always-on `IF` is set.
- **CF = 0** — no unsigned overflow, 32500 fits in 16 bits.
- **OF = 0** — 32500 still fits in the signed 16-bit range check used by the CPU (no sign change from two positives).
- **ZF = 0 / SF = 0** — result is non-zero and positive.

## add3.asm — `add ax, [num2]` then `adc ax, 0` (0xFFFF + 1)

After `add ax, [num2]` (0xFFFF + 1):

Flags: `eflags 0x257  [ CF PF AF ZF IF ]`, `AX = 0x0000`

- **CF = 1** — the addition produced a carry out of bit 15 (0xFFFF + 1 = 0x10000, truncated to 0x0000). This is exactly the case ADC is meant to pick up.
- **ZF = 1** — the truncated 16-bit result is 0.
- **AF = 1** — carry out of bit 3 (nibble carry) also occurred.
- **PF = 1** — the result byte 0x00 has an even number of set bits (0).

After `adc ax, 0` (0 + CF):

Flags: `eflags 0x202  [ IF ]`, `AX = 0x0001`

- **CF = 0** — adding 0 + previous carry (1) does not itself carry out.
- All other flags cleared because the result (1) is small, non-zero, and positive.
- This demonstrates why `ADC` exists: it folds the previous `CF` into the next addition so a multi-word add doesn't lose the carry.
