# Design and Implementation of UART Based on Verilog HDL in FPGA

![UART Communication](https://img.shields.io/badge/Protocol-UART-blue) ![Language](https://img.shields.io/badge/Language-Verilog-orange) ![FPGA](https://img.shields.io/badge/Platform-FPGA-green)

A complete implementation of an 8-bit Universal Asynchronous Receiver Transmitter (UART) communication system designed for FPGA platforms using Verilog HDL. This project demonstrates reliable full-duplex serial communication with configurable baud rates, modular design architecture, and comprehensive testing capabilities.

---

## 📋 Table of Contents

- [Introduction](#introduction)
- [What is UART?](#what-is-uart)
- [UART Protocol Theory](#uart-protocol-theory)
- [Project Overview](#project-overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Module Descriptions](#module-descriptions)
- [Hardware Requirements](#hardware-requirements)
- [Getting Started](#getting-started)
- [Simulation and Testing](#simulation-and-testing)
- [Resource Utilization](#resource-utilization)
- [Future Improvements](#future-improvements)
- [Contributors](#contributors)
- [Acknowledgments](#acknowledgments)
- [License](#license)

---

## 🚀 Introduction

This project implements a complete **8-bit UART transceiver** on an FPGA platform, specifically designed for the **ZedBoard Zynq-7000 SoC**. UART is one of the most widely used serial communication protocols in embedded systems, providing a simple, reliable, and cost-effective method for data transmission between digital devices without requiring a shared clock signal.

The implementation includes both transmitter (TX) and receiver (RX) modules, along with a baud rate generator, enabling full-duplex communication with external devices such as PCs, microcontrollers, or other FPGAs.

---

## 📡 What is UART?

**UART (Universal Asynchronous Receiver Transmitter)** is a hardware communication protocol that enables asynchronous serial communication between two devices. Unlike synchronous protocols (such as SPI or I²C), UART does not require a shared clock signal between communicating devices, making it ideal for point-to-point communication over longer distances.

### Key Characteristics:

- **Asynchronous Communication**: No shared clock signal required
- **Serial Transmission**: Data transmitted one bit at a time
- **Full-Duplex**: Simultaneous two-way communication (TX and RX)
- **Simple Hardware**: Requires only two wires (TX and RX) plus ground
- **Flexible Configuration**: Supports various data formats and baud rates

---

## 📚 UART Protocol Theory

### Data Frame Structure

UART communication is organized into data frames (packets), where each frame contains:

1. **Start Bit (1 bit)**: Signals the beginning of data transmission
   - Transition from HIGH (idle) to LOW indicates start of frame
   - Duration: 1 bit period

2. **Data Bits (5-9 bits)**: The actual payload being transmitted
   - Most common: 8 bits (1 byte)
   - Transmitted LSB (Least Significant Bit) first
   - Can be 5, 6, 7, 8, or 9 bits depending on configuration

3. **Parity Bit (0 or 1 bit)**: Optional error detection mechanism
   - **Even Parity**: Total number of 1's should be even
   - **Odd Parity**: Total number of 1's should be odd
   - **No Parity**: Most common configuration (this project uses no parity)

4. **Stop Bit(s) (1-2 bits)**: Signals the end of data transmission
   - Line returns to HIGH (idle state)
   - Can be 1, 1.5, or 2 bits
   - Provides time for receiver to prepare for next frame

### 8N1 Configuration

This project implements the **8N1 format**, which is the most commonly used UART configuration:

- **8**: 8 data bits
- **N**: No parity bit
- **1**: 1 stop bit

**Total frame size**: 10 bits (1 start + 8 data + 1 stop)

```
Idle | Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop | Idle
HIGH | LOW   |          Data Bits (LSB first)        | HIGH | HIGH
     └──────────────────────────────────────────────────────┘
                    10-bit frame
```

### Baud Rate

The **baud rate** defines the speed of data transmission, measured in bits per second (bps). Both transmitter and receiver must use the same baud rate for successful communication.

**Common Baud Rates**:
- 9600 bps (default for many embedded systems)
- 19200 bps
- 38400 bps
- 57600 bps
- 115200 bps (commonly used for modern applications)

**Baud Rate Tolerance**: UART can tolerate up to ±10% difference in baud rates between devices, though smaller differences are preferred for reliability.

### How UART Works

#### Transmission Process:
1. **Idle State**: TX line remains HIGH when no data is being transmitted
2. **Start Transmission**: When data is ready, transmitter pulls line LOW (start bit)
3. **Data Transmission**: Transmitter shifts out data bits one at a time at the baud rate frequency
4. **Stop Bit**: Transmitter drives line HIGH for stop bit duration
5. **Return to Idle**: Line remains HIGH until next transmission

![STEP-1](ReferencePictures/Introduction-to-UART-Data-Transmission-Diagram-UART-Gets-Byte-from-Data-Bus-600x583.png)

#### Reception Process:
1. **Monitor for Start Bit**: Receiver continuously monitors RX line for HIGH-to-LOW transition
2. **Validate Start Bit**: Sample at mid-point of start bit to confirm valid start (not a glitch)
3. **Sample Data Bits**: Sample each data bit at its center point using 16x oversampling
4. **Reconstruct Byte**: Collect all 8 data bits into a parallel byte
5. **Verify Stop Bit**: Check that stop bit is HIGH; if not, frame error occurred
6. **Output Data**: Assert data-valid signal and output the received byte

#### Oversampling:
This implementation uses **16x oversampling** of the baud rate. This means the internal clock runs at 16 times the baud rate, allowing the receiver to:
- Detect the start bit more accurately
- Sample data bits at their center point (most stable region)
- Tolerate slight timing differences between transmitter and receiver

---

## 🎯 Project Overview

This UART transceiver project is designed as a comprehensive, modular solution for serial communication on FPGA platforms. The implementation consists of four main components working together to provide reliable full-duplex communication.

### Objectives

✅ Design and implement a UART transceiver supporting 8-bit data communication in 8N1 format

✅ Integrate a flexible baud rate generator for configurable communication speeds

✅ Verify design functionality through simulation and hardware testing

✅ Optimize resource utilization and power consumption for efficient FPGA implementation

✅ Enable reliable serial communication between FPGA and external devices

### Design Methodology

The project follows a structured HDL design approach:
- **Modular Architecture**: Separate modules for TX, RX, baud generator, and top-level integration
- **Finite State Machines**: Control logic implemented using FSMs for predictable behavior
- **Parameterized Design**: Configurable clock frequency and baud rate parameters
- **Comprehensive Testing**: Simulation testbench with loopback verification

---

## ✨ Features

- ✅ **8-bit Data Width**: Standard byte-oriented communication
- ✅ **8N1 Frame Format**: 1 start bit, 8 data bits, no parity, 1 stop bit
- ✅ **Configurable Baud Rate**: Easily adjustable via parameters (default: 115200 bps)
- ✅ **16x Oversampling**: Enhanced receiver accuracy and timing tolerance
- ✅ **Full-Duplex Communication**: Simultaneous transmit and receive capability
- ✅ **Frame Error Detection**: Receiver validates start and stop bits
- ✅ **Busy/Done Signaling**: Status flags for transmission and reception completion
- ✅ **Modular Design**: Clean, reusable modules for easy integration
- ✅ **Low Resource Usage**: Less than 5% FPGA resource utilization
- ✅ **Synchronous Reset**: Active-low reset for reliable initialization
- ✅ **Comprehensive Testbench**: Verification through simulation with loopback test

---

## 🏗️ System Architecture

The UART system consists of four main modules integrated into a top-level wrapper:

```
┌─────────────────────────────────────────────────────────────┐
│                        uart_top                             │
│                                                             │
│  ┌──────────────┐        ┌──────────────┐                   │
│  │              │        │              │                   │
│  │  baud_gen    │───────▶│  uart_tx     │─────▶ TX Serial  │
│  │              │  tick  │              │                   │
│  └──────────────┘        └──────────────┘                   │
│         │                                                   │
│         │ tick                                              │
│         │                                                   │
│         │                ┌──────────────┐                   │
│         │                │              │                   │
│         └───────────────▶│  uart_rx     │◀───── RX Serial  │
│                          │              │                   │
│                          └──────────────┘                   │
│                                                             │
│  System Clock (50/100 MHz) ─────▶ All Modules              │
│  Reset ──────────────────────────▶ All Modules             │
└─────────────────────────────────────────────────────────────┘
```

### Signal Flow:
1. **System Clock** feeds into the baud rate generator
2. **Baud Generator** produces 16x oversampling tick for both TX and RX
3. **Transmitter** serializes parallel input data on TX line
4. **Receiver** deserializes serial data from RX line to parallel output
5. **Status signals** indicate busy/done states for handshaking

---

## 🔧 Module Descriptions

### 1. **baud_gen** (Baud Rate Generator)

**Purpose**: Generates a periodic tick signal at 16x the desired baud rate for accurate timing.

**Key Features**:
- Parameterized clock frequency and baud rate
- Clock division using counter logic
- Produces single-cycle tick pulses
- Enables both TX and RX modules

**Parameters**:
- `CLK_FREQ`: System clock frequency (default: 50 MHz)
- `BAUD_RATE`: Target baud rate (default: 9600 bps)

**Calculation**:
```
DIVISOR = CLK_FREQ / (BAUD_RATE × 16)
```

**Operation**:
- Counts system clock cycles
- Generates tick pulse when counter reaches DIVISOR-1
- Resets counter and continues

---

### 2. **uart_tx** (UART Transmitter)

**Purpose**: Converts parallel 8-bit data into serial format with proper UART framing.

**FSM States**:
1. **IDLE**: Waits for transmission request, TX line held HIGH
2. **START**: Transmits start bit (LOW) for one baud period
3. **DATA**: Transmits 8 data bits LSB-first, one per baud period
4. **STOP**: Transmits stop bit (HIGH) for one baud period

**Key Signals**:
- `i_tx_start`: Pulse HIGH for one clock cycle to begin transmission
- `i_tx_data[7:0]`: Parallel data to transmit (latched on start)
- `o_tx_serial`: Serial output line
- `o_tx_busy`: HIGH during transmission, LOW when ready

**Operation**:
1. In IDLE state, wait for `tx_start` pulse
2. Latch input data and transition to START state
3. Output start bit (LOW) for 16 tick cycles
4. Output each data bit for 16 tick cycles (LSB first)
5. Output stop bit (HIGH) for 16 tick cycles
6. Return to IDLE and deassert `tx_busy`

---

### 3. **uart_rx** (UART Receiver)

**Purpose**: Receives serial data and reconstructs parallel 8-bit output with error checking.

**FSM States**:
1. **IDLE**: Monitors RX line for start bit (HIGH-to-LOW transition)
2. **START**: Validates start bit by sampling at center (tick 7)
3. **DATA**: Samples 8 data bits at their center points (tick 7 of each bit)
4. **STOP**: Verifies stop bit is HIGH, outputs data if valid

**Key Signals**:
- `i_rx_serial`: Serial input line
- `o_rx_data[7:0]`: Received parallel data
- `o_rx_valid`: Pulses HIGH for one cycle when data is ready

**Operation**:
1. Detect falling edge on RX line (potential start bit)
2. Wait 7 tick cycles (to center of start bit) and sample
3. If start bit is valid (LOW), proceed to data sampling
4. Sample each of 8 data bits at their center (tick 7)
5. After 16 ticks per bit, move to next bit
6. Verify stop bit is HIGH at completion
7. Output data and pulse `rx_valid` if frame is valid
8. Discard frame and return to IDLE if stop bit is invalid

**Error Detection**:
- **Glitch Rejection**: Invalid start bits are ignored
- **Framing Error**: Stop bit must be HIGH, otherwise frame is discarded

---

### 4. **uart_top** (Top-Level Integration)

**Purpose**: Integrates all submodules and provides unified interface to external logic.

**Integration**:
- Instantiates `baud_gen`, `uart_tx`, and `uart_rx` modules
- Connects shared clock, reset, and baud tick signals
- Provides clean interface for external connectivity

**Parameters**:
- `CLK_FREQ`: System clock frequency
- `BAUD_RATE`: Desired baud rate for communication

**I/O Interface**:

**Inputs**:
- `i_clk`: System clock
- `i_rst_n`: Active-low asynchronous reset
- `i_tx_data[7:0]`: Data to transmit
- `i_tx_start`: Start transmission pulse
- `i_rx_serial`: Serial data input

**Outputs**:
- `o_tx_serial`: Serial data output
- `o_tx_busy`: Transmitter busy flag
- `o_rx_data[7:0]`: Received data
- `o_rx_valid`: Data valid pulse

---

### 5. **uart_tb** (Testbench)

**Purpose**: Simulation-only module for verifying UART functionality before synthesis.

**Test Methodology**:
- Generates system clock and reset signals
- Instantiates `uart_top` module
- Connects TX output to RX input (loopback mode)
- Sends test byte (0xAA) through transmitter
- Verifies received data matches transmitted data
- Reports PASS/FAIL status

**Test Sequence**:
1. Apply reset and initialize signals
2. Release reset and wait for stability
3. Load test data (0xAA) and pulse `tx_start`
4. Wait for transmitter to complete (`tx_busy` goes LOW)
5. Wait for receiver to assert `rx_valid`
6. Compare received data with expected value
7. Display test results and finish simulation

---

## 🛠️ Hardware Requirements

### Target Platform

- **Board**: ZedBoard Zynq-7000 Evaluation and Development Kit
- **FPGA Device**: XC7Z020-CLG484-1 (Zynq-7000 SoC)
- **Board Part**: avnet.com:zedboard:part0:1.4
- **Board Revision**: D

### Software Tools

- **Design Tool**: Xilinx Vivado 2025.1 (or compatible version)
- **HDL**: Verilog HDL
- **Simulation**: Vivado Simulator or ModelSim
- **Synthesis**: Vivado Synthesis
- **Implementation**: Vivado Implementation

### Optional Hardware

- **Serial Terminal**: For PC communication (Tera Term, PuTTY, or similar)
- **USB-UART Bridge**: If not integrated on board
- **Oscilloscope**: For signal verification (optional)

---

## 🚦 Getting Started

### Prerequisites

1. **Xilinx Vivado** installed and licensed
2. **ZedBoard** or compatible FPGA development board
3. **USB cable** for FPGA programming and serial communication
4. **Serial terminal software** (Tera Term, PuTTY, etc.)

### Installation & Setup

#### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/uart-verilog-fpga.git
cd uart-verilog-fpga
```

#### 2. Project Structure

```
uart-verilog-fpga/
│
├── src/                      # Source files
│   ├── baud_gen.v           # Baud rate generator
│   ├── uart_tx.v            # UART transmitter
│   ├── uart_rx.v            # UART receiver
│   └── uart_top.v           # Top-level integration
│
├── sim/                      # Simulation files
│   └── uart_tb.v            # Testbench
│
├── constraints/              # Constraint files
│   └── uart_constraints.xdc # Pin assignments and timing
│
├── docs/                     # Documentation
│   └── project_report.pdf   # Detailed project report
│
└── README.md                 # This file
```

#### 3. Create Vivado Project

1. **Open Vivado** and create a new project
2. **Select target board**: ZedBoard Zynq-7000 or your specific board
3. **Add source files**:
   - Add all `.v` files from `src/` directory
   - Add testbench from `sim/` directory (as simulation source)
4. **Add constraints**:
   - Add `.xdc` file from `constraints/` directory

#### 4. Configure Parameters (Optional)

In `uart_top.v`, modify parameters as needed:

```verilog
module uart_top #(
    parameter CLK_FREQ  = 50_000_000,  // Your FPGA clock frequency
    parameter BAUD_RATE = 115200       // Desired baud rate
) (
    // ports...
);
```

**Important**: Ensure `CLK_FREQ` matches your FPGA's actual clock frequency.

#### 5. Pin Assignment

Edit `uart_constraints.xdc` to match your board's pin configuration:

```tcl
# System Clock (100 MHz on ZedBoard)
set_property PACKAGE_PIN Y9 [get_ports i_clk]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk]

# Reset (Active-low button)
set_property PACKAGE_PIN P16 [get_ports i_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports i_rst_n]

# UART TX/RX pins (USB-UART bridge)
set_property PACKAGE_PIN Y19 [get_ports o_tx_serial]
set_property PACKAGE_PIN Y18 [get_ports i_rx_serial]
set_property IOSTANDARD LVCMOS33 [get_ports {o_tx_serial i_rx_serial}]

# Timing constraints
create_clock -period 10.000 -name sys_clk [get_ports i_clk]
```

---

## 🧪 Simulation and Testing

### Running Behavioral Simulation

#### Using Vivado Simulator:

1. **Set testbench as top module**:
   - Right-click on `uart_tb.v` in Sources
   - Select "Set as Top"

2. **Run simulation**:
   - Click "Run Simulation" → "Run Behavioral Simulation"
   - Wait for simulation to complete

3. **View waveforms**:
   - Add signals to waveform viewer
   - Observe TX serial output, RX input, and data comparison
   - Verify timing matches baud rate

4. **Check results**:
   - Console should display "TEST PASSED" if data matches
   - Verify no framing errors or mismatches

### Expected Simulation Output

```
---------------------------------------------------
--- Starting Simplified UART Loopback Test ---
---      BAUD_RATE = 19200 bps             ---
---------------------------------------------------
INFO: Reset released. Waiting for system to stabilize.
INFO: Requesting transmission of data: 0xAA
INFO: Transmitter is no longer busy.
INFO: Waiting for receiver to assert 'rx_valid'...
INFO: Receiver has asserted 'rx_valid'.
----------------------------------------------------
--- TEST PASSED ---
--- Received data 0xAA matches expected. ---
----------------------------------------------------
INFO: Simulation finished.
```

### Hardware Testing

#### 1. Synthesize and Implement

1. **Run Synthesis**: Click "Run Synthesis" in Vivado
2. **Run Implementation**: Click "Run Implementation"
3. **Generate Bitstream**: Click "Generate Bitstream"

#### 2. Program FPGA

1. Connect ZedBoard via USB
2. Power on the board
3. In Vivado: "Open Hardware Manager" → "Auto Connect"
4. Right-click on FPGA device → "Program Device"
5. Select generated `.bit` file and program

#### 3. Test with Serial Terminal

1. **Identify COM Port**:
   - Windows: Device Manager → Ports (COM & LPT)
   - Linux: `ls /dev/ttyUSB*` or `/dev/ttyACM*`

2. **Configure Terminal** (Tera Term / PuTTY):
   - Port: Select correct COM port
   - Baud Rate: 115200 (or your configured rate)
   - Data Bits: 8
   - Parity: None
   - Stop Bits: 1
   - Flow Control: None

3. **Test Communication**:
   - Send characters from terminal
   - Observe received data (if loopback mode)
   - Verify correct transmission and reception

---

## 📊 Resource Utilization

### Post-Implementation Results (ZedBoard Zynq-7000)

| Resource Type | Used | Available | Utilization |
|--------------|------|-----------|-------------|
| **LUT** (Logic) | 156 | 53,200 | < 1% |
| **FF** (Flip-Flops) | 84 | 106,400 | < 1% |
| **IO** (I/O Pins) | 21 | 200 | 10.5% |
| **BUFG** (Clock Buffers) | 1 | 32 | 3.1% |

### Performance Metrics

- **Maximum Clock Frequency**: 200+ MHz (limited by FPGA, not design)
- **Supported Baud Rates**: 9600 - 115200 bps (configurable)
- **Power Consumption**: < 50 mW (estimated for UART logic only)
- **Latency**: ~10 bit periods per frame (dependent on baud rate)

### Design Efficiency

The extremely low resource utilization (< 1% for logic and registers) demonstrates that this UART implementation is:
- **Lightweight**: Suitable for integration into larger SoC designs
- **Scalable**: Multiple UART instances can coexist on the same FPGA
- **Power-Efficient**: Minimal dynamic power consumption

---

## 🔮 Future Improvements

This project provides a solid foundation for UART communication on FPGAs. Here are potential enhancements to extend functionality and robustness:

### 1. **Parity Bit Support**
- **Even/Odd Parity**: Add parity generation in transmitter and checking in receiver
- **Error Reporting**: Flag parity errors via dedicated output signal
- **Configurable**: Parameter to enable/disable parity

### 2. **FIFO Buffer Integration**
- **TX FIFO**: Queue multiple bytes for transmission without CPU intervention
- **RX FIFO**: Buffer incoming data to prevent loss during high-speed bursts
- **Depth Configuration**: Parameterized FIFO depth (e.g., 16, 32, 64 bytes)
- **Status Flags**: Empty, full, almost-full, almost-empty indicators

### 3. **Configurable Frame Format**
- **Variable Data Bits**: Support 5, 6, 7, 8, or 9-bit data frames
- **Multiple Stop Bits**: Configurable 1, 1.5, or 2 stop bits
- **Runtime Configuration**: Control via registers instead of compile-time parameters

### 4. **Flow Control**
- **Hardware Flow Control**: Implement RTS/CTS signaling
- **Software Flow Control**: XON/XOFF protocol support
- **Backpressure Handling**: Prevent data loss when receiver is busy

### 5. **Interrupt Support**
- **RX Interrupt**: Generate interrupt on data reception
- **TX Interrupt**: Generate interrupt when transmitter becomes idle
- **Error Interrupts**: Separate interrupts for framing, parity, or overrun errors

### 6. **Multi-Protocol Support**
- **SPI Interface**: Add SPI master/slave capability
- **I²C Interface**: Implement I²C master for sensor communication
- **Unified Serial Core**: Single configurable module supporting multiple protocols

### 7. **Advanced Error Handling**
- **Break Detection**: Detect extended LOW period (break condition)
- **Overrun Detection**: Flag when new data arrives before previous byte is read
- **Error Counters**: Track statistics on framing, parity, and overrun errors

### 8. **DMA Support**
- **Direct Memory Access**: Transfer data to/from memory without CPU intervention
- **Burst Transfers**: Efficient multi-byte transfers
- **Memory-Mapped Registers**: Standard register interface for software control

### 9. **Enhanced Testbench**
- **Randomized Testing**: Generate random data patterns and baud rates
- **Coverage Metrics**: Code and functional coverage analysis
- **Edge Case Testing**: Test boundary conditions, errors, and timing violations
- **Automated Regression**: Continuous integration testing

### 10. **Documentation & Usability**
- **Detailed User Guide**: Step-by-step integration instructions
- **Example Applications**: Demo projects for common use cases
- **Python/C Libraries**: Host-side software for PC communication
- **Timing Diagrams**: Visual documentation of all signal transitions

---

## 🙏 Acknowledgments

We would like to express our gratitude to the following resources and projects that inspired and guided this implementation:

### Educational Resources
- [Analog Devices - UART Communication Protocol](https://www.analog.com/en/resources/analog-dialogue/articles/uart-a-hardware-communication-protocol.html)
- [Digilent - UART Explained](https://digilent.com/blog/uart-explained/)
- [Wikipedia - Universal Asynchronous Receiver-Transmitter](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)
- [Circuit Fever - UART in FPGA Verilog](https://circuitfever.com/uart-in-fpga-verilog)

### Tools & Platforms
- **Xilinx Vivado**: FPGA design and synthesis tool
- **ZedBoard**: Evaluation platform for Zynq-7000 SoC
- **Icarus Verilog & GTKWave**: Open-source simulation tools

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Mridul S Kumar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 📞 Contact & Support

For questions, suggestions, or contributions:

- **GitHub Issues**: Report bugs or request features to my Email
- **Pull Requests**: Contributions are welcome!
- **Email**: mridulsudheerkumar21feb2005@gmail.com

---

## 📈 Project Status

- ✅ **Core Implementation**: Complete
- ✅ **Simulation Verification**: Passed
- ❎ **Hardware Testing**: Verified on ZedBoard
- ⏳ **FIFO Integration**: Planned
- ⏳ **Parity Support**: Planned
- ⏳ **Multi-protocol Support**: Under consideration

---

## ⭐ Show Your Support

If you find this project helpful, please consider:
- ⭐ **Starring** this repository
- 🍴 **Forking** for your own projects
- 📢 **Sharing** with others interested in FPGA development
- 💬 **Contributing** improvements and bug fixes

---
