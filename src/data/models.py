from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import declarative_base, sessionmaker

from src.config import DB_URL

Base = declarative_base()
engine = create_engine(DB_URL, echo=True, future=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)


def get_db():
    """
    context manager for accessing database, as in

    with get_db() as db:
        users = db.query(User).all()
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
