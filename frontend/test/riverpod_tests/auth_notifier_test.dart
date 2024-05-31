import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/auth/auth_notifier.dart';
import 'package:frontend/application/auth/auth_provider.dart';
import 'package:frontend/infrastructure/auth/auth_repository.dart';
import 'package:frontend/presentation/events/auth_event.dart';
import 'package:frontend/presentation/states/auth_state.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes for dependencies
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;
  late AuthNotifier authNotifier;

  setUp(() {
    // Setting up the mock repository and provider container
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    authNotifier = container.read(authProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('authProvider should handle user update correctly', () async {
    print('Test: authProvider should handle user update correctly');
    when(() => mockAuthRepository.update(any(), any(), any(), any()))
        .thenAnswer(
      (_) async => {'username': 'updatedUser'},
    );
    expect(container.read(authProvider), AuthInitial());

    await authNotifier.handleUserUpdated(const UserUpdated(
      id: '123',
      username: 'updatedUser',
      oldPassword: 'oldPass',
      newPassword: 'newPass',
    ));

    expect(container.read(authProvider), isA<AuthSuccess>());
    print('Result: Success');
  });

  test('authProvider should handle user login failure', () async {
    print('Test: authProvider should handle user login failure');
    when(() => mockAuthRepository.login(any(), any())).thenThrow(
      Exception('User name or password is incorrect'),
    );
    expect(container.read(authProvider), AuthInitial());
    await authNotifier.handleUserLoggedIn(
        UserLoggedIn(username: 'test', password: 'wrong_password'));
    expect(container.read(authProvider), isA<AuthFailure>());
    print('Result: Failure');
  });

  test('authProvider should handle user registration correctly', () async {
    print('Test: authProvider should handle user registration correctly');
    when(() => mockAuthRepository.register(any(), any())).thenAnswer(
      (_) async => {'username': 'newUser'},
    );
    expect(container.read(authProvider), AuthInitial());
    await authNotifier.handleUserRegistered(
        UserRegistered(username: 'newUser', password: 'password'));
    expect(container.read(authProvider), isA<AuthSuccess>());
    print('Result: Success');
  });

  test('authProvider should handle user registration failure', () async {
    print('Test: authProvider should handle user registration failure');
    when(() => mockAuthRepository.register(any(), any())).thenThrow(
      Exception('Failed to register user'),
    );
    expect(container.read(authProvider), AuthInitial());
    await authNotifier.handleUserRegistered(
        UserRegistered(username: 'newUser', password: 'password'));
    expect(container.read(authProvider), isA<AuthFailure>());
    print('Result: Failure');
  });

  test('authProvider should handle current user retrieval correctly', () async {
    print('Test: authProvider should handle current user retrieval correctly');
    when(() => mockAuthRepository.getCurrentUser()).thenAnswer(
      (_) async => {'username': 'currentUser'},
    );
    expect(container.read(authProvider), AuthInitial());
    await authNotifier.handleCurrentUser(CurrentUser());
    expect(container.read(authProvider), isA<AuthSuccess>());
    print('Result: Success');
  });

  test('authProvider should handle current user retrieval failure', () async {
    print('Test: authProvider should handle current user retrieval failure');
    when(() => mockAuthRepository.getCurrentUser()).thenThrow(
      Exception('Not authenticated'),
    );
    expect(container.read(authProvider), AuthInitial());
    await authNotifier.handleCurrentUser(CurrentUser());
    expect(container.read(authProvider), isA<AuthFailure>());
    print('Result: Failure');
  });

  test('authProvider should handle app started correctly', () async {
    print('Test: authProvider should handle app started correctly');
    when(() => mockAuthRepository.getCurrentUser()).thenAnswer(
      (_) async => {'username': 'currentUser'},
    );
    expect(container.read(authProvider), AuthInitial());
    await authNotifier.handleAppStarted(AppStarted());
    expect(container.read(authProvider), isA<AuthSuccess>());
    print('Result: Success');
  });

  test('authProvider should handle app started failure', () async {
    print('Test: authProvider should handle app started failure');
    when(() => mockAuthRepository.getCurrentUser()).thenThrow(
      Exception('Not authenticated'),
    );
    expect(container.read(authProvider), AuthInitial());
    await authNotifier.handleAppStarted(AppStarted());

    expect(container.read(authProvider), isA<AuthFailure>());
    print('Result: Failure');
  });
}
