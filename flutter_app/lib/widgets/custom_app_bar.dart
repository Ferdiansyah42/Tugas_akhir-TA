import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_constants.dart';

/// Top App Bar Resmi FuzzyBroiler IP
/// Menyediakan info tab, selector kandang, dan indikator mode offline
class CustomAppBar extends StatelessWidget {
  final int currentIndex;
  final String selectedFlock;
  final int currentAge;
  final ValueChanged<String> onFlockSelected;
  final VoidCallback? onProfileTap;

  const CustomAppBar({
    super.key,
    required this.currentIndex,
    required this.selectedFlock,
    required this.currentAge,
    required this.onFlockSelected,
    this.onProfileTap,
  });

  static const List<String> tabTitles = [
    'Beranda',
    'Evaluasi Mikroklimat',
    'Solusi Tindakan Kandang',
    'Riwayat & Tren Skor',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/smart_farm_icon.png',
                        width: 34,
                        height: 34,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 34,
                          height: 34,
                          color: AppColors.primary,
                          child: const Icon(Icons.cruelty_free, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  AppConstants.appName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'DSS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            tabTitles[currentIndex.clamp(0, tabTitles.length - 1)],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        CircleAvatar(radius: 3, backgroundColor: AppColors.tertiary),
                        SizedBox(width: 5),
                        Text('Offline', style: TextStyle(fontSize: 11, color: AppColors.textBody)),
                        SizedBox(width: 4),
                        Icon(Icons.cloud_off, size: 14, color: AppColors.textBody),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    key: const Key('app_bar_profile_avatar'),
                    onTap: onProfileTap,
                    borderRadius: BorderRadius.circular(16),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/farmer_avatar.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.cottage, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: PopupMenuButton<String>(
                        initialValue: selectedFlock,
                        onSelected: onFlockSelected,
                        itemBuilder: (context) => AppConstants.flocks
                            .map((f) => PopupMenuItem(value: f, child: Text(f)))
                            .toList(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                '$selectedFlock (Hari ke-$currentAge)',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textHeadline,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircleAvatar(radius: 3, backgroundColor: AppColors.tertiary),
                  SizedBox(width: 4),
                  Text(
                    AppConstants.offlineBadge,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tertiaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
