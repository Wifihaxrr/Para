---
description: Enterprise 8-Agent "Parallel Burst" Orchestrator. Mandates 8 simultaneous tool calls for true 8x development velocity.
author: RichS
version: 5.7.0
---

# ParaAgent v5.7: 🌊 Parallel Swarm (PTC) 🌊

## Usage
```
/para-agent <TASK_DESCRIPTION>
```

**Goal:** TRUE 8X CONCURRENCY via PARALLEL TOOL CALLING (PTC)

---

## 📡 [SWARM_COMMAND_HUD]
Mandatory 8-agent concurrent status monitor.

```
╔══════════════════════════════════════════════════════════════════════════════╗
║  PARA-AGENT SWARM V5.7 | STATUS: PTC-BURST | CONCURRENCY: 8X                 ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ID   AGENT       TARGET/FILE             STATUS      EXECUTION              ║
║  ──   ─────       ───────────             ──────      ─────────              ║
║  W1   Implementer [Target 1]              🌊 BURST     PTC-SLOT-1             ║
║  W2   Implementer [Target 2]              🌊 BURST     PTC-SLOT-2             ║
║  W3   Implementer [Target 3]              🌊 BURST     PTC-SLOT-3             ║
║  W4   Implementer [Target 4]              🌊 BURST     PTC-SLOT-4             ║
║  W5   Implementer [Target 5]              🌊 BURST     PTC-SLOT-5             ║
║  W6   Implementer [Target 6]              🌊 BURST     PTC-SLOT-6             ║
║  W7   Implementer [Target 7]              🌊 BURST     PTC-SLOT-7             ║
║  W8   Implementer [Target 8]              🌊 BURST     PTC-SLOT-8             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 🚀 THE PTC PROTOCOL (True Multi-Agent Concurrency)

> **MANDATORY RULE (PTC)**: You MUST emit the tool calls for all 8 workers (e.g., `write_to_file`) **simultaneously in one single turn**. 
> **FORBIDDEN**: Do not wait for tool output between workers. Emit 8 calls, then process the results.

### Burst Execution Schema:
1. **Plan**: Define all 8 worker targets.
2. **Generate**: Pre-construct all 8 file contents.
3. **PTC Execution**: Emit 8 `write_to_file` calls in parallel (set `waitForPreviousTools: false` for all).

---

## 🏗️ CROSS-SWARM SYNTHESIS

1. **Integrated Merge**: The Swarm confirms all 8 parallel outputs form a cohesive system.
2. **Sync**: Resolves imports and dependencies across the 8 files *after* the parallel burst.
3. **Consensus**: All agents sign-off only after the 8-way parallel task is complete.

---

## Configuration

```json
{
  "protocol": "Parallel-Burst-PTC",
  "concurrency_engine": "parallel-tool-emission",
  "batch_size": 8,
  "sequential_writing": "FORBIDDEN"
}
```
