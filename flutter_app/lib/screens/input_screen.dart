import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../fuzzy/fuzzy_engine.dart';

/// Screen Tab 2: Input Evaluasi
/// Form interaktif untuk memasukkan data mikroklimat (Umur, Suhu, RH)
class InputScreen extends StatelessWidget {
  final double inputAge;
  final double inputTemp;
  final double inputRh;
  final FuzzyBroilerEngine engine;
  final ValueChanged<double> onAgeChanged;
  final ValueChanged<double> onTempChanged;
  final ValueChanged<double> onRhChanged;
  final void Function(PresetScenario preset) onApplyPreset;
  final VoidCallback onRunEvaluation;

  const InputScreen({
    super.key,
    required this.inputAge,
    required this.inputTemp,
    required this.inputRh,
    required this.engine,
    required this.onAgeChanged,
    required this.onTempChanged,
    required this.onRhChanged,
    required this.onApplyPreset,
    required this.onRunEvaluation,
  });

  @override
  Widget build(BuildContext context) {
    final targetTemp = engine.getTargetTemperature(inputAge.round());
    final dev = double.parse((inputTemp - targetTemp).toStringAsFixed(1));
    final phase = engine.getAgePhase(inputAge.round());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Input Evaluasi Mikroklimat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const Text(
          'Gunakan slider atau preset cepat untuk menguji respons inferensi secara langsung.',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),

        // Quick Preset Buttons (Sangat berguna saat sidang TA)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AppConstants.presetScenarios.map((preset) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(
                    preset.chipLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.secondaryContainer),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  onPressed: () => onApplyPreset(preset),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
              // 1. Umur Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: AppColors.primary, size: 18),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Umur: ${inputAge.round()} Hari',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textHeadline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      phase,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: inputAge,
                min: 1,
                max: 42,
                divisions: 41,
                activeColor: AppColors.primary,
                onChanged: onAgeChanged,
              ),

              // Live Target Temp Banner
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.secondaryContainer),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Target Cobb 500 / Ross 308:',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: AppColors.textBody),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${targetTemp.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Suhu Aktual Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.device_thermostat, color: AppColors.warningButton, size: 18),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Suhu: ${inputTemp.toStringAsFixed(1)}°C',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textHeadline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: dev.abs() <= 1.5 ? AppColors.emeraldBg : AppColors.warningBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Deviasi: ${dev >= 0 ? '+' : ''}${dev.toStringAsFixed(1)}°C',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: dev.abs() <= 1.5 ? AppColors.emeraldText : AppColors.warningTextDark,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: inputTemp,
                min: 18.0,
                max: 38.0,
                divisions: 200,
                activeColor: AppColors.warningButton,
                onChanged: onTempChanged,
              ),
              const SizedBox(height: 16),

              // 3. Kelembaban RH Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.water_drop, color: AppColors.primary, size: 18),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Kelembaban: ${inputRh.round()}%',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textHeadline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: inputRh >= 60 && inputRh <= 70
                          ? AppColors.emeraldBg
                          : AppColors.warningBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      inputRh < 55
                          ? 'Kering'
                          : (inputRh > 75 ? 'Terlalu Lembab' : 'Ideal (60-70%)'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: inputRh >= 60 && inputRh <= 70
                            ? AppColors.emeraldText
                            : AppColors.warningTextDark,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: inputRh,
                min: 30.0,
                max: 95.0,
                divisions: 65,
                activeColor: AppColors.primary,
                onChanged: onRhChanged,
              ),
              const SizedBox(height: 20),

              // Submit Action
              ElevatedButton.icon(
                onPressed: onRunEvaluation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.psychology, size: 22),
                label: const Text(
                  'Jalankan Inferensi Fuzzy',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

