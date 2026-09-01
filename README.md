# FPGA-Based Multi-Protocol Communication Bridge

A modular FPGA-based communication bridge designed using Verilog HDL to convert data between different serial communication protocols.

> 🚧 **Project Status: Under Development**
>
> **Currently implemented:** UART → SPI  
> **Planned extensions:** SPI → UART, UART ↔ I²C, and additional protocols.

## Overview

Communication protocols such as UART, SPI, and I²C are widely used for communication between microcontrollers, sensors, peripherals, and embedded systems. These protocols have different signaling and timing requirements, making direct communication between devices using different protocols difficult.

This project implements a configurable and modular **FPGA-based protocol bridge** that receives data through one communication protocol, buffers and processes the data inside the FPGA, and transmits it using another protocol.

The first stage of the project implements a **UART-to-SPI communication bridge** using synthesizable Verilog RTL.

## Current Implementation: UART → SPI

The current design receives serial data through UART, stores the received bytes in a FIFO, and transmits each byte through an SPI master interface.

```text
        UART
          │
          ▼
   +--------------+
   |   UART RX    |
   +------+-------+
          │
          ▼
   +--------------+
   |     FIFO     |
   +------+-------+
          │
          ▼
   +--------------+
   |    Bridge    |
   |  Controller  |
   +------+-------+
          │
          ▼
   +--------------+
   |  SPI Master  |
   +------+-------+
          │
          ▼
         SPI
