"""Minimal order API for Kubernetes delivery lab."""

from __future__ import annotations

import os
from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI(title="Order Service", version="1.0.0")
BUILD_ID = os.getenv("BUILD_ID", "local")


class Order(BaseModel):
    sku: str = Field(min_length=1)
    quantity: int = Field(ge=1)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "build": BUILD_ID}


@app.post("/orders", status_code=201)
def create_order(order: Order) -> dict[str, object]:
    return {"sku": order.sku, "quantity": order.quantity, "status": "accepted"}
