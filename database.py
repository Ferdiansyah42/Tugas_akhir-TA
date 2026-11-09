"""
Database module untuk FuzzyBroiler IP menggunakan SQLite lokal.
Mendukung penyimpanan offline riwayat evaluasi kandang dan deteksi tren.
"""

import sqlite3
import os
import json
from datetime import datetime, timedelta
from typing import List, Dict, Optional, Any

DB_PATH = os.path.join(os.path.dirname(__file__), "fuzzy_broiler.db")


def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS evaluations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        flock_name TEXT NOT NULL DEFAULT 'Kandang Blok A',
        created_at TEXT NOT NULL,
        age INTEGER NOT NULL,
        temperature REAL NOT NULL,
        humidity REAL NOT NULL,
        target_temp REAL NOT NULL,
        temp_dev REAL NOT NULL,
        score_mamdani REAL NOT NULL,
        score_sugeno REAL NOT NULL,
        category TEXT NOT NULL,
        condition_title TEXT NOT NULL,
        recommendation_summary TEXT NOT NULL,
        recommendation_details TEXT NOT NULL,
        warning_flag INTEGER DEFAULT 0,
        warning_message TEXT,
        synced INTEGER DEFAULT 0
    );
    """)

    # Seed data awal jika tabel masih kosong
    cursor.execute("SELECT COUNT(*) FROM evaluations")
    count = cursor.fetchone()[0]
    if count == 0:
        now = datetime.now()
        seed_data = [
            (
                "Kandang Blok A",
                (now - timedelta(days=2)).strftime("%Y-%m-%d 08:30:00"),
                19,
                27.2,
                65.0,
                27.0,
                0.2,
                89.5,
                88.0,
                "Tinggi",
                "KONDISI BAIK SEKALI",
                "Kondisi kandang saat ini sangat baik dan optimal. Pertahankan timer sirkulasi ventilasi minimum.",
                json.dumps([
                    {"icon": "check_circle", "title": "Ventilasi Minimum", "action": "Jalankan siklus ventilasi minimum berkala."},
                    {"icon": "inventory_2", "title": "Pemeriksaan Sekam", "action": "Pastikan sekam tetap kering dan bebas amonia."}
                ]),
                0,
                None,
                0
            ),
            (
                "Kandang Blok A",
                (now - timedelta(days=1)).strftime("%Y-%m-%d 08:30:00"),
                20,
                28.0,
                66.5,
                27.0,
                1.0,
                87.2,
                85.0,
                "Tinggi",
                "KONDISI BAIK SEKALI",
                "Buka tirai samping sedikit (sekitar 20%) agar sirkulasi udara tetap segar.",
                json.dumps([
                    {"icon": "curtains", "title": "Tirai Samping", "action": "Buka tirai sedikit untuk memperlancar sirkulasi udara."},
                    {"icon": "mode_fan", "title": "Blower Fan", "action": "Pastikan kipas blower aktif pada kecepatan normal."}
                ]),
                0,
                None,
                0
            ),
            (
                "Kandang Blok A",
                now.strftime("%Y-%m-%d 08:30:00"),
                21,
                28.8,
                68.0,
                27.0,
                1.8,
                86.0,
                84.5,
                "Tinggi",
                "KONDISI BAIK SEKALI",
                "Buka tirai samping sedikit (sekitar 30%) & nyalakan Kipas Blower nomor 2 agar hawa panas keluar dan ayam tidak gerah.",
                json.dumps([
                    {"icon": "mode_fan", "title": "Pengaturan Kipas / Blower", "action": "Nyalakan blower exhaust fan nomor 2 untuk melancarkan sirkulasi angin (wind chill) di atas ayam."},
                    {"icon": "curtains", "title": "Bukaan Tirai Samping", "action": "Buka tirai samping sedikit (sekitar 30%) agar hawa panas tidak terperangkap di dalam kandang."},
                    {"icon": "water_drop", "title": "Ketersediaan Air Minum", "action": "Pastikan aliran air minum lancar dan segar untuk membantu ayam mendinginkan tubuh."}
                ]),
                1,
                "Suhu agak sedikit naik dalam 2 hari ini. Yuk cek ventilasi dan sirkulasi angin agar ayam tetap nyaman.",
                0
            ),
        ]

        cursor.executemany("""
        INSERT INTO evaluations (
            flock_name, created_at, age, temperature, humidity,
            target_temp, temp_dev, score_mamdani, score_sugeno,
            category, condition_title, recommendation_summary,
            recommendation_details, warning_flag, warning_message, synced
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, seed_data)

    conn.commit()
    conn.close()


def insert_evaluation(eval_dict: Dict[str, Any]) -> int:
    conn = get_db_connection()
    cursor = conn.cursor()

    details_json = json.dumps(eval_dict.get("recommendation_details", []))
    created_at = eval_dict.get("created_at") or datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    cursor.execute("""
    INSERT INTO evaluations (
        flock_name, created_at, age, temperature, humidity,
        target_temp, temp_dev, score_mamdani, score_sugeno,
        category, condition_title, recommendation_summary,
        recommendation_details, warning_flag, warning_message, synced
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (
        eval_dict.get("flock_name", "Kandang Blok A"),
        created_at,
        eval_dict["age"],
        eval_dict["temperature"],
        eval_dict["humidity"],
        eval_dict["target_temp"],
        eval_dict["temp_deviation"],
        eval_dict["score_mamdani"],
        eval_dict["score_sugeno"],
        eval_dict["category"],
        eval_dict["condition_title"],
        eval_dict["recommendation_summary"],
        details_json,
        1 if eval_dict.get("warning_flag") else 0,
        eval_dict.get("warning_message"),
        0
    ))

    inserted_id = cursor.lastrowid
    conn.commit()
    conn.close()
    return inserted_id


def get_latest_evaluation() -> Optional[Dict[str, Any]]:
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM evaluations ORDER BY id DESC LIMIT 1")
    row = cursor.fetchone()
    conn.close()
    if row:
        d = dict(row)
        try:
            d["recommendation_details"] = json.loads(d["recommendation_details"])
        except Exception:
            d["recommendation_details"] = []
        return d
    return None


def get_all_evaluations(limit: int = 50) -> List[Dict[str, Any]]:
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM evaluations ORDER BY id DESC LIMIT ?", (limit,))
    rows = cursor.fetchall()
    conn.close()

    result = []
    for r in rows:
        d = dict(r)
        try:
            d["recommendation_details"] = json.loads(d["recommendation_details"])
        except Exception:
            d["recommendation_details"] = []
        result.append(d)
    return result


def get_recent_scores(limit: int = 5) -> List[float]:
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT score_mamdani FROM evaluations ORDER BY id DESC LIMIT ?", (limit,))
    rows = cursor.fetchall()
    conn.close()
    scores = [r["score_mamdani"] for r in rows]
    scores.reverse()  # Urutan kronologis lama ke baru
    return scores


if __name__ == "__main__":
    init_db()
    latest = get_latest_evaluation()
    print("Database terinisialisasi. Data evaluasi terbaru:", latest["flock_name"], latest["age"], "hari, skor:", latest["score_mamdani"])
