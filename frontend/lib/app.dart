import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class BetApp extends StatelessWidget {
  const BetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BetEbet',
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (BuildContext context) => OnboardingScreen(),
        '/login': (BuildContext context) => const LoginPage(),
        '/': (BuildContext context) => const HomePage(),
        '/register': (BuildContext context) => const RegistrationPage(),
        '/review': (BuildContext context) => const ReviewPage(),
        '/admin': (BuildContext context) => AdminPage(),
        '/add_game': (BuildContext context) =>
            const AddGameForm(buttonName: "Add"),
        '/about': (BuildContext context) => AboutPage(),
        '/users': (BuildContext context) => const UsersPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/review-edit': (BuildContext context) => ReviewEdit(),
        '/review-page': (BuildContext context) => RatingForm(),
        '/game_details': (BuildContext context) => GameDetailPage(
            game: Game(image: "assets/game1.jpg", name: "Game 1")),
        '/profile': (BuildContext context) => const ProfilePage(),
      },
      theme: ThemeData.dark(),
    );
  }
}
