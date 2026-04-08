# Pydantic V2 Schemas

## Schema Patterns

```python
from pydantic import BaseModel, EmailStr, Field, field_validator, model_validator
from typing import Self

class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8)
    username: str = Field(min_length=3, max_length=50)
    age: int = Field(ge=18, le=120)

    @field_validator('password')
    @classmethod
    def validate_password(cls, v: str) -> str:
        if not any(c.isupper() for c in v):
            raise ValueError('Password must contain uppercase')
        if not any(c.isdigit() for c in v):
            raise ValueError('Password must contain digit')
        return v

    @field_validator('username')
    @classmethod
    def validate_username(cls, v: str) -> str:
        if not v.isalnum():
            raise ValueError('Username must be alphanumeric')
        return v.lower()

class UserUpdate(BaseModel):
    email: EmailStr | None = None
    username: str | None = Field(None, min_length=3, max_length=50)
```

## ORM Mode (from_attributes)

```python
class UserResponse(BaseModel):
    model_config = {"from_attributes": True}

    id: int
    email: EmailStr
    username: str
    is_active: bool = True
    created_at: datetime

# Usage with SQLAlchemy model
user_response = UserResponse.model_validate(db_user)
```

## Model Validator

```python
class OrderCreate(BaseModel):
    items: list[OrderItem]
    discount_code: str | None = None
    total: float

    @model_validator(mode='after')
    def validate_order(self) -> Self:
        calculated = sum(item.price * item.quantity for item in self.items)
        if abs(self.total - calculated) > 0.01:
            raise ValueError('Total does not match items')
        return self
```

## Nested Models

```python
class Address(BaseModel):
    street: str
    city: str
    country: str = Field(default="US")

class UserWithAddress(BaseModel):
    name: str
    addresses: list[Address] = Field(default_factory=list)
```

## Serialization Control

```python
class User(BaseModel):
    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {"email": "user@example.com", "username": "johndoe"}
        }
    }

    id: int
    email: EmailStr
    password: str = Field(exclude=True)  # Never serialize
    internal_id: str = Field(repr=False)  # Hide from repr

# Serialize with aliases
class ApiResponse(BaseModel):
    model_config = {"populate_by_name": True}

    user_id: int = Field(alias="userId", serialization_alias="user_id")
```

## Settings with pydantic-settings (New Projects)

Use `pydantic-settings` as the single source of truth for configuration — environment variables, `.env` files, and defaults all in one place.

```python
from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        env_prefix="MYAPP_",
    )

    # App
    debug: bool = False
    host: str = "0.0.0.0"
    port: int = Field(default=8000, ge=1, le=65535)
    allowed_origins: list[str] = Field(default_factory=lambda: ["http://localhost:3000"])

    # Database
    database_url: str = "sqlite+aiosqlite:///./dev.db"

    # Auth
    secret_key: str
    access_token_expire_minutes: int = 30

    @field_validator("database_url")
    @classmethod
    def validate_database_url(cls, v: str) -> str:
        if not v.startswith(("postgresql+asyncpg://", "sqlite+aiosqlite://")):
            raise ValueError("Must use async database driver")
        return v

settings = Settings()
```

### Usage patterns

```python
# .env file
# MYAPP_DEBUG=true
# MYAPP_DATABASE_URL=postgresql+asyncpg://user:pass@localhost/mydb
# MYAPP_SECRET_KEY=super-secret

# Override via environment (e.g. in CI/CD or docker-compose)
# MYAPP_PORT=9000

# Access anywhere
from myproject.config import settings

engine = create_async_engine(settings.database_url)
```

### Integration with Click CLI

```python
import click
from myproject.config import Settings

@click.group()
@click.option("--debug/--no-debug", default=None)
@click.pass_context
def app(ctx: click.Context, debug: bool | None) -> None:
    """MyApp CLI."""
    overrides = {}
    if debug is not None:
        overrides["debug"] = debug
    ctx.obj = Settings(**overrides)

@app.command()
@click.pass_obj
def serve(settings: Settings) -> None:
    """Start the server."""
    click.echo(f"Serving on {settings.host}:{settings.port}")
```

### Quick Reference

| V1 Syntax | V2 Syntax |
|-----------|-----------|
| `@validator` | `@field_validator` |
| `@root_validator` | `@model_validator` |
| `class Config` | `model_config = {}` |
| `orm_mode = True` | `from_attributes = True` |
| `Optional[X]` | `X \| None` |
| `.dict()` | `.model_dump()` |
| `.parse_obj()` | `.model_validate()` |
