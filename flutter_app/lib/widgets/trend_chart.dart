import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// CustomPainter untuk menggambar grafik garis tren skor historis secara elegan
class ScoreTrendPainter extends CustomPainter {
  final List<double> scores;

  ScoreTrendPainter({required this.scores});

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;

    final paintLine = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintDot = Paint()
      ..color = AppColors.tertiary
      ..style = PaintingStyle.fill;

    final paintGrid = Paint()
      ..color = AppColors.outline
      ..strokeWidth = 1;

    // Garis Ambang Ideal 75
    final y75 = size.height * (1.0 - (75.0 / 100.0));
    canvas.drawLine(Offset(0, y75), Offset(size.width, y75), paintGrid);

    final path = Path();
    final stepX = scores.length > 1 ? size.width / (scores.length - 1) : size.width;

    for (int i = 0; i < scores.length; i++) {
      final x = i * stepX;
      final normScore = (scores[i].clamp(0.0, 100.0)) / 100.0;
      final y = size.height * (1.0 - normScore);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paintLine);

    // Titik lingkaran di setiap evaluasi
    for (int i = 0; i < scores.length; i++) {
      final x = i * stepX;
      final normScore = (scores[i].clamp(0.0, 100.0)) / 100.0;
      final y = size.height * (1.0 - normScore);
      canvas.drawCircle(Offset(x, y), 5, paintDot);
      canvas.drawCircle(Offset(x, y), 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Widget Container Grafik Tren Skor Historis
class TrendChartWidget extends StatelessWidget {
  final List<double> scores;
  final int firstAge;
  final int lastAge;

  const TrendChartWidget({
    super.key,
    required this.scores,
    required this.firstAge,
    required this.lastAge,
  });

  @override
  Widget build(BuildContext context) {
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
            children: const [
              Text(
                'Grafik Tren Kesehatan (0 - 100)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeadline,
                ),
              ),
              Text(
                'Ambang: 75+',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.emeraldGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 110,
            width: double.infinity,
            child: CustomPaint(
              painter: ScoreTrendPainter(scores: scores),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Awal (Hari $firstAge)',
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
              Text(
                'Terbaru (Hari $lastAge)',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
