import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'brand_logo.dart';
import 'count_badge.dart';

/// Top of the home page: the centred logo, then the city picker on the start
/// (right) side and the chat / notifications / menu buttons.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.city,
    required this.notificationCount,
    required this.messageCount,
    required this.onCityTap,
    required this.onMessagesTap,
    required this.onNotificationsTap,
    required this.onMenuTap,
  });

  static const cityKey = ValueKey('header-city');
  static const messagesKey = ValueKey('header-messages');
  static const notificationsKey = ValueKey('header-notifications');
  static const menuKey = ValueKey('header-menu');

  static const messagesLabel = 'الدردشة';
  static const notificationsLabel = 'الإشعارات';
  static const menuLabel = 'القائمة';

  /// In the design the icon group ends ~72dp from the left edge of a 375dp
  /// frame, while the city name sits close to the right edge.
  static const _endInsetFactor = 72 / 375;

  final String city;
  final int notificationCount;
  final int messageCount;
  final VoidCallback onCityTap;
  final VoidCallback onMessagesTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: BrandLogo()),
        // Design: icon centres 81dp from the top of the page and the search
        // field directly below them (2dp under the 28dp icons).
        const SizedBox(height: 29),
        LayoutBuilder(
          builder: (context, constraints) {
            final endInset = (constraints.maxWidth * _endInsetFactor).clamp(
              12.0,
              140.0,
            );
            return Row(
              children: [
                const SizedBox(width: 4),
                _CitySelector(city: city, onTap: onCityTap),
                const Spacer(),
                _HeaderIconButton(
                  key: messagesKey,
                  label: messagesLabel,
                  badgeCount: messageCount,
                  onTap: onMessagesTap,
                  icon: SvgPicture.asset(
                    AppAssets.iconChatBubbles,
                    colorFilter: const ColorFilter.mode(
                      AppColors.headerIcon,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                _HeaderIconButton(
                  key: notificationsKey,
                  label: notificationsLabel,
                  badgeCount: notificationCount,
                  onTap: onNotificationsTap,
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    size: 27,
                    color: AppColors.headerIcon,
                  ),
                ),
                _HeaderIconButton(
                  key: menuKey,
                  label: menuLabel,
                  onTap: onMenuTap,
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 32,
                    color: AppColors.headerIcon,
                  ),
                ),
                SizedBox(width: endInset),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CitySelector extends StatelessWidget {
  const _CitySelector({required this.city, required this.onTap});

  final String city;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'اختيار المدينة',
      child: InkWell(
        key: HomeHeader.cityKey,
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(city, style: AppTextStyles.headerCity),
              const SizedBox(width: 3),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: badgeCount > 0 ? '$label ($badgeCount)' : label,
        child: InkResponse(
          onTap: onTap,
          radius: 22,
          child: SizedBox(
            width: 44,
            height: 32,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox.square(dimension: 28, child: Center(child: icon)),
                  if (badgeCount > 0)
                    Positioned(
                      right: -1,
                      bottom: 0,
                      child: CountBadge(count: badgeCount),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
