import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../fuzzy/fuzzy_engine.dart';

/// Dialog Visualisasi Kurva Fungsi Keanggotaan Fuzzy (Membership Functions)
/// Menggambar grafik fungsi keanggotaan matematis murni menggunakan CustomPainter
class FuzzyMembershipDialog extends StatefulWidget {
  final double currentAge;
  final double currentTempDev;
  final double currentHumidity;
  final double currentScore;

  const FuzzyMembershipDialog({
    super.key,
    required this.currentAge,
    required this.currentTempDev,
    required this.currentHumidity,
    required this.currentScore,
  });

  static void show(
    BuildContext context, {
    required double age,
    required double tempDev,
    required double humidity,
    required double score,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: FuzzyMembershipDialog(
          currentAge: age,
          currentTempDev: tempDev,
          currentHumidity: humidity,
          currentScore: score,
        ),
      ),
    );
  }

  @override
  State<FuzzyMembershipDialog> createState() => _FuzzyMembershipDialogState();
}

class _FuzzyMembershipDialogState extends State<FuzzyMembershipDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FuzzyBroilerEngine _engine = FuzzyBroilerEngine();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ageMfs = _engine.fuzzifyAge(widget.currentAge);
    final tempMfs = _engine.fuzzifyTempDev(widget.currentTempDev);
    final rhMfs = _engine.fuzzifyHumidity(widget.currentHumidity);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 620),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_graph, color: AppColors.primary, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Kurva Himpunan Fuzzy',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                tooltip: 'Tutup',
              ),
            ],
          ),
          const Text(
            'Visualisasi matematis derajat keanggotaan μ(x) pada skenario evaluasi saat ini.',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),

          // Tab Bar Kurva
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Deviasi Suhu (ΔT)'),
              Tab(text: 'Umur (Hari)'),
              Tab(text: 'Kelembaban (RH)'),
              Tab(text: 'Output Skor (IP)'),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Tab Deviasi Suhu
                _buildCurveTab(
                  title: 'Kurva Deviasi Suhu (ΔT)',
                  unit: '°C',
                  currentVal: widget.currentTempDev,
                  minX: -6.0,
                  maxX: 6.0,
                  mfs: tempMfs,
                  labels: const ['Dingin', 'Nyaman', 'Panas'],
                  colors: const [Colors.blue, AppColors.emeraldGreen, AppColors.warningButton],
                  painter: TempDevCurvePainter(currentDev: widget.currentTempDev),
                  explanation:
                      '• Dingin: deviasi < -1.0°C\n• Nyaman: -2.5°C s/d +3.0°C\n• Panas: deviasi > +1.5°C',
                ),

                // 2. Tab Umur
                _buildCurveTab(
                  title: 'Kurva Umur Ayam (Hari)',
                  unit: 'Hari',
                  currentVal: widget.currentAge,
                  minX: 1.0,
                  maxX: 42.0,
                  mfs: ageMfs,
                  labels: const ['Starter', 'Grower', 'Finisher'],
                  colors: const [Colors.amber, Colors.teal, Colors.deepPurple],
                  painter: AgeCurvePainter(currentAge: widget.currentAge),
                  explanation:
                      '• Starter: 1 - 14 hari (Brooding)\n• Grower: 12 - 30 hari (Pertumbuhan)\n• Finisher: 27 - 42 hari (Pembesaran Akhir)',
                ),

                // 3. Tab Kelembaban RH
                _buildCurveTab(
                  title: 'Kurva Kelembaban Relatif (RH)',
                  unit: '%',
                  currentVal: widget.currentHumidity,
                  minX: 30.0,
                  maxX: 95.0,
                  mfs: rhMfs,
                  labels: const ['Rendah', 'Ideal', 'Tinggi'],
                  colors: const [Colors.orange, AppColors.emeraldGreen, Colors.blueAccent],
                  painter: HumidityCurvePainter(currentRh: widget.currentHumidity),
                  explanation:
                      '• Rendah (Kering): < 55%\n• Ideal: 55% - 75% (Rentang optimal 60-70%)\n• Tinggi (Lembab): > 72%',
                ),

                // 4. Tab Output Skor
                _buildOutputCurveTab(
                  currentScore: widget.currentScore,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurveTab({
    required String title,
    required String unit,
    required double currentVal,
    required double minX,
    required double maxX,
    required Map<String, double> mfs,
    required List<String> labels,
    required List<Color> colors,
    required CustomPainter painter,
    required String explanation,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Nilai Input Aktif
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.secondaryContainer),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nilai Input Aktif: ${currentVal.toStringAsFixed(1)} $unit',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Garis Merah',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.emeraldText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Canvas Grafik Kurva
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline),
            ),
            child: CustomPaint(painter: painter),
          ),
          const SizedBox(height: 10),

          // Nilai μ(x) Derajat Keanggotaan
          const Text(
            'Derajat Keanggotaan Aktif (Fuzzifikasi):',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textHeadline),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(labels.length, (i) {
              final key = mfs.keys.elementAt(i);
              final deg = mfs[key] ?? 0.0;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < labels.length - 1 ? 6 : 0),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors[i].withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors[i].withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Text(labels[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors[i])),
                      const SizedBox(height: 2),
                      Text(
                        'μ = ${deg.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textHeadline),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),

          // Parameter Matematika Himpunan
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              explanation,
              style: const TextStyle(fontSize: 11, color: AppColors.textBody, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputCurveTab({required double currentScore}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.secondaryContainer),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hasil Defuzzifikasi: ${currentScore.toStringAsFixed(1)} / 100',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    currentScore >= 75 ? 'Tinggi' : (currentScore >= 50 ? 'Sedang' : 'Rendah'),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.emeraldText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Canvas Grafik Kurva Output Skor
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline),
            ),
            child: CustomPaint(
              painter: ScoreOutputCurvePainter(currentScore: currentScore),
            ),
          ),
          const SizedBox(height: 10),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _CurveLegend(label: 'Rendah (0 - 55)', color: Colors.red),
              _CurveLegend(label: 'Sedang (45 - 75)', color: Colors.amber),
              _CurveLegend(label: 'Tinggi (70 - 100)', color: AppColors.emeraldGreen),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '• Defuzzifikasi Mamdani menggunakan Center of Gravity (Centroid) diskrit 200 partisi.\n'
              '• Sugeno orde-0 menggunakan rata-rata terbobot singelton (Rendah=30, Sedang=60, Tinggi=90).\n'
              '• Ambang evaluasi: ≥75 (Tinggi/Optimal), 50–74 (Sedang/Penyesuaian), <50 (Rendah/Kritis).',
              style: TextStyle(fontSize: 11, color: AppColors.textBody, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurveLegend extends StatelessWidget {
  final String label;
  final Color color;

  const _CurveLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textBody)),
      ],
    );
  }
}

// ================= CUSTOM PAINTERS =================

class TempDevCurvePainter extends CustomPainter {
  final double currentDev;

  TempDevCurvePainter({required this.currentDev});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sumbu X: -6.0 s/d +6.0
    double toX(double dev) => ((dev + 6.0) / 12.0) * w;
    double toY(double mu) => h - (mu * (h - 20)) - 10;

    final gridPaint = Paint()..color = const Color(0xFFE5EEFF)..strokeWidth = 1;
    canvas.drawLine(Offset(0, toY(0)), Offset(w, toY(0)), gridPaint);
    canvas.drawLine(Offset(0, toY(1)), Offset(w, toY(1)), gridPaint);
    canvas.drawLine(Offset(toX(0), 0), Offset(toX(0), h), gridPaint);

    // 1. Kurva Dingin: trapesium -15, -15, -3, -1
    final pathDingin = Path()
      ..moveTo(toX(-6.0), toY(1.0))
      ..lineTo(toX(-3.0), toY(1.0))
      ..lineTo(toX(-1.0), toY(0.0));
    canvas.drawPath(pathDingin, Paint()..color = Colors.blue.withOpacity(0.8)..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // 2. Kurva Nyaman: trapesium -2.5, -1.0, 1.8, 3.0
    final pathNyaman = Path()
      ..moveTo(toX(-2.5), toY(0.0))
      ..lineTo(toX(-1.0), toY(1.0))
      ..lineTo(toX(1.8), toY(1.0))
      ..lineTo(toX(3.0), toY(0.0));
    canvas.drawPath(pathNyaman, Paint()..color = AppColors.emeraldGreen..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // 3. Kurva Panas: trapesium 1.5, 3.2, 15, 15
    final pathPanas = Path()
      ..moveTo(toX(1.5), toY(0.0))
      ..lineTo(toX(3.2), toY(1.0))
      ..lineTo(toX(6.0), toY(1.0));
    canvas.drawPath(pathPanas, Paint()..color = AppColors.warningButton..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // Garis penanda nilai input aktif
    final clampedDev = currentDev.clamp(-6.0, 6.0);
    final curX = toX(clampedDev);
    final markerPaint = Paint()..color = Colors.red..strokeWidth = 2;
    canvas.drawLine(Offset(curX, 0), Offset(curX, h), markerPaint);
    canvas.drawCircle(Offset(curX, toY(0)), 4, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AgeCurvePainter extends CustomPainter {
  final double currentAge;

  AgeCurvePainter({required this.currentAge});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sumbu X: 1 s/d 42
    double toX(double age) => ((age - 1.0) / 41.0) * w;
    double toY(double mu) => h - (mu * (h - 20)) - 10;

    // 1. Starter: 0, 0, 10, 15
    final pathStarter = Path()
      ..moveTo(toX(1.0), toY(1.0))
      ..lineTo(toX(10.0), toY(1.0))
      ..lineTo(toX(15.0), toY(0.0));
    canvas.drawPath(pathStarter, Paint()..color = Colors.amber..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // 2. Grower: segitiga 12, 21, 30
    final pathGrower = Path()
      ..moveTo(toX(12.0), toY(0.0))
      ..lineTo(toX(21.0), toY(1.0))
      ..lineTo(toX(30.0), toY(0.0));
    canvas.drawPath(pathGrower, Paint()..color = Colors.teal..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // 3. Finisher: 27, 32, 42, 50
    final pathFinisher = Path()
      ..moveTo(toX(27.0), toY(0.0))
      ..lineTo(toX(32.0), toY(1.0))
      ..lineTo(toX(42.0), toY(1.0));
    canvas.drawPath(pathFinisher, Paint()..color = Colors.deepPurple..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // Garis penanda umur aktif
    final curX = toX(currentAge.clamp(1.0, 42.0));
    canvas.drawLine(Offset(curX, 0), Offset(curX, h), Paint()..color = Colors.red..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HumidityCurvePainter extends CustomPainter {
  final double currentRh;

  HumidityCurvePainter({required this.currentRh});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sumbu X: 30 s/d 95
    double toX(double rh) => ((rh - 30.0) / 65.0) * w;
    double toY(double mu) => h - (mu * (h - 20)) - 10;

    // 1. Rendah: 0, 0, 50, 58
    final pathRendah = Path()
      ..moveTo(toX(30.0), toY(1.0))
      ..lineTo(toX(50.0), toY(1.0))
      ..lineTo(toX(58.0), toY(0.0));
    canvas.drawPath(pathRendah, Paint()..color = Colors.orange..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // 2. Ideal: 55, 60, 70, 75
    final pathIdeal = Path()
      ..moveTo(toX(55.0), toY(0.0))
      ..lineTo(toX(60.0), toY(1.0))
      ..lineTo(toX(70.0), toY(1.0))
      ..lineTo(toX(75.0), toY(0.0));
    canvas.drawPath(pathIdeal, Paint()..color = AppColors.emeraldGreen..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // 3. Tinggi: 72, 78, 100, 100
    final pathTinggi = Path()
      ..moveTo(toX(72.0), toY(0.0))
      ..lineTo(toX(78.0), toY(1.0))
      ..lineTo(toX(95.0), toY(1.0));
    canvas.drawPath(pathTinggi, Paint()..color = Colors.blueAccent..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // Garis penanda RH aktif
    final curX = toX(currentRh.clamp(30.0, 95.0));
    canvas.drawLine(Offset(curX, 0), Offset(curX, h), Paint()..color = Colors.red..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ScoreOutputCurvePainter extends CustomPainter {
  final double currentScore;

  ScoreOutputCurvePainter({required this.currentScore});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sumbu X: 0 s/d 100
    double toX(double s) => (s / 100.0) * w;
    double toY(double mu) => h - (mu * (h - 20)) - 10;

    // 1. Rendah: trapesium 0, 0, 30, 55
    final pathRendah = Path()
      ..moveTo(toX(0), toY(1.0))
      ..lineTo(toX(30), toY(1.0))
      ..lineTo(toX(55), toY(0.0));
    canvas.drawPath(pathRendah, Paint()..color = Colors.red..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // 2. Sedang: segitiga 45, 60, 75
    final pathSedang = Path()
      ..moveTo(toX(45), toY(0.0))
      ..lineTo(toX(60), toY(1.0))
      ..lineTo(toX(75), toY(0.0));
    canvas.drawPath(pathSedang, Paint()..color = Colors.amber..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // 3. Tinggi: trapesium 70, 85, 100, 100
    final pathTinggi = Path()
      ..moveTo(toX(70), toY(0.0))
      ..lineTo(toX(85), toY(1.0))
      ..lineTo(toX(100), toY(1.0));
    canvas.drawPath(pathTinggi, Paint()..color = AppColors.emeraldGreen..strokeWidth = 2.5..style = PaintingStyle.stroke);

    // Garis penanda skor hasil defuzzifikasi
    final curX = toX(currentScore.clamp(0.0, 100.0));
    canvas.drawLine(Offset(curX, 0), Offset(curX, h), Paint()..color = AppColors.primary..strokeWidth = 3);
    canvas.drawCircle(Offset(curX, toY(0)), 5, Paint()..color = AppColors.primary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

