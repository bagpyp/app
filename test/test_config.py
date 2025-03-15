from src.config import DB_PORT


def test_db_port_overwritten_during_tests():
    assert DB_PORT == "5431"
