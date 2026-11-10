# Bomb Defusal Game (x86 MASM)

A two-player cooperative bomb defusal terminal game written in 32-bit x86 Assembly (MASM) using the Irvine32 library.

One player acts as the **Defuser**, sitting at the terminal interface with the ticking timer, exposed wires, and encrypted core. The other player acts as the **Expert**, consulting the offline `MANUAL.md` field guide to decipher the safe actions without looking at the screen.

---

## Game Overview & Features

* **Real-Time Asynchronous Loop:** Operates on an unblocked tick timer providing live countdown updates while capturing user keystrokes.
* **Procedural Bomb Generation:** Each round generates a randomized 16-bit disarm code and a shuffled sequence of 4 color-coded wires (`red`, `blue`, `green`, `yellow`).
* **Two-Stage Disarm Protocol:**
  1. **Stage 1 (Wire Cut):** Cut the correct wire based on serial parity, wire frequency, and sequence rules.
  2. **Stage 2 (Cipher PIN):** Compute and enter the 16-bit verification key to completely disarm the core.
* **Fail Conditions:** Accumulating 3 strikes or letting the 120-second timer expire triggers immediate detonation.

## Getting Started

* Make sure you have the `Irvine32` lib installed at `C:\Irvine`
* Run `run.bat` to start the game (or `build.bat` to strictly build `game.exe`)

## Project Architecture

The codebase is split into an Engine/UI module (engine.asm) and a Game Logic module (logic.asm) linked through a common interface header (bomb.inc).