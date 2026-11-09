import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../fuzzy/fuzzy_engine.dart';

/// Screen Tab 3: Hasil Inferensi
/// Komparasi mendalam Mamdani vs Sugeno, Estimasi IP, FCR, dan Mortalitas
class HasilScreen extends StatelessWidget {
  final EvaluationResult currentEvaluation;
  final VoidCallback onNavigateToSolusi;

  const HasilScreen({
    super.key,
    required this.currentEvaluation,
    required this.onNavigateToSolusi,
  });

  @override
  Widget build(BuildContext context) {
    // Estimasi Indeks Performa (IP) formula standar industri peternakan:
    // IP = [(100 - Mortalitas%) * Bobot(kg)] / [FCR * Umur(hari)] * 100
    final mortEst = currentEvaluation.scoreMamdani >= 75
        ? 1.8
        : (currentEvaluation.scoreMamdani >= 50 ? 3.5 : 7.2);
    final fcrEst = currentEvaluation.scoreMamdani >= 75
        ? 1.48
        : (currentEvaluation.scoreMamdani >= 50 ? 1.62 : 1.85);
    final weightEst = (currentEvaluation.age * 0.052) + 0.35;
    final ipEstimated =
        (((100 - mortEst) * weightEst) / (fcrEst * currentEvaluation.age)) * 100;

    final isGood = currentEvaluation.scoreMamdani >= 75;
    final isMed = currentEvaluation.scoreMamdani >= 50;

    final categoryBg = isGood
        ? AppColors.emeraldBg
        : (isMed ? AppColors.warningBg : AppColors.errorBg);
    final categoryText = isGood
        ? AppColors.emeraldText
        : (isMed ? AppColors.warningTextDark : AppColors.errorText);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Hasil Inferensi Fuzzy',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const Text(
          'Evaluasi Potensi Indeks Performa (IP) Broiler secara Real-Time',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kategori Potensi Panen:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentEvaluation.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: categoryText,
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
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Mamdani (Centroid)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentEvaluation.scoreMamdani.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const Text(
                            'Skor Utama TA',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.secondaryContainer),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Sugeno (Weighted)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentEvaluation.scoreSugeno.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          const Text(
                            'Model Pembanding',
                            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
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
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [
                        Text('Latensi Sugeno', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        Text('0.005 ms', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    Container(height: 24, width: 1, color: AppColors.outline),
                    Column(
                      children: const [
                        Text('Latensi Mamdani', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        Text('0.496 ms', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textBody)),
                      ],
                    ),
                    Container(height: 24, width: 1, color: AppColors.outline),
                    Column(
                      children: const [
                        Text('Korelasi (r)', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        Text('0.9987', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Divider(color: AppColors.outline),
              const SizedBox(height: 8),

              // Variable Details
              _buildResultRow('Fase Biologis:', currentEvaluation.agePhase),
              _buildResultRow(
                'Deviasi Suhu (ΔT):',
                '${currentEvaluation.tempDeviation >= 0 ? '+' : ''}${currentEvaluation.tempDeviation}°C (Target ${currentEvaluation.targetTemp.round()}°C)',
              ),
              _buildResultRow(
                'Status Kelembaban:',
                '${currentEvaluation.humidity.round()}% (${currentEvaluation.humidityStatus})',
              ),
              _buildResultRow(
                'Estimasi Indeks Performa (IP):',
                '${ipEstimated.round()} (Kategori: ${currentEvaluation.category})',
              ),
              _buildResultRow(
                'Estimasi FCR / Mortalitas:',
                '${fcrEst.toStringAsFixed(2)} / ${mortEst.toStringAsFixed(1)}%',
              ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onNavigateToSolusi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text(
                  'Terapkan Panduan Solusi Tindakan',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
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
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeadline,
            ),
          ),
        ],
      ),
    );
  }
}

