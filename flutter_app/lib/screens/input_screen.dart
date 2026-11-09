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

        // Quick Preset Buttons (Menggunakan Wrap agar tidak terpotong di tepi layar)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.presetScenarios.map((preset) {
            return InkWell(
              onTap: () => onApplyPreset(preset),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondaryContainer),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      preset.iconEmoji,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      preset.name,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
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
              // 1. Umur Slider & Precision Stepper
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
                            'Umur Ayam: ${inputAge.round()} Hari',
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
              Row(
                children: [
                  IconButton(
                    onPressed: inputAge > 1 ? () => onAgeChanged((inputAge - 1).clamp(1.0, 42.0)) : null,
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary, size: 22),
                    tooltip: 'Kurangi 1 Hari',
                  ),
                  Expanded(
                    child: Slider(
                      value: inputAge,
                      min: 1,
                      max: 42,
                      divisions: 41,
                      activeColor: AppColors.primary,
                      onChanged: onAgeChanged,
                    ),
                  ),
                  IconButton(
                    onPressed: inputAge < 42 ? () => onAgeChanged((inputAge + 1).clamp(1.0, 42.0)) : null,
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 22),
                    tooltip: 'Tambah 1 Hari',
                  ),
                ],
              ),

              // Live Target Temp Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.secondaryContainer),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.insights, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Target Suhu Strain Hari ke-${inputAge.round()}:',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: AppColors.textBody),
                      ),
                    ),
                    const SizedBox(width: 6),
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

              // 2. Suhu Aktual Slider & Precision Stepper
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
                            'Suhu Ruangan: ${inputTemp.toStringAsFixed(1)}°C',
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
              Row(
                children: [
                  IconButton(
                    onPressed: inputTemp > 18.0 ? () => onTempChanged((inputTemp - 0.5).clamp(18.0, 38.0)) : null,
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.warningButton, size: 22),
                    tooltip: 'Kurangi 0.5°C',
                  ),
                  Expanded(
                    child: Slider(
                      value: inputTemp,
                      min: 18.0,
                      max: 38.0,
                      divisions: 200,
                      activeColor: AppColors.warningButton,
                      onChanged: onTempChanged,
                    ),
                  ),
                  IconButton(
                    onPressed: inputTemp < 38.0 ? () => onTempChanged((inputTemp + 0.5).clamp(18.0, 38.0)) : null,
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.warningButton, size: 22),
                    tooltip: 'Tambah 0.5°C',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Kelembaban RH Slider & Precision Stepper
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
                            'Kelembaban: ${inputRh.round()}% RH',
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
                      color: inputRh >= 55 && inputRh <= 75
                          ? AppColors.emeraldBg
                          : AppColors.warningBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      inputRh < 55
                          ? 'Kering (<55%)'
                          : (inputRh > 75 ? 'Lembab (>75%)' : 'Ideal (55-75%)'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: inputRh >= 55 && inputRh <= 75
                          ? AppColors.emeraldText
                          : AppColors.warningTextDark,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: inputRh > 30.0 ? () => onRhChanged((inputRh - 1.0).clamp(30.0, 95.0)) : null,
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary, size: 22),
                    tooltip: 'Kurangi 1%',
                  ),
                  Expanded(
                    child: Slider(
                      value: inputRh,
                      min: 30.0,
                      max: 95.0,
                      divisions: 65,
                      activeColor: AppColors.primary,
                      onChanged: onRhChanged,
                    ),
                  ),
                  IconButton(
                    onPressed: inputRh < 95.0 ? () => onRhChanged((inputRh + 1.0).clamp(30.0, 95.0)) : null,
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 22),
                    tooltip: 'Tambah 1%',
                  ),
                ],
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

