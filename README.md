# ♠️ ChipMango Logic Poker Lab: Designing a 5-Card Draw Player

Welcome to the official GitHub repository for **ChipMango’s Logic Poker Lab** — where digital design meets gameplay. This project-based course turns the classic game of **5-Card Draw Poker** into a comprehensive hardware design journey using **SystemVerilog/Verilog** and **Cadence EDA tools**.

Whether you're designing for **FPGAs** or **ASICs**, this lab will challenge you to build a fully autonomous poker-playing hardware module—from hand memory to ranking logic, all the way to bluffing and betting strategies.

---

## 🎯 Course Overview

This hands-on lab targets **intermediate-level** students in **Digital Design**, **FPGA**, and **ASIC design** tracks. Students will:

- Design modular RTL logic for poker gameplay
- Implement memory, ranking engines, FSMs, and behavioral logic
- Simulate and debug designs with **Cadence Xcelium** and **SimVision**
- Synthesize and analyze performance using **Cadence Genus**
- Compete in a **final simulation tournament** against the Instructor's Dealer AI

> "This isn’t just a lab — this is hardware gaming with purpose."

---

## 📚 Modules

| Module | Title                                             | Duration     |
|--------|---------------------------------------------------|--------------|
| 0      | Getting Started with Poker Logic Design           | 51 mins      |
| 1      | Card Encoding and Memory Management               | 48 mins      |
| 2      | Hand Ranking Engine                               | 37 mins      |
| 3      | Player Interface & Command Generator              | 59 mins      |
| 4      | Control FSM and Game Flow                         | 54 mins      |
| 5      | Personality Logic (Good, Bad, Bluff)              | 1 hr 2 mins  |
| 6      | Integrating and Testing the Full Player           | 46 mins      |
| 7      | Synthesis and Performance Analysis                | 1 hr 10 mins |
| 8      | Defeat the Dealer – Final Project + Tournament    | 38 mins      |

---

## 🧠 Skills You’ll Gain

- RTL Design & Simulation (SystemVerilog/Verilog)
- Finite State Machine (FSM) Development
- Digital Microarchitecture
- Data Path and Control Path Integration
- FPGA/ASIC Flow using Cadence Tools
- Behavioral Hardware Modeling
- Verification & Debugging with SimVision

---

## 🛠 Tools Used

- **Cadence Xcelium** – RTL simulation
- **Cadence SimVision** – Waveform debugging
- **Cadence Genus** – RTL synthesis and analysis

> All labs are runnable in Cadence's cloud-based environment or in your local UNIX setup.

---

## 🗂 Repository Structure

```bash
logic-poker-lab/
│
├── module00/                 # Intro & simulation setup
│   ├── src/                  # Source files (Verilog/SystemVerilog)
│   ├── testbench/           # Testbenches for simulation
│   ├── sim/                 # files.f and simulation setup
│
├── module01/                 # Card encoding and memory logic
├── module02/                 # Hand ranking engine
...
├── module08/                 # Final integration and dealer showdown
│
└── README.md                # You are here 🎯

