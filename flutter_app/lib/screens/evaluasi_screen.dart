import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../fuzzy/fuzzy_engine.dart';
import '../widgets/fuzzy_membership_dialog.dart';
import 'input_screen.dart';
import 'hasil_screen.dart';

/// Screen Tab 2: Evaluasi Terpadu (Input & Hasil Inferensi Fuzzy)
/// Menggabungkan input mikroklimat dan analisis komparasi Mamdani/Sugeno
/// dalam satu layar dengan navigasi sub-tab yang elegan dan tidak memadati bottom bar.
class EvaluasiScreen extends StatefulWidget {
  final double inputAge;
  final double inputTemp;
  final double inputRh;
  final FuzzyBroilerEngine engine;
  final EvaluationResult currentEvaluation;
  final ValueChanged<double> onAgeChanged;
  final ValueChanged<double> onTempChanged;
  final ValueChanged<double> onRhChanged;
  final void Function(PresetScenario preset) onApplyPreset;
  final VoidCallback onRunEvaluation;
  final VoidCallback onNavigateToSolusi;
  final int initialSubTabIndex;

  const EvaluasiScreen({
    super.key,
    required this.inputAge,
    required this.inputTemp,
    required this.inputRh,
    required this.engine,
    required this.currentEvaluation,
    required this.onAgeChanged,
    required this.onTempChanged,
    required this.onRhChanged,
    required this.onApplyPreset,
    required this.onRunEvaluation,
    required this.onNavigateToSolusi,
    this.initialSubTabIndex = 0,
  });

  @override
  State<EvaluasiScreen> createState() => EvaluasiScreenState();
}

class EvaluasiScreenState extends State<EvaluasiScreen> with SingleTickerProviderStateMixin {
  late TabController _subTabController;

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialSubTabIndex.clamp(0, 1),
    );
  }

  @override
  void didUpdateWidget(covariant EvaluasiScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSubTabIndex != oldWidget.initialSubTabIndex) {
      _subTabController.animateTo(widget.initialSubTabIndex.clamp(0, 1));
    }
  }

  @override
  void dispose() {
    _subTabController.dispose();
    super.dispose();
  }

  void switchToHasilTab() {
    if (_subTabController.index != 1) {
      _subTabController.animateTo(1);
    }
  }

  void switchToInputTab() {
    if (_subTabController.index != 0) {
      _subTabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pill Sub-Tab Navigation Header
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _subTabController,
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textBody,
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            tabs: const [
              Tab(text: 'Form Input'),
              Tab(text: 'Hasil Inferensi'),
            ],
          ),
        ),

        // Konten Sub-Tab (Input Form atau Hasil)
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            children: [
              // Sub-tab 0: Form Input
              InputScreen(
                inputAge: widget.inputAge,
                inputTemp: widget.inputTemp,
                inputRh: widget.inputRh,
                engine: widget.engine,
                onAgeChanged: widget.onAgeChanged,
                onTempChanged: widget.onTempChanged,
                onRhChanged: widget.onRhChanged,
                onApplyPreset: widget.onApplyPreset,
                onRunEvaluation: () {
                  widget.onRunEvaluation();
                  _subTabController.animateTo(1); // Otomatis pindah ke hasil
                },
              ),

              // Sub-tab 1: Hasil Evaluasi & Komparasi Fuzzy
              Stack(
                children: [
                  HasilScreen(
                    currentEvaluation: widget.currentEvaluation,
                    onNavigateToSolusi: widget.onNavigateToSolusi,
                  ),

                  // Floating Button untuk Melihat Kurva Himpunan Fuzzy
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton.extended(
                      heroTag: 'btnFuzzyCurves',
                      onPressed: () {
                        FuzzyMembershipDialog.show(
                          context,
                          age: widget.currentEvaluation.age.toDouble(),
                          tempDev: widget.currentEvaluation.tempDeviation,
                          humidity: widget.currentEvaluation.humidity,
                          score: widget.currentEvaluation.scoreMamdani,
                        );
                      },
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      icon: const Icon(Icons.auto_graph, size: 18),
                      label: const Text(
                        'Kurva Fuzzy',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
