import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Card Siklus Kandang Aktif (Informasi Closed House & Populasi)
class FlockBannerCard extends StatelessWidget {
  final String flockName;
  final int age;
  final String strain;
  final int population;

  const FlockBannerCard({
    super.key,
    required this.flockName,
    required this.age,
    this.strain = 'Cobb 500',
    this.population = 10000,
  });

  @override
  Widget build(BuildContext context) {
    final daysToHarvest = (42 - age).clamp(0, 42);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.domain, color: AppColors.primary, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Siklus Kandang Aktif',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeadline,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Siklus Berjalan',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 80,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF00382E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.warehouse, color: AppColors.primaryFixed, size: 30),
                    SizedBox(height: 2),
                    Text(
                      'CH-01',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$flockName Closed House 01',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHeadline,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Strain: $strain',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Populasi: $population Ekor',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Panen: $daysToHarvest Hari Lagi',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.tertiary,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Sertifikasi: SNI Broiler',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
