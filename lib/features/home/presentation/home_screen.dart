import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/home_content.dart';
import '../models/promo_slide.dart';
import 'home_feed.dart';
import 'sheets/choice_sheet.dart';
import 'sheets/contact_request_sheet.dart';
import 'sheets/favorites_sheet.dart';
import 'sheets/projects_sheet.dart';
import 'sheets/search_results_sheet.dart';
import 'sheets/unavailable_sheet.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_drawer.dart';
import 'widgets/home_header.dart';

/// Home screen: the scrollable feed, the "المزيد" drawer and the floating
/// bottom navigation.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const cityPickerTitle = 'اختر المدينة';
  static const countryPickerTitle = 'اختر الدولة';
  static const country = 'مصر';
  static const profileTitle = 'الملف الشخصي';
  static const logoutUnavailableMessage =
      'تسجيل الخروج غير متاح حالياً لأن التطبيق غير مرتبط بنظام حسابات.';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();
  HomeNavDestination _destination = HomeNavDestination.home;

  /// City chosen with the header's city picker.
  String _city = HomeContent.cities.first.name;

  /// Contact requests captured this session. There is no backend in the
  /// project, so they are kept in memory only.
  final List<ContactRequest> _contactRequests = [];

  bool get _onHome => _destination == HomeNavDestination.home;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onNavSelected(HomeNavDestination destination) {
    if (destination == HomeNavDestination.home &&
        _onHome &&
        _scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    setState(() => _destination = destination);
  }

  Future<void> _requestContact({
    required String subject,
    required String description,
    String title = ContactRequestForm.defaultTitle,
  }) async {
    final request = await showContactRequestSheet(
      context,
      title: title,
      subject: subject,
      description: description,
    );
    if (request == null || !mounted) return;
    setState(() => _contactRequests.add(request));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('تم تسجيل طلب التواصل باسم ${request.name}')),
      );
  }

  void _onContactTap(PromoSlide slide) =>
      _requestContact(subject: slide.title, description: slide.subtitle);

  Future<void> _pickCity() async {
    final city = await showChoiceSheet<String>(
      context,
      title: HomeScreen.cityPickerTitle,
      selected: _city,
      choices: [
        for (final city in HomeContent.cities)
          SheetChoice(
            value: city.name,
            label: city.name,
            subtitle: '${city.forSaleLabel}  •  ${city.forRentLabel}',
          ),
      ],
    );
    if (city == null || !mounted) return;
    setState(() => _city = city);
  }

  void _pickCountry() {
    // Egypt is the only market the app (and its data) covers.
    showChoiceSheet<String>(
      context,
      title: HomeScreen.countryPickerTitle,
      selected: HomeScreen.country,
      choices: const [
        SheetChoice(
          value: HomeScreen.country,
          label: HomeScreen.country,
          leading: EgyptFlag(size: 26),
        ),
      ],
    );
  }

  void _search(String query) {
    showSearchResultsSheet(
      context,
      query: query,
      results: HomeContent.search(query),
    );
  }

  void _openMessages() => showUnavailableSheet(
    context,
    title: HomeHeader.messagesLabel,
    icon: Icons.forum_outlined,
  );

  void _openNotifications() => showUnavailableSheet(
    context,
    title: HomeHeader.notificationsLabel,
    icon: Icons.notifications_none_rounded,
  );

  void _closeDrawer() => _scaffoldKey.currentState?.closeEndDrawer();

  void _openProfile() {
    _closeDrawer();
    showUnavailableSheet(
      context,
      title: HomeScreen.profileTitle,
      icon: Icons.person_outline_rounded,
    );
  }

  void _onDrawerItem(DrawerMenuItem item) {
    _closeDrawer();
    switch (item) {
      case DrawerMenuItem.favorites:
        showFavoritesSheet(context, title: item.label);
      case DrawerMenuItem.notifications:
        _openNotifications();
      case DrawerMenuItem.messages:
        _openMessages();
      case DrawerMenuItem.addProperty:
        _requestContact(
          title: item.label,
          subject: item.label,
          description: 'اترك بياناتك وسيتواصل معك فريقنا لإضافة عقارك.',
        );
      case DrawerMenuItem.packages:
        showUnavailableSheet(
          context,
          title: item.label,
          icon: Icons.workspace_premium_outlined,
        );
      case DrawerMenuItem.latestProjects:
        showProjectsSheet(
          context,
          title: item.label,
          projects: HomeContent.projects,
        );
      case DrawerMenuItem.helpCenter:
        showUnavailableSheet(
          context,
          title: item.label,
          icon: Icons.contact_support_outlined,
        );
      case DrawerMenuItem.customerService:
        _requestContact(
          title: item.label,
          subject: item.label,
          description: 'اترك بياناتك وسيتواصل معك فريق خدمة العملاء.',
        );
      case DrawerMenuItem.joinUs:
        _requestContact(
          title: item.label,
          subject: item.label,
          description: 'اترك بياناتك وسنتواصل معك بخصوص الانضمام إلينا.',
        );
      case DrawerMenuItem.logout:
        showUnavailableSheet(
          context,
          title: item.label,
          icon: Icons.logout_rounded,
          message: HomeScreen.logoutUnavailableMessage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final header = HomeHeader(
      city: _city,
      notificationCount: HomeContent.unreadNotifications,
      messageCount: HomeContent.unreadMessages,
      onCityTap: _pickCity,
      onMessagesTap: _openMessages,
      onNotificationsTap: _openNotifications,
      onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer(),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
      child: PopScope(
        // Back from another tab returns to the home feed first.
        canPop: _onHome,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) setState(() => _destination = HomeNavDestination.home);
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          extendBody: true,
          // The menu button sits on the left of the header, so the "المزيد"
          // panel slides in from that side: the end drawer in RTL.
          endDrawer: HomeDrawer(
            profile: HomeContent.profile,
            notificationCount: HomeContent.unreadNotifications,
            messageCount: HomeContent.unreadMessages,
            onItemSelected: _onDrawerItem,
            onProfileTap: _openProfile,
            onCountryTap: _pickCountry,
          ),
          body: IndexedStack(
            index: _onHome ? 0 : 1,
            children: [
              HomeFeed(
                scrollController: _scrollController,
                header: header,
                onSearch: _search,
                onContactTap: _onContactTap,
              ),
              if (_onHome)
                const SizedBox.shrink()
              else
                NavDestinationEmptyView(
                  destination: _destination,
                  onBackHome: () => _onNavSelected(HomeNavDestination.home),
                ),
            ],
          ),
          bottomNavigationBar: HomeBottomNav(
            current: _destination,
            onSelected: _onNavSelected,
          ),
        ),
      ),
    );
  }
}

/// Shown for the bottom-navigation tabs that are outside the supplied design
/// (المطورون، السوق، العروض، عقاراتى). No data source exists for them yet.
class NavDestinationEmptyView extends StatelessWidget {
  const NavDestinationEmptyView({
    super.key,
    required this.destination,
    required this.onBackHome,
  });

  static const message = UnavailableContent.message;

  final HomeNavDestination destination;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(32, insets.top, 32, insets.bottom),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(destination.label, style: AppTextStyles.sheetTitle),
            const SizedBox(height: 6),
            Text(
              message,
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onBackHome,
              icon: const Icon(Icons.home_outlined),
              label: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}
