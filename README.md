# Bomb Defusal Game (x86 MASM)

A two-player cooperative bomb defusal terminal game written in 32-bit x86 Assembly (MASM) using the Irvine32 library.

One player acts as the **Defuser**, sitting at the terminal interface with the ticking timer, exposed wires, and encrypted core. The other player acts as the **Expert**, consulting the offline `MANUAL.md` field guide to decipher the safe actions without looking at the screen.

---

## Game Overview & Features

...

## Project Architecture

The codebase is split into an Engine/UI module (engine.asm) and a Game Logic module (logic.asm) linked through a common interface header (bomb.inc).