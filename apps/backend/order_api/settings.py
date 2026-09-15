from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_name: str = "order-api"
    build_id: str = "local"
    database_url: str = ""
    otel_exporter_otlp_endpoint: str = ""
    otel_service_name: str = "order-api"


settings = Settings()
