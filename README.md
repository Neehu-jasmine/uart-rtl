# UART RTL — From Parallel Data to Serial Bits

> A simulation-first UART implementation designed from RTL fundamentals and verified through waveform-based testing.

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Simulation](https://img.shields.io/badge/Verification-Vivado%20Simulation-orange)
![UART](https://img.shields.io/badge/Protocol-UART-green)
![Status](https://img.shields.io/badge/Status-Verified-success)

---

## ⚡ What is this?

This project is a UART communication system designed entirely in **Verilog RTL** and verified through simulation.

The design implements the complete path:

```text
Parallel Data
     │
     ▼
┌──────────────┐
│ UART TX      │
└──────┬───────┘
       │
       │ Serial TX
       ▼
┌──────────────┐
│ UART RX      │
└──────┬───────┘
       │
       ▼
Received Data
