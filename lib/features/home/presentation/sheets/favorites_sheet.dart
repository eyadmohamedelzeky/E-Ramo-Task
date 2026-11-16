import 'package:flutter/material.dart';

import '../../data/home_content.dart';
import '../../state/favorites_controller.dart';
import 'app_sheet.dart';
import 'results_list.dart';

/// Drawer "عقاراتي المفضلة": every listing and project the user has hearted.
/// The list updates live when an item is removed from the favourites.
Future<void> showFavoritesSheet(BuildContext context, {required String title}) {
  return showAppSheet<void>(
    context,
    title: title,
    builder: (context, controller) {
      final favorites = FavoritesScope.of(context);
      final listings = HomeContent.allListings
          .where((listing) => favorites.isFavorite(listing.id))
          .toList(growable: false);
      final projects = HomeContent.projects
          .where((project) => favorites.isFavorite(project.id))
          .toList(growable: false);
      if (listings.isEmpty && projects.isEmpty) {
        return SheetEmptyMessage(
          message: 'لم تقم بإضافة أي عقار إلى المفضلة بعد',
          controller: controller,
        );
      }
      return ResultsList(
        listings: listings,
        projects: projects,
        controller: controller,
      );
    },
  );
}
