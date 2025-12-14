# AES-HDL-EECE644

## Overview

This project implements a **fully synchronous AES-128 encryption core in SystemVerilog**, designed for hardware verification and simulation. The AES core performs **one AES round per clock cycle**, uses a **finite state machine (FSM)** for control, and includes a complete **key expansion unit**. The design was verified against both **NIST test vectors** and an external dataset generated using a Python AES reference implementation.

This project was developed as part of **EECE 644**.

---

## Features

* AES-128 encryption (ECB mode)
* Fully synchronous design
* One AES round per clock cycle
* Separate key expansion module
* FSM-controlled datapath
* Dataset-driven verification using `$readmemh`
* Verified against Python reference AES implementation

---

## AES Architecture

The AES core consists of the following components:

* **Key Expansion Unit**

  * Generates all 11 round keys for AES-128
* **AES Round Datapath**

  * SubBytes
  * ShiftRows
  * MixColumns
  * AddRoundKey
* **Final Round Datapath**

  * SubBytes
  * ShiftRows
  * AddRoundKey
* **Control FSM**

  * Manages round sequencing and output timing

### Round Execution

| Cycle      | Operation                                       |
| ---------- | ----------------------------------------------- |
| Round 0    | Initial AddRoundKey                             |
| Rounds 1–9 | SubBytes → ShiftRows → MixColumns → AddRoundKey |
| Round 10   | SubBytes → ShiftRows → AddRoundKey              |
| Done       | Ciphertext latched and held stable              |

---

## Project Structure

```
AES-HDL-EECE644/
├── aes_core.sv          # AES control FSM and datapath integration
├── aes_round.sv         # AES standard round (SB → SR → MC → ARK)
├── aes_final_round.sv   # AES final round (SB → SR → ARK)
├── add_round_key.sv     # XOR-based AddRoundKey
├── key_expansion.sv     # AES-128 key expansion
├── aes_tables.sv        # AES S-box and constants
├── aes128_top.sv        # Top-level wrapper
│
├── sub_bytes.sv         # SubBytes transformation
├── shift_rows.sv        # ShiftRows transformation
├── mix_columns.sv       # MixColumns transformation
│
├── inv_sub_bytes.sv     # Inverse SubBytes (for future decryption support)
├── inv_shift_rows.sv    # Inverse ShiftRows
│
├── aes_tb.sv            # Testbench with dataset verification
├── plaintext_risk.hex   # Plaintext dataset
├── ciphertext_ref.hex   # Reference ciphertext dataset
│
└── README.md
```

---

## Verification Methodology

### Software Reference

A Python script using **PyCryptodome AES-128 in ECB mode** was used to generate reference ciphertexts:

* Key:

  ```
  00112233445566778899AABBCCDDEEFF
  ```
* Mode: ECB
* Each plaintext block encrypted independently

### Hardware Verification

* Plaintext and reference ciphertext values are loaded using `$readmemh`
* Each plaintext block is encrypted by the hardware AES core
* Output ciphertext is compared cycle-accurately against the reference
* Simulation halts on any mismatch

### Result

✔ All dataset vectors passed
✔ Hardware output matched software reference for all test cases

---

## ECB Mode Explanation

ECB (Electronic Codebook) mode encrypts each 128-bit plaintext block independently using the same key. While ECB is not secure for real-world applications due to pattern leakage, it is well-suited for hardware verification because it allows deterministic, block-by-block comparison between software and hardware implementations.

---

## How to Run the Simulation

1. Open ModelSim / Questa
2. Add all `.sv` files and `.hex` files to the project
3. Compile the design
4. Run the simulation:

   ```
   restart -force
   run -all
   ```
5. Check the transcript for:

   ```
   ALL DATASET VECTORS PASSED
   ```

---

## Notes

* This project focuses on the **AES encryption primitive**, not secure system integration.
* ECB mode is used solely for verification purposes.
* The design can be extended to support other modes such as CBC or CTR.

---

## Author

**Susie Nguyen**
GitHub: [susienguyen1018](https://github.com/susienguyen1018)

**Sam Carter**

---

## Acknowledgments

* NIST FIPS-197 AES Specification
* PyCryptodome AES Reference Implementation
* EECE 644 Course Materials
