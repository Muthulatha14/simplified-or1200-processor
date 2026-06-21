# Simplified OR1200-Style Processor

A simplified version of the OpenRISC OR1200 processor architecture, built in Verilog HDL. Implements the core memory subsystem features that distinguish a full-scale processor from a basic pipeline: instruction/data caching, virtual memory translation (MMU), and interrupt handling.

## Project Info
- **Tech:** Verilog HDL
- **Simulator:** JDoodle (Icarus Verilog)
- **Difficulty:** Advanced
- **Inspired by:** OpenRISC OR1200 architecture

## Modules
| File | Description |
|------|--------------|
| instruction_cache.v | Direct-mapped instruction cache (8 lines) |
| data_cache.v | Write-through data cache (8 lines) |
| mmu.v | Page-based Memory Management Unit (virtual-to-physical translation) |
| interrupt_unit.v | Interrupt handling with context save/restore |
| or1200_memory_path.v | Top-level integration: MMU → Cache → Memory, with parallel interrupt handling |
| tb_or1200_memory_path.v | Testbench demonstrating full datapath |

## Architecture Overview

```
CPU generates Virtual Address
        |
      [MMU] --> translates to Physical Address (or raises page_fault)
        |
  [I-Cache / D-Cache] --> checks cache, falls back to main memory on miss
        |
   Data/Instruction returned to CPU

Meanwhile: [Interrupt Unit] monitors and can redirect execution at any time
```

## Key Concepts Implemented

### Caching
- Direct-mapped cache structure with valid bits and tags
- Demonstrates cache hit/miss behavior
- Data cache uses write-through policy (writes update cache + main memory simultaneously)

### MMU (Virtual Memory)
- Translates virtual addresses to physical addresses using a page table
- Detects and reports page faults for unmapped memory access

### Interrupt Handling
- Detects interrupt requests (subject to an enable flag)
- Saves current PC before jumping to a fixed handler address
- Restores execution at the correct return address after handling

## Simulation Results
```
VA=0 | instr=00221820 | cache_hit=0 page_fault=0 (MISS, no fault)
VA=0 | instr=00221820 | cache_hit=1 page_fault=0 (HIT, no fault)
VA=00000a00 | page_fault=1 (FAULT - unmapped page)
INTERRUPT during fetch | next_pc=00000100 | in_handler=1
```

## Learning Outcomes
- Large RTL codebase navigation and modular system design
- Full CPU memory subsystem integration (MMU + Cache + Interrupts)
- Cache hit/miss behavior and write-through policy implementation
- Virtual memory translation and page fault detection
- Interrupt context save/restore mechanism

## Related Projects
This project builds on concepts from a separately implemented 5-stage pipelined MIPS processor (hazard detection + forwarding), combining pipelining with the memory subsystem features found in real-world RISC processors like OR1200.
