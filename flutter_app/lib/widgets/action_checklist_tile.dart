import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Tile Item Checklist Tindakan Nyata di Kandang
/// Mendukung aksi penyelesaian interaktif (checked/unchecked)
class ActionChecklistTile extends StatelessWidget {
  final String title;
  final String actionText;
  final String iconName;
  final bool isDone;
  final ValueChanged<bool?> onChanged;

  const ActionChecklistTile({
    super.key,
    required this.title,
    required this.actionText,
    required this.iconName,
    required this.isDone,
    required this.onChanged,
  });

  IconData _resolveIcon(String name) {
    switch (name) {
      case 'mode_fan':
      case 'fan':
        return Icons.air;
      case 'curtains':
      case 'window':
        return Icons.curtains;
      case 'thermostat':
        return Icons.device_thermostat;
      default:
        return Icons.water_drop;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemIcon = _resolveIcon(iconName);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDone ? AppColors.emeraldGreen : AppColors.outline,
          width: isDone ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: CheckboxListTile(
          value: isDone,
          activeColor: AppColors.primary,
          onChanged: onChanged,
          secondary: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDone ? AppColors.emeraldBg : AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(itemIcon, color: AppColors.primary, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? AppColors.textMuted : AppColors.textHeadline,
            ),
          ),
          subtitle: Text(
            actionText,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              decoration: isDone ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}
