import 'package:e_ramo_task/core/utils/formatters.dart';
import 'package:e_ramo_task/features/home/data/home_content.dart';
import 'package:e_ramo_task/features/home/models/property_listing.dart';
import 'package:e_ramo_task/features/home/state/favorites_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatThousands', () {
    test('adds comma separators', () {
      expect(formatThousands(4000000), '4,000,000');
      expect(formatThousands(8725), '8,725');
      expect(formatThousands(505), '505');
      expect(formatThousands(0), '0');
      expect(formatThousands(-1500), '-1,500');
    });
  });

  group('formatListedAgo', () {
    test('uses Arabic relative wording', () {
      expect(formatListedAgo(0), 'اليوم');
      expect(formatListedAgo(1), 'منذ يوم');
      expect(formatListedAgo(2), 'منذ يومين');
      expect(formatListedAgo(4), 'منذ 4 ايام');
      expect(formatListedAgo(14), 'منذ 14 يوم');
    });
  });

  group('PropertyListing labels', () {
    test('match the design copy', () {
      final listing = HomeContent.duplexes.first;
      expect(listing.priceLabel, '4,000,000 ج.م');
      expect(listing.areaLabel, '8,725sqft');
      expect(listing.listedAgoLabel, 'منذ 4 ايام');
      expect(listing.location, 'الشيخ زايد الجيزة');
    });

    test('rent prices are monthly ("4,000 ج.م شهريا" in the design)', () {
      final rent = HomeContent.featured.firstWhere(
        (listing) => listing.purpose == ListingPurpose.rent,
      );
      expect(rent.priceLabel, '4,000 ج.م');
      expect(rent.pricePeriodLabel, 'شهريا');
      expect(rent.fullPriceLabel, '4,000 ج.م شهريا');

      final sale = HomeContent.featured.first;
      expect(sale.pricePeriodLabel, isNull);
      expect(sale.fullPriceLabel, '4,000,000 ج.م');
    });
  });

  group('normalizeArabic', () {
    test('folds spelling variants', () {
      expect(normalizeArabic('إسكندرية'), normalizeArabic('اسكندريه'));
      expect(normalizeArabic('أكتوبر'), 'اكتوبر');
      expect(normalizeArabic('مستشفى'), 'مستشفي');
      expect(normalizeArabic('شَقّة'), 'شقه');
      expect(normalizeArabic('  Business   PARK '), 'business park');
    });
  });

  group('HomeContent.search', () {
    test('requires every word and ignores spelling variants', () {
      final results = HomeContent.search('الشيخ زايد');
      expect(results.listings.map((l) => l.id), contains('featured-1'));
      expect(results.projects.map((p) => p.id), contains('project-1'));
      expect(
        results.listings.every((l) => l.location.contains('الشيخ زايد')),
        isTrue,
      );

      // "اكتوبر" (no hamza) still finds "6 أكتوبر".
      final october = HomeContent.search('اكتوبر');
      expect(october.listings, isNotEmpty);
      expect(october.projects.map((p) => p.id), contains('project-4'));

      expect(HomeContent.search('مارينا').isEmpty, isTrue);
      expect(HomeContent.search('   ').isEmpty, isTrue);
    });

    test('matches the developer name, ignoring case', () {
      final results = HomeContent.search('gg developments');
      expect(results.listings, hasLength(HomeContent.allListings.length));
      expect(results.projects, hasLength(HomeContent.projects.length));
    });

    test('matches the purpose label', () {
      final rentals = HomeContent.search('للإيجار');
      expect(rentals.listings, isNotEmpty);
      expect(
        rentals.listings.every((l) => l.purpose == ListingPurpose.rent),
        isTrue,
      );
    });
  });

  group('HomeContent', () {
    test('every listing section has four items with sale and rent', () {
      for (final section in [
        HomeContent.duplexes,
        HomeContent.apartments,
        HomeContent.villas,
      ]) {
        expect(section, hasLength(4));
        expect(section.map((l) => l.purpose).toSet(), ListingPurpose.values);
      }
    });

    test('listing and project ids are unique', () {
      final ids = [
        ...HomeContent.allListings.map((l) => l.id),
        ...HomeContent.projects.map((p) => p.id),
      ];
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('featured section has four promoted listings with sale and rent', () {
      expect(HomeContent.featured, hasLength(4));
      expect(HomeContent.featured.every((l) => l.isFeatured), isTrue);
      expect(
        HomeContent.featured.map((l) => l.purpose).toSet(),
        ListingPurpose.values,
      );
      expect(HomeContent.allListings, containsAll(HomeContent.featured));
    });

    test('first featured card and first project carry the design copy', () {
      final listing = HomeContent.featured.first;
      expect(listing.priceLabel, '4,000,000 ج.م');
      expect(listing.title, startsWith('شقة سكنية للبيع تشطيب سوبر'));
      expect(listing.location, 'الشيخ زايد الجيزة');

      final project = HomeContent.projects.first;
      expect(project.name, 'كمبوند الشيخ زايد');
      expect(project.summary, startsWith('شقق سكنية فاخرة ومطاعم تجار'));
      expect(project.listedAgoLabel, 'منذ 4 ايام');
    });

    test('initial favourites all exist', () {
      final ids = {
        ...HomeContent.allListings.map((l) => l.id),
        ...HomeContent.projects.map((p) => p.id),
      };
      expect(ids, containsAll(HomeContent.initialFavoriteIds));
    });

    test('hero slides carry the design copy', () {
      expect(HomeContent.heroSlides, hasLength(4));
      expect(HomeContent.heroSlides.first.title, 'منزل احلامك الآن متوفر');
    });

    test('listingsInCity matches the location text', () {
      final giza = HomeContent.cities.firstWhere((c) => c.name == 'الجيزة');
      final listings = HomeContent.listingsInCity(giza);
      expect(listings, isNotEmpty);
      expect(listings.every((l) => l.location.contains('الجيزة')), isTrue);
    });
  });

  group('FavoritesController', () {
    test('toggles and notifies', () {
      final controller = FavoritesController(initial: {'a'});
      var notifications = 0;
      controller.addListener(() => notifications++);

      expect(controller.isFavorite('a'), isTrue);
      controller.toggle('a');
      expect(controller.isFavorite('a'), isFalse);
      controller.toggle('b');
      expect(controller.isFavorite('b'), isTrue);
      expect(controller.count, 1);
      expect(notifications, 2);
    });
  });
}
