# SKILL: ParaSpec DSL Reference

> **Version:** 1.0.0  
> **Purpose:** Formal specification language for Spec-Driven Development in ParaAgent

---

## Overview

**ParaSpec** is a domain-specific language for writing formal, machine-verifiable specifications. It bridges the gap between human intent and machine validation.

## Core Constructs

### 1. Module Definition

```paraspec
@spec_module ModuleName
  @description "Module purpose"
  @version "1.0.0"
  @author "Author Name"
  
  @types
    # Type definitions
  
  @constants
    # Constant values
  
  @spec function_name
    # Function specification
  @end
  
@end_module
```

### 2. Type Definitions

```paraspec
@types
  # Primitive types with constraints
  UserId: string[UUID]
  Email: string[pattern=/^[^@]+@[^@]+$/]
  Amount: integer[min=0, max=99999999]
  Status: enum[pending, active, completed, failed]
  
  # Complex types
  User: {
    id: UserId,
    email: Email,
    name: string[min_length=1, max_length=100],
    status: Status,
    createdAt: timestamp,
    metadata?: object  # Optional field
  }
  
  # Union types
  Result: Success | Failure
  
  # Array types
  UserList: User[]
  
  # Map types
  UserCache: Map<UserId, User>
```

### 3. Function Specification

```paraspec
@spec functionName
  @description "What this function does"
  
  @signature
    input: { param1: Type, param2: Type }
    output: ReturnType
    throws: [ErrorType1, ErrorType2]
  
  @preconditions
    # What must be true BEFORE execution
    - param1 IS NOT null
    - param1.length > 0
  
  @postconditions
    # What must be true AFTER execution
    - RESULT IS NOT null
    - RESULT.status == "created"
  
  @invariants
    # What must ALWAYS be true
    - Entity.count >= 0
  
  @examples
    # Concrete input/output pairs
    - input: { param1: "value" }
      output: { result: "expected" }
@end
```

### 4. Precondition Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `IS NOT null` | Non-nullity | `user IS NOT null` |
| `IS null` | Nullity | `error IS null` |
| `==` | Equality | `status == "active"` |
| `!=` | Inequality | `status != "deleted"` |
| `>`, `>=`, `<`, `<=` | Comparison | `amount > 0` |
| `IN` | Set membership | `status IN ["a", "b"]` |
| `NOT IN` | Set exclusion | `status NOT IN ["deleted"]` |
| `MATCHES` | Regex match | `email MATCHES /pattern/` |
| `EXISTS` | Entity exists | `User.findById(id) EXISTS` |
| `NOT EXISTS` | Entity missing | `User.findById(id) NOT EXISTS` |
| `AND` | Logical and | `a > 0 AND a < 100` |
| `OR` | Logical or | `status == "a" OR status == "b"` |
| `IMPLIES` | Logical implication | `isPremium IMPLIES hasAccess` |
| `FORALL` | Universal quantifier | `FORALL items: item.price > 0` |
| `EXISTS_ONE` | Existential quantifier | `EXISTS_ONE user: user.isAdmin` |

### 5. Postcondition Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `RESULT` | Return value | `RESULT IS NOT null` |
| `old(x)` | Value before execution | `old(balance) - amount == balance` |
| `UNCHANGED` | Value unchanged | `user.email UNCHANGED` |
| `INCREASED_BY` | Value increased | `counter INCREASED_BY 1` |
| `DECREASED_BY` | Value decreased | `stock DECREASED_BY quantity` |

### 6. State Transitions

```paraspec
@state_transitions
  # Define valid state changes
  - WHEN status == "pending" 
    THEN CAN_BECOME ["processing", "cancelled"]
    
  - WHEN status == "processing" 
    THEN CAN_BECOME ["completed", "failed"]
    AND REQUIRES ["payment_confirmed"]
    
  - WHEN status == "completed" 
    THEN CANNOT_CHANGE
    
  - WHEN status == "failed"
    THEN CAN_BECOME ["pending"]  # Retry allowed
    WITHIN 24h  # Time constraint
```

### 7. Edge Cases

```paraspec
@edge_cases
  # Explicit boundary conditions
  - WHEN input == null THEN THROWS NullInputError
  - WHEN input == "" THEN THROWS EmptyInputError
  - WHEN input.length > MAX_LENGTH THEN THROWS InputTooLongError
  - WHEN rate > RATE_LIMIT THEN THROWS RateLimitError
  - WHEN network_unavailable THEN RETRIES 3 TIMES THEN THROWS NetworkError
  - WHEN concurrent_modification THEN THROWS OptimisticLockError
```

### 8. Security Constraints

```paraspec
@security
  # Access control
  - REQUIRES_ROLE "admin" FOR delete_operation
  - REQUIRES_PERMISSION "write:users" FOR update
  
  # Data protection
  - password MUST NOT appear in logs
  - password MUST NOT be stored in plaintext
  - sensitiveData MUST be encrypted at rest
  
  # Input sanitization
  - userInput MUST be sanitized against XSS
  - queryParams MUST be parameterized
```

### 9. Performance Constraints

```paraspec
@performance
  # Response time
  - response_time < 100ms FOR 95th percentile
  - response_time < 500ms FOR 99th percentile
  
  # Resource usage
  - memory_usage < 50MB
  - cpu_time < 100ms
  
  # Throughput
  - requests_per_second >= 1000
  
  # Caching
  - cache_hit_rate >= 80%
```

### 10. Behavioral Properties

```paraspec
@properties
  # Idempotency: Multiple calls = same result
  @idempotent
    FORALL inputs: f(input) == f(f(input))
  
  # Commutativity: Order doesn't matter
  @commutative
    FORALL a, b: combine(a, b) == combine(b, a)
  
  # Associativity: Grouping doesn't matter
  @associative
    FORALL a, b, c: op(op(a, b), c) == op(a, op(b, c))
  
  # Reversibility: Can be undone
  @reversible
    FORALL x: undo(do(x)) == x
```

---

## Spec-Driven Development Workflow

```mermaid
graph TD
    A[User Request] --> B[@SpecWriter]
    B --> C[ParaSpec Specifications]
    C --> D[@Tester]
    C --> E[@Architect]
    D --> F[Test Cases from Specs]
    E --> G[Interfaces from Specs]
    F --> H[@Implementer]
    G --> H
    H --> I[Implementation]
    I --> J[@ContractValidator]
    C --> J
    J --> K{Validates?}
    K -->|Yes| L[@Synthesizer]
    K -->|No| H
```

## Spec-to-Test Mapping

| Spec Clause | Generated Test |
|-------------|----------------|
| `@precondition x > 0` | `test_rejects_zero_or_negative_x()` |
| `@postcondition RESULT != null` | `test_never_returns_null()` |
| `@invariant balance >= 0` | `test_balance_never_negative()` |
| `@edge_case null THROWS Error` | `test_throws_on_null()` |
| `@example {in} -> {out}` | `test_example_case()` |

## Validation Report Format

```
═══════════════════════════════════════════════════════════════
 CONTRACT VALIDATION REPORT
═══════════════════════════════════════════════════════════════
 Module: PaymentProcessing
 Spec Version: 1.2.0
 Implementation: src/payment/
═══════════════════════════════════════════════════════════════

 PRECONDITIONS          ████████░░  80%  (8/10 verified)
 POSTCONDITIONS         ██████████  100% (12/12 verified)
 INVARIANTS             ██████████  100% (3/3 verified)
 EDGE CASES             ██████░░░░  60%  (6/10 verified)
 STATE TRANSITIONS      ████████░░  80%  (4/5 verified)

═══════════════════════════════════════════════════════════════
 VERDICT: ⚠️  PARTIAL COMPLIANCE
 Missing: 2 preconditions, 4 edge cases, 1 state transition
═══════════════════════════════════════════════════════════════
```
