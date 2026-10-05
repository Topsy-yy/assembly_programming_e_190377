# sub/ — SUB and SBB flag behavior

Files run in gdb the same way as add/ (debug build + breakpoint right after the arithmetic
instruction, before the result is stored/overwritten).

## sub2.asm — `sub ax, [num2]` (1000 - 2000)

Result: `AX = 0xFC18` (-1000 as a signed 16-bit value)

Flags: `eflags 0x287  [ CF PF SF IF ]`

- **CF = 1** — a borrow was needed (1000 < 2000), so `SUB` sets carry to signal "borrow occurred" (opposite meaning of CF on ADD).
- **SF = 1** — the two's-complement result is negative (top bit set).
- **PF = 1** — the low byte of the result (0x18) has an even number of set bits.
- **OF = 0** — no signed overflow: subtracting a positive from a smaller positive correctly yields a negative, which is representable.

## sub3.asm — `sub ax, [num2]` then `sbb ax, 0` (0 - 1)

After `sub ax, [num2]` (0 - 1):

Flags: `eflags 0x297  [ CF PF AF SF IF ]`, `AX = 0xFFFF`

- **CF = 1** — borrow needed since 0 < 1.
- **SF = 1** — result 0xFFFF is negative in two's complement.
- **AF = 1** — nibble borrow occurred.
- **PF = 1** — 0xFF has an even number of set bits.

After `sbb ax, 0` (AX - 0 - CF):

Flags: `eflags 0x282  [ SF IF ]`, `AX = 0xFFFE`

- **CF = 0** — 0xFFFF - 0 - 1 = 0xFFFE needs no further borrow.
- **SF = 1** — result is still negative.
- `SBB` mirrors `ADC` for subtraction: it subtracts the previous borrow (`CF`) so a multi-word subtract chains correctly across words.
