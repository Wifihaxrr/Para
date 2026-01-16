# SKILL: Parallel Orchestration

This skill provides the logic for splitting and merging tasks across multiple parallel worker agents.

## 1. Composition & Decomposer Schema (Worker-Architect)

To decompose a task, the Coordinator must generate a `WorkGraph`:

```json
{
  "workUnits": [
    {
      "id": "W-ARCH",
      "role": "Architect",
      "tasks": ["Define API contracts", "Setup types"],
      "lockedFiles": ["/types/index.ts"]
    },
    {
      "id": "W-FEAT",
      "role": "Feature-Dev",
      "tasks": ["Implement handlers", "Business logic"],
      "lockedFiles": ["/handlers/user.ts"]
    }
  ]
}
```

## 2. Parallel Merge Strategy (Worker-Feature)

The synthesis phase integrates changes using a staged commit approach:

1.  **Isolation Check**: Ensure no two workers modified the same line character-for-character.
2.  **Breadth-First Integration**: Merge independent files first to reduce the dependency surface.
3.  **Atomic Overwrite**: If a file was modified by multiple workers, the Coordinator performs a 3-way merge.

## 3. Conflict Resolution Protocols (Worker-Logic)

- **Semantic Conflict**: If `Worker-A` changes a function signature and `Worker-B` tries to call the old one, the Synthesizer triggers a signature-update pass.
- **Resource Lock**: Critical files (like `package.json`) are handled solely by the Coordinator to prevent dependency drift.
