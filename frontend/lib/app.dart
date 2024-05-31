import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/Domain/game_model.dart';
import 'package:frontend/Infrastructure/auth_repository.dart';
import 'package:frontend/Infrastructure/auth_service.dart';
import 'package:frontend/Infrastructure/game_repository.dart';
import 'package:frontend/Infrastructure/game_service.dart';
import 'package:frontend/Infrastructure/review_repository.dart';
import 'package:frontend/Infrastructure/review_service.dart';
import 'package:frontend/Infrastructure/users_repository.dart';
import 'package:frontend/Infrastructure/users_service.dart';
import 'package:frontend/presentation/screens/about.dart';
import 'package:frontend/presentation/screens/game_add.dart';
import 'package:frontend/presentation/screens/game_detail.dart';
import 'package:frontend/presentation/screens/login.dart';
import 'package:frontend/presentation/screens/home.dart';
import 'package:frontend/presentation/screens/register.dart';
import 'package:frontend/presentation/screens/admin_page.dart';
import 'package:frontend/presentation/screens/review.dart';
import 'package:frontend/presentation/screens/review_edit.dart';
import 'package:frontend/presentation/screens/users.dart';
import 'package:frontend/presentation/screens/onboarding_screen.dart';
import 'package:frontend/presentation/widgets/rating_page.dart';
import 'presentation/screens/profile.dart';

// Providers for Services
final gameServiceProvider = Provider((ref) => GameService());
final userServiceProvider = Provider((ref) => UsersService());
final authServiceProvider = Provider((ref) => AuthService());
final reviewServiceProvider = Provider((ref) => ReviewService());

// Providers for Repositories
final gameRepositoryProvider = Provider((ref) {
  final gameService = ref.watch(gameServiceProvider);
  return GameRepository(gameService);
});

final userRepositoryProvider = Provider((ref) {
  final userService = ref.watch(userServiceProvider);
  return UsersRepository(userService: userService);
});

final authRepositoryProvider = Provider((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepository(authService: authService);
});

final reviewRepositoryProvider = Provider((ref) {
  final reviewService = ref.watch(reviewServiceProvider);
  return ReviewRepository(reviewService);
});

class AddGameFormWrapper extends StatelessWidget {
  const AddGameFormWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AddGameForm(buttonName: "Add");
  }
}

class BetApp extends StatelessWidget {
  const BetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) =>  OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => const LoginPage(),
        ),
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => const HomePage(),
        ),
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) => const RegistrationPage(),
        ),
        GoRoute(
          path: '/review',
          builder: (BuildContext context, GoRouterState state) => const ReviewPage(),
        ),
        GoRoute(
          path: '/admin',
          builder: (BuildContext context, GoRouterState state) => AdminPage(),
        ),
        GoRoute(
          path: '/add_game',
          builder: (BuildContext context, GoRouterState state) => const AddGameFormWrapper(),
        ),
        GoRoute(
          path: '/about',
          builder: (BuildContext context, GoRouterState state) => AboutPage(),
        ),
        GoRoute(
          path: '/users',
          builder: (BuildContext context, GoRouterState state) => const UsersPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) => const HomePage(),
        ),
        GoRoute(
          path: '/review-edit',
          builder: (BuildContext context, GoRouterState state) => const ReviewEdit(),
        ),
        GoRoute(
          path: '/review-page',
          builder: (BuildContext context, GoRouterState state) => RatingForm(),
        ),
        GoRoute(
          path: '/game_details',
          builder: (BuildContext context, GoRouterState state) => GameDetailPage(
            game: Game(image: "assets/game1.jpg", name: "Game 1"),
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'BetEbet',
        theme: ThemeData.dark(),
        routerConfig: _router,
      ),
    );
  }
}