import 'package:e_ramo_task/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled Cairo font so text is laid out with real metrics
/// (the default test font renders every glyph as a square).
Future<void> loadAppFonts() async {
  final loader = FontLoader('Cairo');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(rootBundle.load('assets/fonts/Cairo-$weight.ttf'));
  }
  await loader.load();
}

/// Sets the logical screen size for the current test and restores it after.
void setScreenSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

/// Pumps the full app. A tall screen keeps every section built at once.
Future<void> pumpApp(
  WidgetTester tester, {
  Size size = const Size(393, 5200),
}) async {
  setScreenSize(tester, size);
  await tester.pumpWidget(const ERamoApp());
  await tester.pumpAndSettle();
}
