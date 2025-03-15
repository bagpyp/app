from src.data.models import User


def test_get_db(test_db):
    user = User(name="test", email="test@test.test")
    test_db.add(user)
    test_db.commit()

    queried_user = test_db.query(User).first()

    assert queried_user.name == "test"
    assert queried_user.email == "test@test.test"
