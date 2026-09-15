from __future__ import annotations

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

from order_api.db import ping_database
from order_api.settings import settings

app = FastAPI(title="Order API", version="2.0.0")


class Order(BaseModel):
    sku: str = Field(min_length=1)
    quantity: int = Field(ge=1)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "build": settings.build_id, "service": settings.app_name}


@app.get("/ready")
def ready() -> dict[str, str]:
    if settings.database_url and not ping_database():
        raise HTTPException(status_code=503, detail="database unavailable")
    return {"status": "ready", "database": "ok" if settings.database_url else "skipped"}


@app.post("/orders", status_code=201)
def create_order(order: Order) -> dict[str, object]:
    return {
        "sku": order.sku,
        "quantity": order.quantity,
        "status": "accepted",
        "build": settings.build_id,
    }
