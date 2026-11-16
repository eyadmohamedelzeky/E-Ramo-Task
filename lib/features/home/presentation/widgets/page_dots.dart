import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Carousel position indicator. Laid out left-to-right with the first page
/// on the left, as in the design.
class PageDots extends StatelessWidget {
  const PageDots({
    super.key,
    required this.count,
    required this.current,
    this.onDotTap,
  });

  static const dotSize = 7.0;

  final int count;
  final int current;
  final ValueChanged<int>? onDotTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            Semantics(
              button: onDotTap != null,
              selected: i == current,
              label: '${i + 1} / $count',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDotTap == null ? null : () => onDotTap!(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.5,
                    vertical: 4,
                  ),
                  child: AnimatedContainer(
                    key: ValueKey('dot-$i'),
                    duration: const Duration(milliseconds: 200),
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == current
                          ? AppColors.primary
                          : AppColors.dotInactive,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
