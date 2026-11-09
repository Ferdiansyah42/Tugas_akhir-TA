import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../fuzzy/fuzzy_engine.dart';
import '../widgets/early_warning_banner.dart';
import '../widgets/hero_score_card.dart';
import '../widgets/telemetry_card.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/flock_banner_card.dart';

/// Screen Tab 1: Beranda
/// Tampilan dashboard utama mikroklimat presisi sesuai desain mockup visual
class BerandaScreen extends StatelessWidget {
  final EvaluationResult currentEvaluation;
  final String selectedFlock;
  final bool showEarlyWarning;
  final VoidCallback onDismissEarlyWarning;
  final VoidCallback onNavigateToInput;
  final VoidCallback onNavigateToHasil;
  final VoidCallback onNavigateToSolusi;

  const BerandaScreen({
    super.key,
    required this.currentEvaluation,
    required this.selectedFlock,
    required this.showEarlyWarning,
    required this.onDismissEarlyWarning,
    required this.onNavigateToInput,
    required this.onNavigateToHasil,
    required this.onNavigateToSolusi,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Early Warning Alert Banner
        if (showEarlyWarning)
          EarlyWarningBanner(
            flockName: selectedFlock,
            message: currentEvaluation.warningMessage ??
                'Suhu agak sedikit naik dalam 2 hari ini. Yuk cek ventilasi dan sirkulasi angin agar ayam tetap nyaman.',
            onActionTap: onNavigateToSolusi,
            onDismissTap: onDismissEarlyWarning,
          ),

        // 2. Hero Score & Health Status Card
        HeroScoreCard(
          conditionTitle: currentEvaluation.conditionTitle,
          conditionSubtitle: currentEvaluation.conditionSubtitle,
          category: currentEvaluation.category,
          score: currentEvaluation.scoreMamdani,
          predictionDesc: currentEvaluation.predictionDesc,
          onTap: onNavigateToHasil,
        ),

        const SizedBox(height: 16),

        // 3. Header Section Mikroklimat
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kondisi Ruangan Kandang Hari Ini',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeadline,
              ),
            ),
            Row(
              children: const [
                Icon(Icons.check_circle, size: 14, color: AppColors.tertiary),
                SizedBox(width: 4),
                Text(
                  'Terpantau Bagus',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 4. Telemetry Card: Umur Ayam
        TelemetryCard(
          title: 'UMUR AYAM',
          value: '${currentEvaluation.age}',
          unit: 'Hari',
          badgeText: currentEvaluation.agePhase,
          badgeBg: AppColors.secondaryContainer,
          badgeTextColor: AppColors.onSecondaryContainer,
          icon: Icons.calendar_month,
          iconColor: AppColors.primary,
          leftBorderColor: AppColors.primary,
          subText: 'Fase Tumbuh Broiler',
        ),
        const SizedBox(height: 8),

        // 5. Telemetry Card: Suhu Ruangan
        TelemetryCard(
          title: 'SUHU RUANGAN',
          value: currentEvaluation.temperature.toStringAsFixed(1),
          unit: '°C',
          badgeText: currentEvaluation.tempStatus,
          badgeBg: AppColors.warningBg,
          badgeTextColor: AppColors.warningTextDark,
          icon: Icons.device_thermostat,
          iconColor: AppColors.warningButton,
          leftBorderColor: AppColors.warningButton,
          subText:
              'Target: ${currentEvaluation.targetTemp.round()}°C (ΔT: ${currentEvaluation.tempDeviation >= 0 ? '+' : ''}${currentEvaluation.tempDeviation}°C)',
        ),
        const SizedBox(height: 8),

        // 6. Telemetry Card: Kelembaban Udara
        TelemetryCard(
          title: 'KELEMBABAN UDARA',
          value: '${currentEvaluation.humidity.round()}',
          unit: '%',
          badgeText: currentEvaluation.humidityStatus,
          badgeBg: AppColors.emeraldBg,
          badgeTextColor: AppColors.emeraldText,
          icon: Icons.water_drop,
          iconColor: AppColors.primary,
          leftBorderColor: AppColors.emeraldGreen,
          subText: 'Rentang Pas: 60 - 70%',
        ),

        const SizedBox(height: 16),

        // 7. Priority Actionable Recommendation Card
        RecommendationCard(
          priority: currentEvaluation.recommendationPriority,
          summary: currentEvaluation.recommendationSummary,
          onTap: onNavigateToSolusi,
        ),

        const SizedBox(height: 16),

        // 8. Active Flock Card
        FlockBannerCard(
          flockName: selectedFlock,
          age: currentEvaluation.age,
        ),

        const SizedBox(height: 16),

        // 9. Floating CTA Button
        ElevatedButton(
          onPressed: onNavigateToInput,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
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
              Text(
                '➕ Cek Kondisi Kandang Hari Ini',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'Bisa dipakai langsung kapan saja • Tanpa butuh kuota internet',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

