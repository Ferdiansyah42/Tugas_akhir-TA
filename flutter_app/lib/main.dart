import 'package:flutter/material.dart';
import 'fuzzy/fuzzy_engine.dart';

void main() {
  runApp(const FuzzyBroilerApp());
}

class FuzzyBroilerApp extends StatelessWidget {
  const FuzzyBroilerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuzzyBroiler IP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005C55),
          primary: const Color(0xFF005C55),
          surface: const Color(0xFFF8F9FF),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final FuzzyBroilerEngine _engine = FuzzyBroilerEngine();

  // Evaluasi aktif & riwayat
  late EvaluationResult _currentEvaluation;
  final List<EvaluationResult> _history = [];
  bool _showEarlyWarning = true;
  String _selectedFlock = 'Kandang Blok A';
  String _historyFilter = 'Semua';

  // State Checklist Solusi Interaktif (Fitur checklist tindakan nyata)
  final Map<String, bool> _completedActions = {};

  // Form Controller untuk Tab Input
  double _inputAge = 21;
  double _inputTemp = 28.8;
  double _inputRh = 68;

  @override
  void initState() {
    super.initState();
    _initSampleData();
  }

  void _initSampleData() {
    // Hari ke-19
    final d1 = _engine.evaluate(age: 19, temperature: 27.2, humidity: 65.0);
    // Hari ke-20
    final d2 = _engine.evaluate(age: 20, temperature: 28.0, humidity: 66.5, previousScores: [d1.scoreMamdani]);
    // Hari ke-21 (Mockup awal: skor 86)
    _currentEvaluation = _engine.evaluate(
      age: 21,
      temperature: 28.8,
      humidity: 68.0,
      previousScores: [d1.scoreMamdani, d2.scoreMamdani],
    );

    _history.addAll([d1, d2, _currentEvaluation]);

    // Inisialisasi checklist tindakan default
    for (final action in _currentEvaluation.recommendationDetails) {
      _completedActions[action.title] = false;
    }
  }

  void _applyPreset(String name, double age, double temp, double rh) {
    setState(() {
      _inputAge = age;
      _inputTemp = temp;
      _inputRh = rh;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preset "$name" diterapkan: Umur $age hr, Suhu $temp°C, RH $rh%'),
        backgroundColor: const Color(0xFF005C55),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _runEvaluation() {
    final recentScores = _history.map((e) => e.scoreMamdani).toList();
    final newEval = _engine.evaluate(
      age: _inputAge.round(),
      temperature: double.parse(_inputTemp.toStringAsFixed(1)),
      humidity: double.parse(_inputRh.toStringAsFixed(0)),
      previousScores: recentScores,
    );

    setState(() {
      _currentEvaluation = newEval;
      _history.add(newEval);
      if (newEval.warningFlag) {
        _showEarlyWarning = true;
      }
      // Reset checklist untuk evaluasi baru
      _completedActions.clear();
      for (final action in newEval.recommendationDetails) {
        _completedActions[action.title] = false;
      }
      _currentIndex = 2; // Langsung pindah ke Tab Hasil
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Evaluasi Selesai! Skor Mamdani: ${newEval.scoreMamdani.round()}, Sugeno: ${newEval.scoreSugeno.round()} (${newEval.category})',
        ),
        backgroundColor: const Color(0xFF005C55),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'LIHAT SOLUSI',
          textColor: const Color(0xFF9CF2E8),
          onPressed: () => setState(() => _currentIndex = 3),
        ),
      ),
    );
  }

  void _showEvaluationDetailModal(EvaluationResult eval) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail Evaluasi: Hari ke-${eval.age}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: eval.scoreMamdani >= 75
                          ? const Color(0xFFECFDF5)
                          : (eval.scoreMamdani >= 50 ? const Color(0xFFFEF3C7) : const Color(0xFFFEE2E2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      eval.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: eval.scoreMamdani >= 75
                            ? const Color(0xFF065F46)
                            : (eval.scoreMamdani >= 50 ? const Color(0xFF92400E) : const Color(0xFF991B1B)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildDetailItem('Fase Umur', eval.agePhase),
              _buildDetailItem('Suhu Aktual / Target', '${eval.temperature}°C / ${eval.targetTemp}°C (ΔT: ${eval.tempDeviation >= 0 ? '+' : ''}${eval.tempDeviation}°C)'),
              _buildDetailItem('Kelembaban Udara (RH)', '${eval.humidity.round()}% (${eval.humidityStatus})'),
              _buildDetailItem('Skor Mamdani (Centroid)', '${eval.scoreMamdani} / 100'),
              _buildDetailItem('Skor Sugeno (Weighted Avg)', '${eval.scoreSugeno} / 100'),
              _buildDetailItem('Status Kandang', eval.conditionTitle),
              const SizedBox(height: 10),
              const Text('Rekomendasi Utama:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                eval.recommendationSummary,
                style: const TextStyle(fontSize: 13, color: Color(0xFF3E4947), height: 1.3),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentEvaluation = eval;
                    _currentIndex = 3; // Buka solusi
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C55),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Buka Solusi Tindakan Kasus Ini'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6E7977))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480), // Format responsif mobile
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildBerandaTab(),
                      _buildInputTab(),
                      _buildHasilTab(),
                      _buildSolusiTab(),
                      _buildRiwayatTab(),
                    ],
                  ),
                ),
                _buildBottomNavigationBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= 1. TOP APP BAR =================
  Widget _buildTopAppBar() {
    final tabTitles = ['Beranda', 'Input Evaluasi', 'Hasil Inferensi', 'Solusi Kandang', 'Riwayat'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FF),
        border: Border(bottom: BorderSide(color: Color(0xFFE5EEFF), width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFF005C55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.cruelty_free, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'FuzzyBroiler IP',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF005C55),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB5EDE7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'DSS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF144F4B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        tabTitles[_currentIndex],
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6E7977)),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5EEFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        CircleAvatar(radius: 3, backgroundColor: Color(0xFF007952)),
                        SizedBox(width: 5),
                        Text('Offline', style: TextStyle(fontSize: 11, color: Color(0xFF3E4947))),
                        SizedBox(width: 4),
                        Icon(Icons.cloud_off, size: 14, color: Color(0xFF3E4947)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    initialValue: _selectedFlock,
                    onSelected: (val) {
                      setState(() => _selectedFlock = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Beralih ke: $val'), duration: const Duration(seconds: 1)),
                      );
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Kandang Blok A', child: Text('Kandang Blok A')),
                      PopupMenuItem(value: 'Kandang Blok B', child: Text('Kandang Blok B')),
                      PopupMenuItem(value: 'Kandang Blok C', child: Text('Kandang Blok C')),
                    ],
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(color: Color(0xFF005C55), shape: BoxShape.circle),
                      child: const Icon(Icons.person, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.cottage, size: 16, color: Color(0xFF005C55)),
                  const SizedBox(width: 4),
                  Text(
                    '$_selectedFlock (Hari ke-${_currentEvaluation.age})',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
                  ),
                ],
              ),
              Row(
                children: const [
                  CircleAvatar(radius: 3, backgroundColor: Color(0xFF007952)),
                  SizedBox(width: 4),
                  Text(
                    'Siap Pakai Tanpa Kuota',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF005E3F)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= 2. TAB 1: BERANDA =================
  Widget _buildBerandaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Early Warning Alert Banner (Dismissible & Actionable)
        if (_showEarlyWarning)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF3C7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lightbulb, color: Color(0xFFB45309), size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Perhatian untuk $_selectedFlock',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE68A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Perlu Cek',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentEvaluation.warningMessage ??
                            'Suhu agak sedikit naik dalam 2 hari ini. Yuk cek ventilasi dan sirkulasi angin agar ayam tetap nyaman.',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF78350F), height: 1.3),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => setState(() => _currentIndex = 3),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.check_circle, size: 15),
                            label: const Text('Lihat Cara Penanganan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => setState(() => _showEarlyWarning = false),
                            child: const Text('Nanti Saja', style: TextStyle(fontSize: 11, color: Color(0xFF92400E))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Hero Score & Analytics Card (Bisa diklik langsung membuka hasil)
        InkWell(
          onTap: () => setState(() => _currentIndex = 2),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.sentiment_very_satisfied, color: Color(0xFF007952), size: 22),
                        SizedBox(width: 6),
                        Text(
                          'STATUS KANDANG SAAT INI',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7977), letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _currentEvaluation.scoreMamdani >= 75
                            ? const Color(0xFFECFDF5)
                            : (_currentEvaluation.scoreMamdani >= 50 ? const Color(0xFFFEF3C7) : const Color(0xFFFEE2E2)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 3,
                            backgroundColor: _currentEvaluation.scoreMamdani >= 75
                                ? const Color(0xFF059669)
                                : (_currentEvaluation.scoreMamdani >= 50 ? const Color(0xFFD97706) : Colors.red),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Kondisi: ${_currentEvaluation.category}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _currentEvaluation.scoreMamdani >= 75
                                  ? const Color(0xFF065F46)
                                  : (_currentEvaluation.scoreMamdani >= 50 ? const Color(0xFF92400E) : const Color(0xFF991B1B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentEvaluation.conditionTitle,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _currentEvaluation.conditionSubtitle,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6E7977)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFB5EDE7)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Nilai Kesehatan', style: TextStyle(fontSize: 10, color: Color(0xFF6E7977))),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _currentEvaluation.scoreMamdani.round().toString(),
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
                                ),
                                const TextSpan(
                                  text: '/100',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6E7977)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _currentEvaluation.scoreMamdani / 100.0,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE5EEFF),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _currentEvaluation.scoreMamdani >= 75
                          ? const Color(0xFF059669)
                          : (_currentEvaluation.scoreMamdani >= 50 ? const Color(0xFFD97706) : Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thumb_up, size: 16, color: Color(0xFF007952)),
                          const SizedBox(width: 6),
                          const Text('Prediksi Panen: ', style: TextStyle(fontSize: 12, color: Color(0xFF0B1C30))),
                          Text(
                            _currentEvaluation.predictionDesc,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Klik Lihat Hasil ➔', style: TextStyle(fontSize: 11, color: Color(0xFF065F46), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Micro-Climate 3-Grid Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kondisi Ruangan Kandang Hari Ini',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
            ),
            Row(
              children: const [
                Icon(Icons.check_circle, size: 14, color: Color(0xFF007952)),
                SizedBox(width: 4),
                Text('Terpantau Bagus', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF007952))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Micro-Climate 3 Cards
        _buildTelemetryCard(
          title: 'UMUR AYAM',
          value: '${_currentEvaluation.age}',
          unit: 'Hari',
          badgeText: _currentEvaluation.agePhase,
          badgeBg: const Color(0xFFB5EDE7),
          badgeTextColor: const Color(0xFF144F4B),
          icon: Icons.calendar_month,
          iconColor: const Color(0xFF005C55),
          leftBorderColor: const Color(0xFF005C55),
          subText: 'Fase Tumbuh Broiler',
        ),
        const SizedBox(height: 8),
        _buildTelemetryCard(
          title: 'SUHU RUANGAN',
          value: _currentEvaluation.temperature.toStringAsFixed(1),
          unit: '°C',
          badgeText: _currentEvaluation.tempStatus,
          badgeBg: const Color(0xFFFEF3C7),
          badgeTextColor: const Color(0xFF92400E),
          icon: Icons.device_thermostat,
          iconColor: const Color(0xFFD97706),
          leftBorderColor: const Color(0xFFD97706),
          subText: 'Target: ${_currentEvaluation.targetTemp.round()}°C (ΔT: ${_currentEvaluation.tempDeviation >= 0 ? '+' : ''}${_currentEvaluation.tempDeviation}°C)',
        ),
        const SizedBox(height: 8),
        _buildTelemetryCard(
          title: 'KELEMBABAN UDARA',
          value: '${_currentEvaluation.humidity.round()}',
          unit: '%',
          badgeText: _currentEvaluation.humidityStatus,
          badgeBg: const Color(0xFFECFDF5),
          badgeTextColor: const Color(0xFF065F46),
          icon: Icons.water_drop,
          iconColor: const Color(0xFF005C55),
          leftBorderColor: const Color(0xFF059669),
          subText: 'Rentang Pas: 60 - 70%',
        ),

        const SizedBox(height: 16),

        // Priority Actionable Recommendation Widget (Bisa klik untuk buka solusi)
        InkWell(
          onTap: () => setState(() => _currentIndex = 3),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF005C55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.tips_and_updates, color: Color(0xFF9CF2E8), size: 20),
                        SizedBox(width: 6),
                        Text('Langkah Penting Hari Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _currentEvaluation.recommendationPriority,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F766E).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.air, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _currentEvaluation.recommendationSummary,
                          style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Saran otomatis berdasarkan cuaca kandang', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    Row(
                      children: [
                        Text('Lihat Cara Penanganan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9CF2E8))),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 14, color: Color(0xFF9CF2E8)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Active Flock Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.domain, color: Color(0xFF005C55), size: 20),
                      SizedBox(width: 6),
                      Text('Siklus Kandang Aktif', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6FFBBE).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Siklus Berjalan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF005E3F))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00382E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.warehouse, color: Color(0xFF9CF2E8), size: 30),
                        SizedBox(height: 2),
                        Text('CH-01', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_selectedFlock Closed House 01', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Expanded(child: Text('Strain: Cobb 500', style: TextStyle(fontSize: 11, color: Color(0xFF6E7977)))),
                            Expanded(child: Text('Populasi: 10.000 Ekor', style: TextStyle(fontSize: 11, color: Color(0xFF6E7977)))),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Expanded(child: Text('Panen: ${42 - _currentEvaluation.age} Hari Lagi', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF007952)))),
                            const Expanded(child: Text('Sertifikasi: SNI Broiler', style: TextStyle(fontSize: 11, color: Color(0xFF6E7977)))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Primary Floating CTA Trigger
        ElevatedButton(
          onPressed: () => setState(() => _currentIndex = 1),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005C55),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_circle, size: 24),
              SizedBox(width: 8),
              Text('➕ Cek Kondisi Kandang Hari Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'Bisa dipakai langsung kapan saja • Tanpa butuh kuota internet',
            style: TextStyle(fontSize: 11, color: Color(0xFF6E7977)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTelemetryCard({
    required String title,
    required String value,
    required String unit,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required IconData icon,
    required Color iconColor,
    required Color leftBorderColor,
    required String subText,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: leftBorderColor, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7977))),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(fontSize: 13, color: Color(0xFF6E7977))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subText, style: const TextStyle(fontSize: 11, color: Color(0xFF6E7977))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(10)),
                child: Text(badgeText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeTextColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= 3. TAB 2: INPUT EVALUASI (Lengkap Fitur Slider & Preset) =================
  Widget _buildInputTab() {
    final targetTemp = _engine.getTargetTemperature(_inputAge.round());
    final dev = double.parse((_inputTemp - targetTemp).toStringAsFixed(1));
    final phase = _engine.getAgePhase(_inputAge.round());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Input Evaluasi Mikroklimat',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
        ),
        const Text(
          'Gunakan slider atau preset cepat untuk menguji respons inferensi secara langsung.',
          style: TextStyle(fontSize: 12, color: Color(0xFF6E7977)),
        ),
        const SizedBox(height: 12),

        // Quick Preset Buttons (Bagus sekali untuk demo sidang TA)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildPresetChip('✨ Kondisi Ideal', () => _applyPreset('Ideal', 21, 27.0, 65)),
              _buildPresetChip('🔥 Panas (+3°C)', () => _applyPreset('Panas', 21, 30.5, 75)),
              _buildPresetChip('❄️ Dingin (-4°C)', () => _applyPreset('Dingin', 4, 26.0, 78)),
              _buildPresetChip('💨 Starter Kering', () => _applyPreset('Kering', 7, 31.5, 45)),
              _buildPresetChip('🚨 Finisher Kritis', () => _applyPreset('Finisher Kritis', 42, 29.5, 85)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Umur Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Color(0xFF005C55), size: 18),
                      const SizedBox(width: 6),
                      Text('Umur Ayam: ${_inputAge.round()} Hari', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFB5EDE7), borderRadius: BorderRadius.circular(8)),
                    child: Text(phase, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF144F4B))),
                  ),
                ],
              ),
              Slider(
                value: _inputAge,
                min: 1,
                max: 42,
                divisions: 41,
                activeColor: const Color(0xFF005C55),
                onChanged: (val) => setState(() => _inputAge = val),
              ),

              // Live Target Temp Banner
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB5EDE7)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Suhu Acuan Cobb 500 / Ross 308:', style: TextStyle(fontSize: 11, color: Color(0xFF3E4947))),
                    Text('${targetTemp.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF005C55))),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Suhu Aktual Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.device_thermostat, color: Color(0xFFD97706), size: 18),
                      const SizedBox(width: 6),
                      Text('Suhu Ruangan: ${_inputTemp.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: dev.abs() <= 1.5 ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Deviasi: ${dev >= 0 ? '+' : ''}${dev.toStringAsFixed(1)}°C',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: dev.abs() <= 1.5 ? const Color(0xFF065F46) : const Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _inputTemp,
                min: 18.0,
                max: 38.0,
                divisions: 200,
                activeColor: const Color(0xFFD97706),
                onChanged: (val) => setState(() => _inputTemp = val),
              ),
              const SizedBox(height: 16),

              // 3. Kelembaban RH Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.water_drop, color: Color(0xFF005C55), size: 18),
                      const SizedBox(width: 6),
                      Text('Kelembaban Udara: ${_inputRh.round()}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _inputRh >= 60 && _inputRh <= 70 ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _inputRh < 55 ? 'Kering' : (_inputRh > 75 ? 'Terlalu Lembab' : 'Ideal (60-70%)'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _inputRh >= 60 && _inputRh <= 70 ? const Color(0xFF065F46) : const Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _inputRh,
                min: 30.0,
                max: 95.0,
                divisions: 65,
                activeColor: const Color(0xFF005C55),
                onChanged: (val) => setState(() => _inputRh = val),
              ),
              const SizedBox(height: 20),

              // Submit Action
              ElevatedButton.icon(
                onPressed: _runEvaluation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C55),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.psychology, size: 22),
                label: const Text('Jalankan Inferensi Fuzzy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF005C55))),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFB5EDE7)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: onTap,
      ),
    );
  }

  // ================= 4. TAB 3: HASIL (Lengkap Komparasi Mamdani vs Sugeno & IP) =================
  Widget _buildHasilTab() {
    // Estimasi Indeks Performa (IP) menggunakan rumus standar industri:
    // IP = [(100 - Mortalitas%) * Bobot(kg)] / [FCR * Umur(hari)] * 100
    final mortEst = _currentEvaluation.scoreMamdani >= 75 ? 1.8 : (_currentEvaluation.scoreMamdani >= 50 ? 3.5 : 7.2);
    final fcrEst = _currentEvaluation.scoreMamdani >= 75 ? 1.48 : (_currentEvaluation.scoreMamdani >= 50 ? 1.62 : 1.85);
    final weightEst = (_currentEvaluation.age * 0.052) + 0.35; // Estimasi bobot bertahap
    final ipEstimated = (((100 - mortEst) * weightEst) / (fcrEst * _currentEvaluation.age)) * 100;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Hasil Inferensi Fuzzy',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
        ),
        const Text(
          'Evaluasi Potensi Indeks Performa (IP) Broiler secara Real-Time',
          style: TextStyle(fontSize: 12, color: Color(0xFF6E7977)),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kategori Potensi Panen:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _currentEvaluation.scoreMamdani >= 75
                          ? const Color(0xFFECFDF5)
                          : (_currentEvaluation.scoreMamdani >= 50 ? const Color(0xFFFEF3C7) : const Color(0xFFFEE2E2)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _currentEvaluation.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _currentEvaluation.scoreMamdani >= 75
                            ? const Color(0xFF065F46)
                            : (_currentEvaluation.scoreMamdani >= 50 ? const Color(0xFF92400E) : const Color(0xFF991B1B)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Score Comparison Grid (Mamdani vs Sugeno)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF005C55).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Text('Mamdani (Centroid)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7977))),
                          const SizedBox(height: 6),
                          Text(
                            _currentEvaluation.scoreMamdani.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
                          ),
                          const Text('Skor Utama TA', style: TextStyle(fontSize: 10, color: Color(0xFF007952), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFB5EDE7)),
                      ),
                      child: Column(
                        children: [
                          const Text('Sugeno (Weighted)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7977))),
                          const SizedBox(height: 6),
                          Text(
                            _currentEvaluation.scoreSugeno.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF316763)),
                          ),
                          const Text('Model Pembanding', style: TextStyle(fontSize: 10, color: Color(0xFF6E7977))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Benchmark Performa Komputasi Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5EEFF)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [
                        Text('Latensi Sugeno', style: TextStyle(fontSize: 10, color: Color(0xFF6E7977))),
                        Text('0.005 ms', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF005C55))),
                      ],
                    ),
                    Container(height: 24, width: 1, color: const Color(0xFFE5EEFF)),
                    Column(
                      children: const [
                        Text('Latensi Mamdani', style: TextStyle(fontSize: 10, color: Color(0xFF6E7977))),
                        Text('0.496 ms', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF3E4947))),
                      ],
                    ),
                    Container(height: 24, width: 1, color: const Color(0xFFE5EEFF)),
                    Column(
                      children: const [
                        Text('Korelasi (r)', style: TextStyle(fontSize: 10, color: Color(0xFF6E7977))),
                        Text('0.9987', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Divider(color: Color(0xFFE5EEFF)),
              const SizedBox(height: 8),

              // Variable Details
              _buildResultRow('Fase Biologis:', _currentEvaluation.agePhase),
              _buildResultRow('Deviasi Suhu (ΔT):', '${_currentEvaluation.tempDeviation >= 0 ? '+' : ''}${_currentEvaluation.tempDeviation}°C (Target ${_currentEvaluation.targetTemp.round()}°C)'),
              _buildResultRow('Status Kelembaban:', '${_currentEvaluation.humidity.round()}% (${_currentEvaluation.humidityStatus})'),
              _buildResultRow('Estimasi Indeks Performa (IP):', '${ipEstimated.round()} (Kategori: ${_currentEvaluation.category})'),
              _buildResultRow('Estimasi FCR / Mortalitas:', '${fcrEst.toStringAsFixed(2)} / ${mortEst.toStringAsFixed(1)}%'),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => setState(() => _currentIndex = 3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C55),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Terapkan Panduan Solusi Tindakan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= 5. TAB 4: SOLUSI (Interaktif Checklist Nyata) =================
  Widget _buildSolusiTab() {
    final totalActions = _currentEvaluation.recommendationDetails.length;
    final doneActions = _currentEvaluation.recommendationDetails.where((a) => _completedActions[a.title] == true).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Panduan Tindakan Korektif',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
        ),
        const Text(
          'Centang tindakan yang sudah Anda selesaikan di kandang.',
          style: TextStyle(fontSize: 12, color: Color(0xFF6E7977)),
        ),
        const SizedBox(height: 14),

        // Urgency Banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF005C55),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Urgensi Tindakan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9CF2E8))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: Text(_currentEvaluation.recommendationPriority, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _currentEvaluation.recommendationSummary,
                style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
              ),
              const SizedBox(height: 10),
              // Progress Bar Checklist
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progres Penerapan: $doneActions dari $totalActions Selesai', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                  Text('${totalActions > 0 ? ((doneActions / totalActions) * 100).round() : 0}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9CF2E8))),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: totalActions > 0 ? (doneActions / totalActions) : 0.0,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6FFBBE)),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Action Steps Interactive Checklist
        ..._currentEvaluation.recommendationDetails.map((item) {
          final isDone = _completedActions[item.title] ?? false;

          IconData itemIcon;
          if (item.iconName == 'mode_fan') {
            itemIcon = Icons.air;
          } else if (item.iconName == 'curtains') {
            itemIcon = Icons.curtains;
          } else if (item.iconName == 'thermostat') {
            itemIcon = Icons.device_thermostat;
          } else {
            itemIcon = Icons.water_drop;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDone ? const Color(0xFF059669) : const Color(0xFFE5EEFF), width: isDone ? 1.5 : 1),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 1)),
              ],
            ),
            child: CheckboxListTile(
              value: isDone,
              activeColor: const Color(0xFF005C55),
              onChanged: (val) {
                setState(() {
                  _completedActions[item.title] = val ?? false;
                });
              },
              secondary: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDone ? const Color(0xFFECFDF5) : const Color(0xFFB5EDE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(itemIcon, color: const Color(0xFF005C55), size: 20),
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? const Color(0xFF6E7977) : const Color(0xFF0B1C30),
                ),
              ),
              subtitle: Text(
                item.action,
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF6E7977),
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          );
        }).toList(),

        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Kontak Bantuan Teknis'),
                content: const Text(
                  'Jika kondisi memburuk dan ayam menunjukkan gejala stres berat:\n\n'
                  '• Hotline Dokter Hewan (drh): 0812-3456-7890\n'
                  '• PPL Dinas Peternakan: 0821-9876-5432\n'
                  '• Layanan Kemitraan: 0813-2345-6789',
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
                ],
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF005C55),
            side: const BorderSide(color: Color(0xFF005C55)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.support_agent),
          label: const Text('Hubungi Bantuan Teknis Kandang'),
        ),
      ],
    );
  }

  // ================= 6. TAB 5: RIWAYAT (Grafik Visual & Filter Interaktif) =================
  Widget _buildRiwayatTab() {
    final filteredHistory = _history.where((item) {
      if (_historyFilter == 'Tinggi') return item.category == 'Tinggi';
      if (_historyFilter == 'Sedang') return item.category == 'Sedang';
      if (_historyFilter == 'Rendah') return item.category == 'Rendah';
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Riwayat & Tren Skor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
                ),
                Text(
                  'Grafik evaluasi harian kandang (offline SQLite)',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6E7977)),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _history.clear();
                  _initSampleData();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Riwayat disetel ulang ke data awal.')),
                );
              },
              icon: const Icon(Icons.refresh, color: Color(0xFF005C55)),
              tooltip: 'Reset Data Awal',
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Visual Trend Line Chart (Menggunakan CustomPaint Canvas murni tanpa dependensi)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Grafik Tren Kesehatan (0 - 100)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text('Ambang: 75+', style: TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 110,
                width: double.infinity,
                child: CustomPaint(
                  painter: ScoreTrendPainter(scores: _history.map((e) => e.scoreMamdani).toList()),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Awal (Hari ${_history.first.age})', style: const TextStyle(fontSize: 10, color: Color(0xFF6E7977))),
                  Text('Terbaru (Hari ${_history.last.age})', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF005C55))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Filter Bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Semua', 'Tinggi', 'Sedang', 'Rendah'].map((f) {
              final isSel = _historyFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(f, style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                  selected: isSel,
                  selectedColor: const Color(0xFFB5EDE7),
                  backgroundColor: Colors.white,
                  checkmarkColor: const Color(0xFF005C55),
                  onSelected: (selected) => setState(() => _historyFilter = f),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),

        // History Cards List
        if (filteredHistory.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(
              child: Text('Tidak ada riwayat evaluasi dengan filter ini.', style: TextStyle(fontSize: 12, color: Color(0xFF6E7977))),
            ),
          )
        else
          ...filteredHistory.reversed.map((row) {
            final isHigh = row.scoreMamdani >= 75;
            final isMed = row.scoreMamdani >= 50;
            final borderColor = isHigh ? const Color(0xFF059669) : (isMed ? const Color(0xFFD97706) : Colors.red);

            return InkWell(
              onTap: () => _showEvaluationDetailModal(row),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: borderColor, width: 4)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 1)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hari ke-${row.age} (${row.agePhase})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: '${row.scoreMamdani.round()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF005C55))),
                              const TextSpan(text: '/100', style: TextStyle(fontSize: 11, color: Color(0xFF6E7977))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Suhu: ${row.temperature.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 11, color: Color(0xFF6E7977))),
                        Text('RH: ${row.humidity.round()}%', style: const TextStyle(fontSize: 11, color: Color(0xFF6E7977))),
                        Text('Target: ${row.targetTemp.round()}°C', style: const TextStyle(fontSize: 11, color: Color(0xFF6E7977))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '"${row.recommendationSummary}"',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF6E7977)),
                          ),
                        ),
                        const Text('Detail ➔', style: TextStyle(fontSize: 10, color: Color(0xFF005C55), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  // ================= 7. BOTTOM NAVIGATION BAR =================
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5EEFF), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF005C55),
        unselectedItemColor: const Color(0xFF6E7977),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_outlined),
            activeIcon: Icon(Icons.tune),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Hasil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_outlined),
            activeIcon: Icon(Icons.checklist),
            label: 'Solusi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}

/// CustomPainter untuk menggambar grafik garis tren skor historis secara elegan
class ScoreTrendPainter extends CustomPainter {
  final List<double> scores;

  ScoreTrendPainter({required this.scores});

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;

    final paintLine = Paint()
      ..color = const Color(0xFF005C55)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintDot = Paint()
      ..color = const Color(0xFF007952)
      ..style = PaintingStyle.fill;

    final paintGrid = Paint()
      ..color = const Color(0xFFE5EEFF)
      ..strokeWidth = 1;

    // Gambar Garis Ambang Ideal 75
    final y75 = size.height * (1.0 - (75.0 / 100.0));
    canvas.drawLine(Offset(0, y75), Offset(size.width, y75), paintGrid);

    final path = Path();
    final stepX = scores.length > 1 ? size.width / (scores.length - 1) : size.width;

    for (int i = 0; i < scores.length; i++) {
      final x = i * stepX;
      // Normalisasi skor 0–100 ke koordinat Y
      final normScore = (scores[i].clamp(0.0, 100.0)) / 100.0;
      final y = size.height * (1.0 - normScore);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paintLine);

    // Gambar titik lingkaran di setiap evaluasi
    for (int i = 0; i < scores.length; i++) {
      final x = i * stepX;
      final normScore = (scores[i].clamp(0.0, 100.0)) / 100.0;
      final y = size.height * (1.0 - normScore);
      canvas.drawCircle(Offset(x, y), 5, paintDot);
      canvas.drawCircle(Offset(x, y), 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
