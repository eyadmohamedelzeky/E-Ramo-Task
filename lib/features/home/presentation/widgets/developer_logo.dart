import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/property_listing.dart';

/// "بواسطة" caption above the developer's oval monogram logo.
class DeveloperBadge extends StatelessWidget {
  const DeveloperBadge({super.key, required this.developer});

  static const byLabel = 'بواسطة';

  final Developer developer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(byLabel, style: AppTextStyles.developerCaption),
        const SizedBox(height: 1),
        DeveloperLogo(developer: developer),
      ],
    );
  }
}

class DeveloperLogo extends StatelessWidget {
  const DeveloperLogo({
    super.key,
    required this.developer,
    this.width = 40,
    this.height = 28,
  });

  final Developer developer;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scale = height / 28;
    return Semantics(
      label: developer.name,
      image: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.all(
            Radius.elliptical(width / 2, height / 2),
          ),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: ExcludeSemantics(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  developer.monogram,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12.5 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: -1.6 * scale,
                    color: AppColors.developerRed,
                  ),
                ),
                SizedBox(height: 1.5 * scale),
                Text(
                  developer.caption,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 3 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: AppColors.developerNavy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
