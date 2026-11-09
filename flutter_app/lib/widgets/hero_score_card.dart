import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Card Hero Status Kandang & Nilai Kesehatan Broiler (Skor 0 - 100)
/// Komponen visual utama sesuai persis dengan mockup gambar user
class HeroScoreCard extends StatelessWidget {
  final String conditionTitle;
  final String conditionSubtitle;
  final String category;
  final double score;
  final String predictionDesc;
  final VoidCallback onTap;

  const HeroScoreCard({
    super.key,
    required this.conditionTitle,
    required this.conditionSubtitle,
    required this.category,
    required this.score,
    required this.predictionDesc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isGood = score >= 75;
    final isModerate = score >= 50;

    final statusColor = isGood
        ? AppColors.emeraldGreen
        : (isModerate ? AppColors.warningButton : AppColors.error);

    final statusBg = isGood
        ? AppColors.emeraldBg
        : (isModerate ? AppColors.warningBg : AppColors.errorBg);

    final statusText = isGood
        ? AppColors.emeraldText
        : (isModerate ? AppColors.warningTextDark : AppColors.errorText);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                Expanded(
                  child: Row(
                    children: const [
                      Icon(Icons.sentiment_very_satisfied, color: AppColors.tertiary, size: 22),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'STATUS KANDANG SAAT INI',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Kondisi: $category',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusText,
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
                        conditionTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        conditionSubtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondaryContainer),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Nilai Kesehatan',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: score.round().toString(),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const TextSpan(
                              text: '/100',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMuted,
                              ),
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
                value: score / 100.0,
                minHeight: 8,
                backgroundColor: AppColors.surfaceContainer,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.thumb_up, size: 16, color: AppColors.tertiary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Prediksi Panen: ',
                            style: TextStyle(fontSize: 12, color: AppColors.textHeadline),
                          ),
                          TextSpan(
                            text: predictionDesc,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textHeadline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Lihat Hasil ➔',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.emeraldText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
