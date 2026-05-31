# FPGA Based Smart Traffic Light Controller using Verilog HDL

## Overview

This project implements a **Smart Traffic Light Controller** using **Verilog HDL** and demonstrates the complete FPGA design workflow using **Xilinx Vivado**.

The controller is based on a **Finite State Machine (FSM)** architecture and supports multiple real-world traffic management features including:

- Normal traffic sequencing
- Pedestrian crossing requests
- Emergency vehicle override handling
- Night mode blinking operation
- Request prioritization and safe state transitions

The project was designed, simulated, synthesized, implemented, and successfully verified for FPGA deployment using the **Xilinx Artix-7 FPGA** platform.

---

## Target FPGA

- FPGA Family : Xilinx Artix-7
- Device       : xc7a35tcpg236-1
- Toolchain    : Vivado 2024.x

---

## Features

- FSM-based traffic control architecture
- Independent main road and side road control
- Pedestrian crossing support
- Emergency vehicle priority override
- Night mode blinking operation
- Timer-controlled state sequencing
- Runtime request handling
- Modular Verilog implementation
- Behavioral simulation and waveform verification
- FPGA synthesis and implementation flow
- Timing and resource utilization analysis
- Complete FPGA constraints and pin mapping

---

## Working Principle

The controller operates using a **Finite State Machine (FSM)** that transitions through different traffic states based on timer expiration and external requests.

### Normal Operation Sequence

```text
MAIN_GREEN
    ↓
MAIN_YELLOW
    ↓
ALL_RED_1
    ↓
SIDE_GREEN
    ↓
SIDE_YELLOW
    ↓
ALL_RED_2
    ↓
Repeat
```

### Additional Functionalities

- **Pedestrian Requests** are latched and serviced safely during all-red phases.
- **Emergency Requests** receive highest priority and redirect traffic safely.
- **Night Mode** enables blinking yellow or red operation for low-traffic conditions.
- Timer durations are programmable through FSM-controlled counters.

---

## Project Structure

```text
FPGA-Smart-Traffic-Light-Controller/
│
├── design/
│   ├── top_traffic_controller.v
│   ├── traffic_fsm.v
│   ├── timer_counter.v
│   └── clock_enable_generator.v
│
├── simulation/
│   └── traffic_controller_tb.v
│
├── constraints/
│   └── traffic_controller.xdc
│
├── screenshots/
│   ├── waveforms/
│   ├── synthesis/
│   ├── implementation/
│   ├── timing/
│   └── reports/
│
├── docs/
│   ├── simulation_notes.md
│   ├── implementation_notes.md
│   └── project_report.pdf
│
├── README.md
├── LICENSE
└── .gitignore
```

---

## RTL Modules

| Module | Function |
|---|---|
| `top_traffic_controller` | Top-level integration module |
| `traffic_fsm` | Controls traffic sequencing and FSM transitions |
| `timer_counter` | Generates programmable countdown timing |
| `clock_enable_generator` | Generates periodic enable tick signals |
| `traffic_controller_tb` | Functional verification testbench |

---

## FSM States Implemented

| State | Description |
|---|---|
| MAIN_GREEN | Main road traffic enabled |
| MAIN_YELLOW | Main road transition warning |
| ALL_RED_1 | Safety delay before side road |
| SIDE_GREEN | Side road traffic enabled |
| SIDE_YELLOW | Side road transition warning |
| ALL_RED_2 | Safety delay before main road |
| PEDESTRIAN_CROSSING | Pedestrian crossing enabled |
| EMERGENCY | Emergency vehicle priority mode |
| NIGHT_MODE_HIGH | Night blinking ON phase |
| NIGHT_MODE_LOW | Night blinking OFF phase |

---

## Verification

The design was verified using multiple functional test scenarios.

### Test Cases Performed

- Initial reset verification
- Normal traffic sequencing
- Pedestrian request handling
- Emergency request handling
- Simultaneous request priority verification
- Night mode entry and exit
- Rapid night mode toggling
- Edge-case request timing verification

### Verification Results

Functional verification confirmed:

- Correct FSM state transitions
- Proper timer-controlled sequencing
- Safe emergency handling
- Correct pedestrian servicing
- Stable night mode operation
- Proper request prioritization
- Successful reset behavior

Detailed simulation notes are available in:

```text
sim/Simulation_Notes.txt
```

---

## FPGA Design Flow

The project successfully completed the following Vivado stages:

- Behavioral Simulation
- RTL Elaboration
- Synthesis
- Placement
- Routing
- Timing Analysis
- Design Rule Check (DRC)
- Bitstream Generation

---

## Tools Used

- Verilog HDL
- Xilinx Vivado 2024.x
- Vivado Simulator
- Artix-7 FPGA Series

---

## Resource Utilization and Timing

The implemented design achieved successful FPGA implementation with:

- Successful synthesis completion
- Successful routing completion
- Positive timing analysis
- Valid FPGA pin mapping
- Successful bitstream generation

Detailed synthesis and timing reports are available in:

```text
vivado_reports/
```

---

# Results

## 1. System Block Diagram

<img width="1536" height="1024" alt="Block_Diagram" src="https://github.com/user-attachments/assets/83f6d47f-7fa7-4e11-9dd6-63701470138b" />

---

## 2. FSM State Transition Diagram

<img width="1264" height="842" alt="State_Transition_Diagram" src="https://github.com/user-attachments/assets/808ca75f-f927-4fe1-bc16-ea6013d3c771" />

---

## 3. Behavioral Simulation Waveform

<img width="1627" height="891" alt="test_1_Reset" src="https://github.com/user-attachments/assets/2c4cd5d2-bb13-42af-8a24-48c3028c6731" />

---

## 4. Pedestrian Request Verification

<img width="1627" height="897" alt="test_2_pedestrian" src="https://github.com/user-attachments/assets/26b1b051-05ac-4b7e-bae1-18ab1255cf10" />

---

## 5. Emergency Override Verification

<img width="1618" height="888" alt="test_4_emergency" src="https://github.com/user-attachments/assets/63426e64-b271-473a-84ee-e0fa12995f86" />

---

## 6. Night Mode Verification

<img width="1622" height="892" alt="test_6_night_mode" src="https://github.com/user-attachments/assets/b85aa047-f346-4be1-b494-babd4f67711b" />

---

## 7. Implemented Design

<img width="1622" height="893" alt="Vivado_Implemented_Design" src="https://github.com/user-attachments/assets/13f72da3-d25a-4a43-9a47-eb988a4ea0c7" />

---

## 8. Resource Utilization Summary

<img width="752" height="322" alt="utilization_waveform" src="https://github.com/user-attachments/assets/5a57278f-ca81-4ae3-be25-6ff817d955c7" />

---

## 9. Timing Summary

<img width="1365" height="317" alt="Vivado_Timing_Summary" src="https://github.com/user-attachments/assets/889265b0-e8bd-4193-b637-6eb631626f30" />

---

## Simulation Notes

For faster simulation:

- The `COUNT_STOP` parameter was reduced inside the testbench.
- Hardware-oriented timing values were restored in the design source before implementation.

Example:

```verilog
top_traffic_controller #(.COUNT_STOP(3)) traffic (...);
```

Final FPGA implementation uses:

```verilog
parameter COUNT_STOP = 100000000;
```

---

## Key Learnings

- FSM-based digital system design
- Traffic control logic implementation
- Request prioritization techniques
- Emergency override handling
- Modular RTL architecture
- FPGA verification workflow
- Vivado synthesis and implementation flow
- Constraint handling and pin mapping
- Timing analysis and FPGA deployment concepts

---

## Future Improvements

- Physical FPGA board deployment
- Seven-segment display integration
- Sensor-based adaptive traffic timing
- Vehicle density-based dynamic control
- UART/GPIO communication support
- SystemVerilog verification environment
- Low-power optimization techniques

---

## Notes

- Simulation timing values were reduced for faster verification.
- FPGA-oriented timing parameters were restored before synthesis and implementation.
- Physical pin assignments may vary depending on the FPGA development board used.
- Additional implementation details are available in:

```text
vivado_reports/Implementation_Notes.txt
```

---

## Author

**M.V.S.Charith**

FPGA and Digital Design Enthusiast

---
