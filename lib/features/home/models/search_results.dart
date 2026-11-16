import 'project.dart';
import 'property_listing.dart';

/// Matches for a query typed in the home search bar.
class SearchResults {
  const SearchResults({this.listings = const [], this.projects = const []});

  final List<PropertyListing> listings;
  final List<RealEstateProject> projects;

  int get total => listings.length + projects.length;

  bool get isEmpty => total == 0;
}
