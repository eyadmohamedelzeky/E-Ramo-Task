import 'package:flutter_test/flutter_test.dart';

import 'package:e_ramo_task/main.dart';

void main() {
  testWidgets('renders the RTL real-estate home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ERamoApp());

    expect(find.text('مشاهدة الكل'), findsWidgets);
  });
}
