import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/news_article.dart';
import '../sheets/news_sheets.dart';
import 'section_header.dart';

/// "اهم الأخبار": horizontally scrolling article cards.
class NewsSection extends StatelessWidget {
  const NewsSection({super.key, required this.articles});

  static const title = 'اهم الأخبار';

  /// 221 x 227dp cards on a 375dp frame.
  static const cardHeight = 227.0;
  static const _widthFactor = 221 / 375;
  static const _gap = 14.0;

  final List<NewsArticle> articles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: title,
          onViewAll: () => showAllNewsSheet(context, articles),
        ),
        const SizedBox(height: 19),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = math.min(
              math.max(constraints.maxWidth * _widthFactor, 200.0),
              300.0,
            );
            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: SectionHeader.horizontalPadding,
                ),
                itemCount: articles.length,
                separatorBuilder: (_, _) => const SizedBox(width: _gap),
                itemBuilder: (context, index) => SizedBox(
                  width: cardWidth,
                  child: NewsCard(
                    article: articles[index],
                    onTap: () => showArticleSheet(context, articles[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.article,
    this.onTap,
    this.imageHeight = 108,
    this.expandBody = true,
  });

  static const radius = 14.0;

  final NewsArticle article;
  final VoidCallback? onTap;
  final double imageHeight;

  /// Fill the remaining card height with the summary (fixed-height cards in
  /// the feed); `false` lets the card size itself (lists in sheets).
  final bool expandBody;

  @override
  Widget build(BuildContext context) {
    // The design wraps the summary in a narrower box (four lines).
    final summary = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 30, 12),
      child: Text(
        article.summary,
        style: AppTextStyles.newsBody,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
    return Material(
      color: AppColors.newsCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: AppColors.newsCardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: expandBody ? MainAxisSize.max : MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(
                article.imageAsset,
                height: imageHeight,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
              child: Text(
                article.title,
                style: AppTextStyles.newsTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 7),
            // In fixed-height feed cards the summary yields space (and is
            // clipped with an ellipsis) instead of overflowing.
            if (expandBody) Flexible(child: summary) else summary,
          ],
        ),
      ),
    );
  }
}
