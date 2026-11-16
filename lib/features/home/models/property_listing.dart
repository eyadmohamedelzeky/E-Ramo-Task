import '../../../core/utils/formatters.dart';

/// Whether a listing is offered for sale or for rent.
enum ListingPurpose {
  sale('للبيع'),
  rent('للإيجار');

  const ListingPurpose(this.label);

  /// Arabic label used by the filter tabs and the image badge.
  final String label;
}

class Developer {
  const Developer({
    required this.name,
    required this.monogram,
    required this.caption,
  });

  final String name;

  /// Letters rendered inside the circular developer logo (e.g. "GG").
  final String monogram;

  /// Small caption printed under the monogram.
  final String caption;
}

class PropertyListing {
  const PropertyListing({
    required this.id,
    required this.title,
    required this.price,
    required this.purpose,
    required this.imageAsset,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqft,
    required this.location,
    required this.listedDaysAgo,
    required this.developer,
    this.description,
    this.isFeatured = false,
  });

  final String id;
  final String title;

  /// Price in Egyptian pounds (monthly rent for [ListingPurpose.rent]).
  final int price;
  final ListingPurpose purpose;
  final String imageAsset;
  final int bedrooms;
  final int bathrooms;
  final int areaSqft;
  final String location;
  final int listedDaysAgo;
  final Developer developer;
  final String? description;

  /// Promoted listing shown in "عقارات مميزة في مصر" with the "مميز" pill.
  final bool isFeatured;

  /// Amount only, e.g. "4,000,000 ج.م".
  String get priceLabel => '${formatThousands(price)} ج.م';

  /// "شهريا" for rentals (printed muted after the amount), else `null`.
  String? get pricePeriodLabel =>
      purpose == ListingPurpose.rent ? 'شهريا' : null;

  /// Amount and period together, e.g. "4,000 ج.م شهريا".
  String get fullPriceLabel {
    final period = pricePeriodLabel;
    return period == null ? priceLabel : '$priceLabel $period';
  }

  String get areaLabel => '${formatThousands(areaSqft)}sqft';

  String get listedAgoLabel => formatListedAgo(listedDaysAgo);
}
