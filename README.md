# ParaAgent v5.0

> **UltraThink Orchestrator - Deep Reasoning + Anti-Hallucination + Confidence Calibration**

[![Version](https://img.shields.io/badge/version-5.0.0-blue.svg)]()
[![Agents](https://img.shields.io/badge/agents-10-green.svg)]()
[![Reasoning](https://img.shields.io/badge/reasoning-UltraThink-purple.svg)]()

## 🚀 Installation

ParaAgent is available via the Claude Marketplace.

### From CLI

```bash
/plugin add Wifihaxrr/ParaAgent
```

### Manual Installation

If you are developing locally:

```bash
/plugin add .
```

## 🧠 What's New in v5.0

| Feature | Description |
|---------|-------------|
| **Mandatory UltraThink** | Every agent MUST reason explicitly before acting |
| **Pre-Flight Checklists** | 10-item validation before every output |
| **Anti-Hallucination Guards** | Never invent - cite or say UNKNOWN |
| **Confidence Scoring** | Every output ends with calibrated confidence % |
| **Self-Reflection Loops** | Agents question their own work |
| **Escalation Criteria** | Know when to STOP and ask |

## ⚡ Usage

```
/para-agent "Build a complete REST API with authentication"
```

## 🔒 Anti-Hallucination Protocol

```
┌─────────────────────────────────────────────────────────┐
│ ANTI-HALLUCINATION RULES                                │
├─────────────────────────────────────────────────────────┤
│ ✗ NEVER invent file paths                              │
│ ✗ NEVER invent function names                          │
│ ✗ NEVER assume library APIs                            │
│ ✓ ALWAYS cite line numbers                             │
│ ✓ ALWAYS say UNKNOWN when uncertain                    │
│ ✓ ALWAYS state assumptions explicitly                  │
└─────────────────────────────────────────────────────────┘
```

## 📊 Confidence Calibration

Every output includes:

```
CONFIDENCE: 85%
REASON: All tests pass, spec compliant, but no production benchmark
```

## 🤖 The 10-Agent Swarm (v2.0)

| Agent | Enhancement |
|-------|-------------|
| @Researcher | Mandatory citation |
| @SpecWriter | Completeness scoring |
| @Architect | Assumption documentation |
| @Tester | Coverage confidence |
| @Implementer×3 | Anti-hallucination guards |
| @Reviewer | Calibrated severity |
| @Optimizer | Benchmark verification |
| @ContractValidator | Compliance scoring |
| @Documenter | Source citation |
| @Synthesizer | Integration verification |

## 📁 Structure

```
ParaAgent/
├── commands/para-agent.md    (650+ lines, UltraThink)
├── skills/
│   ├── parallel_orchestration.md
│   └── paraspec_dsl.md
├── agents/                   (All v2.0)
│   ├── researcher.md
│   ├── specwriter.md
│   ├── architect.md
│   ├── implementer.md
│   ├── reviewer.md
│   ├── tester.md
│   ├── optimizer.md
│   ├── contractvalidator.md
│   ├── documenter.md
│   └── synthesizer.md
└── README.md
```

## 📝 License

MIT © RichS

---

*ParaAgent v5.0: Think deep. Verify everything. Never guess.*
