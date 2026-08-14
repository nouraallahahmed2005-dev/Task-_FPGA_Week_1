# AXI4-Lite-Slave-Interface

## Overview

A parameterized Verilog HDL implementation of an AXI4-Lite Slave with Read/Write Controllers, a memory-mapped Register File, and UART TX/RX.

## Architecture

- AXI4-Lite Interface
- Write Controller
- Read Controller
- Register File
- UART TX
- UART RX

## Features

- AXI4-Lite Read/Write transactions
- Memory-mapped Register File
- Address decoding and alignment checking
- Access permissions
- WSTRB byte-level writes
- Error handling and read timeout
- UART TX/RX
- Multi-byte data transmission

## Project Structure

```text
AXI4-Lite-Slave-Interface/
│
├── README.md
│
├── Documentation/
│   └── AXI4-Lite Report.pdf
│
├── AXI4-Lite/
│   │
│   ├── RTL/
│   │   ├── write_controller.v
│   │   ├── Read_Controller.v
│   │   ├── reg_file.v
│   │   └── top_module.v
│   │
│   ├── Testbench/
│   │   ├── Read_Controller_tb.v
│   │   ├── reg_file_tb.v
│   │   └── top_module_tb.v
│   │
│   └── Simulation/
│       ├── run.do
│       └── wave.do
│
└── UART/
    │
    ├── RTL/
    │   ├── uart_tx.v
    │   └── uart_rx.v
    │   └── reg_file.v
    │   └── topmodule.v
    │
    └── Testbench/
        └── register_file_uart_tb.v

```

## Simulation

The design was verified using ModelSim.

## Implementation

The RTL design was synthesized and implemented using Xilinx Vivado.

## Tools

- Verilog HDL
- ModelSim
- Xilinx Vivado
