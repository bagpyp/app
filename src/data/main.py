from contextlib import contextmanager

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from src.config import DB_URL

engine = create_engine(DB_URL, echo=True, future=True)
SessionLocal = sessionmaker(bind=engine)


@contextmanager
def create_session():
    """
    context manager for accessing database, as in
    with create_session() as db:
        users = db.query(User).all()
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_db():
    """
    generator clone of the above, only used by FastAPI
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
