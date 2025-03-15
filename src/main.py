import os
from contextlib import asynccontextmanager

from alembic import command
from alembic.config import Config
from fastapi import FastAPI

from src.api.main import root_router
from src.config import root_dir


@asynccontextmanager
async def lifespan(app_: FastAPI):
    print("App starting up.")
    # Run db migrations on each startup
    try:
        alembic_cfg = Config(os.path.join(root_dir, "alembic.ini"))
        alembic_cfg.set_main_option(
            "script_location", os.path.join(root_dir, "src", "data", "alembic")
        )
        command.upgrade(alembic_cfg, "head")
    except Exception as e:
        raise e
    yield
    print("App shutting down.")


app = FastAPI(lifespan=lifespan)
app.include_router(root_router)
