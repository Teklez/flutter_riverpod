//admin_page rendering the things correctly
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/screens/admin_page.dart';

void main() {
  testWidgets('AdminPage has an AppBar with title "BetEbet"', (WidgetTester tester) async {

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: AdminPage(),
        ),
      ),
    );

    final appBarFinder = find.byType(AppBar);

    expect(appBarFinder, findsOneWidget);

    final titleFinder = find.text('BetEbet');

    expect(titleFinder, findsOneWidget);
    
    final searchIconButtonFinder = find.widgetWithIcon(IconButton, Icons.search);

    expect(searchIconButtonFinder, findsOneWidget);
  });
}
