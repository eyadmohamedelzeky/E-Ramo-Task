import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/property_listing.dart';

/// "الكل | للبيع | للإيجار" filter. `null` means "all".
class PurposeFilterTabs extends StatelessWidget {
  const PurposeFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const allLabel = 'الكل';

  final ListingPurpose? selected;
  final ValueChanged<ListingPurpose?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterTab(
          key: const ValueKey('filter-all'),
          label: allLabel,
          selected: selected == null,
          onTap: () => onChanged(null),
        ),
        for (final purpose in ListingPurpose.values) ...[
          const _TabDivider(),
          _FilterTab(
            key: ValueKey('filter-${purpose.name}'),
            label: purpose.label,
            selected: selected == purpose,
            onTap: () => onChanged(purpose),
          ),
        ],
      ],
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: selected
                ? AppTextStyles.filterTabSelected
                : AppTextStyles.filterTab,
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

class _TabDivider extends StatelessWidget {
  const _TabDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 11,
      margin: const EdgeInsets.symmetric(horizontal: 9),
      color: AppColors.tabDivider,
    );
  }
}
