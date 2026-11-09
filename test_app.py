"""
Unit Test untuk memvalidasi Flask routes dan API FuzzyBroiler IP.
"""

from app import app
import json

client = app.test_client()

def test_index_route():
    response = client.get("/")
    assert response.status_code == 200
    assert b"FuzzyBroiler IP" in response.data
    assert b"Kandang Blok A" in response.data
    print("[PASS] Index route OK")

def test_api_evaluate():
    payload = {
        "age": 21,
        "temperature": 28.8,
        "humidity": 68.0
    }
    response = client.post("/api/evaluate", 
                           data=json.dumps(payload),
                           content_type="application/json")
    assert response.status_code == 200
    data = response.get_json()
    assert data["status"] == "success"
    assert "score_mamdani" in data["data"]
    assert "score_sugeno" in data["data"]
    print(f"[PASS] API Evaluate OK (Mamdani: {data['data']['score_mamdani']}, Sugeno: {data['data']['score_sugeno']})")

def test_api_history():
    response = client.get("/api/history")
    assert response.status_code == 200
    data = response.get_json()
    assert data["status"] == "success"
    assert len(data["data"]) > 0
    print(f"[PASS] API History OK (Total records: {data['total']})")

if __name__ == "__main__":
    test_index_route()
    test_api_evaluate()
    test_api_history()
    print("ALL TESTS PASSED SUCCESSFULLY!")

