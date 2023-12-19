from logging import Logger
from typing import Annotated

from fastapi import APIRouter, Query

from src.api.dependencies import container
from src.models.oauth import AuthCode

router = APIRouter(prefix="/callback")


@router.get("/google-oauth2")
async def read_root(
    auth_code: Annotated[AuthCode, Query(alias="code")],
    logger: Annotated[Logger, container.depends(Logger)],
    state: Annotated[str | None, Query(alias="state")] = None,
) -> None:
    pass
