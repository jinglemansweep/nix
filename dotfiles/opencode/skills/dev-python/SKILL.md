---
name: dev-python
description: "Use when building Python 3.11+ applications requiring type safety, async programming, or robust error handling. Also covers high-performance async API development with FastAPI and Pydantic V2. Generates type-annotated Python code, configures mypy in strict mode, writes pytest test suites with fixtures and mocking, and validates code with black and ruff. Invoke for type hints, async/await patterns, dataclasses, dependency injection, logging configuration, structured error handling, REST endpoints, Pydantic models, JWT authentication, async SQLAlchemy, WebSocket endpoints, and OpenAPI documentation."
license: MIT
compatibility: opencode
metadata:
  author: https://github.com/jinglemansweep
  version: "0.1.0"
  domain: language
  triggers: Python development, type hints, async Python, pytest, mypy, dataclasses, Python best practices, Pythonic code, FastAPI, Pydantic, REST API Python, SQLAlchemy async, JWT authentication, OpenAPI, Swagger Python
  role: specialist
  scope: implementation
  output-format: code
  related-skills: expert-devops, expert-scaffolder, expert-testing
---

# Python Dev

Modern Python 3.11+ specialist focused on type-safe, async-first, production-ready code.

## When to Use This Skill

- Writing type-safe Python with complete type coverage
- Implementing async/await patterns for I/O operations
- Setting up pytest test suites with fixtures and mocking
- Creating Pythonic code with comprehensions, generators, context managers
- Building packages with Poetry and proper project structure
- Performance optimization and profiling
- Building REST APIs with FastAPI
- Implementing Pydantic V2 validation schemas
- Setting up async database operations with SQLAlchemy
- Implementing JWT authentication/authorization
- Creating WebSocket endpoints
- Optimizing API performance

## New Project Defaults

When scaffolding a **new** Python project, always use these libraries and patterns. Existing projects should follow whatever patterns they already use.

| Concern | Library / Pattern | Notes |
|---------|-------------------|-------|
| CLI | `click` | Declarative commands, options, arguments |
| Models / Validation | `pydantic` (v2) | BaseModel schemas, field/model validators |
| Configuration | `pydantic-settings` | Env vars, `.env` files, CLI overrides in one Settings class |
| ORM / Migrations | `sqlalchemy` (async) + `alembic` | Async engine, DeclarativeBase, revision-based migrations |
| Packaging | `pyproject.toml` | `dependencies` + `[project.optional-dependencies] dev`, hatchling backend |

Typical new-project `pyproject.toml` dependency block:
```toml
dependencies = [
    "click>=8.1.0",
    "pydantic>=2.5.0",
    "pydantic-settings>=2.1.0",
    "sqlalchemy[asyncio]>=2.0.0",
    "alembic>=1.13.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-asyncio>=0.23.0",
    "pytest-cov>=4.1.0",
    "mypy>=1.7.0",
    "black>=23.11.0",
    "ruff>=0.1.6",
    "httpx>=0.25.0",
]
```

## Core Workflow

1. **Activate virtual environment** — Ensure `.venv` exists and is active (see Virtual Environment section below)
2. **Analyze codebase** — Review structure, dependencies, type coverage, test suite
3. **Design interfaces** — Define protocols, dataclasses, type aliases
4. **Implement** — Write Pythonic code with full type hints and error handling
5. **Test** — Create comprehensive pytest suite with >90% coverage
6. **Validate** — Run `.venv/bin/mypy --strict`, `.venv/bin/black --check`, `.venv/bin/ruff check`
   - If mypy fails: fix type errors reported and re-run before proceeding
   - If tests fail: debug assertions, update fixtures, and iterate until green
   - If ruff/black reports issues: apply auto-fixes, then re-validate

## Virtual Environment

**Always** use a virtual environment when interacting with a Python codebase. The virtual environment lives at `.venv` in the project root.

### Detection and Setup

Before running **any** Python command, check and prepare the environment:

```bash
# Check if .venv exists
if [ ! -d .venv ]; then
    python3 -m venv .venv
fi

# Activate and install dependencies
source .venv/bin/activate
pip install -e ".[dev]"
```

### Running Commands

Always use `.venv/bin/` prefix or activate the venv first:

```bash
# Preferred: explicit path (no activation needed)
.venv/bin/python -m pytest
.venv/bin/mypy src/
.venv/bin/ruff check src/
.venv/bin/black --check src/

# Alternative: activate then run
source .venv/bin/activate && pytest && mypy src/ && ruff check src/
```

### Rules

- If `.venv/` does not exist, create it with `python3 -m venv .venv`
- After creating `.venv`, always install dependencies: `source .venv/bin/activate && pip install -e ".[dev]"`
- Never run bare `python`, `pytest`, `mypy`, `ruff`, or `black` without ensuring the venv is active
- Never install packages globally or into the system Python

## Reference Guide

Load detailed guidance based on context:

| Topic | Reference | Load When |
|-------|-----------|-----------|
| Type System | `references/type-system.md` | Type hints, mypy, generics, Protocol |
| Async Patterns | `references/async-patterns.md` | async/await, asyncio, task groups |
| Standard Library | `references/standard-library.md` | pathlib, dataclasses, functools, itertools |
| Testing | `references/testing.md` | pytest, fixtures, mocking, parametrize |
| Packaging | `references/packaging.md` | poetry, pip, pyproject.toml, distribution |
| Pydantic V2 | `references/pydantic-v2.md` | Creating schemas, validation, model_config |
| SQLAlchemy | `references/async-sqlalchemy.md` | Async database, models, CRUD operations |
| Endpoints | `references/endpoints-routing.md` | APIRouter, dependencies, routing |
| Authentication | `references/authentication.md` | JWT, OAuth2, get_current_user |
| Async Testing | `references/testing-async.md` | pytest-asyncio, httpx, fixtures |
| Django Migration | `references/migration-from-django.md` | Migrating from Django/DRF to FastAPI |

## Constraints

### MUST DO
- Type hints for all function signatures and class attributes
- Always use a Python virtual environment at `.venv` — create if missing, activate before running any Python commands, install all dependencies
- For new projects: use `click` (CLI), `pydantic` (models), `pydantic-settings` (config), `sqlalchemy`+`alembic` (ORM/migrations), `pyproject.toml` (packaging)
- PEP 8 compliance with black formatting
- Comprehensive docstrings (Google style)
- Test coverage exceeding 90% with pytest
- Use `X | None` instead of `Optional[X]` (Python 3.10+)
- Async/await for I/O-bound operations
- Dataclasses over manual __init__ methods
- Context managers for resource handling
- Use Pydantic V2 syntax (`field_validator`, `model_validator`, `model_config`) for FastAPI schemas
- Use `Annotated` pattern for FastAPI dependency injection
- Return proper HTTP status codes from API endpoints
- Document API endpoints (auto-generated OpenAPI)

### MUST NOT DO
- Skip type annotations on public APIs
- Use mutable default arguments
- Mix sync and async code improperly
- Ignore mypy errors in strict mode
- Use bare except clauses
- Hardcode secrets or configuration
- Use deprecated stdlib modules (use pathlib not os.path)
- Use Pydantic V1 syntax (`@validator`, `class Config`)
- Use synchronous database operations in async contexts
- Store passwords in plain text
- Expose sensitive data in API responses

## Code Examples

### Type-annotated function with error handling
```python
from pathlib import Path

def read_config(path: Path) -> dict[str, str]:
    """Read configuration from a file.

    Args:
        path: Path to the configuration file.

    Returns:
        Parsed key-value configuration entries.

    Raises:
        FileNotFoundError: If the config file does not exist.
        ValueError: If a line cannot be parsed.
    """
    config: dict[str, str] = {}
    with path.open() as f:
        for line in f:
            key, _, value = line.partition("=")
            if not key.strip():
                raise ValueError(f"Invalid config line: {line!r}")
            config[key.strip()] = value.strip()
    return config
```

### Configuration with pydantic-settings (new projects)
```python
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict

class AppConfig(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    host: str = "0.0.0.0"
    port: int = Field(default=8000, ge=1, le=65535)
    debug: bool = False
    database_url: str
    allowed_origins: list[str] = Field(default_factory=lambda: ["http://localhost:3000"])

config = AppConfig()
```

### Async pattern
```python
import asyncio
import httpx

async def fetch_all(urls: list[str]) -> list[bytes]:
    """Fetch multiple URLs concurrently."""
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url) for url in urls]
        responses = await asyncio.gather(*tasks)
        return [r.content for r in responses]
```

### pytest fixture and parametrize
```python
import pytest
from pathlib import Path

@pytest.fixture
def config_file(tmp_path: Path) -> Path:
    cfg = tmp_path / "config.txt"
    cfg.write_text("host=localhost\nport=8080\n")
    return cfg

@pytest.mark.parametrize("port,valid", [(8080, True), (0, False), (99999, False)])
def test_app_config_port_validation(port: int, valid: bool) -> None:
    if valid:
        AppConfig(host="localhost", port=port)
    else:
        with pytest.raises(ValueError):
            AppConfig(host="localhost", port=port)
```

### pyproject.toml tool config (new projects)
```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "myproject"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "click>=8.1.0",
    "pydantic>=2.5.0",
    "pydantic-settings>=2.1.0",
    "sqlalchemy[asyncio]>=2.0.0",
    "alembic>=1.13.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-asyncio>=0.23.0",
    "pytest-cov>=4.1.0",
    "mypy>=1.7.0",
    "black>=23.11.0",
    "ruff>=0.1.6",
    "httpx>=0.25.0",
]

[project.scripts]
myproject = "myproject.cli:app"

[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

Clean `.venv/bin/mypy --strict` output looks like:
```
Success: no issues found in 12 source files
```
Any reported error (e.g., `error: Function is missing a return type annotation`) must be resolved before the implementation is considered complete.

## FastAPI Code Examples

### Pydantic V2 Schemas + FastAPI Endpoint
```python
from pydantic import BaseModel, EmailStr, field_validator, model_config

class UserCreate(BaseModel):
    model_config = model_config(str_strip_whitespace=True)

    email: EmailStr
    password: str
    name: str | None = None

    @field_validator("password")
    @classmethod
    def password_strength(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Password must be at least 8 characters")
        return v

class UserResponse(BaseModel):
    model_config = model_config(from_attributes=True)

    id: int
    email: EmailStr
    name: str | None = None
```

```python
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from typing import Annotated

from app.database import get_db
from app.schemas import UserCreate, UserResponse
from app import crud

router = APIRouter(prefix="/users", tags=["users"])

DbDep = Annotated[AsyncSession, Depends(get_db)]

@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(payload: UserCreate, db: DbDep) -> UserResponse:
    existing = await crud.get_user_by_email(db, payload.email)
    if existing:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Email already registered")
    return await crud.create_user(db, payload)
```

### Async SQLAlchemy CRUD
```python
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.models import User
from app.schemas import UserCreate
from app.security import hash_password

async def get_user_by_email(db: AsyncSession, email: str) -> User | None:
    result = await db.execute(select(User).where(User.email == email))
    return result.scalar_one_or_none()

async def create_user(db: AsyncSession, payload: UserCreate) -> User:
    user = User(email=payload.email, hashed_password=hash_password(payload.password), name=payload.name)
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user
```

### JWT Authentication
```python
from datetime import datetime, timedelta, timezone
from jose import JWTError, jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from typing import Annotated

SECRET_KEY = "read-from-env"
ALGORITHM = "HS256"
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/token")

def create_access_token(subject: str, expires_delta: timedelta = timedelta(minutes=30)) -> str:
    payload = {"sub": subject, "exp": datetime.now(timezone.utc) + expires_delta}
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]) -> str:
    try:
        data = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        subject: str | None = data.get("sub")
        if subject is None:
            raise ValueError
        return subject
    except (JWTError, ValueError):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

CurrentUser = Annotated[str, Depends(get_current_user)]
```

## Output Templates

When implementing Python features, provide:
1. Module file with complete type hints
2. Test file with pytest fixtures
3. Type checking confirmation (mypy --strict passes)
4. Brief explanation of Pythonic patterns used

## Knowledge Reference

Python 3.11+, typing module, mypy, pytest, black, ruff, dataclasses, async/await, asyncio, pathlib, functools, itertools, Pydantic, contextlib, collections.abc, Protocol, FastAPI, Pydantic V2, async SQLAlchemy, Alembic migrations, JWT/OAuth2, pytest-asyncio, httpx, BackgroundTasks, WebSockets, dependency injection, OpenAPI/Swagger, click, pydantic-settings, hatchling
