import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/project.dart';
import 'featured_property_card.dart';
import 'property_card.dart';

/// Vertical card of "اهم المشاريع العقارية في مصر": photo with the green
/// "مشروع" pill, project name + heart, summary, location / age and the
/// developer, inside a green outline.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.onTap});

  /// Same footprint as the featured cards; the photo takes the top 140dp.
  static const width = FeaturedPropertyCard.width;
  static const height = FeaturedPropertyCard.height;
  static const imageHeight = 140.0;

  final RealEstateProject project;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FeaturedPropertyCard.radius),
        side: const BorderSide(
          color: AppColors.project,
          width: FeaturedPropertyCard.borderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: imageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    project.imageAsset,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                  ),
                  const PositionedDirectional(
                    start: 0,
                    bottom: 7,
                    child: ProjectBadge(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(17, 12, 17, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.name,
                            style: AppTextStyles.projectTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        FavoriteButton(listingId: project.id, size: 19),
                      ],
                    ),
                    Text(
                      project.summary,
                      style: AppTextStyles.listingTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    ListingFooter(
                      location: project.location,
                      listedAgo: project.listedAgoLabel,
                      developer: project.developer,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Green "مشروع" pill with a building icon, hugging the photo's start edge.
class ProjectBadge extends StatelessWidget {
  const ProjectBadge({super.key});

  static const label = 'مشروع';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 21,
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 10, 0),
      decoration: const BoxDecoration(
        color: AppColors.project,
        borderRadius: BorderRadiusDirectional.horizontal(
          end: Radius.circular(11),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.apartment_outlined, size: 14, color: Colors.white),
          SizedBox(width: 4),
          Text(label, style: AppTextStyles.projectBadge),
        ],
      ),
    );
  }
}
