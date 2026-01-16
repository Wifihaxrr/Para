# SKILL: Advanced Parallel Orchestration

> **Version:** 2.0.0  
> **Author:** RichS  
> **Purpose:** Provides the algorithms, data structures, and protocols for high-concurrency multi-agent workflows.

---

## Table of Contents

1. [Core Data Structures](#1-core-data-structures)
2. [Decomposition Algorithm](#2-decomposition-algorithm)
3. [Dependency Resolution](#3-dependency-resolution)
4. [Token Budgeting System](#4-token-budgeting-system)
5. [Parallel Execution Engine](#5-parallel-execution-engine)
6. [3-Tier Merge Protocol](#6-3-tier-merge-protocol)
7. [Conflict Resolution Matrix](#7-conflict-resolution-matrix)
8. [Failure Recovery Procedures](#8-failure-recovery-procedures)
9. [Real-World Scenarios](#9-real-world-scenarios)

---

## 1. Core Data Structures

### 1.1 WorkUnit Schema

Every task is decomposed into atomic WorkUnits:

```json
{
  "$schema": "ParaAgent/WorkUnit/v2",
  "id": "string (UUID)",
  "agent": "@Architect | @Implementer | @Reviewer | @Tester | @Synthesizer",
  "scope": {
    "files": ["string (relative path)"],
    "functions": ["string (optional, function names to modify)"],
    "lineRanges": [{"file": "string", "start": "int", "end": "int"}]
  },
  "dependencies": ["string (WorkUnit IDs)"],
  "priority": "CRITICAL | HIGH | MEDIUM | LOW",
  "status": "PENDING | RUNNING | BLOCKED | COMPLETE | FAILED",
  "output": {
    "tokens": "int",
    "codeBlocks": ["string"],
    "issues": ["Issue object"]
  },
  "metadata": {
    "estimatedTokens": "int",
    "actualTokens": "int",
    "startTime": "ISO timestamp",
    "endTime": "ISO timestamp"
  }
}
```

### 1.2 WorkGraph Schema

The complete task representation:

```json
{
  "$schema": "ParaAgent/WorkGraph/v2",
  "taskId": "string (PARA-YYYYMMDD-NNN)",
  "description": "string (user's original task)",
  "createdAt": "ISO timestamp",
  "config": {
    "maxParallelWorkers": "int",
    "conflictStrategy": "strict | semantic | permissive",
    "tokenBudget": "int (model limit * threshold)"
  },
  "workUnits": ["WorkUnit[]"],
  "layers": [
    {
      "layerId": 0,
      "workUnitIds": ["WU-01", "WU-02"]
    }
  ],
  "sharedContext": {
    "files": {"path": "content"},
    "interfaces": {"name": "definition"},
    "constants": {"name": "value"}
  }
}
```

### 1.3 Issue Schema

Used by @Reviewer:

```json
{
  "file": "string",
  "line": "int",
  "column": "int (optional)",
  "severity": "LOW | MEDIUM | HIGH | CRITICAL",
  "category": "STYLE | LOGIC | SECURITY | PERFORMANCE | TYPE",
  "message": "string",
  "suggestion": "string (optional fix)",
  "autoFixable": "boolean"
}
```

---

## 2. Decomposition Algorithm

### 2.1 Overview

The Decomposer transforms a task description into a WorkGraph.

### 2.2 Pseudocode

```python
def decompose_task(task_description: str, workspace: Workspace) -> WorkGraph:
    # Step 1: Parse intent
    intent = parse_intent(task_description)
    affected_areas = identify_affected_areas(intent, workspace)
    
    # Step 2: Build file manifest
    file_manifest = []
    for area in affected_areas:
        files = scan_directory(area.path)
        for file in files:
            file_manifest.append({
                "path": file.path,
                "exists": file.exists,
                "tokens": estimate_tokens(file.content) if file.exists else 0,
                "hotness": get_modification_frequency(file.path)
            })
    
    # Step 3: Identify natural boundaries
    boundaries = []
    for file in file_manifest:
        if is_interface_file(file):
            boundaries.append(create_work_unit(file, agent="@Architect"))
        elif is_test_file(file):
            boundaries.append(create_work_unit(file, agent="@Tester"))
        else:
            boundaries.append(create_work_unit(file, agent="@Implementer"))
    
    # Step 4: Build dependency graph
    graph = DependencyGraph()
    for wu in boundaries:
        imports = extract_imports(wu.files)
        for imported_file in imports:
            dependency = find_work_unit_by_file(boundaries, imported_file)
            if dependency:
                graph.add_edge(dependency.id, wu.id)
    
    # Step 5: Topological layer assignment
    layers = graph.topological_layers()
    
    # Step 6: Construct WorkGraph
    return WorkGraph(
        taskId=generate_task_id(),
        workUnits=boundaries,
        layers=layers,
        config=get_default_config()
    )
```

### 2.3 Intent Classification

| Intent Pattern | Agent Assignment | Priority |
|----------------|------------------|----------|
| "Create new..." | @Architect → @Implementer | CRITICAL |
| "Refactor..." | @Implementer → @Reviewer | HIGH |
| "Add tests for..." | @Tester | MEDIUM |
| "Fix bug in..." | @Implementer → @Tester | CRITICAL |
| "Document..." | @Implementer | LOW |

---

## 3. Dependency Resolution

### 3.1 Topological Sorting

WorkUnits are organized into **layers** based on their dependencies:

```
Layer 0: [WU-01, WU-05]        ← No dependencies, execute first
Layer 1: [WU-02, WU-03, WU-06] ← Depend only on Layer 0
Layer 2: [WU-04, WU-07]        ← Depend on Layer 1
Layer 3: [WU-08]               ← Final synthesis layer
```

### 3.2 Circular Dependency Detection

```python
def detect_cycles(graph: DependencyGraph) -> List[Cycle]:
    visited = set()
    rec_stack = set()
    cycles = []
    
    def dfs(node, path):
        visited.add(node)
        rec_stack.add(node)
        path.append(node)
        
        for neighbor in graph.neighbors(node):
            if neighbor not in visited:
                dfs(neighbor, path)
            elif neighbor in rec_stack:
                cycle_start = path.index(neighbor)
                cycles.append(path[cycle_start:])
        
        path.pop()
        rec_stack.remove(node)
    
    for node in graph.nodes:
        if node not in visited:
            dfs(node, [])
    
    return cycles
```

### 3.3 Cycle Resolution Strategies

| Strategy | When to Use | Action |
|----------|-------------|--------|
| **Interface Extraction** | Two implementations depend on each other | Extract shared interfaces to a new @Architect WorkUnit |
| **Merge Units** | Small, tightly coupled files | Combine into a single WorkUnit |
| **User Clarification** | Unclear architecture | HALT and ask user to clarify ownership |

---

## 4. Token Budgeting System

### 4.1 Token Estimation

```python
def estimate_tokens(content: str) -> int:
    # Rough estimation: 1 token ≈ 4 characters
    return len(content) // 4

def calculate_total_budget(work_graph: WorkGraph) -> TokenBudget:
    context_tokens = sum(
        estimate_tokens(content) 
        for content in work_graph.sharedContext.files.values()
    )
    
    output_tokens = sum(
        wu.metadata.estimatedTokens 
        for wu in work_graph.workUnits
    )
    
    overhead = 2000  # System prompt, formatting, etc.
    
    return TokenBudget(
        context=context_tokens,
        output=output_tokens,
        overhead=overhead,
        total=context_tokens + output_tokens + overhead,
        limit=MODEL_CONTEXT_LIMIT,
        utilization=total / MODEL_CONTEXT_LIMIT
    )
```

### 4.2 Batching Strategy

When token utilization exceeds threshold:

```
IF budget.utilization > config.tokenBudgetThreshold:
    SWITCH to Sequential Batching Mode:
    
    FOR each layer in work_graph.layers:
        # Load only this layer's context
        context = load_layer_context(layer)
        
        # Execute all WorkUnits in layer
        FOR each wu in layer.workUnits:
            execute(wu, context)
        
        # Commit outputs to persistent storage
        commit_layer_outputs(layer)
        
        # Unload context to free tokens
        unload_context(context)
```

---

## 5. Parallel Execution Engine

### 5.1 Execution Loop

```python
async def execute_work_graph(graph: WorkGraph):
    status_table = initialize_status_table(graph)
    completed = set()
    failed = set()
    
    while len(completed) + len(failed) < len(graph.workUnits):
        # Find ready WorkUnits (all dependencies complete)
        ready = [
            wu for wu in graph.workUnits
            if wu.id not in completed
            and wu.id not in failed
            and all(dep in completed for dep in wu.dependencies)
        ]
        
        # Limit concurrency
        batch = ready[:config.maxParallelWorkers]
        
        # Execute batch (simulated parallelism)
        results = await parallel_execute(batch)
        
        for wu, result in zip(batch, results):
            if result.success:
                completed.add(wu.id)
                wu.status = "COMPLETE"
                wu.output = result.output
                
                # Run @Reviewer if Implementer
                if wu.agent == "@Implementer":
                    await invoke_reviewer(wu.output)
            else:
                failed.add(wu.id)
                wu.status = "FAILED"
                
                # Check if failure is recoverable
                if is_recoverable(result.error):
                    await attempt_recovery(wu, result.error)
        
        update_status_table(status_table)
    
    return ExecutionResult(completed, failed)
```

### 5.2 Worker Isolation

Each worker operates in isolation with a defined scope:

```yaml
Worker Isolation Rules:
  - READ: Only files in sharedContext + own scope
  - WRITE: Only files in own scope
  - MODIFY: Only line ranges in own scope
  - IMPORT: Can reference interfaces from dependency outputs
  - CANNOT: Access other workers' in-progress outputs
```

---

## 6. 3-Tier Merge Protocol

### 6.1 Tier 1: Syntactic Merge

Standard line-by-line git-style merge:

```python
def syntactic_merge(base: str, workers_outputs: List[str]) -> MergeResult:
    # Apply each worker's diff sequentially
    result = base
    conflicts = []
    
    for output in workers_outputs:
        diff = compute_diff(result, output)
        
        for hunk in diff.hunks:
            if has_conflict(result, hunk):
                conflicts.append(ConflictMarker(hunk))
            else:
                result = apply_hunk(result, hunk)
    
    return MergeResult(content=result, conflicts=conflicts)
```

### 6.2 Tier 2: Semantic Merge

AST-aware merge for intelligent conflict resolution:

```python
def semantic_merge(syntactic_result: MergeResult) -> MergeResult:
    ast = parse_to_ast(syntactic_result.content)
    
    # Detect renamed symbols
    renames = detect_renames(ast, original_ast)
    
    # Propagate renames across the codebase
    for rename in renames:
        update_all_references(ast, rename.old_name, rename.new_name)
    
    # Detect signature changes
    signature_changes = detect_signature_changes(ast, original_ast)
    
    for change in signature_changes:
        update_call_sites(ast, change)
    
    return MergeResult(content=ast_to_code(ast), conflicts=[])
```

### 6.3 Tier 3: Structural Merge

Validate project structure integrity:

```python
def structural_merge(merged_content: str, graph: WorkGraph) -> ValidationResult:
    issues = []
    
    # Check import paths
    for import_stmt in extract_imports(merged_content):
        if not file_exists(import_stmt.path):
            issues.append(StructuralIssue("BROKEN_IMPORT", import_stmt))
    
    # Check folder structure
    expected_structure = graph.metadata.expectedStructure
    actual_structure = scan_directory(".")
    
    for expected_path in expected_structure:
        if expected_path not in actual_structure:
            issues.append(StructuralIssue("MISSING_FILE", expected_path))
    
    # Check build configuration
    if has_changes_to_build_files(graph):
        build_result = run_build()
        if not build_result.success:
            issues.append(StructuralIssue("BUILD_FAILURE", build_result.error))
    
    return ValidationResult(passed=len(issues) == 0, issues=issues)
```

---

## 7. Conflict Resolution Matrix

| Conflict Type | Detection | Resolution |
|---------------|-----------|------------|
| **Line Overlap** | Two workers edit same line | Priority-based: @Architect > @Implementer > @Tester |
| **Import Conflict** | Both add same import differently | Keep first, deduplicate |
| **Function Signature** | Parameter mismatch | Use @Architect's version, update call sites |
| **Type Mismatch** | Incompatible type changes | HALT, require user decision |
| **Test Assertion** | Conflicting expected values | Keep both, mark for review |

---

## 8. Failure Recovery Procedures

### 8.1 Worker Failure

```yaml
on_worker_failure:
  - log_error(worker_id, error_details)
  - IF error.type == "TIMEOUT":
      retry_with_simpler_prompt(worker)
  - IF error.type == "OUTPUT_TOO_LARGE":
      split_work_unit(worker, into=2)
      requeue_sub_units()
  - IF error.type == "INVALID_OUTPUT":
      invoke_reviewer_for_correction(worker.output)
  - IF error.type == "DEPENDENCY_MISSING":
      requeue_after_dependency(worker)
  - ELSE:
      mark_failed(worker)
      notify_user()
```

### 8.2 Synthesis Failure

```yaml
on_synthesis_failure:
  - IF failure.type == "MERGE_CONFLICT":
      attempt_semantic_merge()
      IF still_failed:
          present_conflict_to_user()
  - IF failure.type == "BUILD_ERROR":
      invoke_implementer_for_fix(build_error.details)
  - IF failure.type == "TEST_FAILURE":
      analyze_test_output()
      suggest_fixes()
```

---

## 9. Real-World Scenarios

### 9.1 Scenario: Large Refactoring Task

**Task:** "Refactor the payment module from callbacks to async/await"

**Decomposition:**
```
Layer 0: @Architect
  - WU-01: Update PaymentService interface to async
  
Layer 1: @Implementer (parallel)
  - WU-02: Refactor PaymentProcessor.ts
  - WU-03: Refactor PaymentValidator.ts
  - WU-04: Refactor PaymentGateway.ts
  
Layer 2: @Implementer
  - WU-05: Update all call sites in controllers
  
Layer 3: @Tester
  - WU-06: Update all payment tests
  
Layer 4: @Synthesizer
  - WU-07: Final merge and validation
```

### 9.2 Scenario: New Feature with Tests

**Task:** "Add user profile picture upload with S3 storage"

**Decomposition:**
```
Layer 0: @Architect
  - WU-01: Define ProfilePicture interface and S3Config types
  
Layer 1: @Implementer (parallel)
  - WU-02: Implement S3 upload service
  - WU-03: Implement ProfilePictureController
  
Layer 2: @Tester (parallel)
  - WU-04: Unit tests for S3 service (mocked)
  - WU-05: Integration tests for controller
  
Layer 3: @Synthesizer
  - WU-06: Merge, lint, run full test suite
```

---

## Appendix: Configuration Options

```json
{
  "parallel_orchestration": {
    "max_parallel_workers": 4,
    "conflict_strategy": "semantic",
    "auto_lint": true,
    "auto_typecheck": true,
    "token_budget_threshold": 0.8,
    "retry_on_failure": true,
    "max_retries": 2,
    "layer_timeout_ms": 60000,
    "enable_status_table": true,
    "verbose_logging": false
  }
}
```
