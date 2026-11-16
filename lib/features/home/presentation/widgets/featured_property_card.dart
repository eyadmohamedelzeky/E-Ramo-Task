import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/property_listing.dart';
import 'property_card.dart';

/// Vertical card of the "عقارات مميزة في مصر" section: photo on top with the
/// "مميز" pill and the gold purpose tag, details below, gold outline.
class FeaturedPropertyCard extends StatelessWidget {
  const FeaturedPropertyCard({super.key, required this.listing, this.onTap});

  /// 198 x 268dp on a 375dp frame; the photo takes the top 131dp.
  static const width = 198.0;
  static const height = 268.0;
  static const imageHeight = 131.0;
  static const radius = 24.0;

  /// The purpose tag covers 43% of the card width.
  static const purposeTagWidthFactor = 0.43;
  static const borderWidth = 1.2;

  final PropertyListing listing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: AppColors.featured, width: borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: imageHeight,
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      listing.imageAsset,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                    ),
                    const PositionedDirectional(
                      start: 0,
                      bottom: 6,
                      child: FeaturedBadge(),
                    ),
                    PositionedDirectional(
                      end: 0,
                      bottom: 0,
                      width: constraints.maxWidth * purposeTagWidthFactor,
                      child: _PurposeTag(purpose: listing.purpose),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListingDetails(
                listing: listing,
                padding: const EdgeInsetsDirectional.fromSTEB(17, 8, 17, 10),
                titleToSpecsFlex: 10,
                specsToFooterFlex: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gold "★ مميز" pill hugging the start edge of the photo.
class FeaturedBadge extends StatelessWidget {
  const FeaturedBadge({super.key});

  static const label = 'مميز';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 9, 0),
      decoration: const BoxDecoration(
        color: AppColors.featured,
        borderRadius: BorderRadiusDirectional.horizontal(
          end: Radius.circular(9),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 13, color: AppColors.textPrimary),
          SizedBox(width: 3),
          Text(label, style: AppTextStyles.featuredBadge),
        ],
      ),
    );
  }
}

/// Gold "للبيع" / "للإيجار" tag in the end-bottom corner of the photo.
class _PurposeTag extends StatelessWidget {
  const _PurposeTag({required this.purpose});

  final ListingPurpose purpose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.featured,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(8),
        ),
      ),
      child: Text(purpose.label, style: AppTextStyles.badge),
    );
  }
}
