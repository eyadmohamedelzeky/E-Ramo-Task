import 'package:flutter/material.dart';

import '../../models/city.dart';
import '../widgets/city_section.dart';
import 'app_sheet.dart';

/// "مشاهدة الكل" for the city section: a grid of all cities.
Future<void> showCitiesSheet(BuildContext context, List<City> cities) {
  return showAppSheet<void>(
    context,
    title: CitySection.title,
    builder: (context, controller) => GridView.builder(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 166 / 221,
      ),
      itemCount: cities.length,
      itemBuilder: (context, index) => CityCard(
        city: cities[index],
        onTap: () => CitySection.openCity(context, cities[index]),
      ),
    ),
  );
}
