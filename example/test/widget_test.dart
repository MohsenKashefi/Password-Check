// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:password_check_example/main.dart';

void main() {
  testWidgets('Password Check Demo smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PasswordCheckApp());

    // Verify that the app loads with the expected widgets.
    expect(find.text('Password Check Demo'), findsOneWidget);
    expect(find.text('Password Validation'), findsOneWidget);
    expect(find.text('Password Generation'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Generate Strong Password'), findsOneWidget);
  });
}
