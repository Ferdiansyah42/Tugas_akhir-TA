import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Banner Peringatan Dini (Early Warning System)
/// Muncul otomatis jika terjadi tren penurunan skor atau anomali mikroklimat
class EarlyWarningBanner extends StatelessWidget {
  final String flockName;
  final String message;
  final VoidCallback onActionTap;
  final VoidCallback onDismissTap;

  const EarlyWarningBanner({
    super.key,
    required this.flockName,
    required this.message,
    required this.onActionTap,
    required this.onDismissTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.warningBorder.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb, color: AppColors.warningIcon, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Perhatian untuk $flockName',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warningText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warningBorder,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Perlu Cek',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warningTextDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.warningText,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onActionTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warningButton,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.check_circle, size: 15),
                      label: const Text(
                        'Lihat Cara Penanganan',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: onDismissTap,
                      child: const Text(
                        'Nanti Saja',
                        style: TextStyle(fontSize: 11, color: AppColors.warningTextDark),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
