---
description: Enterprise 8-Agent "Parallel Burst" Orchestrator. Mandates 8 simultaneous tool calls for true 8x development velocity.
author: RichS
version: 5.6.0
---

# ParaAgent v5.6: 🌊 Parallel Swarm 🌊

## Usage
```
/para-agent <TASK_DESCRIPTION>
```

**Goal:** TRUE 8X CONCURRENCY (Parallel Tool Execution)

---

## 📡 [SWARM_COMMAND_HUD]
Mandatory 8-agent concurrent status monitor.

```
╔══════════════════════════════════════════════════════════════════════════════╗
║  PARA-AGENT SWARM V5.6 | STATUS: PARALLEL-BURST | CONCURRENCY: 8X            ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ID   AGENT       TARGET/FILE             STATUS      EXECUTION              ║
║  ──   ─────       ───────────             ──────      ─────────              ║
║  W1   Implementer [Target 1]              🌊 BURST     PARALLEL-1             ║
║  W2   Implementer [Target 2]              🌊 BURST     PARALLEL-1             ║
║  W3   Implementer [Target 3]              🌊 BURST     PARALLEL-1             ║
║  W4   Implementer [Target 4]              🌊 BURST     PARALLEL-1             ║
║  W5   Implementer [Target 5]              🌊 BURST     PARALLEL-1             ║
║  W6   Implementer [Target 6]              🌊 BURST     PARALLEL-1             ║
║  W7   Implementer [Target 7]              🌊 BURST     PARALLEL-1             ║
║  W8   Implementer [Target 8]              🌊 BURST     PARALLEL-1             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 🚀 THE PARALLEL BURST (Zero Sequentiality)

> **MANDATORY RULE**: You MUST emit all tool calls (e.g., `write_to_file`) for all 8 agents in **one single response**. 
> **FORBIDDEN**: Do not write one file, wait for success, then write the second. This is sequential and violates v5.6 protocol.

### Execution Process:
1. **Plan**: Define exactly what W1-W8 will do.
2. **Generate**: Construct all 8 file contents in memory.
3. **Burst**: Emit 8 tool calls simultaneously using `waitForPreviousTools: false` (or equivalent parallel tool calling).

---

## 🏗️ SWARM INTEGRATION & VALIDATION

1. **Integrated Logic**: The Swarm confirms all 8 parallel outputs form a cohesive system.
2. **Conflict Check**: Resolves inter-file references.
3. **Consensus**: All agents sign-off only after the 8 parallel tools complete successfully.

---

## Configuration

```json
{
  "protocol": "Parallel-Burst",
  "tool_execution": "parallel",
  "batch_size": 8,
  "sequential_checklists": "disabled"
}
```
