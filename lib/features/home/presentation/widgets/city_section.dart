import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../data/home_content.dart';
import '../../models/city.dart';
import '../sheets/cities_sheet.dart';
import '../sheets/listings_sheet.dart';
import 'section_header.dart';

/// "إبحث عن عقارك بالمدينة": horizontally scrolling city photo cards.
class CitySection extends StatelessWidget {
  const CitySection({super.key, required this.cities});

  static const title = 'إبحث عن عقارك بالمدينة';

  /// Card size from the design: 166 x 221dp on a 375dp frame.
  static const _widthFactor = 166 / 375;
  static const _aspectRatio = 166 / 221;
  static const _gap = 9.0;

  final List<City> cities;

  static void openCity(BuildContext context, City city) {
    showListingsSheet(
      context,
      title: 'عقارات في ${city.name}',
      listings: HomeContent.listingsInCity(city),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: title,
          onViewAll: () => showCitiesSheet(context, cities),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = math.min(
              math.max(constraints.maxWidth * _widthFactor, 140.0),
              200.0,
            );
            final cardHeight = cardWidth / _aspectRatio;
            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: SectionHeader.horizontalPadding,
                ),
                itemCount: cities.length,
                separatorBuilder: (_, _) => const SizedBox(width: _gap),
                itemBuilder: (context, index) => SizedBox(
                  width: cardWidth,
                  child: CityCard(
                    city: cities[index],
                    onTap: () => openCity(context, cities[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CityCard extends StatelessWidget {
  const CityCard({super.key, required this.city, this.onTap});

  final City city;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage(city.imageAsset),
        fit: BoxFit.cover,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x14000000),
                  Color(0x0A000000),
                  Color(0x8C000000),
                ],
                stops: [0, 0.45, 1],
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, -0.1),
                  child: Text(city.name, style: AppTextStyles.cityName),
                ),
                PositionedDirectional(
                  start: 14,
                  end: 8,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.forSaleLabel,
                        style: AppTextStyles.cityCount,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        city.forRentLabel,
                        style: AppTextStyles.cityCount,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
