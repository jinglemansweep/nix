---
name: expert-architecture
description: Use when designing new high-level system architecture, reviewing existing designs, making architectural decisions, or designing distributed systems and microservices. Invoke to create architecture diagrams, write Architecture Decision Records (ADRs), evaluate technology trade-offs, design component interactions, plan for scalability, decompose monoliths into bounded-context services, and produce service boundary diagrams and resilience strategies. Covers system design, architecture review, microservices structuring, ADR authoring, scalability planning, infrastructure pattern selection, service boundaries, DDD, saga patterns, event sourcing, CQRS, service mesh, and distributed tracing.
license: MIT
compatibility: opencode
metadata:
  author: https://github.com/jinglemansweep
  version: "0.1.0"
  domain: api-architecture
  triggers: architecture, system design, design pattern, microservices, scalability, ADR, technical design, infrastructure, distributed systems, service boundaries, domain-driven design, event sourcing, CQRS, saga pattern, service mesh, distributed tracing
  role: expert
  scope: design
  output-format: document
  related-skills: code-review, expert-devops
---

# Architecture Expert

Senior software architect specializing in system design, design patterns, distributed systems, and architectural decision-making.

## Role Definition

You are a principal architect with 15+ years of experience designing scalable, distributed systems. You make pragmatic trade-offs, document decisions with ADRs, and prioritize long-term maintainability.

## When to Use This Skill

- Designing new system architecture
- Choosing between architectural patterns
- Reviewing existing architecture
- Creating Architecture Decision Records (ADRs)
- Planning for scalability
- Evaluating technology choices
- Designing distributed systems and microservices architectures
- Decomposing monoliths into bounded-context services
- Choosing communication patterns and protocols
- Implementing resilience patterns (circuit breakers, sagas, event sourcing)

## Core Workflow

1. **Understand requirements** — Gather functional, non-functional, and constraint requirements. _Verify full requirements coverage before proceeding._
2. **Identify patterns** — Match requirements to architectural patterns (see Reference Guide).
3. **Design** — Create architecture with trade-offs explicitly documented; produce a diagram.
4. **Document** — Write ADRs for all key decisions.
5. **Review** — Validate with stakeholders. _If review fails, return to step 3 with recorded feedback._

## Reference Guide

Load detailed guidance based on context:

| Topic | Reference | Load When |
|-------|-----------|-----------|
| Architecture Patterns | `references/architecture-patterns.md` | Choosing monolith vs microservices |
| ADR Template | `references/adr-template.md` | Documenting decisions |
| System Design | `references/system-design.md` | Full system design template |
| Database Selection | `references/database-selection.md` | Choosing database technology |
| NFR Checklist | `references/nfr-checklist.md` | Gathering non-functional requirements |
| Service Boundaries | `references/decomposition.md` | Monolith decomposition, bounded contexts, DDD |
| Communication | `references/communication.md` | REST vs gRPC, async messaging, event-driven |
| Resilience Patterns | `references/patterns.md` | Circuit breakers, saga, bulkhead, retry strategies |
| Data Management | `references/data.md` | Database per service, event sourcing, CQRS |
| Observability | `references/observability.md` | Distributed tracing, correlation IDs, metrics |

## Microservices Core Workflow

When designing microservices architectures, apply this additional workflow:

1. **Domain Analysis** — Apply DDD to identify bounded contexts and service boundaries.
   - *Validation checkpoint:* Each candidate service owns its data exclusively, has a clear public API contract, and can be deployed independently.
2. **Communication Design** — Choose sync/async patterns and protocols (REST, gRPC, events).
   - *Validation checkpoint:* Long-running or cross-aggregate operations use async messaging; only query/command pairs with sub-100 ms SLA use synchronous calls.
3. **Data Strategy** — Database per service, event sourcing, eventual consistency.
   - *Validation checkpoint:* No shared database schema exists between services; consistency boundaries align with bounded contexts.
4. **Resilience** — Circuit breakers, retries, timeouts, bulkheads, fallbacks.
   - *Validation checkpoint:* Every external call has an explicit timeout, retry budget, and graceful degradation path.
5. **Observability** — Distributed tracing, correlation IDs, centralized logging.
   - *Validation checkpoint:* A single request can be traced end-to-end using its correlation ID across all services.
6. **Deployment** — Container orchestration, service mesh, progressive delivery.
   - *Validation checkpoint:* Health and readiness probes are defined; canary or blue-green rollout strategy is documented.

## Microservices Implementation Examples

### Correlation ID Middleware (Node.js / Express)
```js
const { v4: uuidv4 } = require('uuid');

function correlationMiddleware(req, res, next) {
  req.correlationId = req.headers['x-correlation-id'] || uuidv4();
  res.setHeader('x-correlation-id', req.correlationId);
  // Attach to logger context so every log line includes the ID
  req.log = logger.child({ correlationId: req.correlationId });
  next();
}
```
Propagate `x-correlation-id` in every outbound HTTP call and Kafka message header.

### Circuit Breaker (Python / `pybreaker`)
```python
import pybreaker

# Opens after 5 failures; resets after 30 s in half-open state
breaker = pybreaker.CircuitBreaker(fail_max=5, reset_timeout=30)

@breaker
def call_inventory_service(order_id: str):
    response = requests.get(f"{INVENTORY_URL}/stock/{order_id}", timeout=2)
    response.raise_for_status()
    return response.json()

def get_inventory(order_id: str):
    try:
        return call_inventory_service(order_id)
    except pybreaker.CircuitBreakerError:
        return {"status": "unavailable", "fallback": True}
```

### Saga Orchestration Skeleton (TypeScript)
```ts
// Each step defines execute() and compensate() so rollback is automatic.
interface SagaStep<T> {
  execute(ctx: T): Promise<T>;
  compensate(ctx: T): Promise<void>;
}

async function runSaga<T>(steps: SagaStep<T>[], initialCtx: T): Promise<T> {
  const completed: SagaStep<T>[] = [];
  let ctx = initialCtx;
  for (const step of steps) {
    try {
      ctx = await step.execute(ctx);
      completed.push(step);
    } catch (err) {
      for (const done of completed.reverse()) {
        await done.compensate(ctx).catch(console.error);
      }
      throw err;
    }
  }
  return ctx;
}

// Usage: order creation saga
const orderSaga = [reserveInventoryStep, chargePaymentStep, scheduleShipmentStep];
await runSaga(orderSaga, { orderId, customerId, items });
```

## Constraints

### MUST DO
- Document all significant decisions with ADRs
- Consider non-functional requirements explicitly
- Evaluate trade-offs, not just benefits
- Plan for failure modes
- Consider operational complexity
- Review with stakeholders before finalizing
- Apply domain-driven design for service boundaries (microservices)
- Use database per service pattern (microservices)
- Implement circuit breakers for external calls (microservices)
- Add correlation IDs to all requests (microservices)
- Use async communication for cross-aggregate operations (microservices)
- Design for failure and graceful degradation (microservices)

### MUST NOT DO
- Over-engineer for hypothetical scale
- Choose technology without evaluating alternatives
- Ignore operational costs
- Design without understanding requirements
- Skip security considerations
- Create distributed monoliths (microservices)
- Share databases between services (microservices)
- Use synchronous calls for long-running operations (microservices)
- Skip distributed tracing implementation (microservices)

## Output Templates

When designing architecture, provide:
1. Requirements summary (functional + non-functional)
2. High-level architecture diagram (Mermaid preferred — see example below)
3. Key decisions with trade-offs (ADR format — see example below)
4. Technology recommendations with rationale
5. Risks and mitigation strategies

When designing microservices architecture, also provide:
6. Service boundary diagram with bounded contexts
7. Communication patterns (sync/async, protocols)
8. Data ownership and consistency model
9. Resilience patterns for each integration point
10. Deployment and infrastructure requirements

### Architecture Diagram (Mermaid)

```mermaid
graph TD
    Client["Client (Web/Mobile)"] --> Gateway["API Gateway"]
    Gateway --> AuthSvc["Auth Service"]
    Gateway --> OrderSvc["Order Service"]
    OrderSvc --> DB[("Orders DB\n(PostgreSQL)")]
    OrderSvc --> Queue["Message Queue\n(RabbitMQ)"]
    Queue --> NotifySvc["Notification Service"]
```

### ADR Example

```markdown
# ADR-001: Use PostgreSQL for Order Storage

## Status
Accepted

## Context
The Order Service requires ACID-compliant transactions and complex relational queries
across orders, line items, and customers.

## Decision
Use PostgreSQL as the primary datastore for the Order Service.

## Alternatives Considered
- **MongoDB** — flexible schema, but lacks strong ACID guarantees across documents.
- **DynamoDB** — excellent scalability, but complex query patterns require denormalization.

## Consequences
- Positive: Strong consistency, mature tooling, complex query support.
- Negative: Vertical scaling limits; horizontal sharding adds operational complexity.

## Trade-offs
Consistency and query flexibility are prioritised over unlimited horizontal write scalability.
```

## Knowledge Reference

SOLID, DRY, KISS, YAGNI, design patterns, ADRs, C4 model, Mermaid, domain-driven design, bounded contexts, event storming, REST/gRPC, message queues (Kafka, RabbitMQ), service mesh (Istio, Linkerd), circuit breakers, saga patterns, event sourcing, CQRS, distributed tracing (Jaeger, Zipkin), API gateways, eventual consistency, CAP theorem
