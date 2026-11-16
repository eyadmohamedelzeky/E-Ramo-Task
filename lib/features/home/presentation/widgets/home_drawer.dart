import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/user_profile.dart';
import 'count_badge.dart';

/// Entries of the "المزيد" drawer, in on-screen order.
enum DrawerMenuItem {
  favorites('عقاراتي المفضلة', Icons.favorite),
  notifications('الإشعارات', Icons.notifications),
  messages('الدردشة', Icons.forum),
  addProperty('أضف عقارك', Icons.apartment),
  packages('شراء باقات', null),
  latestProjects('أحدث المشاريع', Icons.location_city),
  helpCenter('مركز المساعده', Icons.live_help),
  customerService('خدمة العملاء', Icons.support_agent),
  joinUs('إنضم إلينا', Icons.person),
  logout('تسجيل الخروج', Icons.logout_rounded);

  const DrawerMenuItem(this.label, this.icon);

  final String label;

  /// `null` for [packages], which uses the crown SVG.
  final IconData? icon;
}

/// Side menu opened by the header's menu button ("Frame 34343" in the
/// design). Used as the scaffold's end drawer, so in RTL it slides in from
/// the left, on the same side as the menu button.
///
/// Layout, top to bottom (the user's identity comes first, as expected of a
/// side menu): the profile header (photo, name, city), then the "المزيد"
/// section title with the country selector, then the menu tiles. It closes
/// like any drawer: tap outside, swipe, system back, or picking an item.
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.profile,
    required this.notificationCount,
    required this.messageCount,
    required this.onItemSelected,
    required this.onProfileTap,
    required this.onCountryTap,
  });

  static const title = 'المزيد';
  static const titleKey = ValueKey('drawer-title');
  static const profileKey = ValueKey('drawer-profile');
  static const countryKey = ValueKey('drawer-country');

  /// 232dp of a 375dp frame in the design.
  static const widthFactor = 232 / 375;

  final UserProfile profile;
  final int notificationCount;
  final int messageCount;
  final ValueChanged<DrawerMenuItem> onItemSelected;
  final VoidCallback onProfileTap;
  final VoidCallback onCountryTap;

  int _badgeFor(DrawerMenuItem item) => switch (item) {
    DrawerMenuItem.notifications => notificationCount,
    DrawerMenuItem.messages => messageCount,
    _ => 0,
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Drawer(
      key: const ValueKey('home-drawer'),
      width: (screenWidth * widthFactor).clamp(240.0, 320.0),
      backgroundColor: AppColors.drawerBackground,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile header: the first thing at the top of the menu.
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              child: _ProfileTile(profile: profile, onTap: onProfileTap),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(12, 14, 12, 24 + bottomInset),
              children: [
                // "المزيد" now titles the options below it, next to the
                // country selector (the pairing from the design's top bar).
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            title,
                            key: titleKey,
                            style: AppTextStyles.drawerTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      _CountrySelector(onTap: onCountryTap),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                for (final item in DrawerMenuItem.values) ...[
                  _DrawerTile(
                    item: item,
                    badgeCount: _badgeFor(item),
                    onTap: () => onItemSelected(item),
                  ),
                  if (item != DrawerMenuItem.values.last)
                    const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountrySelector extends StatelessWidget {
  const _CountrySelector({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'اختيار الدولة: مصر',
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.surface,
          shape: StadiumBorder(),
          shadows: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: HomeDrawer.countryKey,
            onTap: onTap,
            customBorder: const StadiumBorder(),
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EgyptFlag(size: 18),
                  SizedBox(width: 3),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.navy,
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

/// Round Egyptian flag (red, white with the golden eagle, black).
class EgyptFlag extends StatelessWidget {
  const EgyptFlag({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ClipOval(
        child: SizedBox.square(
          dimension: size,
          child: Column(
            // Stretch: the childless stripes would otherwise be 0dp wide.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(child: ColoredBox(color: Color(0xFFCE1126))),
              Expanded(
                child: ColoredBox(
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      width: size * 0.18,
                      height: size * 0.24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC09300),
                        borderRadius: BorderRadius.circular(size * 0.05),
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(child: ColoredBox(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.profile, required this.onTap});

  final UserProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: HomeDrawer.profileKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.2),
              ),
              child: ClipOval(
                child: Image.asset(
                  profile.avatarAsset,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  semanticLabel: profile.name,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profile.name,
                    style: AppTextStyles.profileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    profile.city,
                    style: AppTextStyles.profileCity,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Mirrors to "‹" in RTL.
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 8),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: AppColors.textBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.item,
    required this.badgeCount,
    required this.onTap,
  });

  final DrawerMenuItem item;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = item == DrawerMenuItem.logout
        ? AppColors.favorite
        : AppColors.primary;
    final icon = item.icon;
    return Material(
      color: AppColors.drawerTile,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        key: ValueKey('drawer-${item.name}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 45),
          child: Row(
            children: [
              const SizedBox(width: 10),
              SizedBox.square(
                dimension: 19,
                child: icon != null
                    ? Icon(icon, size: 19, color: color)
                    : SvgPicture.asset(
                        AppAssets.iconCrown,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(item.label, style: AppTextStyles.drawerItem),
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 6),
                CountBadge(count: badgeCount, size: 11),
              ],
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }
}
