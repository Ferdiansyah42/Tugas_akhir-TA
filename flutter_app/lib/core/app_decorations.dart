import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gaya Visual, Bayangan Card, dan Tipografi Terstandarisasi
class AppDecorations {
  static BoxDecoration cardBoxDecoration({Color? color, Border? border}) {
    return BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: border,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration tileBoxDecoration({Color? borderColor, double borderWidth = 1}) {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: borderColor ?? AppColors.outline,
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 6,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  static const TextStyle headlineBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: -0.3,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.textHeadline,
  );

  static const TextStyle captionMuted = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );
}
