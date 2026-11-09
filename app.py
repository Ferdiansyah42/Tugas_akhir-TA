"""
Aplikasi Web FuzzyBroiler IP (Python Flask)
Sistem Pendukung Keputusan Penilai Potensi Indeks Performa Ayam Broiler
Berdasarkan Suhu, Kelembaban, dan Umur Adaptif Menggunakan Fuzzy Mamdani & Sugeno.
"""

from flask import Flask, render_template, request, jsonify
import os
from fuzzy_engine import FuzzyBroilerEngine
from database import init_db, insert_evaluation, get_latest_evaluation, get_all_evaluations, get_recent_scores

app = Flask(__name__)
app.config["SECRET_KEY"] = "fuzzy-broiler-secret-key-2026"

# Inisialisasi Database dan Mesin Fuzzy
init_db()
engine = FuzzyBroilerEngine()


@app.route("/")
def index():
    """Halaman Utama (Menampilkan 5 tab terintegrasi sesuai blueprint & mockup)."""
    latest = get_latest_evaluation()
    history = get_all_evaluations(limit=30)
    return render_template("index.html", latest=latest, history=history)


@app.route("/api/evaluate", methods=["POST"])
def api_evaluate():
    """Endpoint API untuk memproses evaluasi fuzzy secara interaktif."""
    try:
        data = request.get_json() or {}
        age = int(data.get("age", 21))
        temperature = float(data.get("temperature", 28.8))
        humidity = float(data.get("humidity", 68.0))

        # Ambil tren skor sebelumnya untuk deteksi early warning (3 hari)
        recent_scores = get_recent_scores(limit=3)

        # Jalankan inferensi fuzzy adaptif (Mamdani & Sugeno)
        result = engine.evaluate(
            age=age,
            temperature=temperature,
            humidity=humidity,
            previous_scores=recent_scores,
        )

        # Simpan hasil evaluasi ke SQLite lokal
        eval_dict = {
            "flock_name": "Kandang Blok A",
            "age": result.age,
            "temperature": result.temperature,
            "humidity": result.humidity,
            "target_temp": result.target_temp,
            "temp_deviation": result.temp_deviation,
            "score_mamdani": result.score_mamdani,
            "score_sugeno": result.score_sugeno,
            "category": result.category,
            "condition_title": result.condition_title,
            "recommendation_summary": result.recommendation_summary,
            "recommendation_details": result.recommendation_details,
            "warning_flag": result.warning_flag,
            "warning_message": result.warning_message,
        }

        inserted_id = insert_evaluation(eval_dict)

        return jsonify({
            "status": "success",
            "message": "Evaluasi fuzzy berhasil diproses",
            "id": inserted_id,
            "data": {
                "age": result.age,
                "temperature": result.temperature,
                "humidity": result.humidity,
                "target_temp": result.target_temp,
                "temp_deviation": result.temp_deviation,
                "age_phase": result.age_phase,
                "temp_status": result.temp_status,
                "humidity_status": result.humidity_status,
                "score_mamdani": result.score_mamdani,
                "score_sugeno": result.score_sugeno,
                "category": result.category,
                "condition_title": result.condition_title,
                "condition_subtitle": result.condition_subtitle,
                "prediction_desc": result.prediction_desc,
                "recommendation_summary": result.recommendation_summary,
                "recommendation_priority": result.recommendation_priority,
                "recommendation_details": result.recommendation_details,
                "warning_flag": result.warning_flag,
                "warning_message": result.warning_message,
            }
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400


@app.route("/api/history", methods=["GET"])
def api_history():
    """Endpoint API untuk mengambil seluruh riwayat evaluasi dari SQLite."""
    history = get_all_evaluations(limit=50)
    return jsonify({
        "status": "success",
        "total": len(history),
        "data": history
    })


if __name__ == "__main__":
    print("=" * 60)
    print("FuzzyBroiler IP - Aplikasi SPK Fuzzy Broiler Berjalan (Python Flask)")
    print("Buka browser di: http://127.0.0.1:5000")
    print("=" * 60)
    app.run(host="127.0.0.1", port=5000, debug=True)
