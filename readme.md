# 8-bit SAP-1 Computer (Verilog)

## Overview

This repository contains my implementation of an **8-bit computer based on the SAP-1 architecture** written in Verilog.

I am an **EVD (Electronics with VLSI Design) student** exploring how processors are built at the hardware level. The goal of this project is to understand how a CPU works by **building one from scratch**, starting from a very simple architecture and gradually expanding it.

The project begins with a minimal **SAP-1 (Simple-As-Possible) computer**, and then additional features will be implemented step by step to evolve it into a more capable processor.

This repository is primarily a **learning and experimentation project**.

---

## Goals of the Project

* Understand **digital computer architecture from the hardware level**
* Implement basic CPU components in **Verilog**
* Learn how modules interact through **buses and control signals**
* Simulate and debug designs using open-source tools
* Gradually evolve a simple CPU into something more capable

---

## Development Plan

The processor will be developed in stages:

### Stage 1 — SAP-1 Implementation

The initial goal is to implement the classic SAP-1 architecture including:

* Program Counter (PC)
* Memory Address Register (MAR)
* RAM
* Instruction Register (IR)
* Accumulator (A register)
* B Register
* ALU (Adder/Subtractor)
* Output Register
* Control Unit
* Shared 8-bit system bus

The processor will execute a minimal instruction set such as:

* `LDA` – Load accumulator
* `ADD` – Add memory value
* `SUB` – Subtract memory value
* `OUT` – Output accumulator
* `HLT` – Halt execution

---

### Stage 2 — Architectural Improvements

After the basic SAP-1 works, the processor will gradually be extended with features such as:

* Conditional jumps
* Status flags (Zero, Carry, etc.)
* Additional registers
* Improved ALU operations
* Better instruction encoding

---

### Stage 3 — Toward a More Useful CPU

Long-term improvements may include:

* Larger memory
* More instructions
* Stack support
* Subroutines
* Basic I/O system
* Possibly a simple assembler

The goal is to move from **a teaching architecture to a small but practical CPU design**.

---

## Project Structure

```
8-bit-SAP1/
│
├── src/        # Verilog modules (CPU hardware)
├── tb/         # Simulation testbenches
├── program/    # Memory initialization files
├── docs/       # Notes and architecture documentation
└── README.md
```

---

## Tools Used

The project uses open-source digital design tools:

* **Icarus Verilog** – simulation compiler
* **vvp** – simulation runtime
* **GTKWave** – waveform viewer

---

## Why SAP-1?

SAP-1 is a classic educational architecture that demonstrates the core ideas behind CPU design:

* instruction fetch/decode/execute cycle
* data buses
* registers
* ALU operations
* control logic

Because the design is intentionally simple, it is ideal for learning how processors work internally.

---

## Status

🚧 Work in progress.

The CPU is being built module by module. Each component will be implemented, simulated, and verified before integrating it into the full processor.

---

## Learning Focus

This project is mainly about understanding:

* digital system design
* hardware description languages
* datapath and control architecture
* how real processors execute instructions

---

## License

This project is primarily educational. Feel free to explore, modify, or use the code for learning purposes.
