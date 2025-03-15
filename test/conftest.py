from typing import Any, Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from src.config import DB_URL
from src.data.main import get_db
from src.data.models import Base
from src.main import app

# PORT has been overwritten by test/__init__.py and src/config.py
test_engine = create_engine(DB_URL)
TestSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=test_engine)


@pytest.fixture(scope="function")
def test_db() -> Generator[Session, Any, None]:
    """Fixture to tear down and set the test database back up"""
    # Delete all data from previously ran tests
    Base.metadata.drop_all(bind=test_engine)
    # Create the tables directly from the ORM classes in models.py
    Base.metadata.create_all(bind=test_engine)
    db = TestSessionLocal()
    try:
        yield db
    finally:
        db.close()


@pytest.fixture(scope="function")
def test_client(test_db: Session):
    # Override the non-test db accessor with the test fixture
    app.dependency_overrides[get_db] = lambda: test_db
    client = TestClient(app)
    yield client
    # Reset the overrides on tear down
    app.dependency_overrides = {}
