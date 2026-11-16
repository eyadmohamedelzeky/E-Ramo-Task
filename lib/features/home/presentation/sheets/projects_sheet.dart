import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/project.dart';
import '../../state/favorites_controller.dart';
import '../widgets/developer_logo.dart';
import '../widgets/featured_property_card.dart';
import '../widgets/project_card.dart';
import '../widgets/property_card.dart';
import 'app_sheet.dart';

/// "مشاهدة الكل" for the projects section and the drawer's "أحدث المشاريع".
Future<void> showProjectsSheet(
  BuildContext context, {
  required String title,
  required List<RealEstateProject> projects,
}) {
  return showAppSheet<void>(
    context,
    title: '$title (${projects.length})',
    builder: (context, controller) {
      if (projects.isEmpty) {
        return SheetEmptyMessage(
          message: 'لا توجد مشاريع متاحة حالياً',
          controller: controller,
        );
      }
      return LayoutBuilder(
        builder: (context, constraints) {
          // One full-width card per row on phones, more on wide screens.
          final columns = ((constraints.maxWidth - 40 + 12) / 312)
              .floor()
              .clamp(1, 4);
          return GridView.builder(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: ProjectCard.height,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) => ProjectCard(
              project: projects[index],
              onTap: () => showProjectDetailsSheet(context, projects[index]),
            ),
          );
        },
      );
    },
  );
}

/// Details for a tapped project, built only from the local project data.
Future<void> showProjectDetailsSheet(
  BuildContext context,
  RealEstateProject project,
) {
  return showAppSheet<void>(
    context,
    title: project.name,
    initialChildSize: 0.85,
    builder: (context, controller) =>
        _ProjectDetails(project: project, controller: controller),
  );
}

class _ProjectDetails extends StatelessWidget {
  const _ProjectDetails({required this.project, required this.controller});

  final RealEstateProject project;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesScope.of(context);
    final isFavorite = favorites.isFavorite(project.id);

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(FeaturedPropertyCard.radius),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(project.imageAsset, fit: BoxFit.cover),
                const PositionedDirectional(
                  start: 0,
                  bottom: 12,
                  child: ProjectBadge(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                project.name,
                style: AppTextStyles.sheetTitle.copyWith(fontSize: 20),
              ),
            ),
            FavoriteButton(listingId: project.id, size: 26),
          ],
        ),
        Text(
          project.summary,
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        IconLabel(
          icon: Icons.location_on,
          label: project.location,
          style: AppTextStyles.location.copyWith(fontSize: 13),
        ),
        const SizedBox(height: 6),
        IconLabel(
          icon: Icons.access_time,
          label: project.listedAgoLabel,
          style: AppTextStyles.listedAgo.copyWith(fontSize: 13),
        ),
        const Divider(height: 32),
        Row(
          children: [
            DeveloperLogo(developer: project.developer, width: 52, height: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${DeveloperBadge.byLabel} ${project.developer.name}',
                style: AppTextStyles.body,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: () => favorites.toggle(project.id),
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          label: Text(isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة'),
        ),
      ],
    );
  }
}
