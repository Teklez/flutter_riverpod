import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/screens/about.dart'; // Import the AboutPage widget

void main() {
  testWidgets('About page displays title correctly',
      (WidgetTester tester) async {
    // Build the AboutPage widget
    await tester.pumpWidget(MaterialApp(home: AboutPage()));

    // Verify that the title "Welcome to BetEbet" is displayed
    expect(find.text('Welcome to BetEbet'), findsOneWidget);
  });
}
