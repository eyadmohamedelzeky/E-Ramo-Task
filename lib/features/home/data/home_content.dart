import '../../../core/constants/app_assets.dart';
import '../../../core/utils/formatters.dart';
import '../models/city.dart';
import '../models/news_article.dart';
import '../models/project.dart';
import '../models/promo_slide.dart';
import '../models/property_listing.dart';
import '../models/search_results.dart';
import '../models/user_profile.dart';

/// Static content for the home page. The project has no backend/API, so the
/// page is driven by this local data set (copy taken from the design).
abstract final class HomeContent {
  static const _developer = Developer(
    name: 'GG Developments',
    monogram: 'GG',
    caption: 'DEVELOPMENTS',
  );

  /// "عقارات مميزة في مصر". The first two cards carry the design's copy.
  static const featured = <PropertyListing>[
    PropertyListing(
      id: 'featured-1',
      title: 'شقة سكنية للبيع تشطيب سوبر لوكس',
      price: 4000000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.featured1,
      bedrooms: 10,
      bathrooms: 5,
      areaSqft: 8725,
      location: 'الشيخ زايد الجيزة',
      listedDaysAgo: 4,
      developer: _developer,
      isFeatured: true,
    ),
    PropertyListing(
      id: 'featured-2',
      title: 'شقة سكنية للإيجار تشطيب سوبر لوكس',
      price: 4000,
      purpose: ListingPurpose.rent,
      imageAsset: AppAssets.featured2,
      bedrooms: 10,
      bathrooms: 5,
      areaSqft: 8725,
      location: 'الشيخ زايد الجيزة',
      listedDaysAgo: 4,
      developer: _developer,
      isFeatured: true,
    ),
    PropertyListing(
      id: 'featured-3',
      title: 'شقة فاخرة للبيع بإطلالة على الحديقة',
      price: 7800000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.featured3,
      bedrooms: 4,
      bathrooms: 3,
      areaSqft: 3400,
      location: 'التجمع الخامس القاهرة',
      listedDaysAgo: 2,
      developer: _developer,
      isFeatured: true,
    ),
    PropertyListing(
      id: 'featured-4',
      title: 'شقة مفروشة للبيع بالقرب من النيل',
      price: 5600000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.featured4,
      bedrooms: 3,
      bathrooms: 2,
      areaSqft: 2100,
      location: 'الزمالك القاهرة',
      listedDaysAgo: 6,
      developer: _developer,
      isFeatured: true,
    ),
  ];

  /// "اهم المشاريع العقارية في مصر". The first card carries the design's
  /// copy; the second keeps the visible part of the design's second card.
  static const projects = <RealEstateProject>[
    RealEstateProject(
      id: 'project-1',
      name: 'كمبوند الشيخ زايد',
      summary: 'شقق سكنية فاخرة ومطاعم تجارية ومساحات خضراء',
      imageAsset: AppAssets.project1,
      location: 'الشيخ زايد الجيزة',
      listedDaysAgo: 4,
      developer: _developer,
    ),
    RealEstateProject(
      id: 'project-2',
      name: 'كمبوند الشيخ زايد هايتس',
      summary: 'شقق سكنية فاخرة ومطاعم وخدمات متكاملة',
      imageAsset: AppAssets.project2,
      location: 'الشيخ زايد الجيزة',
      listedDaysAgo: 4,
      developer: _developer,
    ),
    RealEstateProject(
      id: 'project-3',
      name: 'كمبوند النخيل',
      summary: 'فيلات وشقق حول البحيرات وحمامات السباحة',
      imageAsset: AppAssets.project3,
      location: 'التجمع الخامس القاهرة',
      listedDaysAgo: 6,
      developer: _developer,
    ),
    RealEstateProject(
      id: 'project-4',
      name: 'بيزنس بارك أكتوبر',
      summary: 'مكاتب إدارية ومحلات تجارية بتصميم عصري',
      imageAsset: AppAssets.project4,
      location: '6 أكتوبر الجيزة',
      listedDaysAgo: 9,
      developer: _developer,
    ),
  ];

  static const duplexes = <PropertyListing>[
    PropertyListing(
      id: 'duplex-1',
      title: 'دوبلكس للبيع تشطيب سوبر لوكس بالشيخ زايد',
      price: 4000000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.duplex1,
      bedrooms: 10,
      bathrooms: 5,
      areaSqft: 8725,
      location: 'الشيخ زايد الجيزة',
      listedDaysAgo: 4,
      developer: _developer,
    ),
    PropertyListing(
      id: 'duplex-2',
      title: 'دوبلكس بحديقة خاصة في كمبوند متكامل الخدمات',
      price: 6250000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.duplex2,
      bedrooms: 5,
      bathrooms: 4,
      areaSqft: 4300,
      location: 'التجمع الخامس القاهرة',
      listedDaysAgo: 2,
      developer: _developer,
    ),
    PropertyListing(
      id: 'duplex-3',
      title: 'دوبلكس للإيجار مفروش بالكامل بإطلالة مميزة',
      price: 45000,
      purpose: ListingPurpose.rent,
      imageAsset: AppAssets.duplex3,
      bedrooms: 4,
      bathrooms: 3,
      areaSqft: 3550,
      location: '6 أكتوبر الجيزة',
      listedDaysAgo: 6,
      developer: _developer,
    ),
    PropertyListing(
      id: 'duplex-4',
      title: 'دوبلكس للبيع استلام فوري بالتقسيط',
      price: 5100000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.duplex4,
      bedrooms: 6,
      bathrooms: 4,
      areaSqft: 5120,
      location: 'مدينتي القاهرة',
      listedDaysAgo: 9,
      developer: _developer,
    ),
  ];

  static const apartments = <PropertyListing>[
    PropertyListing(
      id: 'apartment-1',
      title: 'شقة سكنية للبيع تشطيب سوبر لوكس',
      price: 4000000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.apartment1,
      bedrooms: 10,
      bathrooms: 5,
      areaSqft: 8725,
      location: 'الشيخ زايد الجيزة',
      listedDaysAgo: 4,
      developer: _developer,
    ),
    PropertyListing(
      id: 'apartment-2',
      title: 'شقة واسعة للبيع بالقرب من الخدمات',
      price: 2850000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.apartment2,
      bedrooms: 3,
      bathrooms: 2,
      areaSqft: 1940,
      location: 'مدينة نصر القاهرة',
      listedDaysAgo: 3,
      developer: _developer,
    ),
    PropertyListing(
      id: 'apartment-3',
      title: 'شقة للإيجار مفروشة بإطلالة على الحديقة',
      price: 18000,
      purpose: ListingPurpose.rent,
      imageAsset: AppAssets.apartment3,
      bedrooms: 2,
      bathrooms: 1,
      areaSqft: 1290,
      location: 'سموحة الإسكندرية',
      listedDaysAgo: 1,
      developer: _developer,
    ),
    PropertyListing(
      id: 'apartment-4',
      title: 'شقة للبيع بمقدم وتقسيط على 6 سنوات',
      price: 3300000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.apartment4,
      bedrooms: 3,
      bathrooms: 2,
      areaSqft: 2150,
      location: 'المعادي القاهرة',
      listedDaysAgo: 12,
      developer: _developer,
    ),
  ];

  static const villas = <PropertyListing>[
    PropertyListing(
      id: 'villa-1',
      title: 'فيلا سكنية للبيع تشطيب سوبر لوكس',
      price: 4000000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.villa1,
      bedrooms: 10,
      bathrooms: 5,
      areaSqft: 8725,
      location: 'الشيخ زايد الجيزة',
      listedDaysAgo: 4,
      developer: _developer,
    ),
    PropertyListing(
      id: 'villa-2',
      title: 'فيلا مستقلة بحمام سباحة خاص',
      price: 12500000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.villa2,
      bedrooms: 6,
      bathrooms: 5,
      areaSqft: 9800,
      location: 'التجمع الخامس القاهرة',
      listedDaysAgo: 5,
      developer: _developer,
    ),
    PropertyListing(
      id: 'villa-3',
      title: 'فيلا للإيجار بحديقة وحمام سباحة',
      price: 95000,
      purpose: ListingPurpose.rent,
      imageAsset: AppAssets.villa3,
      bedrooms: 5,
      bathrooms: 4,
      areaSqft: 7400,
      location: 'الشيخ زايد الجيزة',
      listedDaysAgo: 8,
      developer: _developer,
    ),
    PropertyListing(
      id: 'villa-4',
      title: 'فيلا توين هاوس للبيع في كمبوند هادئ',
      price: 9750000,
      purpose: ListingPurpose.sale,
      imageAsset: AppAssets.villa4,
      bedrooms: 5,
      bathrooms: 4,
      areaSqft: 6900,
      location: 'القاهرة الجديدة القاهرة',
      listedDaysAgo: 14,
      developer: _developer,
    ),
  ];

  static const allListings = [
    ...featured,
    ...apartments,
    ...villas,
    ...duplexes,
  ];

  /// Listings and projects shown as favourites on first launch (filled
  /// hearts in the design).
  static const initialFavoriteIds = {
    'featured-1',
    'project-1',
    'apartment-1',
    'villa-1',
    'duplex-1',
  };

  static const cities = <City>[
    City(
      name: 'القاهرة',
      imageAsset: AppAssets.cityCairo,
      forSaleCount: 505,
      forRentCount: 1002,
    ),
    City(
      name: 'الجيزة',
      imageAsset: AppAssets.cityGiza,
      forSaleCount: 505,
      forRentCount: 1002,
    ),
    City(
      name: 'الإسكندرية',
      imageAsset: AppAssets.cityAlexandria,
      forSaleCount: 318,
      forRentCount: 640,
    ),
  ];

  static List<PropertyListing> listingsInCity(City city) => allListings
      .where((listing) => listing.location.contains(city.name))
      .toList(growable: false);

  static const _newsSummary =
      'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا '
      'النص من مولد النص العربى.';

  static const news = <NewsArticle>[
    NewsArticle(
      id: 'news-1',
      title: 'أحدث سوق إيجي',
      summary: _newsSummary,
      imageAsset: AppAssets.news1,
    ),
    NewsArticle(
      id: 'news-2',
      title: 'أحدث سوق إيجي',
      summary: _newsSummary,
      imageAsset: AppAssets.news2,
    ),
    NewsArticle(
      id: 'news-3',
      title: 'أحدث سوق إيجي',
      summary: _newsSummary,
      imageAsset: AppAssets.news3,
    ),
  ];

  static const _bannerTitle = 'مكتبك لازم يكون انيق';
  static const _bannerSubtitle =
      'مشروع كمبوند الشيخ زايد اكتر من 200 مكتب ومحل فى انتظارك';

  static const promoSlides = <PromoSlide>[
    PromoSlide(
      imageAsset: AppAssets.bannerOffice1,
      title: _bannerTitle,
      subtitle: _bannerSubtitle,
    ),
    PromoSlide(
      imageAsset: AppAssets.bannerOffice2,
      title: _bannerTitle,
      subtitle: _bannerSubtitle,
    ),
    PromoSlide(
      imageAsset: AppAssets.bannerOffice3,
      title: _bannerTitle,
      subtitle: _bannerSubtitle,
    ),
    PromoSlide(
      imageAsset: AppAssets.bannerOffice4,
      title: _bannerTitle,
      subtitle: _bannerSubtitle,
    ),
  ];

  static const _heroTitle = 'منزل احلامك الآن متوفر';
  static const _heroSubtitle =
      'مشروع كمبوند الشيخ زايد اكثر من 200 شقة ومحل فى انتظارك';

  /// Hero carousel under the search bar.
  static const heroSlides = <PromoSlide>[
    PromoSlide(
      imageAsset: AppAssets.hero1,
      title: _heroTitle,
      subtitle: _heroSubtitle,
    ),
    PromoSlide(
      imageAsset: AppAssets.hero2,
      title: _heroTitle,
      subtitle: _heroSubtitle,
    ),
    PromoSlide(
      imageAsset: AppAssets.hero3,
      title: _heroTitle,
      subtitle: _heroSubtitle,
    ),
    PromoSlide(
      imageAsset: AppAssets.hero4,
      title: _heroTitle,
      subtitle: _heroSubtitle,
    ),
  ];

  /// Signed-in user shown in the drawer (design copy; the project has no
  /// account backend).
  static const profile = UserProfile(
    name: 'عبدالله محمد',
    city: 'القاهرة',
    avatarAsset: AppAssets.avatar,
  );

  /// Unread counters shown on the header icons and drawer items.
  static const unreadNotifications = 2;
  static const unreadMessages = 5;

  /// Searches listing titles / locations / purpose / developer and project
  /// names / summaries / locations / developer. Every word of [query] must
  /// match (case, diacritics and alef / ta marbuta / alef maqsura spelling
  /// variants are ignored).
  static SearchResults search(String query) {
    final terms = normalizeArabic(
      query,
    ).split(' ').where((term) => term.isNotEmpty).toList(growable: false);
    if (terms.isEmpty) return const SearchResults();

    bool matches(String text) {
      final haystack = normalizeArabic(text);
      return terms.every(haystack.contains);
    }

    return SearchResults(
      listings: allListings
          .where(
            (l) => matches(
              '${l.title} ${l.location} ${l.purpose.label} '
              '${l.developer.name}',
            ),
          )
          .toList(growable: false),
      projects: projects
          .where(
            (p) => matches(
              '${p.name} ${p.summary} ${p.location} ${p.developer.name}',
            ),
          )
          .toList(growable: false),
    );
  }
}
