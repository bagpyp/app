from fastapi import APIRouter, Depends, Response
from sqlalchemy.orm import Session

from src.data.main import get_db

root_router = APIRouter(
    prefix="",
)


@root_router.get("/health")
def health_check(_: Session = Depends(get_db)):
    """
    Will only return OK is the app is running and
    connected to the database.
    """
    return Response(status_code=200)
