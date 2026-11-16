import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Destinations of the bottom navigation, in visual right-to-left order.
enum HomeNavDestination {
  developers('المطورون'),
  market('السوق'),
  home('الرئيسية'),
  offers('العروض'),
  myProperties('عقاراتى');

  const HomeNavDestination(this.label);

  final String label;
}

/// Floating white navigation card with the raised teal home/search button.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.current,
    required this.onSelected,
  });

  static const _sideMargin = 15.0;
  static const _bottomMargin = 6.0;
  static const _barHeight = 62.0;
  static const _centerButtonSize = 66.0;

  /// How far the centre button rises above the white bar.
  static const _protrusion = 24.0;

  final HomeNavDestination current;
  final ValueChanged<HomeNavDestination> onSelected;

  @override
  Widget build(BuildContext context) {
    final systemInset = MediaQuery.viewPaddingOf(context).bottom;
    final insidePadding = (systemInset - _bottomMargin).clamp(0.0, 64.0);
    final barHeight = _barHeight + insidePadding;

    return SizedBox(
      height: _protrusion + barHeight + _bottomMargin,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: _sideMargin,
            right: _sideMargin,
            bottom: _bottomMargin,
            height: barHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                  bottom: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(13, 9, 13, 7 + insidePadding),
                child: Row(
                  children: [
                    _item(HomeNavDestination.developers),
                    _item(HomeNavDestination.market),
                    const SizedBox(width: _centerButtonSize),
                    _item(HomeNavDestination.offers),
                    _item(HomeNavDestination.myProperties),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: _CenterButton(
                size: _centerButtonSize,
                selected: current == HomeNavDestination.home,
                onTap: () => onSelected(HomeNavDestination.home),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(HomeNavDestination destination) {
    return Expanded(
      child: _NavItem(
        destination: destination,
        selected: current == destination,
        onTap: () => onSelected(destination),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final HomeNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? AppColors.primary : AppColors.navIcon;
    final labelStyle = selected
        ? AppTextStyles.navLabel.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          )
        : AppTextStyles.navLabel;

    return Semantics(
      button: true,
      selected: selected,
      child: InkResponse(
        key: ValueKey('nav-${destination.name}'),
        onTap: onTap,
        radius: 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 24,
              child: _icon(destination, iconColor),
            ),
            const SizedBox(height: 3),
            Text(
              destination.label,
              style: labelStyle,
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _icon(HomeNavDestination destination, Color color) {
    final filter = ColorFilter.mode(color, BlendMode.srcIn);
    return switch (destination) {
      HomeNavDestination.developers => SvgPicture.asset(
        AppAssets.iconDevelopers,
        colorFilter: filter,
      ),
      HomeNavDestination.market => Icon(
        Icons.storefront_outlined,
        color: color,
        size: 24,
      ),
      HomeNavDestination.offers => Icon(
        Icons.local_fire_department,
        color: color,
        size: 24,
      ),
      HomeNavDestination.myProperties => SvgPicture.asset(
        AppAssets.iconMyProperties,
        colorFilter: filter,
      ),
      HomeNavDestination.home => const SizedBox.shrink(),
    };
  }
}

class _CenterButton extends StatelessWidget {
  const _CenterButton({
    required this.size,
    required this.selected,
    required this.onTap,
  });

  final double size;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: HomeNavDestination.home.label,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            key: const ValueKey('nav-home'),
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.iconHomeSearch,
                width: 31,
                height: 31,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
