# mips-core
Implementation of a MIPS IV core in SystemVerilog as coursework for the Instruction Set Architecture module at Imperial College

This is a CPU core that satisfys the MIPS IV ISA (https://www.cs.cmu.edu/afs/cs/academic/class/15740-f97/public/doc/mips-isa.pdf).

It is a single cycle CPU with a Harvard memory interface.

# Contributors

Bryan Tan

Luc Jones

Nick Mytilineos

Bardia Mohammadzadeh

Bakhtiar Mohammadzadeh

Kiril Avramov

# rtl
Contains the SystemVerilog files of the CPU core. `mips_harvard.v` is the top level design, the submodules are in the `mips_cpu` directory.

# issie
Contains the Issie schematic files for the CPU. Checkout Issie: https://tomcl.github.io/issie/

# tests
Contains the testbench for the CPU. `tb` directory contains the actual SystemVerilog files. Run `test_mips_cpu_harvard.sh` to run all tests as an Iverilog simulation. Alternatively, test each instruction individually by running `run_one_instr.sh <instruction name>`.
