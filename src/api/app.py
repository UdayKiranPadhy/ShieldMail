from fastapi import FastAPI

from src.api.routes import user

app = FastAPI(title="ShieldMail API")
app.openapi_version = "1.0.0"

app.include_router(user.router)
