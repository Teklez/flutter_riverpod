import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/auth/auth_notifier.dart';
import 'package:frontend/application/auth/auth_provider.dart';
import 'package:frontend/infrastructure/auth/auth_repository.dart';
import 'package:frontend/presentation/events/auth_event.dart';
import 'package:frontend/presentation/screens/login.dart';
import 'package:frontend/presentation/states/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Mock the AuthRepository and AuthNotifier
class MockAuthNotifier extends Mock implements AuthNotifier {}
class MockAuthRepository extends Mock implements AuthRepository {}

// Create a widget for testing with GoRouter
Widget createWidgetUnderTest(MockAuthNotifier mockAuthNotifier) {
  final mockAuthProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => mockAuthNotifier,
  );

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Home'))),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Admin'))),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authProvider.overrideWith((ref) => mockAuthNotifier),
    ],
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

@GenerateMocks([AuthNotifier, AuthRepository])
void main() {
  testWidgets('LoginPage successful login navigates to /home for non-admin user',
      (WidgetTester tester) async {
    // Create mock notifier and set up the initial state
    final mockAuthNotifier = MockAuthNotifier();
    when(mockAuthNotifier.state).thenReturn(AuthInitial());

    await tester.pumpWidget(createWidgetUnderTest(mockAuthNotifier));

    // Enter username and password
    await tester.enterText(find.byKey(Key('usernameField')), 'user');
    await tester.enterText(find.byKey(Key('passwordField')), 'password');

    // Tap the login button
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump();

    // Simulate successful login
    when(mockAuthNotifier.state).thenReturn(AuthSuccess(message: {'roles': ['user']}));
    mockAuthNotifier.state = AuthSuccess(message: {'roles': ['user']});
    await tester.pumpAndSettle();

    // Verify navigation to /home
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('LoginPage successful login navigates to /admin for admin user',
      (WidgetTester tester) async {
    // Create mock notifier and set up the initial state
    final mockAuthNotifier = MockAuthNotifier();
    when(mockAuthNotifier.state).thenReturn(AuthInitial());

    await tester.pumpWidget(createWidgetUnderTest(mockAuthNotifier));

    // Enter username and password
    await tester.enterText(find.byKey(Key('usernameField')), 'admin');
    await tester.enterText(find.byKey(Key('passwordField')), 'password');

    // Tap the login button
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump();

    // Simulate successful login
    when(mockAuthNotifier.state).thenReturn(AuthSuccess(message: {'roles': ['admin']}));
    mockAuthNotifier.state = AuthSuccess(message: {'roles': ['admin']});
    await tester.pumpAndSettle();

    // Verify navigation to /admin
    expect(find.text('Admin'), findsOneWidget);
  });

  testWidgets('LoginPage shows error message on AuthFailure', (WidgetTester tester) async {
    // Create mock notifier and set up the initial state
    final mockAuthNotifier = MockAuthNotifier();
    when(mockAuthNotifier.state).thenReturn(AuthInitial());

    await tester.pumpWidget(createWidgetUnderTest(mockAuthNotifier));

    // Enter username and password
    await tester.enterText(find.byKey(Key('usernameField')), 'user');
    await tester.enterText(find.byKey(Key('passwordField')), 'wrongpassword');

    // Tap the login button
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump();

    // Simulate authentication failure
    when(mockAuthNotifier.state).thenReturn(AuthFailure(message: 'Invalid credentials'));
    mockAuthNotifier.state = AuthFailure(message: 'Invalid credentials');
    await tester.pump();

    // Verify error message
    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
