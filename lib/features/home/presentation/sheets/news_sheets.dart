import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../models/news_article.dart';
import '../widgets/news_section.dart';
import 'app_sheet.dart';

/// "مشاهدة الكل" for the news section.
Future<void> showAllNewsSheet(
  BuildContext context,
  List<NewsArticle> articles,
) {
  return showAppSheet<void>(
    context,
    title: NewsSection.title,
    builder: (context, controller) => ListView.separated(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      itemCount: articles.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) => NewsCard(
        article: articles[index],
        imageHeight: 170,
        expandBody: false,
        onTap: () => showArticleSheet(context, articles[index]),
      ),
    ),
  );
}

/// Full article view for a tapped news card.
Future<void> showArticleSheet(BuildContext context, NewsArticle article) {
  return showAppSheet<void>(
    context,
    title: article.title,
    builder: (context, controller) => ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(NewsCard.radius),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(article.imageAsset, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Text(article.title, style: AppTextStyles.sheetTitle),
        const SizedBox(height: 8),
        Text(article.summary, style: AppTextStyles.body),
      ],
    ),
  );
}
