import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../models/project.dart';
import '../../models/property_listing.dart';
import '../widgets/project_card.dart';
import '../widgets/property_card.dart';
import 'projects_sheet.dart';
import 'property_details_sheet.dart';

/// Listings followed by projects, each group under a small heading. Used by
/// the search results and favourites sheets.
class ResultsList extends StatelessWidget {
  const ResultsList({
    super.key,
    required this.listings,
    required this.projects,
    required this.controller,
  });

  static const listingsHeading = 'العقارات';
  static const projectsHeading = 'المشاريع';

  final List<PropertyListing> listings;
  final List<RealEstateProject> projects;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        if (listings.isNotEmpty) ...[
          _Heading('$listingsHeading (${listings.length})'),
          for (final listing in listings) ...[
            PropertyCard(
              key: ValueKey('result-${listing.id}'),
              listing: listing,
              onTap: () => showPropertyDetailsSheet(context, listing),
            ),
            const SizedBox(height: 12),
          ],
        ],
        if (projects.isNotEmpty) ...[
          _Heading('$projectsHeading (${projects.length})'),
          for (final project in projects) ...[
            SizedBox(
              height: ProjectCard.height,
              child: ProjectCard(
                key: ValueKey('result-${project.id}'),
                project: project,
                onTap: () => showProjectDetailsSheet(context, project),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        text,
        style: AppTextStyles.sectionTitle.copyWith(fontSize: 15),
      ),
    );
  }
}
