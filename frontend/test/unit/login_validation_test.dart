//login validarion
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/screens/login.dart';

void main() {
  testWidgets('LoginPage validates username and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    final loginButtonFinder = find.widgetWithText(ElevatedButton, 'Log In');
    await tester.tap(loginButtonFinder);
    await tester.pump();

    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'testuser');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), '123');
    await tester.tap(loginButtonFinder);
    await tester.pump();

    expect(find.text('Please enter your username'), findsNothing);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'testuser');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(loginButtonFinder);
    await tester.pump();

    expect(find.text('Please enter your username'), findsNothing);
    expect(find.text('Please enter your password'), findsNothing);
    expect(find.text('Password must be at least 6 characters'), findsNothing);
  });
}
