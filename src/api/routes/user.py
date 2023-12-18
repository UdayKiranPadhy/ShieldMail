from logging import Logger
from typing import Annotated

from fastapi import APIRouter

from src.api.dependencies import container

router = APIRouter(prefix="/user")


@router.get("/")
async def read_root(
    logger: Annotated[Logger, container.depends(Logger)],
) -> dict[str, str]:
    logger.info("From Singleton Logger")
    return {"message": "Hello World"}
