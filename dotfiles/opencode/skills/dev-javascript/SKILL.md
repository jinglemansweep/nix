---
name: dev-javascript
description: "Writes, debugs, and refactors JavaScript and TypeScript code using modern ES2023+ features, async/await patterns, ESM module systems, and Node.js APIs. Also covers advanced TypeScript type systems including custom type guards, utility types, branded types, and tRPC for end-to-end type safety. Use when building vanilla JavaScript or TypeScript applications, implementing Promise-based async flows, optimising browser or Node.js performance, working with Web Workers or Fetch API, reviewing .js/.mjs/.cjs/.ts files for correctness and best practices, or building applications requiring advanced generics, conditional or mapped types, discriminated unions, monorepo setup, or full-stack type safety."
license: MIT
compatibility: opencode
metadata:
  author: https://github.com/jinglemansweep
  version: "0.1.0"
  domain: language
  triggers: JavaScript, ES2023, async await, Node.js, vanilla JavaScript, Web Workers, Fetch API, browser API, module system, TypeScript, generics, type safety, conditional types, mapped types, tRPC, tsconfig, type guards, discriminated unions
  role: specialist
  scope: implementation
  output-format: code
  related-skills: expert-scaffolder, expert-testing
---

# JavaScript Dev

## When to Use This Skill

- Building vanilla JavaScript or TypeScript applications
- Implementing async/await patterns and Promise handling
- Working with modern module systems (ESM/CJS)
- Optimizing browser performance and memory usage
- Developing Node.js backend services
- Implementing Web Workers, Service Workers, or browser APIs
- Building TypeScript applications with advanced generics, conditional/mapped types
- Designing discriminated unions and type guards for state machines
- Setting up tRPC for end-to-end type safety
- Configuring tsconfig for strict type checking

## Core Workflow

1. **Analyze requirements** — Review `package.json`, module system, Node version, browser targets; confirm `.js`/`.mjs`/`.cjs` conventions
2. **Design architecture** — Plan modules, async flows, and error handling strategies
3. **Implement** — Write ES2023+ code with proper patterns and optimisations
4. **Validate** — Run linter (`eslint --fix`); if linter fails, fix all reported issues and re-run before proceeding. Check for memory leaks with DevTools or `--inspect`, verify bundle size; if leaks are found, resolve them before continuing
5. **Test** — Write comprehensive tests with Jest achieving 85%+ coverage; if coverage falls short, add missing cases and re-run. Confirm no unhandled Promise rejections

## Reference Guide

Load detailed guidance based on context:

| Topic | Reference | Load When |
|-------|-----------|-----------|
| Modern Syntax | `references/modern-syntax.md` | ES2023+ features, optional chaining, private fields |
| Async Patterns | `references/async-patterns.md` | Promises, async/await, error handling, event loop |
| Modules | `references/modules.md` | ESM vs CJS, dynamic imports, package.json exports |
| Browser APIs | `references/browser-apis.md` | Fetch, Web Workers, Storage, IntersectionObserver |
| Node Essentials | `references/node-essentials.md` | fs/promises, streams, EventEmitter, worker threads |
| Advanced Types | `references/advanced-types.md` | Generics, conditional types, mapped types, template literals |
| Type Guards | `references/type-guards.md` | Type narrowing, discriminated unions, assertion functions |
| Utility Types | `references/utility-types.md` | Partial, Pick, Omit, Record, custom utilities |
| TS Configuration | `references/configuration.md` | tsconfig options, strict mode, project references |
| TS Patterns | `references/patterns.md` | Builder pattern, factory pattern, type-safe APIs |

## Constraints

### MUST DO
- Use ES2023+ features exclusively
- Use `X | null` or `X | undefined` patterns
- Use optional chaining (`?.`) and nullish coalescing (`??`)
- Use async/await for all asynchronous operations
- Use ESM (`import`/`export`) for new projects
- Implement proper error handling with try/catch
- Add JSDoc comments for complex functions
- Follow functional programming principles
- Enable TypeScript strict mode with all compiler flags
- Use type-first API design
- Implement branded types for domain modeling
- Use `satisfies` operator for type validation
- Create discriminated unions for state machines
- Generate declaration files for libraries

### MUST NOT DO
- Use `var` (always use `const` or `let`)
- Use callback-based patterns (prefer Promises)
- Mix CommonJS and ESM in the same module
- Ignore memory leaks or performance issues
- Skip error handling in async functions
- Use synchronous I/O in Node.js
- Mutate function parameters
- Create blocking operations in the browser
- Use explicit `any` without justification
- Skip type coverage for public APIs
- Disable strict null checks
- Use `as` assertions without necessity
- Use enums (prefer const objects with `as const`)

## Key Patterns with Examples

### Async/Await Error Handling
```js
// ✅ Correct — always handle async errors explicitly
async function fetchUser(id) {
  try {
    const response = await fetch(`/api/users/${id}`);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return await response.json();
  } catch (err) {
    console.error("fetchUser failed:", err);
    return null;
  }
}

// ❌ Incorrect — unhandled rejection, no null guard
async function fetchUser(id) {
  const response = await fetch(`/api/users/${id}`);
  return response.json();
}
```

### Optional Chaining & Nullish Coalescing
```js
// ✅ Correct
const city = user?.address?.city ?? "Unknown";

// ❌ Incorrect — throws if address is undefined
const city = user.address.city || "Unknown";
```

### ESM Module Structure
```js
// ✅ Correct — named exports, no default-only exports for libraries
// utils/math.mjs
export const add = (a, b) => a + b;
export const multiply = (a, b) => a * b;

// consumer.mjs
import { add } from "./utils/math.mjs";

// ❌ Incorrect — mixing require() with ESM
const { add } = require("./utils/math.mjs");
```

### Avoid var / Prefer const
```js
// ✅ Correct
const MAX_RETRIES = 3;
let attempts = 0;

// ❌ Incorrect
var MAX_RETRIES = 3;
var attempts = 0;
```

## TypeScript Code Examples

### Branded Types
```typescript
type Brand<T, B extends string> = T & { readonly __brand: B };
type UserId  = Brand<string, "UserId">;
type OrderId = Brand<number, "OrderId">;

const toUserId  = (id: string): UserId  => id as UserId;
const toOrderId = (id: number): OrderId => id as OrderId;

function getOrder(userId: UserId, orderId: OrderId) { /* ... */ }
```

### Discriminated Unions & Type Guards
```typescript
type LoadingState = { status: "loading" };
type SuccessState = { status: "success"; data: string[] };
type ErrorState   = { status: "error";   error: Error };
type RequestState = LoadingState | SuccessState | ErrorState;

function isSuccess(state: RequestState): state is SuccessState {
  return state.status === "success";
}

function renderState(state: RequestState): string {
  switch (state.status) {
    case "loading": return "Loading…";
    case "success": return state.data.join(", ");
    case "error":   return state.error.message;
    default: {
      const _exhaustive: never = state;
      throw new Error(`Unhandled state: ${_exhaustive}`);
    }
  }
}
```

### Custom Utility Types
```typescript
type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object ? DeepReadonly<T[K]> : T[K];
};

type RequireExactlyOne<T, Keys extends keyof T = keyof T> =
  Pick<T, Exclude<keyof T, Keys>> &
  { [K in Keys]-?: Required<Pick<T, K>> & Partial<Record<Exclude<Keys, K>, never>> }[Keys];
```

### Recommended tsconfig.json
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "exactOptionalPropertyTypes": true,
    "isolatedModules": true,
    "declaration": true,
    "declarationMap": true,
    "incremental": true,
    "skipLibCheck": false
  }
}
```

## Output Templates

When implementing JavaScript features, provide:
1. Module file with clean exports
2. Test file with comprehensive coverage
3. JSDoc documentation for public APIs
4. Brief explanation of patterns used
