# div/ — DIV flag behavior

Files run in gdb the same way as add/. `DIV` (unsigned divide) leaves **every** status flag
(`CF`, `ZF`, `SF`, `OF`, `AF`, `PF`) undefined per the ISA — the CPU does not define their state
after a divide, so whatever gdb reports is leftover/incidental and must not be relied on.

## div1.asm — `div bl` (AX=100 / BL=7, byte divide)

Result: `AL = 0x0E` (quotient 14), `AH = 0x02` (remainder 2)

Flags: `eflags 0x212  [ AF IF ]`

- **AF is undefined after DIV** — its value here is incidental, not a meaningful "half-carry"
  signal for this instruction. The only flag that matters is `IF` (interrupt flag), which is
  unrelated to the division itself.
- Take-away: never branch on flags after `DIV`; check the quotient/remainder registers directly,
  and use a `#DE` (divide error) exception, not flags, to detect divide-by-zero/overflow.

## div2.asm — `div bx` (DX:AX=50000 / BX=300, word divide)

Result: `AX = 0x00A6` (quotient 166), `DX = 0x00C8` (remainder 200)

Flags: `eflags 0x212  [ AF IF ]`

- Same undefined-flags situation as div1.asm — the flag word is identical even though the
  operands and result are completely different, confirming `DIV` does not derive these flags
  from its result.





cd /home/topsy/3.2/Assembly/assembly_programming_e_190377/03_arithmetic

### --- add/ ---
cd add
nasm -f elf32 -g -F dwarf add2.asm -o add2.o && ld -m elf_i386 add2.o -o add2
nasm -f elf32 -g -F dwarf add3.asm -o add3.o && ld -m elf_i386 add3.o -o add3

# break right after the arithmetic instruction, before result is overwritten
gdb -q -batch -ex "break add2.asm:13" -ex run -ex "info registers eflags" -ex "print/x \$ax" ./add2

gdb -q -batch \
  -ex "break add3.asm:12" -ex "break add3.asm:13" \
  -ex run -ex "info registers eflags" -ex "print/x \$ax" \
  -ex continue -ex "info registers eflags" -ex "print/x \$ax" \
  ./add3

rm -f *.o add2 add3
cd ..

### --- sub/ ---
cd sub
nasm -f elf32 -g -F dwarf sub2.asm -o sub2.o && ld -m elf_i386 sub2.o -o sub2
nasm -f elf32 -g -F dwarf sub3.asm -o sub3.o && ld -m elf_i386 sub3.o -o sub3

gdb -q -batch -ex "break sub2.asm:13" -ex run -ex "info registers eflags" -ex "print/x \$ax" ./sub2

gdb -q -batch \
  -ex "break sub3.asm:13" -ex "break sub3.asm:14" \
  -ex run -ex "info registers eflags" -ex "print/x \$ax" \
  -ex continue -ex "info registers eflags" -ex "print/x \$ax" \
  ./sub3

rm -f *.o sub2 sub3
cd ..

### --- mul/ ---
cd mul
nasm -f elf32 -g -F dwarf mul1.asm -o mul1.o && ld -m elf_i386 mul1.o -o mul1
nasm -f elf32 -g -F dwarf mul2.asm -o mul2.o && ld -m elf_i386 mul2.o -o mul2

gdb -q -batch -ex "break mul1.asm:13" -ex run -ex "info registers eflags" -ex "print/x \$ax" ./mul1
gdb -q -batch -ex "break mul2.asm:13" -ex run -ex "info registers eflags" -ex "print/x \$ax" -ex "print/x \$dx" ./mul2

rm -f *.o mul1 mul2
cd ..

### --- div/ ---
cd div
nasm -f elf32 -g -F dwarf div1.asm -o div1.o && ld -m elf_i386 div1.o -o div1
nasm -f elf32 -g -F dwarf div2.asm -o div2.o && ld -m elf_i386 div2.o -o div2

gdb -q -batch -ex "break div1.asm:16" -ex run -ex "info registers eflags" -ex "print/x \$ax" ./div1
gdb -q -batch -ex "break div2.asm:19" -ex run -ex "info registers eflags" -ex "print/x \$ax" -ex "print/x \$dx" ./div2

rm -f *.o div1 div2
cd ../..

### --- commit + push (README.md already written in each folder) ---
git rm --cached 03_arithmetic/add/a.out
git add 03_arithmetic/add/README.md 03_arithmetic/sub/README.md 03_arithmetic/mul/README.md 03_arithmetic/div/README.md
git commit -m "Document CPU flags for add/sub/mul/div examples"
git push origin main