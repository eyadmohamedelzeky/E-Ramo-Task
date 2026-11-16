import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

/// Section title on the start (right) side and "مشاهدة الكل" on the end side.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onViewAll});

  static const horizontalPadding = 20.0;
  static const viewAllLabel = 'مشاهدة الكل';

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: AppTextStyles.sectionTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (onViewAll != null) ...[
            const SizedBox(width: 12),
            InkWell(
              onTap: onViewAll,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Text(viewAllLabel, style: AppTextStyles.viewAll),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
