class City {
  const City({
    required this.name,
    required this.imageAsset,
    required this.forSaleCount,
    required this.forRentCount,
  });

  final String name;
  final String imageAsset;
  final int forSaleCount;
  final int forRentCount;

  String get forSaleLabel => 'عقارات للبيع : $forSaleCount';
  String get forRentLabel => 'عقارات للإيجار : $forRentCount';
}
