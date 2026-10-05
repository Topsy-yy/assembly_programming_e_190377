# mul/ — MUL flag behavior

Files run in gdb the same way as add/. `MUL` (unsigned multiply) only ever defines `CF` and `OF`;
`ZF`, `SF`, `PF`, `AF` are left undefined/unpredictable by the ISA.

## mul1.asm — `mul byte [num2]` (25 * 10, byte operands → AX)

Result: `AX = 0x00FA` (250)

Flags: `eflags 0x202  [ IF ]`

- **CF = 0, OF = 0** — for byte `MUL`, these flags are set only if the high half of the result
  (`AH`) is non-zero, i.e. the product doesn't fit in 8 bits. Here `AH = 0x00`, so both are clear.

## mul2.asm — `mul word [num2]` (3000 * 200, word operands → DX:AX)

Result: `DX:AX = 0x0009:0x27C0` (600000)

Flags: `eflags 0xa03  [ CF OF IF ]`

- **CF = 1, OF = 1** — for word `MUL`, these are set when the upper half of the double-width
  result (`DX`) is non-zero. Here `DX = 0x0009 ≠ 0`, so the product didn't fit in 16 bits and
  both flags are raised together (they always match for `MUL`).
- This is the standard way to detect that a multiply "overflowed" its single-register width and
  the extra bits in `DX`/`EDX` must be kept/handled.
