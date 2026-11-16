import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'app_sheet.dart';

/// One option of [showChoiceSheet].
class SheetChoice<T> {
  const SheetChoice({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
  });

  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
}

/// Single-choice picker (header city, drawer country). Returns the chosen
/// value, or `null` when dismissed.
Future<T?> showChoiceSheet<T>(
  BuildContext context, {
  required String title,
  required List<SheetChoice<T>> choices,
  required T selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetHeader(title: title),
          for (final choice in choices)
            ListTile(
              key: ValueKey('choice-${choice.value}'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: choice.leading,
              title: Text(
                choice.label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: choice.value == selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
              subtitle: choice.subtitle == null
                  ? null
                  : Text(
                      choice.subtitle!,
                      style: AppTextStyles.location.copyWith(fontSize: 12),
                    ),
              trailing: choice.value == selected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                      color: AppColors.dotInactive,
                    ),
              selected: choice.value == selected,
              onTap: () => Navigator.of(context).pop(choice.value),
            ),
        ],
      ),
    ),
  );
}
