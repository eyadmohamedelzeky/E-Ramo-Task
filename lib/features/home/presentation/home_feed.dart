import 'package:flutter/material.dart';

import '../data/home_content.dart';
import '../models/promo_slide.dart';
import 'widgets/city_section.dart';
import 'widgets/featured_properties_section.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/news_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/promo_banner_carousel.dart';
import 'widgets/property_listing_section.dart';

/// Keys for the page sections, in on-screen order.
///
/// They are [PageStorageKey]s so that every horizontal carousel / list gets
/// its own page-storage slot. Without them all nested scrollables share the
/// feed's `home-feed` slot and a carousel built after the page has been
/// scrolled restores the feed's offset, i.e. opens on its last page.
abstract final class HomeSectionKeys {
  static const header = PageStorageKey<String>('section-header');
  static const search = PageStorageKey<String>('section-search');
  static const hero = PageStorageKey<String>('section-hero');
  static const featured = PageStorageKey<String>('section-featured');
  static const projects = PageStorageKey<String>('section-projects');
  static const cities = PageStorageKey<String>('section-cities');
  static const banner = PageStorageKey<String>('section-banner');
  static const apartments = PageStorageKey<String>('section-apartments');
  static const villas = PageStorageKey<String>('section-villas');
  static const duplexes = PageStorageKey<String>('section-duplexes');
  static const news = PageStorageKey<String>('section-news');

  static const ordered = [
    header,
    search,
    hero,
    featured,
    projects,
    cities,
    banner,
    apartments,
    villas,
    duplexes,
    news,
  ];
}

/// The single, continuously scrolling home page.
///
/// Sections follow the exact order of the supplied design screenshots:
/// screenshot 1 (logo / city / icons header, search bar, hero carousel,
/// featured properties, top projects), screenshot 2 (top projects again as
/// the overlap, cities, office banner, apartments, villas) and screenshot 3
/// (duplexes, news, bottom navigation).
class HomeFeed extends StatelessWidget {
  const HomeFeed({
    super.key,
    required this.scrollController,
    required this.header,
    required this.onSearch,
    required this.onContactTap,
  });

  /// Vertical space between consecutive sections (≈70dp from the previous
  /// section's dots to the next title in the design).
  static const sectionSpacing = 64.0;

  /// The banner has no title row, so it gets a little extra space above it
  /// (city cards → banner is 70dp in the design).
  static const bannerExtraSpacing = 6.0;

  /// The top block is tight in the design: the search field sits right under
  /// the header icons and the hero 13dp below the field.
  static const searchSpacing = 0.0;
  static const heroSpacing = 13.0;

  /// Space above the logo (below the status bar).
  static const topPadding = 6.0;

  final ScrollController scrollController;

  /// Logo, city picker and header buttons (owned by the screen's state).
  final Widget header;
  final ValueChanged<String> onSearch;
  final ValueChanged<PromoSlide> onContactTap;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      const FeaturedPropertiesSection(
        key: HomeSectionKeys.featured,
        listings: HomeContent.featured,
      ),
      const ProjectsSection(
        key: HomeSectionKeys.projects,
        projects: HomeContent.projects,
      ),
      const CitySection(
        key: HomeSectionKeys.cities,
        cities: HomeContent.cities,
      ),
      Padding(
        padding: const EdgeInsets.only(top: bannerExtraSpacing),
        child: PromoBannerCarousel(
          key: HomeSectionKeys.banner,
          slides: HomeContent.promoSlides,
          onCtaTap: onContactTap,
        ),
      ),
      const PropertyListingSection(
        key: HomeSectionKeys.apartments,
        title: 'أحدث الشقق في مصر',
        listings: HomeContent.apartments,
      ),
      const PropertyListingSection(
        key: HomeSectionKeys.villas,
        title: 'أحدث الفيلات في مصر',
        listings: HomeContent.villas,
      ),
      const PropertyListingSection(
        key: HomeSectionKeys.duplexes,
        title: 'أحدث الدوبلكس في مصر',
        listings: HomeContent.duplexes,
      ),
      const NewsSection(key: HomeSectionKeys.news, articles: HomeContent.news),
    ];

    final insets = MediaQuery.paddingOf(context);
    return CustomScrollView(
      key: const PageStorageKey('home-feed'),
      controller: scrollController,
      slivers: [
        SliverPadding(
          // `insets.bottom` already includes the floating navigation bar
          // because the scaffold extends its body behind it.
          padding: EdgeInsets.only(
            top: insets.top + topPadding,
            bottom: insets.bottom + 28,
          ),
          sliver: SliverList.list(
            children: [
              KeyedSubtree(key: HomeSectionKeys.header, child: header),
              const SizedBox(height: searchSpacing),
              HomeSearchBar(key: HomeSectionKeys.search, onSearch: onSearch),
              const SizedBox(height: heroSpacing),
              PromoBannerCarousel(
                key: HomeSectionKeys.hero,
                slides: HomeContent.heroSlides,
                onCtaTap: onContactTap,
              ),
              for (final section in sections) ...[
                const SizedBox(height: sectionSpacing),
                section,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
