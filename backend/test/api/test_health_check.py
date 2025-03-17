def test_health_check(test_client):
    response = test_client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "up"}
