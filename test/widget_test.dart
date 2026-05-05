// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App loads and shows game options', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ScoreKeeperApp());

    // Verify that the title is present.
    expect(find.text('Select Game'), findsOneWidget);

    // Verify that the Whist and Rentz buttons are present.
    expect(find.text('Whist'), findsOneWidget);
    expect(find.text('Rentz'), findsOneWidget);
  });
}
