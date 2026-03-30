# 8-bit SAP-1 Computer (Verilog)

## Overview

This repository contains my implementation of an **8-bit computer based on the SAP-1 architecture** written in Verilog.

I am an **Electronics with VLSI Design (EVD) student** exploring how processors are built at the hardware level. The goal of this project is to understand CPU design by **building one from scratch**, starting from a minimal architecture and expanding it step by step.

This project is primarily focused on **learning, experimentation, and architectural understanding**.

---

## Goals of the Project

* Understand **digital computer architecture from the hardware level**
* Implement core CPU components in **Verilog**
* Learn how modules interact via **buses and control signals**
* Simulate and debug using **open-source tools**
* Build a strong foundation for **VLSI and Design Verification**

---

## SAP-1 Implementation

This project implements the classic SAP-1 architecture with:

* Program Counter (PC)
* Memory Address Register (MAR)
* RAM
* Instruction Register (IR)
* Accumulator (A Register)
* B Register
* ALU (Arithmetic Logic Unit)
* Output Register
* Control Unit (hardwired)
* Shared 8-bit system bus

---

## Instruction Set (Opcode Table)

```
0000 - ADD
0001 - SUB
0010 - AND
0011 - OR
0100 - XOR
0101 - NOT
0110 - Logical Left Shift
0111 - Logical Right Shift
1000 - LDA
1001 - LDB
1010 - OUT
1011 - HLT
1100 - NOP
1101 - NOP
1110 - NOP
1111 - NOP
```

---

## Tools Used

* **Icarus Verilog** — simulation compiler
* **vvp** — simulation runtime
* **GTKWave** — waveform visualization
* **Yosys** — open-source tool for schemetic generation

---

## Status

✅ **Completed**

The SAP-1 CPU has been fully implemented, simulated, and verified.
All core modules are integrated and functioning as expected.

---

## Learning Focus

This project helped develop a strong understanding of:

* Digital system design
* Datapath and control architecture
* Instruction execution (fetch–decode–execute cycle)
* Hardware description using Verilog
* Debugging using waveform analysis

---

## Future Work

Although SAP-1 is complete, this serves as a base for more advanced designs:

* Adding flags (Zero, Carry, etc.)
* Conditional branching
* Expanding instruction set
* Moving toward a more practical CPU architecture
* Transition into **Design Verification (DV)** workflows

---

## License

This project is educational and open for learning purposes.
Feel free to explore, modify, and build upon it.
