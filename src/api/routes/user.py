from fastapi import APIRouter

router = APIRouter(prefix="/user")


@router.get("/")
def read_root():
    return {"message": "Hello World"}
