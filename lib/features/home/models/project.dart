import '../../../core/utils/formatters.dart';
import 'property_listing.dart';

/// A real-estate development shown in "اهم المشاريع العقارية في مصر".
class RealEstateProject {
  const RealEstateProject({
    required this.id,
    required this.name,
    required this.summary,
    required this.imageAsset,
    required this.location,
    required this.listedDaysAgo,
    required this.developer,
  });

  final String id;
  final String name;

  /// One-line description printed under the name (e.g. unit types).
  final String summary;
  final String imageAsset;
  final String location;
  final int listedDaysAgo;
  final Developer developer;

  String get listedAgoLabel => formatListedAgo(listedDaysAgo);
}
