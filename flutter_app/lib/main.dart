import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'core/app_constants.dart';
import 'fuzzy/fuzzy_engine.dart';
import 'widgets/custom_app_bar.dart';
import 'screens/beranda_screen.dart';
import 'screens/evaluasi_screen.dart';
import 'screens/solusi_screen.dart';
import 'screens/riwayat_screen.dart';
import 'screens/profil_screen.dart';

void main() {
  runApp(const FuzzyBroilerApp());
}

/// Root Widget Aplikasi FuzzyBroiler IP
class FuzzyBroilerApp extends StatelessWidget {
  const FuzzyBroilerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.background,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

/// Layar Utama dengan Navigasi 4 Tab Bersih & Nyaman
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  int _evaluasiSubTabIndex = 0; // 0: Input, 1: Hasil
  final FuzzyBroilerEngine _engine = FuzzyBroilerEngine();

  // Evaluasi aktif & arsip riwayat
  late EvaluationResult _currentEvaluation;
  final List<EvaluationResult> _history = [];
  bool _showEarlyWarning = true;
  String _selectedFlock = AppConstants.defaultFlock;
  String _historyFilter = 'Semua';

  // State Checklist Solusi Interaktif
  final Map<String, bool> _completedActions = {};

  // Form Controller untuk Evaluasi
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
    final d2 = _engine.evaluate(
      age: 20,
      temperature: 28.0,
      humidity: 66.5,
      previousScores: [d1.scoreMamdani],
    );
    // Hari ke-21 (Mockup awal: skor 86)
    _currentEvaluation = _engine.evaluate(
      age: 21,
      temperature: 28.8,
      humidity: 68.0,
      previousScores: [d1.scoreMamdani, d2.scoreMamdani],
    );

    _history.addAll([d1, d2, _currentEvaluation]);

    // Inisialisasi checklist tindakan
    _completedActions.clear();
    for (final action in _currentEvaluation.recommendationDetails) {
      _completedActions[action.title] = false;
    }
  }

  void _applyPreset(PresetScenario preset) {
    setState(() {
      _inputAge = preset.age;
      _inputTemp = preset.temperature;
      _inputRh = preset.humidity;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Preset "${preset.name}" diterapkan: Umur ${preset.age.round()} hr, Suhu ${preset.temperature}°C, RH ${preset.humidity.round()}%',
        ),
        backgroundColor: AppColors.primary,
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
      _completedActions.clear();
      for (final action in newEval.recommendationDetails) {
        _completedActions[action.title] = false;
      }
      _currentIndex = 1; // Pindah ke tab Evaluasi
      _evaluasiSubTabIndex = 1; // Langsung tampilkan sub-tab Hasil
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Evaluasi Selesai! Skor Mamdani: ${newEval.scoreMamdani.round()}, Sugeno: ${newEval.scoreSugeno.round()} (${newEval.category})',
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'LIHAT SOLUSI',
          textColor: AppColors.primaryFixed,
          onPressed: () => setState(() => _currentIndex = 2),
        ),
      ),
    );
  }

  void _openProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilScreen(
          selectedFlock: _selectedFlock,
          onFlockChanged: (val) {
            setState(() => _selectedFlock = val);
          },
          onResetData: () {
            setState(() {
              _history.clear();
              _initSampleData();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480), // Tampilan responsif mobile
            child: Column(
              children: [
                // 1. Top App Bar Profesional (Avatar profil di pojok kanan atas)
                CustomAppBar(
                  currentIndex: _currentIndex,
                  selectedFlock: _selectedFlock,
                  currentAge: _currentEvaluation.age,
                  onProfileTap: _openProfileScreen,
                  onFlockSelected: (val) {
                    setState(() => _selectedFlock = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Beralih ke: $val'), duration: const Duration(seconds: 1)),
                    );
                  },
                ),

                // 2. Konten Layar 4 Tab Utama
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      // Tab 0: Beranda
                      BerandaScreen(
                        currentEvaluation: _currentEvaluation,
                        selectedFlock: _selectedFlock,
                        showEarlyWarning: _showEarlyWarning,
                        onDismissEarlyWarning: () => setState(() => _showEarlyWarning = false),
                        onNavigateToInput: () => setState(() {
                          _currentIndex = 1;
                          _evaluasiSubTabIndex = 0;
                        }),
                        onNavigateToHasil: () => setState(() {
                          _currentIndex = 1;
                          _evaluasiSubTabIndex = 1;
                        }),
                        onNavigateToSolusi: () => setState(() => _currentIndex = 2),
                        onNavigateToProfil: _openProfileScreen,
                      ),

                      // Tab 1: Evaluasi Terpadu (Input & Hasil Komparasi Fuzzy)
                      EvaluasiScreen(
                        inputAge: _inputAge,
                        inputTemp: _inputTemp,
                        inputRh: _inputRh,
                        engine: _engine,
                        currentEvaluation: _currentEvaluation,
                        initialSubTabIndex: _evaluasiSubTabIndex,
                        onAgeChanged: (val) => setState(() => _inputAge = val),
                        onTempChanged: (val) => setState(() => _inputTemp = val),
                        onRhChanged: (val) => setState(() => _inputRh = val),
                        onApplyPreset: _applyPreset,
                        onRunEvaluation: _runEvaluation,
                        onNavigateToSolusi: () => setState(() => _currentIndex = 2),
                      ),

                      // Tab 2: Solusi SOP Tindakan Kandang
                      SolusiScreen(
                        currentEvaluation: _currentEvaluation,
                        completedActions: _completedActions,
                        onToggleAction: (title, val) {
                          setState(() {
                            _completedActions[title] = val;
                          });
                        },
                      ),

                      // Tab 3: Riwayat & Tren Historis
                      RiwayatScreen(
                        history: _history,
                        historyFilter: _historyFilter,
                        onFilterChanged: (filter) => setState(() => _historyFilter = filter),
                        onResetHistory: () {
                          setState(() {
                            _history.clear();
                            _initSampleData();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Riwayat disetel ulang ke data awal.')),
                          );
                        },
                        onSelectEvaluation: (eval) {
                          setState(() {
                            _currentEvaluation = eval;
                            _currentIndex = 2; // Buka tab solusi
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // 3. Bottom Navigation Bar Bersih & Lega (4 Tab)
                _buildBottomNavigationBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_outlined),
            activeIcon: Icon(Icons.tune),
            label: 'Evaluasi',
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
