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

  // Evaluasi aktif (dimulai dengan data Blok A Hari ke-21 sesuai mockup)
  late EvaluationResult _currentEvaluation;
  final List<EvaluationResult> _history = [];
  bool _showEarlyWarning = true;

  // Form Controller untuk Tab Input
  final TextEditingController _ageController = TextEditingController(text: '21');
  final TextEditingController _tempController = TextEditingController(text: '28.8');
  final TextEditingController _rhController = TextEditingController(text: '68');

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
  }

  @override
  void dispose() {
    _ageController.dispose();
    _tempController.dispose();
    _rhController.dispose();
    super.dispose();
  }

  void _runEvaluation() {
    final age = int.tryParse(_ageController.text) ?? 21;
    final temp = double.tryParse(_tempController.text) ?? 28.8;
    final rh = double.tryParse(_rhController.text) ?? 68.0;

    final recentScores = _history.map((e) => e.scoreMamdani).toList();
    final newEval = _engine.evaluate(
      age: age,
      temperature: temp,
      humidity: rh,
      previousScores: recentScores,
    );

    setState(() {
      _currentEvaluation = newEval;
      _history.add(newEval);
      if (newEval.warningFlag) {
        _showEarlyWarning = true;
      }
      _currentIndex = 2; // Pindah ke Tab Hasil
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480), // Tampilan mobile responsif
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF005C55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 18),
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
                    'Kandang Blok A (Hari ke-${_currentEvaluation.age})',
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
        // Early Warning Banner
        if (_showEarlyWarning && (_currentEvaluation.warningFlag || true))
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
                          const Text(
                            'Perhatian untuk Kandang Blok B',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
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
                      const Text(
                        'Suhu agak sedikit naik dalam 2 hari ini. Yuk cek ventilasi dan sirkulasi angin agar ayam tetap nyaman.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF78350F), height: 1.3),
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

        // Hero Score & Analytics Card
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
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(radius: 3, backgroundColor: Color(0xFF059669)),
                          SizedBox(width: 4),
                          Text(
                            'Kondisi Ayam: Sangat Baik',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
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
                    Column(
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
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
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
                        children: const [
                          Icon(Icons.thumb_up, size: 16, color: Color(0xFF007952)),
                          SizedBox(width: 6),
                          Text('Prediksi Panen: ', style: TextStyle(fontSize: 12, color: Color(0xFF0B1C30))),
                          Text('Sangat Memuaskan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Aman & Nyaman', style: TextStyle(fontSize: 11, color: Color(0xFF065F46), fontWeight: FontWeight.bold)),
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
          subText: 'Target: ${_currentEvaluation.targetTemp.round()}°C',
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

        // Priority Actionable Recommendation Widget
        Container(
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
                    child: const Text('Perlu Dilakukan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF0F766E).withOpacity(0.9),
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
                children: [
                  const Text('Saran otomatis berdasarkan cuaca kandang', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  TextButton.icon(
                    onPressed: () => setState(() => _currentIndex = 3),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF9CF2E8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    label: const Text('Lihat Cara Penanganan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    icon: const Icon(Icons.arrow_forward, size: 14),
                  ),
                ],
              ),
            ],
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
                      color: Color(0xFF6FFBBE).withOpacity(0.3),
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
                        const Text('Kandang Broiler Closed House 01', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
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

  // ================= 3. TAB 2: INPUT =================
  Widget _buildInputTab() {
    final age = int.tryParse(_ageController.text) ?? 21;
    final targetTemp = _engine.getTargetTemperature(age);
    final phase = _engine.getAgePhase(age);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Input Evaluasi Kandang',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
        ),
        const Text(
          'Mesin Fuzzy adaptif akan menghitung deviasi suhu otomatis sesuai pedoman strain.',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Umur
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Umur Ayam (Hari)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFB5EDE7), borderRadius: BorderRadius.circular(8)),
                    child: Text(phase, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF144F4B))),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month, color: Color(0xFF005C55)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),

              // Target Suhu Info
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
                    const Text('Target Suhu Cobb 500 / Ross 308:', style: TextStyle(fontSize: 11, color: Color(0xFF3E4947))),
                    Text('${targetTemp.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF005C55))),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Input Suhu
              const Text('Suhu Ruangan Aktual (°C)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _tempController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.device_thermostat, color: Color(0xFFD97706)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),

              // Input Kelembaban
              const Text('Kelembaban Udara (RH %)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _rhController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.water_drop, color: Color(0xFF005C55)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Submit
              ElevatedButton.icon(
                onPressed: _runEvaluation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C55),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.psychology),
                label: const Text('Jalankan Inferensi Fuzzy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= 4. TAB 3: HASIL =================
  Widget _buildHasilTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Hasil Evaluasi Fuzzy',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
        ),
        const Text(
          'Komparasi Metode Mamdani (Centroid) & Sugeno (Weighted Avg)',
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
                  const Text('Kategori Potensi IP:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _currentEvaluation.category,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Score Comparison Grid
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF005C55).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Text('Mamdani (Centroid)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7977))),
                          const SizedBox(height: 6),
                          Text(
                            _currentEvaluation.scoreMamdani.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
                          ),
                          const Text('Skor Utama TA', style: TextStyle(fontSize: 10, color: Color(0xFF007952))),
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
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE5EEFF)),
              const SizedBox(height: 8),

              // Variable Details
              _buildResultRow('Fase Biologis:', _currentEvaluation.agePhase),
              _buildResultRow('Deviasi Suhu (ΔT):', '${_currentEvaluation.tempDeviation >= 0 ? '+' : ''}${_currentEvaluation.tempDeviation}°C (Target ${_currentEvaluation.targetTemp.round()}°C)'),
              _buildResultRow('Status Kelembaban:', '${_currentEvaluation.humidity.round()}% (${_currentEvaluation.humidityStatus})'),
              _buildResultRow('Estimasi Indeks Performa (IP):', '> 380 (Sangat Bagus)'),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => setState(() => _currentIndex = 3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C55),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Lihat Panduan Solusi Korektif', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
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

  // ================= 5. TAB 4: SOLUSI =================
  Widget _buildSolusiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Panduan Tindakan',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
        ),
        const Text(
          'Langkah prioritas penanganan kandang berdasarkan iklim mikro',
          style: TextStyle(fontSize: 12, color: Color(0xFF6E7977)),
        ),
        const SizedBox(height: 16),

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
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Action Steps List
        ..._currentEvaluation.recommendationDetails.map((item) {
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 1)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB5EDE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(itemIcon, color: const Color(0xFF005C55), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
                      const SizedBox(height: 4),
                      Text(item.action, style: const TextStyle(fontSize: 12, color: Color(0xFF6E7977), height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // ================= 6. TAB 5: RIWAYAT =================
  Widget _buildRiwayatTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Riwayat Evaluasi Kandang',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005C55)),
        ),
        const Text(
          'Log evaluasi tersimpan lokal di perangkat',
          style: TextStyle(fontSize: 12, color: Color(0xFF6E7977)),
        ),
        const SizedBox(height: 16),

        ..._history.reversed.map((row) {
          final isHigh = row.scoreMamdani >= 75;
          final isMed = row.scoreMamdani >= 50;
          final borderColor = isHigh ? const Color(0xFF059669) : (isMed ? const Color(0xFFD97706) : Colors.red);

          return Container(
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
                Text(
                  '"${row.recommendationSummary}"',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF6E7977)),
                ),
              ],
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
