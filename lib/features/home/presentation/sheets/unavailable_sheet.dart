import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'app_sheet.dart';

/// Shared copy for screens whose content needs a backend the project does not
/// have yet (no fake data is shown in their place).
abstract final class UnavailableContent {
  static const message = 'لا يوجد محتوى متاح في هذا القسم حالياً';
}

/// Explains that a section (notifications, chat, packages, …) has no content
/// available yet.
Future<void> showUnavailableSheet(
  BuildContext context, {
  required String title,
  IconData icon = Icons.inbox_outlined,
  String message = UnavailableContent.message,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetHeader(title: title),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 36),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 36, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
