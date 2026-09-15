from fastapi.testclient import TestClient

from order_api.main import app

client = TestClient(app)


def test_health() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "ok"
    assert "build" in body


def test_ready_without_database() -> None:
    response = client.get("/ready")
    assert response.status_code == 200
    assert response.json()["status"] == "ready"


def test_create_order() -> None:
    response = client.post("/orders", json={"sku": "SKU-1", "quantity": 2})
    assert response.status_code == 201
    assert response.json()["status"] == "accepted"
