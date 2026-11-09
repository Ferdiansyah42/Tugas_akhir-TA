import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../fuzzy/fuzzy_engine.dart';
import '../widgets/trend_chart.dart';
import '../widgets/evaluation_detail_modal.dart';

/// Screen Tab 5: Riwayat Evaluasi
/// Visualisasi grafik tren historis & arsip evaluasi mikroklimat harian
class RiwayatScreen extends StatelessWidget {
  final List<EvaluationResult> history;
  final String historyFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onResetHistory;
  final void Function(EvaluationResult eval) onSelectEvaluation;

  const RiwayatScreen({
    super.key,
    required this.history,
    required this.historyFilter,
    required this.onFilterChanged,
    required this.onResetHistory,
    required this.onSelectEvaluation,
  });

  @override
  Widget build(BuildContext context) {
    final filteredHistory = history.where((item) {
      if (historyFilter == 'Tinggi') return item.category == 'Tinggi';
      if (historyFilter == 'Sedang') return item.category == 'Sedang';
      if (historyFilter == 'Rendah') return item.category == 'Rendah';
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Grafik evaluasi harian kandang (offline SQLite)',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
            IconButton(
              onPressed: onResetHistory,
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              tooltip: 'Reset Data Awal',
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Visual Trend Line Chart
        if (history.isNotEmpty)
          TrendChartWidget(
            scores: history.map((e) => e.scoreMamdani).toList(),
            firstAge: history.first.age,
            lastAge: history.last.age,
          ),
        const SizedBox(height: 14),

        // Filter Bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Semua', 'Tinggi', 'Sedang', 'Rendah'].map((f) {
              final isSel = historyFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    f,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppColors.secondaryContainer,
                  backgroundColor: Colors.white,
                  checkmarkColor: AppColors.primary,
                  onSelected: (selected) => onFilterChanged(f),
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
              child: Text(
                'Tidak ada riwayat evaluasi dengan filter ini.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          )
        else
          ...filteredHistory.reversed.map((row) {
            final isHigh = row.scoreMamdani >= 75;
            final isMed = row.scoreMamdani >= 50;
            final borderColor = isHigh
                ? AppColors.emeraldGreen
                : (isMed ? AppColors.warningButton : AppColors.error);

            return InkWell(
              onTap: () {
                EvaluationDetailModal.show(
                  context,
                  eval: row,
                  onOpenSolution: () => onSelectEvaluation(row),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: borderColor, width: 4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hari ke-${row.age} (${row.agePhase})',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${row.scoreMamdani.round()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const TextSpan(
                                text: '/100',
                                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Suhu: ${row.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        Text(
                          'RH: ${row.humidity.round()}%',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        Text(
                          'Target: ${row.targetTemp.round()}°C',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
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
                            style: const TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const Text(
                          'Detail ➔',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
}

