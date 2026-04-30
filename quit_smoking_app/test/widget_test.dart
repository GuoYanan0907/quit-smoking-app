import 'package:flutter_test/flutter_test.dart';

import 'package:quit_smoking_app/main.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const QuitSmokingApp());
    await tester.pumpAndSettle();
  });
}
