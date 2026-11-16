import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Small red unread-count bubble (header icons and drawer items).
class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count, this.size = 12});

  final int count;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return MediaQuery.withNoTextScaling(
      child: Container(
        constraints: BoxConstraints(minWidth: size, minHeight: size),
        padding: EdgeInsets.symmetric(horizontal: size * 0.18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.badge,
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Text(
          count > 9 ? '9+' : '$count',
          style: TextStyle(
            fontSize: size * 0.66,
            fontWeight: FontWeight.w700,
            height: 1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
