import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/property_listing.dart';
import '../../state/favorites_controller.dart';
import 'developer_logo.dart';

/// Horizontal listing card: photo on the start (right) side, details on the
/// end side. Used by the duplex, apartment and villa sections.
class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.listing, this.onTap});

  /// Card height from the design (89px at 0.589px/dp).
  static const height = 151.0;

  /// Photo width relative to the card width (141dp of 334dp).
  static const imageWidthFactor = 141 / 334;

  static const radius = 12.0;

  final PropertyListing listing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageWidth = (constraints.maxWidth * imageWidthFactor).clamp(
          100.0,
          200.0,
        );
        return Material(
          color: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: imageWidth,
                    child: _ListingPhoto(listing: listing),
                  ),
                  Expanded(child: ListingDetails(listing: listing)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ListingPhoto extends StatelessWidget {
  const _ListingPhoto({required this.listing});

  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          listing.imageAsset,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
        PositionedDirectional(
          top: 10,
          end: 0,
          child: PurposeBadge(purpose: listing.purpose),
        ),
      ],
    );
  }
}

/// Grey "للبيع" / "للإيجار" tag pinned to the photo edge.
class PurposeBadge extends StatelessWidget {
  const PurposeBadge({super.key, required this.purpose});

  final ListingPurpose purpose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      constraints: const BoxConstraints(minWidth: 53),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.badgeBackground,
        borderRadius: BorderRadiusDirectional.horizontal(
          start: Radius.circular(4),
        ),
      ),
      child: Text(purpose.label, style: AppTextStyles.badge),
    );
  }
}

/// Price, title, specs, location / age and developer of a listing. Shared by
/// the horizontal [PropertyCard] and the vertical featured card.
class ListingDetails extends StatelessWidget {
  const ListingDetails({
    super.key,
    required this.listing,
    this.padding = const EdgeInsetsDirectional.fromSTEB(11, 13, 10, 13),
    this.titleToSpecsFlex = 12,
    this.specsToFooterFlex = 8,
  });

  final PropertyListing listing;
  final EdgeInsetsGeometry padding;

  /// Relative weights of the two flexible gaps (their dp size at normal text
  /// scale); they shrink first when the text is enlarged.
  final int titleToSpecsFlex;
  final int specsToFooterFlex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: ListingPrice(listing: listing)),
              const SizedBox(width: 6),
              FavoriteButton(listingId: listing.id, size: 19),
            ],
          ),
          Text(
            listing.title,
            style: AppTextStyles.listingTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(flex: titleToSpecsFlex),
          ListingSpecs(listing: listing),
          Spacer(flex: specsToFooterFlex),
          ListingFooter(
            location: listing.location,
            listedAgo: listing.listedAgoLabel,
            developer: listing.developer,
          ),
        ],
      ),
    );
  }
}

/// "4,000,000 ج.م", or "4,000 ج.م شهريا" with a muted period for rentals.
class ListingPrice extends StatelessWidget {
  const ListingPrice({super.key, required this.listing, this.style});

  final PropertyListing listing;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final priceStyle = style ?? AppTextStyles.price;
    final period = listing.pricePeriodLabel;
    return Text.rich(
      TextSpan(
        text: listing.priceLabel,
        children: [
          if (period != null)
            TextSpan(
              text: ' $period',
              style: AppTextStyles.pricePeriod.copyWith(
                fontSize: priceStyle.fontSize! * 0.85,
              ),
            ),
        ],
      ),
      style: priceStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Location and listing age on the start side, "بواسطة" + developer logo on
/// the end side (bottom of listing and project cards).
class ListingFooter extends StatelessWidget {
  const ListingFooter({
    super.key,
    required this.location,
    required this.listedAgo,
    required this.developer,
  });

  final String location;
  final String listedAgo;
  final Developer developer;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconLabel(
                  icon: Icons.location_on,
                  label: location,
                  style: AppTextStyles.location,
                ),
                const SizedBox(height: 11),
                IconLabel(
                  icon: Icons.access_time,
                  label: listedAgo,
                  style: AppTextStyles.listedAgo,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: DeveloperBadge(developer: developer),
        ),
      ],
    );
  }
}

/// Bedrooms, bathrooms and area. Scales down instead of overflowing on very
/// narrow cards.
class ListingSpecs extends StatelessWidget {
  const ListingSpecs({super.key, required this.listing});

  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Spec(icon: Icons.bed_outlined, label: '${listing.bedrooms}'),
          const SizedBox(width: 12),
          _Spec(icon: Icons.bathtub_outlined, label: '${listing.bathrooms}'),
          const SizedBox(width: 12),
          _Spec(icon: Icons.crop_free, label: listing.areaLabel),
        ],
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textBody),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.spec),
      ],
    );
  }
}

class IconLabel extends StatelessWidget {
  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.style,
  });

  final IconData icon;
  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: style.color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Red heart that toggles the listing in [FavoritesScope].
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.listingId, this.size = 20});

  final String listingId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesScope.of(context);
    final isFavorite = favorites.isFavorite(listingId);
    return Semantics(
      button: true,
      toggled: isFavorite,
      label: isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
      child: InkResponse(
        key: ValueKey('favorite-$listingId'),
        onTap: () => favorites.toggle(listingId),
        radius: size,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(isFavorite),
              size: size,
              color: AppColors.favorite,
            ),
          ),
        ),
      ),
    );
  }
}
