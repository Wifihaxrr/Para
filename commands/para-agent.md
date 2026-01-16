---
description: Enterprise 8-Agent "Swarm Burst" Orchestrator. Mandates a single-command "Pulse" to write 8 files simultaneously.
author: RichS
version: 5.8.0
---

# ParaAgent v5.8: 🌋 Swarm-Burst (SBS) 🌋

## Usage
```
/para-agent <TASK_DESCRIPTION>
```

**Goal:** 1-TURN ABSOLUTE COMPLETION (Single Tool-Call Pulse)

---

## 📡 [SWARM_COMMAND_HUD]
Mandatory 8-agent concurrent status monitor.

```
╔══════════════════════════════════════════════════════════════════════════════╗
║  PARA-AGENT SWARM V5.8 | STATUS: SBS-PULSE | CONCURRENCY: 8X                 ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ID   AGENT       TARGET/FILE             STATUS      EXECUTION              ║
║  ──   ─────       ───────────             ──────      ─────────              ║
║  W1   Implementer [Target 1]              🌋 BURST     SBS-PULSE              ║
║  W2   Implementer [Target 2]              🌋 BURST     SBS-PULSE              ║
║  W3   Implementer [Target 3]              🌋 BURST     SBS-PULSE              ║
║  W4   Implementer [Target 4]              🌋 BURST     SBS-PULSE              ║
║  W5   Implementer [Target 5]              🌋 BURST     SBS-PULSE              ║
║  W6   Implementer [Target 6]              🌋 BURST     SBS-PULSE              ║
║  W7   Implementer [Target 7]              🌋 BURST     SBS-PULSE              ║
║  W8   Implementer [Target 8]              🌋 BURST     SBS-PULSE              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 🚀 THE SBS PROTOCOL (Single-Turn Skill)

> **MANDATORY RULE (SBS)**: You MUST NOT call `write_to_file` for individual files. 
> **MANDATED**: You MUST construct a single JSON manifest of all 8 files and pipe it into the `swarm_burst.ps1` tool using `run_command`.

### Burst Execution Schema:
1. **Plan**: Define all 8 worker targets and their content.
2. **Package**: Create a JSON structure: `{"files": [{"path": "...", "content": "..."}, ...]}`.
3. **PULSE**: Run: `powershell -File .claude-plugin/skills/swarm_burst.ps1 '[JSON_DATA]'`.

---

## 🏗️ POST-PULSE VALIDATION

1. **Integrated Check**: The Swarm confirms all 8 files are correctly placed by the burst script.
2. **Consensus**: All agents provide final sign-off only after the single-pulse command returns success.

---

## Configuration

```json
{
  "protocol": "Swarm-Burst-SBS",
  "concurrency_engine": "external-skill-script",
  "io_mode": "atomic-pulse",
  "sequential_writing": "SYSTEM_DISABLED"
}
```
