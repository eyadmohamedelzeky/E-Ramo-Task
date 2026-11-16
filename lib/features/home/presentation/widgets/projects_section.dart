import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../sheets/projects_sheet.dart';
import 'featured_properties_section.dart';
import 'project_card.dart';
import 'section_header.dart';

/// "اهم المشاريع العقارية في مصر": header and a free-scrolling row of
/// project cards.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key, required this.projects});

  static const title = 'اهم المشاريع العقارية في مصر';

  final List<RealEstateProject> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: title,
          onViewAll: () =>
              showProjectsSheet(context, title: title, projects: projects),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: ProjectCard.height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: SectionHeader.horizontalPadding,
            ),
            itemCount: projects.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: FeaturedPropertiesSection.cardGap),
            itemBuilder: (context, index) {
              final project = projects[index];
              return SizedBox(
                width: ProjectCard.width,
                child: ProjectCard(
                  key: ValueKey('card-${project.id}'),
                  project: project,
                  onTap: () => showProjectDetailsSheet(context, project),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
