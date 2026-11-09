import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../fuzzy/fuzzy_engine.dart';
import '../widgets/action_checklist_tile.dart';

/// Screen Tab 4: Solusi Kandang
/// Checklist interaktif SOP tindakan nyata mitigasi mikroklimat
class SolusiScreen extends StatelessWidget {
  final EvaluationResult currentEvaluation;
  final Map<String, bool> completedActions;
  final void Function(String title, bool value) onToggleAction;

  const SolusiScreen({
    super.key,
    required this.currentEvaluation,
    required this.completedActions,
    required this.onToggleAction,
  });

  void _showTechnicalSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Kontak Bantuan Teknis',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        content: const Text(
          'Jika kondisi memburuk dan ayam menunjukkan gejala stres berat:\n\n'
          '• Hotline Dokter Hewan (drh): 0812-3456-7890\n'
          '• PPL Dinas Peternakan: 0821-9876-5432\n'
          '• Layanan Kemitraan: 0813-2345-6789',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalActions = currentEvaluation.recommendationDetails.length;
    final doneActions = currentEvaluation.recommendationDetails
        .where((a) => completedActions[a.title] == true)
        .length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Panduan Tindakan Korektif',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const Text(
          'Centang tindakan yang sudah Anda selesaikan di kandang.',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 14),

        // Urgency Banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Urgensi Tindakan',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryFixed,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentEvaluation.recommendationPriority,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                currentEvaluation.recommendationSummary,
                style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
              ),
              const SizedBox(height: 10),

              // Progress Bar Checklist
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progres Penerapan: $doneActions dari $totalActions Selesai',
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  Text(
                    '${totalActions > 0 ? ((doneActions / totalActions) * 100).round() : 0}%',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryFixed,
                    ),
                  ),
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

        // Banner Keberhasilan Penerapan SOP
        if (totalActions > 0 && doneActions == totalActions)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.emeraldGreen.withOpacity(0.4)),
            ),
            child: Row(
              children: const [
                Text('🎉', style: TextStyle(fontSize: 22)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hebat! Semua langkah SOP mitigasi telah Anda terapkan di kandang. Pantau mikroklimat kembali dalam 15–30 menit.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emeraldText,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Action Steps Interactive Checklist
        ...currentEvaluation.recommendationDetails.map((item) {
          final isDone = completedActions[item.title] ?? false;

          return ActionChecklistTile(
            title: item.title,
            actionText: item.action,
            iconName: item.iconName,
            isDone: isDone,
            onChanged: (val) => onToggleAction(item.title, val ?? false),
          );
        }).toList(),

        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _showTechnicalSupportDialog(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.support_agent),
          label: const Text('Hubungi Bantuan Teknis Kandang'),
        ),
      ],
    );
  }
}

