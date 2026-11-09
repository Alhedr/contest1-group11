# Bomb Defusal Field Manual (Model-IV)

## Section 1: Wire Cut Protocol
Wires are numbered 1 to 4 from top to bottom (Index 0 to 3):

1. If there is more than one **Red** wire AND the last digit of the Bomb Code is odd:
   * Cut the **Second wire** (Wire 2/Index 1).
2. Otherwise, if the last wire is **Yellow** AND there are no **Blue** wires:
   * Cut the **First wire** (Wire 1/Index 0).
3. Otherwise, if there is exactly one **Green** wire:
   * Cut the **Third wire** (Wire 3/Index 2).
4. Otherwise, if none of the above apply:
   * Cut the **Fourth wire** (Wire 4/Index 3).

---

## Section 2: Core PIN Disarm Code
Once the primary wire circuit is safely severed, calculate the 16-bit disarm key:

* Take the 4-digit hexadecimal `Bomb Code` displayed on the terminal.
* Calculate: `Disarm PIN = Bomb Code XOR 0x5A5A`.
* Enter the resulting hex/decimal value into the keypad terminal to trigger full defusal.