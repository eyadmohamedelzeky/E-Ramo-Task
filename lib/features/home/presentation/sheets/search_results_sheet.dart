import 'package:flutter/material.dart';

import '../../models/search_results.dart';
import 'app_sheet.dart';
import 'results_list.dart';

/// Wraps user text in Unicode first-strong isolates (FSI … PDI) so a Latin
/// query such as "GG" cannot reorder the surrounding Arabic, quotes and
/// count when the bidi algorithm lays the line out.
String isolateQuery(String query) => '"\u2068$query\u2069"';

/// Sheet title for a search, e.g. 'نتائج البحث عن "GG" (20)'.
String searchResultsTitle(String query, int total) =>
    'نتائج البحث عن ${isolateQuery(query)} ($total)';

/// Message shown when nothing matches.
String noSearchResultsMessage(String query) =>
    'لا توجد نتائج مطابقة لـ ${isolateQuery(query)}';

/// Results of a home-page search over the listings and projects.
Future<void> showSearchResultsSheet(
  BuildContext context, {
  required String query,
  required SearchResults results,
}) {
  return showAppSheet<void>(
    context,
    title: searchResultsTitle(query, results.total),
    builder: (context, controller) {
      if (results.isEmpty) {
        return SheetEmptyMessage(
          message: noSearchResultsMessage(query),
          controller: controller,
        );
      }
      return ResultsList(
        listings: results.listings,
        projects: results.projects,
        controller: controller,
      );
    },
  );
}
