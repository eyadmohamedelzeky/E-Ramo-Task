import 'package:flutter/material.dart';

import '../../models/property_listing.dart';
import '../widgets/property_card.dart';
import 'app_sheet.dart';
import 'property_details_sheet.dart';

/// "مشاهدة الكل" for a listing section, and the per-city listing view.
Future<void> showListingsSheet(
  BuildContext context, {
  required String title,
  required List<PropertyListing> listings,
}) {
  return showAppSheet<void>(
    context,
    title: '$title (${listings.length})',
    builder: (context, controller) {
      if (listings.isEmpty) {
        return SheetEmptyMessage(
          message: 'لا توجد عقارات متاحة حالياً',
          controller: controller,
        );
      }
      return ListView.separated(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        itemCount: listings.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => PropertyCard(
          listing: listings[index],
          onTap: () => showPropertyDetailsSheet(context, listings[index]),
        ),
      );
    },
  );
}
