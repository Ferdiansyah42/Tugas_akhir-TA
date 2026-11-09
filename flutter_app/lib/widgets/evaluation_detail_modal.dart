import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../fuzzy/fuzzy_engine.dart';

/// Modal Bottom Sheet untuk Menampilkan Rincian Ilmiah Evaluasi
class EvaluationDetailModal {
  static void show(
    BuildContext context, {
    required EvaluationResult eval,
    required VoidCallback onOpenSolution,
  }) {
    final isHigh = eval.scoreMamdani >= 75;
    final isMed = eval.scoreMamdani >= 50;

    final categoryBg = isHigh
        ? AppColors.emeraldBg
        : (isMed ? AppColors.warningBg : AppColors.errorBg);
    final categoryText = isHigh
        ? AppColors.emeraldText
        : (isMed ? AppColors.warningTextDark : AppColors.errorText);

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
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail Evaluasi: Hari ke-${eval.age}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      eval.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: categoryText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildDetailItem('Fase Umur', eval.agePhase),
              _buildDetailItem(
                'Suhu Aktual / Target',
                '${eval.temperature}°C / ${eval.targetTemp}°C (ΔT: ${eval.tempDeviation >= 0 ? '+' : ''}${eval.tempDeviation}°C)',
              ),
              _buildDetailItem(
                'Kelembaban Udara (RH)',
                '${eval.humidity.round()}% (${eval.humidityStatus})',
              ),
              _buildDetailItem('Skor Mamdani (Centroid)', '${eval.scoreMamdani} / 100'),
              _buildDetailItem('Skor Sugeno (Weighted Avg)', '${eval.scoreSugeno} / 100'),
              _buildDetailItem('Status Kandang', eval.conditionTitle),
              const SizedBox(height: 10),
              const Text(
                'Rekomendasi Utama:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                eval.recommendationSummary,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textBody,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onOpenSolution();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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

  static Widget _buildDetailItem(String label, String value) {
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

