import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/user/users_notifier.dart';
import 'package:frontend/application/user/users_provider.dart';
import 'package:frontend/domain/users_model.dart';
import 'package:frontend/infrastructure/user/users_repository.dart';
import 'package:frontend/presentation/events/users_event.dart';
import 'package:frontend/presentation/states/users_state.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes for dependencies
class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  late ProviderContainer container;
  late MockUsersRepository mockUsersRepository;
  late UsersNotifier usersNotifier;

  setUp(() {
    // Setting up the mock repository and provider container
    mockUsersRepository = MockUsersRepository();
    container = ProviderContainer(
      overrides: [
        usersRepositoryProvider.overrideWithValue(mockUsersRepository),
      ],
    );
    usersNotifier = container.read(usersProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('usersProvider should handle fetch users successfully', () async {
    print('Test: usersProvider should handle fetch users successfully');
    final users = [
      User(id: '1', username: 'User 1', password: 'password1'),
      User(id: '2', username: 'User 2', password: 'password2'),
    ];

    when(() => mockUsersRepository.fetchUsers()).thenAnswer((_) async => users);
    expect(container.read(usersProvider), UsersInitial());

    await usersNotifier.handleFetchUsers(FetchUsers());

    expect(container.read(usersProvider), isA<UsersLoadSuccess>());
    expect((container.read(usersProvider) as UsersLoadSuccess).users, users);
    print('Result: Success with fetched users');
  });

  test('usersProvider should handle fetch users with no results', () async {
    print('Test: usersProvider should handle fetch users with no results');
    when(() => mockUsersRepository.fetchUsers()).thenAnswer((_) async => []);
    expect(container.read(usersProvider), UsersInitial());

    await usersNotifier.handleFetchUsers(FetchUsers());

    expect(container.read(usersProvider), isA<UsersEmpty>());
    print('Result: Success with no users');
  });

  test('usersProvider should handle change status successfully', () async {
    print('Test: usersProvider should handle change status successfully');
    final updatedUser = User(
        id: '1', username: 'User 1', password: 'password1', status: 'blocked');
    final users = [
      updatedUser,
      User(id: '2', username: 'User 2', password: 'password2'),
    ];

    when(() => mockUsersRepository.changeStatus(updatedUser))
        .thenAnswer((_) async {});
    when(() => mockUsersRepository.fetchUsers()).thenAnswer((_) async => users);

    await usersNotifier.handleChangeStatus(ChangeStatus(updatedUser));

    expect(container.read(usersProvider), isA<UsersLoadSuccess>());
    expect((container.read(usersProvider) as UsersLoadSuccess).users, users);
    print('Result: Success with status changed');
  });

  test('usersProvider should handle change status failure', () async {
    print('Test: usersProvider should handle change status failure');
    final updatedUser = User(
        id: '1', username: 'User 1', password: 'password1', status: 'blocked');

    when(() => mockUsersRepository.changeStatus(updatedUser))
        .thenThrow(Exception('Failed to change status'));
    expect(container.read(usersProvider), UsersInitial());

    await usersNotifier.handleChangeStatus(ChangeStatus(updatedUser));

    expect(container.read(usersProvider), isA<UsersError>());
    print('Result: Failure to change status');
  });
}
