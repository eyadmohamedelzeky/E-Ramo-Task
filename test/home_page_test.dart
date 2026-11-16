import 'package:e_ramo_task/features/home/presentation/home_feed.dart';
import 'package:e_ramo_task/features/home/presentation/home_screen.dart';
import 'package:e_ramo_task/features/home/data/home_content.dart';
import 'package:e_ramo_task/features/home/presentation/sheets/contact_request_sheet.dart';
import 'package:e_ramo_task/features/home/presentation/sheets/search_results_sheet.dart';
import 'package:e_ramo_task/features/home/presentation/sheets/unavailable_sheet.dart';
import 'package:e_ramo_task/features/home/presentation/widgets/brand_logo.dart';
import 'package:e_ramo_task/features/home/presentation/widgets/featured_property_card.dart';
import 'package:e_ramo_task/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:e_ramo_task/features/home/presentation/widgets/home_drawer.dart';
import 'package:e_ramo_task/features/home/presentation/widgets/home_header.dart';
import 'package:e_ramo_task/features/home/presentation/widgets/home_search_bar.dart';
import 'package:e_ramo_task/features/home/presentation/widgets/project_card.dart';
import 'package:e_ramo_task/features/home/presentation/widgets/property_card.dart';
import 'package:e_ramo_task/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

Finder _inSection(ValueKey<String> section, Finder matching) =>
    find.descendant(of: find.byKey(section), matching: matching);

PageController _pageControllerIn(WidgetTester tester, ValueKey<String> key) =>
    tester.widget<PageView>(_inSection(key, find.byType(PageView))).controller!;

/// The vertical feed's scroll state (the feed also contains horizontal
/// carousels, so take the outermost Scrollable).
ScrollableState _feedScrollable(WidgetTester tester) =>
    tester.state<ScrollableState>(
      find
          .descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          )
          .first,
    );

Future<void> _closeSheet(WidgetTester tester) async {
  await tester.tap(find.byTooltip('إغلاق').last);
  await tester.pumpAndSettle();
}

Future<void> _openDrawer(WidgetTester tester) async {
  await tester.tap(find.byKey(HomeHeader.menuKey));
  await tester.pumpAndSettle();
  expect(find.byType(HomeDrawer), findsOneWidget);
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('renders all sections on one page in the screenshot order', (
    tester,
  ) async {
    await pumpApp(tester);

    const titles = [
      'عقارات مميزة في مصر',
      'اهم المشاريع العقارية في مصر',
      'إبحث عن عقارك بالمدينة',
      'أحدث الشقق في مصر',
      'أحدث الفيلات في مصر',
      'أحدث الدوبلكس في مصر',
      'اهم الأخبار',
    ];
    for (final title in titles) {
      expect(find.text(title), findsOneWidget);
    }
    expect(find.text('منزل احلامك الآن متوفر'), findsWidgets);
    expect(find.text('مكتبك لازم يكون انيق'), findsWidgets);
    expect(find.text(HomeSearchBar.hint), findsOneWidget);

    // Exactly one scrollable page, with sections stacked top to bottom.
    expect(find.byType(CustomScrollView), findsOneWidget);
    final tops = [
      for (final key in HomeSectionKeys.ordered)
        tester.getTopLeft(find.byKey(key)).dy,
    ];
    for (var i = 1; i < tops.length; i++) {
      expect(
        tops[i],
        greaterThan(tops[i - 1]),
        reason:
            '${HomeSectionKeys.ordered[i]} must follow '
            '${HomeSectionKeys.ordered[i - 1]}',
      );
    }
  });

  testWidgets('header shows the logo, city, unread badges and menu', (
    tester,
  ) async {
    await pumpApp(tester);
    const header = HomeSectionKeys.header;

    expect(_inSection(header, find.byType(BrandLogo)), findsOneWidget);
    expect(_inSection(header, find.text('القاهرة')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(HomeHeader.notificationsKey),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(HomeHeader.messagesKey),
        matching: find.text('5'),
      ),
      findsOneWidget,
    );

    // RTL: the city is on the right, the menu button left of the bell, the
    // bell left of the chat icon.
    final city = tester.getCenter(find.byKey(HomeHeader.cityKey)).dx;
    final chat = tester.getCenter(find.byKey(HomeHeader.messagesKey)).dx;
    final bell = tester.getCenter(find.byKey(HomeHeader.notificationsKey)).dx;
    final menu = tester.getCenter(find.byKey(HomeHeader.menuKey)).dx;
    expect(city, greaterThan(chat));
    expect(chat, greaterThan(bell));
    expect(bell, greaterThan(menu));
  });

  testWidgets('city picker changes the header city', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(HomeHeader.cityKey));
    await tester.pumpAndSettle();
    expect(find.text(HomeScreen.cityPickerTitle), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('choice-الجيزة')));
    await tester.pumpAndSettle();
    expect(find.text(HomeScreen.cityPickerTitle), findsNothing);
    expect(
      _inSection(HomeSectionKeys.header, find.text('الجيزة')),
      findsOneWidget,
    );
  });

  testWidgets('search validates the query and lists matching results', (
    tester,
  ) async {
    await pumpApp(tester);

    // Too short: a hint is shown and no sheet opens.
    await tester.tap(find.byKey(HomeSearchBar.submitKey));
    await tester.pumpAndSettle();
    expect(find.text(HomeSearchBar.tooShortMessage), findsOneWidget);
    expect(find.textContaining('نتائج البحث'), findsNothing);

    // Every word must match a listing or a project.
    await tester.enterText(find.byKey(HomeSearchBar.fieldKey), 'الشيخ زايد');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    final total = HomeContent.search('الشيخ زايد').total;
    expect(find.text(searchResultsTitle('الشيخ زايد', total)), findsOneWidget);
    expect(find.byKey(const ValueKey('result-featured-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('result-project-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('result-project-3')), findsNothing);
    await _closeSheet(tester);

    await tester.enterText(find.byKey(HomeSearchBar.fieldKey), 'مارينا');
    await tester.tap(find.byKey(HomeSearchBar.submitKey));
    await tester.pumpAndSettle();
    expect(find.text(noSearchResultsMessage('مارينا')), findsOneWidget);
    await _closeSheet(tester);

    // The clear button empties the field.
    await tester.tap(find.byKey(HomeSearchBar.clearKey));
    await tester.pump();
    expect(find.text('مارينا'), findsNothing);
  });

  testWidgets('hero carousel has no arrows and pages by swipe and dots', (
    tester,
  ) async {
    await pumpApp(tester);
    const hero = HomeSectionKeys.hero;
    final controller = _pageControllerIn(tester, hero);

    // "تواصل الآن" is a compact button (≈80dp), not a full-width bar.
    final cta = _inSection(hero, find.byKey(const ValueKey('banner-cta')));
    expect(tester.getSize(cta.first).width, lessThan(140));

    // The previous / next arrows were removed.
    expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);

    // Paging runs left-to-right: swipe left for the next slide.
    await tester.fling(
      _inSection(hero, find.byType(PageView)),
      const Offset(-300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(controller.page, 1);

    await tester.tap(_inSection(hero, find.byKey(const ValueKey('dot-3'))));
    await tester.pumpAndSettle();
    expect(controller.page, 3);
  });

  testWidgets('featured cards show the design content and filter', (
    tester,
  ) async {
    await pumpApp(tester);
    const section = HomeSectionKeys.featured;

    final card = find.byKey(const ValueKey('card-featured-1'));
    expect(card, findsOneWidget);
    for (final text in [
      '4,000,000 ج.م',
      'شقة سكنية للبيع تشطيب سوبر لوكس',
      '8,725sqft',
      'الشيخ زايد الجيزة',
      'منذ 4 ايام',
      'بواسطة',
      'للبيع',
      FeaturedBadge.label,
    ]) {
      expect(
        find.descendant(of: card, matching: find.textContaining(text)),
        findsWidgets,
        reason: text,
      );
    }
    // The photo is above the details in the vertical card.
    final photo = find.descendant(of: card, matching: find.byType(Image));
    final price = find.descendant(
      of: card,
      matching: find.textContaining('4,000,000'),
    );
    expect(tester.getCenter(photo).dy, lessThan(tester.getCenter(price).dy));

    // The rental card prints its monthly period.
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('card-featured-2')),
        matching: find.textContaining('شهريا'),
      ),
      findsOneWidget,
    );

    await tester.tap(
      _inSection(section, find.byKey(const ValueKey('filter-rent'))),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('card-featured-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('card-featured-1')), findsNothing);

    await tester.tap(
      _inSection(section, find.byKey(const ValueKey('filter-all'))),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('card-featured-1')), findsOneWidget);

    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('بواسطة GG Developments'), findsOneWidget);
  });

  testWidgets('project cards show the design content and open details', (
    tester,
  ) async {
    await pumpApp(tester);
    const section = HomeSectionKeys.projects;

    final card = find.byKey(const ValueKey('card-project-1'));
    for (final text in [
      'كمبوند الشيخ زايد',
      ProjectBadge.label,
      'الشيخ زايد الجيزة',
      'منذ 4 ايام',
      'بواسطة',
    ]) {
      expect(
        find.descendant(of: card, matching: find.text(text)),
        findsOneWidget,
        reason: text,
      );
    }
    expect(
      find.descendant(of: card, matching: find.byIcon(Icons.favorite)),
      findsOneWidget,
    );

    await tester.tap(_inSection(section, find.text('مشاهدة الكل')));
    await tester.pumpAndSettle();
    expect(find.text('اهم المشاريع العقارية في مصر (4)'), findsOneWidget);
    await _closeSheet(tester);

    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('بواسطة GG Developments'), findsOneWidget);
    expect(find.text('إزالة من المفضلة'), findsOneWidget);
    await tester.tap(find.text('إزالة من المفضلة'));
    await tester.pumpAndSettle();
    expect(find.text('إضافة إلى المفضلة'), findsOneWidget);
  });

  testWidgets('drawer lists the menu and its items open their content', (
    tester,
  ) async {
    await pumpApp(tester);
    await _openDrawer(tester);

    expect(find.text(HomeDrawer.title), findsOneWidget);
    expect(find.text('عبدالله محمد'), findsOneWidget);

    // The user's photo and name come first, then the "المزيد" title (with the
    // country selector beside it), then the menu items.
    final profileTop = tester.getTopLeft(find.byKey(HomeDrawer.profileKey)).dy;
    final titleTop = tester.getTopLeft(find.byKey(HomeDrawer.titleKey)).dy;
    final firstItemTop = tester
        .getTopLeft(find.byKey(const ValueKey('drawer-favorites')))
        .dy;
    expect(profileTop, lessThan(titleTop));
    expect(titleTop, lessThan(firstItemTop));
    expect(
      tester.getCenter(find.byKey(HomeDrawer.countryKey)).dy,
      closeTo(tester.getCenter(find.byKey(HomeDrawer.titleKey)).dy, 4),
    );
    // The profile header is the first thing at the top of the panel.
    expect(
      profileTop,
      lessThan(tester.getTopLeft(find.byType(HomeDrawer)).dy + 30),
    );

    // The panel is attached to the left edge, the side of the menu button.
    final panel = tester.getRect(find.byType(HomeDrawer));
    expect(panel.left, 0);
    expect(panel.right, lessThan(393 / 2 + 60));
    expect(
      tester.getCenter(find.byKey(HomeHeader.menuKey)).dx,
      lessThan(393 / 2),
    );

    // The round Egyptian flag draws all three full-width stripes.
    final stripes = find.descendant(
      of: find.byType(EgyptFlag),
      matching: find.byType(ColoredBox),
    );
    expect(stripes, findsNWidgets(3));
    for (var i = 0; i < 3; i++) {
      expect(tester.getSize(stripes.at(i)).width, 18);
    }
    for (final item in DrawerMenuItem.values) {
      expect(find.text(item.label), findsWidgets, reason: item.label);
    }
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('drawer-notifications')),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('drawer-messages')),
        matching: find.text('5'),
      ),
      findsOneWidget,
    );

    // Latest projects → the projects sheet (and the drawer closes).
    await tester.tap(find.byKey(const ValueKey('drawer-latestProjects')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeDrawer), findsNothing);
    expect(find.text('أحدث المشاريع (4)'), findsOneWidget);
    await _closeSheet(tester);

    // Favourites → the hearted listings and projects, updated live.
    await _openDrawer(tester);
    await tester.tap(find.byKey(const ValueKey('drawer-favorites')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('result-featured-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('result-project-1')), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('result-featured-1')),
        matching: find.byKey(const ValueKey('favorite-featured-1')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('result-featured-1')), findsNothing);
    await _closeSheet(tester);

    // Notifications have no data source: an honest empty state.
    await _openDrawer(tester);
    await tester.tap(find.byKey(const ValueKey('drawer-notifications')));
    await tester.pumpAndSettle();
    expect(find.text(UnavailableContent.message), findsOneWidget);
    await _closeSheet(tester);

    // Logout explains why it is unavailable.
    await _openDrawer(tester);
    await tester.tap(find.byKey(const ValueKey('drawer-logout')));
    await tester.pumpAndSettle();
    expect(find.text(HomeScreen.logoutUnavailableMessage), findsOneWidget);
    await _closeSheet(tester);

    // Country selector and the back arrow.
    await _openDrawer(tester);
    await tester.tap(find.byKey(HomeDrawer.countryKey));
    await tester.pumpAndSettle();
    expect(find.text(HomeScreen.countryPickerTitle), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('choice-مصر')));
    await tester.pumpAndSettle();
    // Tapping outside the panel (on the scrim, right of it) closes it.
    await tester.tapAt(const Offset(380, 600));
    await tester.pumpAndSettle();
    expect(find.byType(HomeDrawer), findsNothing);
  });

  testWidgets('drawer customer service records a contact request', (
    tester,
  ) async {
    await pumpApp(tester);
    await _openDrawer(tester);
    await tester.tap(find.byKey(const ValueKey('drawer-customerService')));
    await tester.pumpAndSettle();

    expect(find.byType(ContactRequestForm), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('contact-name')), 'منى');
    await tester.enterText(
      find.byKey(const ValueKey('contact-phone')),
      '01112345678',
    );
    await tester.tap(find.byKey(const ValueKey('contact-submit')));
    await tester.pumpAndSettle();
    expect(find.byType(ContactRequestForm), findsNothing);
    expect(find.text('تم تسجيل طلب التواصل باسم منى'), findsOneWidget);
  });

  testWidgets('header chat and bell open their (empty) sections', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(HomeHeader.messagesKey));
    await tester.pumpAndSettle();
    expect(find.text(UnavailableContent.message), findsOneWidget);
    await _closeSheet(tester);

    await tester.tap(find.byKey(HomeHeader.notificationsKey));
    await tester.pumpAndSettle();
    expect(find.text(UnavailableContent.message), findsOneWidget);
  });

  testWidgets('listing card shows the design content', (tester) async {
    await pumpApp(tester);

    final card = find.byKey(const ValueKey('card-duplex-1'));
    expect(card, findsOneWidget);
    for (final text in [
      '4,000,000 ج.م',
      '8,725sqft',
      '10',
      '5',
      'الشيخ زايد الجيزة',
      'منذ 4 ايام',
      'بواسطة',
      'للبيع',
    ]) {
      expect(
        find.descendant(of: card, matching: find.text(text)),
        findsOneWidget,
        reason: text,
      );
    }
    // The photo sits on the right of the details (RTL).
    final photo = find.descendant(of: card, matching: find.byType(Image));
    final price = find.descendant(
      of: card,
      matching: find.text('4,000,000 ج.م'),
    );
    expect(tester.getCenter(photo).dx, greaterThan(tester.getCenter(price).dx));
  });

  testWidgets('purpose tabs filter the listings and reset the dots', (
    tester,
  ) async {
    await pumpApp(tester);
    const section = HomeSectionKeys.duplexes;

    expect(_inSection(section, find.byType(PropertyCard)), findsWidgets);
    expect(
      _inSection(section, find.byKey(const ValueKey('dot-3'))),
      findsOneWidget,
    );

    await tester.tap(
      _inSection(section, find.byKey(const ValueKey('filter-rent'))),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('card-duplex-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('card-duplex-1')), findsNothing);
    expect(
      _inSection(section, find.byKey(const ValueKey('dot-1'))),
      findsNothing,
    );

    await tester.tap(
      _inSection(section, find.byKey(const ValueKey('filter-sale'))),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('card-duplex-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('card-duplex-3')), findsNothing);

    await tester.tap(
      _inSection(section, find.byKey(const ValueKey('filter-all'))),
    );
    await tester.pumpAndSettle();
    expect(
      _inSection(section, find.byKey(const ValueKey('dot-3'))),
      findsOneWidget,
    );
  });

  testWidgets('listing carousel pages by swipe and by dot', (tester) async {
    await pumpApp(tester);
    const section = HomeSectionKeys.villas;
    final controller = _pageControllerIn(tester, section);
    expect(controller.page, 0);

    // RTL: the next card is on the left, so swipe to the right.
    await tester.fling(
      find.byKey(const ValueKey('card-villa-1')),
      const Offset(300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(controller.page, 1);

    await tester.tap(_inSection(section, find.byKey(const ValueKey('dot-3'))));
    await tester.pumpAndSettle();
    // The last card cannot align to the start edge (padEnds: false), so the
    // carousel settles just short of page 3.
    expect(controller.page!.round(), 3);
  });

  testWidgets('carousels built after scrolling start on their first page', (
    tester,
  ) async {
    // A phone-sized screen, so the lower sections are only built on scroll.
    await pumpApp(tester, size: const Size(393, 852));
    expect(find.byKey(HomeSectionKeys.duplexes), findsNothing);

    final feed = find.byType(CustomScrollView);
    for (var i = 0; i < 40; i++) {
      if (find.byKey(const ValueKey('card-duplex-1')).evaluate().isNotEmpty) {
        break;
      }
      await tester.drag(feed, const Offset(0, -400));
      await tester.pumpAndSettle();
    }
    // Built well below the first screen, after the feed has scrolled.
    expect(_feedScrollable(tester).position.pixels, greaterThan(1000));
    expect(_pageControllerIn(tester, HomeSectionKeys.duplexes).page, 0);
    expect(find.byKey(const ValueKey('card-duplex-1')), findsOneWidget);
  });

  testWidgets('heart toggles the favourite state', (tester) async {
    await pumpApp(tester);
    final heart = find.byKey(const ValueKey('favorite-duplex-1'));

    expect(
      find.descendant(of: heart, matching: find.byIcon(Icons.favorite)),
      findsOneWidget,
    );
    await tester.tap(heart);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: heart, matching: find.byIcon(Icons.favorite_border)),
      findsOneWidget,
    );
  });

  testWidgets('banner swipes and dots change slides', (tester) async {
    await pumpApp(tester);
    const banner = HomeSectionKeys.banner;
    final controller = _pageControllerIn(tester, banner);
    final pages = _inSection(banner, find.byType(PageView));

    // Swiping right on the first slide stays on it.
    await tester.fling(pages, const Offset(300, 0), 1000);
    await tester.pumpAndSettle();
    expect(controller.page, 0);

    await tester.fling(pages, const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(controller.page, 1);

    await tester.fling(pages, const Offset(300, 0), 1000);
    await tester.pumpAndSettle();
    expect(controller.page, 0);

    await tester.tap(_inSection(banner, find.byKey(const ValueKey('dot-3'))));
    await tester.pumpAndSettle();
    expect(controller.page, 3);
  });

  testWidgets('"مشاهدة الكل" opens the full list for a section', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(
      _inSection(HomeSectionKeys.duplexes, find.text('مشاهدة الكل')),
    );
    await tester.pumpAndSettle();
    expect(find.text('أحدث الدوبلكس في مصر (4)'), findsOneWidget);

    await tester.tap(find.byTooltip('إغلاق'));
    await tester.pumpAndSettle();
    expect(find.text('أحدث الدوبلكس في مصر (4)'), findsNothing);

    await tester.tap(
      _inSection(HomeSectionKeys.featured, find.text('مشاهدة الكل')),
    );
    await tester.pumpAndSettle();
    expect(find.text('عقارات مميزة في مصر (4)'), findsOneWidget);
    await _closeSheet(tester);

    await tester.tap(
      _inSection(HomeSectionKeys.news, find.text('مشاهدة الكل')),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('إغلاق'), findsOneWidget);
  });

  testWidgets('tapping cards opens details, city and article sheets', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const ValueKey('card-apartment-1')));
    await tester.pumpAndSettle();
    expect(find.text('بواسطة GG Developments'), findsOneWidget);
    await tester.tap(find.byTooltip('إغلاق'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('الجيزة'));
    await tester.pumpAndSettle();
    expect(find.textContaining('عقارات في الجيزة'), findsOneWidget);
    await tester.tap(find.byTooltip('إغلاق'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('أحدث سوق إيجي').first);
    await tester.pumpAndSettle();
    expect(find.byTooltip('إغلاق'), findsOneWidget);
  });

  testWidgets('contact button validates and records a request', (tester) async {
    await pumpApp(tester);

    await tester.tap(
      _inSection(
        HomeSectionKeys.hero,
        find.byKey(const ValueKey('banner-cta')),
      ).first,
    );
    await tester.pumpAndSettle();
    expect(find.text(ContactRequestForm.defaultTitle), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('contact-submit')));
    await tester.pumpAndSettle();
    expect(find.text(ContactRequestForm.nameError), findsOneWidget);
    expect(find.text(ContactRequestForm.phoneError), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('contact-name')), 'أحمد');
    await tester.enterText(
      find.byKey(const ValueKey('contact-phone')),
      '01012345678',
    );
    await tester.tap(find.byKey(const ValueKey('contact-submit')));
    await tester.pumpAndSettle();

    expect(find.text(ContactRequestForm.defaultTitle), findsNothing);
    expect(find.text('تم تسجيل طلب التواصل باسم أحمد'), findsOneWidget);
  });

  testWidgets('bottom navigation switches tabs and returns home', (
    tester,
  ) async {
    await pumpApp(tester, size: const Size(393, 852));

    for (final destination in HomeNavDestination.values) {
      if (destination == HomeNavDestination.home) continue;
      expect(find.text(destination.label), findsOneWidget);
    }

    await tester.tap(find.byKey(const ValueKey('nav-market')));
    await tester.pumpAndSettle();
    expect(find.text(NavDestinationEmptyView.message), findsOneWidget);

    await tester.tap(find.text('العودة للرئيسية'));
    await tester.pumpAndSettle();
    expect(find.text(NavDestinationEmptyView.message), findsNothing);

    // Home button scrolls the feed back to the top.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    final scrollable = _feedScrollable(tester);
    expect(scrollable.position.pixels, greaterThan(0));
    await tester.tap(find.byKey(const ValueKey('nav-home')));
    await tester.pumpAndSettle();
    expect(scrollable.position.pixels, 0);
  });

  group('responsive layout', () {
    const sizes = {
      'small phone': Size(320, 568),
      'standard phone': Size(360, 640),
      'pixel': Size(393, 785),
      'large phone': Size(430, 932),
      'tablet portrait': Size(800, 1280),
      'tablet landscape': Size(1280, 800),
    };

    for (final MapEntry(key: name, value: size) in sizes.entries) {
      testWidgets('scrolls end-to-end without overflow on $name', (
        tester,
      ) async {
        setScreenSize(tester, size);
        await tester.pumpWidget(const ERamoApp());
        await tester.pumpAndSettle();

        final feed = find.byType(CustomScrollView);
        final scrollable = _feedScrollable(tester);
        var guard = 0;
        while (scrollable.position.pixels <
                scrollable.position.maxScrollExtent &&
            guard++ < 60) {
          await tester.drag(feed, Offset(0, -size.height * 0.6));
          await tester.pumpAndSettle();
        }
        expect(scrollable.position.pixels, scrollable.position.maxScrollExtent);
        expect(find.byKey(HomeSectionKeys.news), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('drawer fits without overflow on $name', (tester) async {
        setScreenSize(tester, size);
        await tester.pumpWidget(const ERamoApp());
        await tester.pumpAndSettle();
        await _openDrawer(tester);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('large text scale does not overflow', (tester) async {
      setScreenSize(tester, const Size(360, 640));
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(const ERamoApp());
      await tester.pumpAndSettle();
      final feed = find.byType(CustomScrollView);
      for (var i = 0; i < 18; i++) {
        await tester.drag(feed, const Offset(0, -400));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);

      await tester.drag(feed, const Offset(0, 20000));
      await tester.pumpAndSettle();
      await _openDrawer(tester);
      expect(tester.takeException(), isNull);
    });
  });
}
