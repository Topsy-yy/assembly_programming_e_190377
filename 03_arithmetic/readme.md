# Assembly Arithmetic Instructions and CPU Flags

## 1. ADD

The `add2` program was assembled and executed using GDB.

The result observed was:

```text
AX = 0x7ef4
EFLAGS = 0x202 [ IF ]
```

### Observation

The addition produced the value:

```text
AX = 0x7EF4
```

The arithmetic flags were not set:

```text
CF = 0
PF = 0
AF = 0
ZF = 0
SF = 0
OF = 0
```

The `IF` flag was set:

```text
IF = 1
```

The final observation is that the result was not zero, was not negative, and there was no carry or signed overflow.

---

## 2. ADC (Add with Carry)

The `add3` program was used to demonstrate `ADC`.

The first breakpoint was placed before:

```asm
adc ax, 0
```

At this point GDB showed:

```text
EFLAGS = 0x257 [ CF PF AF ZF IF ]
AX = 0x0
```

The important flag here was:

```text
CF = 1
```

The `ADC` instruction was then executed.

At the second breakpoint:

```text
EFLAGS = 0x202 [ IF ]
AX = 0x1
```

### Observation

`ADC` adds the value of the Carry Flag to the normal addition.

The calculation was effectively:

```text
AX = AX + 0 + CF
AX = 0 + 0 + 1
AX = 1
```

Therefore:

```text
Before ADC: AX = 0x0000, CF = 1
After ADC:  AX = 0x0001
```

This showed that the Carry Flag can be used as an input to another arithmetic instruction.

---

## 3. SUB

The `sub2` program was used to test subtraction.

The observed result was:

```text
AX = 0xfc18
EFLAGS = 0x287 [ CF PF SF IF ]
```

### Observation

The result was:

```text
AX = 0xFC18
```

The set flags were:

```text
CF = 1
PF = 1
SF = 1
IF = 1
```

The important arithmetic observations were:

* `CF = 1` → a borrow occurred during the subtraction.
* `SF = 1` → the result has its sign bit set, so it is negative when interpreted as a signed value.
* `PF = 1` → the lowest byte of the result has even parity.
* `ZF = 0` → the result was not zero.

---

## 4. SBB (Subtract with Borrow)

The `sub3` program demonstrated `SBB`.

Before executing:

```asm
sbb ax, 0
```

GDB showed:

```text
EFLAGS = 0x297 [ CF PF AF SF IF ]
AX = 0xffff
```

The important part was:

```text
CF = 1
```

After continuing to the next breakpoint:

```text
EFLAGS = 0x282 [ SF IF ]
AX = 0xfffe
```

### Observation

`SBB` subtracts both the specified value and the Carry Flag.

The calculation was:

```text
AX = AX - 0 - CF
AX = 0xffff - 0 - 1
AX = 0xfffe
```

Therefore:

```text
Before SBB: AX = 0xFFFF, CF = 1
After SBB:  AX = 0xFFFE
```

This showed that `SBB` uses the Carry Flag as a borrow from a previous subtraction.

---

## 5. MUL

The `mul1` program demonstrated multiplication.

The observed result was:

```text
AX = 0xfa
EFLAGS = 0x202 [ IF ]
```

### Observation

The multiplication produced:

```text
AX = 0x00FA
```

For this particular multiplication, the result fitted inside the lower 16 bits, so the high part of the result was not needed.

The arithmetic flags were not shown as set:

```text
CF = 0
OF = 0
```

This indicates that the multiplication did not produce a result requiring the upper part of the destination.

---

## 6. MUL with DX:AX

The `mul2` program demonstrated that multiplication can produce a result larger than 16 bits.

GDB showed:

```text
AX = 0x27c0
DX = 0x9
EFLAGS = 0xa03 [ CF IF OF ]
```

For a 16-bit `MUL`, the complete result is stored in:

```text
DX:AX
```

Therefore the complete result was:

```text
DX:AX = 0009:27c0
```

or:

```text
0x000927c0
```

### Observation

The lower 16 bits were stored in:

```text
AX = 0x27C0
```

The upper 16 bits were stored in:

```text
DX = 0x0009
```

The following flags were set:

```text
CF = 1
OF = 1
```

This happened because the multiplication produced a result that required the upper half (`DX`) as well as the lower half (`AX`).

---

## 7. DIV

The `div1` program was used to demonstrate division.

The GDB output was:

```text
EFLAGS = 0x212 [ AF IF ]
AX = 0x20e
```

### Observation

The program reached the instruction:

```asm
mov eax, 1
```

which was the system call setup for exiting the program.

The register value observed at that point was:

```text
AX = 0x020E
```

The flags shown were:

```text
AF = 1
IF = 1
```

The flags are not normally used to determine the result of an unsigned `DIV`, so the main thing to observe in the division example is the register values.

---

## 8. DIV with DX:AX

The `div2` program showed:

```text
AX = 0xa6
DX = 0xc8
EFLAGS = 0x212 [ AF IF ]
```

### Observation

For division, the CPU uses a larger register combination as the dividend.

For a 16-bit division:

```text
DX:AX
```

is used as the dividend.

After the division:

```text
AX = quotient
DX = remainder
```

Therefore the observed values were:

```text
AX = 0x00A6
DX = 0x00C8
```

So:

```text
Quotient  = 0x00A6
Remainder = 0x00C8
```

Unlike `MUL`, the important output of `DIV` is the quotient and remainder rather than the arithmetic flags.

---