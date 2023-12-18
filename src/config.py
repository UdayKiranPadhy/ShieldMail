from pydantic import Field, BaseModel
from pydantic_settings import BaseSettings, SettingsConfigDict


class LoggingConfig(BaseSettings):
    access_token: str
    model_config = SettingsConfigDict(env_file=".env", env_prefix="LOGGING_")


class Config(BaseModel):
    """
    Loads application config from the environment using pydantic.BaseSettings, split up
    into different "modules" with different environment variable prefixes.
    """

    logging: LoggingConfig = Field(default_factory=lambda: LoggingConfig())


_config: Config | None = None


class ConfigProvider:
    @classmethod
    def get_config(cls) -> Config:
        global _config
        if _config is None:
            _config = Config()
        return _config


class FakeConfigProvider:
    @classmethod
    def get_config(cls) -> Config:
        logging = LoggingConfig(access_token="fake_token")

        return Config(logging=logging)
