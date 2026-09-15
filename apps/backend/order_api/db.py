from __future__ import annotations

import psycopg

from order_api.settings import settings


def ping_database() -> bool:
    if not settings.database_url:
        return False
    try:
        with psycopg.connect(settings.database_url, connect_timeout=3) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1")
                return cur.fetchone() == (1,)
    except Exception:
        return False
