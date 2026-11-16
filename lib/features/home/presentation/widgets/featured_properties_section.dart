import 'package:flutter/material.dart';

import '../../models/property_listing.dart';
import '../sheets/listings_sheet.dart';
import '../sheets/property_details_sheet.dart';
import 'featured_property_card.dart';
import 'property_listing_section.dart';
import 'purpose_filter_tabs.dart';
import 'section_header.dart';

/// "عقارات مميزة في مصر": header, purpose filter and a free-scrolling row of
/// vertical featured cards (the next card peeks in from the left).
class FeaturedPropertiesSection extends StatefulWidget {
  const FeaturedPropertiesSection({super.key, required this.listings});

  static const title = 'عقارات مميزة في مصر';

  /// Gap between two cards (15dp in the design).
  static const cardGap = 15.0;

  final List<PropertyListing> listings;

  @override
  State<FeaturedPropertiesSection> createState() =>
      _FeaturedPropertiesSectionState();
}

class _FeaturedPropertiesSectionState extends State<FeaturedPropertiesSection> {
  final _scrollController = ScrollController();
  ListingPurpose? _filter;

  List<PropertyListing> get _visibleListings => _filter == null
      ? widget.listings
      : widget.listings
            .where((listing) => listing.purpose == _filter)
            .toList(growable: false);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterChanged(ListingPurpose? purpose) {
    if (purpose == _filter) return;
    setState(() => _filter = purpose);
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final listings = _visibleListings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: FeaturedPropertiesSection.title,
          onViewAll: () => showListingsSheet(
            context,
            title: FeaturedPropertiesSection.title,
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
          EmptyFilterResult(
            purpose: _filter,
            height: FeaturedPropertyCard.height,
          )
        else
          SizedBox(
            height: FeaturedPropertyCard.height,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: SectionHeader.horizontalPadding,
              ),
              itemCount: listings.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: FeaturedPropertiesSection.cardGap),
              itemBuilder: (context, index) {
                final listing = listings[index];
                return SizedBox(
                  width: FeaturedPropertyCard.width,
                  child: FeaturedPropertyCard(
                    key: ValueKey('card-${listing.id}'),
                    listing: listing,
                    onTap: () => showPropertyDetailsSheet(context, listing),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
