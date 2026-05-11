# 32-bit IEEE-754 Pipelined Floating Point Multiplier

## 🚀 Overview
This project implements a high-performance **4-stage pipelined multiplier** for 32-bit floating-point numbers following the **IEEE-754 Single Precision** standard. The architecture is optimized for high throughput, delivering a new result every clock cycle after a 4-cycle initial latency.

## 🛠️ Tools & Technologies
- **Design Language:** Verilog HDL
- **Simulation/Synthesis:** Xilinx Vivado / ModelSim
- **Target Standard:** IEEE-754 (Single Precision)

## 🏗️ Pipeline Architecture
The multiplier logic is broken down into four distinct stages to maximize frequency:
1. **Stage 1:** Extract Sign, Exponent, and Mantissa. Initial 24x24 bit Mantissa multiplication.
2. **Stage 2:** Exponent addition and Bias (127) adjustment.
3. **Stage 3:** Intermediate product processing and exponent verification.
4. **Stage 4:** Normalization of the product, rounding, and final result packing.

## 📐 RTL Schematic
The hardware implementation highlights the placement of pipeline registers (flip-flops) between stages to break the combinational path.
![RTL Schematic](./assets/schematic.png) 

## 📊 Simulation Results
The testbench verifies the design with various floating-point cases. The waveform confirms the **4-cycle latency**.
![Simulation Waveform](./assets/simulation_waveform.png)

## 📂 Project Structure
- `src/`: RTL Source code (`.v` files)
- `testbench/`: Self-checking testbench
- `assets/`: Schematic and Simulation screenshots
