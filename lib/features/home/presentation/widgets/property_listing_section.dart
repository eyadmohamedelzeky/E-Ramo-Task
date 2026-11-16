import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/property_listing.dart';
import '../sheets/listings_sheet.dart';
import '../sheets/property_details_sheet.dart';
import 'page_dots.dart';
import 'property_card.dart';
import 'purpose_filter_tabs.dart';
import 'section_header.dart';

/// "أحدث ... في مصر" section: header, purpose filter, snapping card carousel
/// with the next card peeking on the left, and page dots.
class PropertyListingSection extends StatefulWidget {
  const PropertyListingSection({
    super.key,
    required this.title,
    required this.listings,
  });

  /// Space between the photo's right edge and the screen edge.
  static const sideInset = SectionHeader.horizontalPadding;
  static const cardGap = 8.0;

  /// How much of the next card is visible on phones (13dp in the design).
  static const peek = 13.0;

  final String title;
  final List<PropertyListing> listings;

  @override
  State<PropertyListingSection> createState() => _PropertyListingSectionState();
}

class _PropertyListingSectionState extends State<PropertyListingSection> {
  ListingPurpose? _filter;
  int _page = 0;
  PageController? _controller;
  double? _fraction;

  List<PropertyListing> get _visibleListings => _filter == null
      ? widget.listings
      : widget.listings
            .where((listing) => listing.purpose == _filter)
            .toList(growable: false);

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  PageController _controllerFor(double fraction) {
    final current = _controller;
    if (current != null && (_fraction! - fraction).abs() < 0.0001) {
      return current;
    }
    final controller = PageController(
      viewportFraction: fraction,
      initialPage: _page,
    );
    _controller = controller;
    _fraction = fraction;
    if (current != null) {
      // The old controller is still attached until this frame is built.
      WidgetsBinding.instance.addPostFrameCallback((_) => current.dispose());
    }
    return controller;
  }

  void _onFilterChanged(ListingPurpose? purpose) {
    if (purpose == _filter) return;
    setState(() {
      _filter = purpose;
      _page = 0;
    });
    final controller = _controller;
    if (controller != null && controller.hasClients) controller.jumpToPage(0);
  }

  void _goToPage(int page) {
    final controller = _controller;
    if (controller == null || !controller.hasClients) return;
    controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final listings = _visibleListings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: widget.title,
          onViewAll: () => showListingsSheet(
            context,
            title: widget.title,
            listings: listings,
          ),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SectionHeader.horizontalPadding,
          ),
          child: PurposeFilterTabs(
            selected: _filter,
            onChanged: _onFilterChanged,
          ),
        ),
        const SizedBox(height: 18.5),
        if (listings.isEmpty)
          EmptyFilterResult(purpose: _filter)
        else
          _buildCarousel(listings),
        const SizedBox(height: 10),
        PageDots(
          count: listings.length,
          current: _page.clamp(0, listings.isEmpty ? 0 : listings.length - 1),
          onDotTap: _goToPage,
        ),
      ],
    );
  }

  Widget _buildCarousel(List<PropertyListing> listings) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final viewport = width - PropertyListingSection.sideInset;
        // Phones: one card plus a 13dp peek. Tablets: two cards side by side.
        final cardWidth = width < 600
            ? viewport -
                  PropertyListingSection.cardGap -
                  PropertyListingSection.peek
            : (viewport - PropertyListingSection.peek) / 2 -
                  PropertyListingSection.cardGap;
        final fraction =
            ((cardWidth + PropertyListingSection.cardGap) / viewport).clamp(
              0.1,
              1.0,
            );
        return SizedBox(
          height: PropertyCard.height,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: PropertyListingSection.sideInset,
            ),
            child: PageView.builder(
              controller: _controllerFor(fraction),
              padEnds: false,
              clipBehavior: Clip.none,
              itemCount: listings.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) {
                final listing = listings[index];
                return Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: PropertyListingSection.cardGap,
                  ),
                  child: PropertyCard(
                    key: ValueKey('card-${listing.id}'),
                    listing: listing,
                    onTap: () => showPropertyDetailsSheet(context, listing),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Placeholder shown when the purpose filter leaves a section empty.
class EmptyFilterResult extends StatelessWidget {
  const EmptyFilterResult({
    super.key,
    required this.purpose,
    this.height = PropertyCard.height,
  });

  final ListingPurpose? purpose;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(
        horizontal: SectionHeader.horizontalPadding,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PropertyCard.radius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        'لا توجد عقارات ${purpose?.label ?? ''} حالياً',
        style: AppTextStyles.listingTitle,
      ),
    );
  }
}
