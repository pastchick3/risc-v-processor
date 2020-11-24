# risc-v-processor

A simple RISC-V processor for learning.

.\risc-v-assembler.exe .\program.asm --padding 32
iverilog -o Processor.vvp src/*.v
vvp Processor.vvp
gtkwave Processor.vcd

This processor currently supports the following instructions:

| Instruction | ALU Control |
| --- | --- |
| ld | - |
| sd | - |
| and | 0000 |
| or | 0001 |
| add | 0010 |
| sub | 0110 |
| beq | - |
