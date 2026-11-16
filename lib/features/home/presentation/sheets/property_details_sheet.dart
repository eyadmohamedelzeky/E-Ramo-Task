import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/property_listing.dart';
import '../../state/favorites_controller.dart';
import '../widgets/developer_logo.dart';
import '../widgets/featured_property_card.dart';
import '../widgets/property_card.dart';
import 'app_sheet.dart';

/// Details for a tapped listing, built only from the local listing data.
Future<void> showPropertyDetailsSheet(
  BuildContext context,
  PropertyListing listing,
) {
  return showAppSheet<void>(
    context,
    title: listing.title,
    initialChildSize: 0.85,
    builder: (context, controller) =>
        _PropertyDetails(listing: listing, controller: controller),
  );
}

class _PropertyDetails extends StatelessWidget {
  const _PropertyDetails({required this.listing, required this.controller});

  final PropertyListing listing;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesScope.of(context);
    final isFavorite = favorites.isFavorite(listing.id);

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(PropertyCard.radius),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(listing.imageAsset, fit: BoxFit.cover),
                if (listing.isFeatured)
                  const PositionedDirectional(
                    start: 0,
                    bottom: 12,
                    child: FeaturedBadge(),
                  ),
                PositionedDirectional(
                  top: 12,
                  end: 0,
                  child: PurposeBadge(purpose: listing.purpose),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ListingPrice(
                listing: listing,
                style: AppTextStyles.sheetTitle.copyWith(fontSize: 20),
              ),
            ),
            FavoriteButton(listingId: listing.id, size: 26),
          ],
        ),
        Text(
          listing.title,
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: ListingSpecs(listing: listing),
        ),
        const SizedBox(height: 12),
        IconLabel(
          icon: Icons.location_on,
          label: listing.location,
          style: AppTextStyles.location.copyWith(fontSize: 13),
        ),
        const SizedBox(height: 6),
        IconLabel(
          icon: Icons.access_time,
          label: listing.listedAgoLabel,
          style: AppTextStyles.listedAgo.copyWith(fontSize: 13),
        ),
        const Divider(height: 32),
        Row(
          children: [
            DeveloperLogo(developer: listing.developer, width: 52, height: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${DeveloperBadge.byLabel} ${listing.developer.name}',
                style: AppTextStyles.body,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: () => favorites.toggle(listing.id),
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          label: Text(isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة'),
        ),
      ],
    );
  }
}
