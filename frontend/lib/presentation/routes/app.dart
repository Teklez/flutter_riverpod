import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/screens/about.dart';
import 'package:frontend/presentation/screens/game_add.dart';
import 'package:frontend/presentation/screens/game_detail.dart';
import 'package:frontend/presentation/screens/login.dart';
import 'package:frontend/presentation/screens/home.dart';
import 'package:frontend/presentation/screens/profile.dart';
import 'package:frontend/presentation/screens/register.dart';
import 'package:frontend/presentation/screens/admin_page.dart';
import 'package:frontend/presentation/screens/review.dart';
import 'package:frontend/presentation/screens/review_edit.dart';
import 'package:frontend/presentation/screens/search.dart';
import 'package:frontend/presentation/screens/users.dart';
import 'package:frontend/presentation/screens/onboarding_screen.dart';
import 'package:frontend/presentation/screens/rating_page.dart';

class BetApp extends StatelessWidget {
  const BetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegistrationPage(),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>?;
            final String? gameId = args?['gameId'] as String?;
            if (gameId == null) {
              return const ErrorPage(message: "Game ID not provided.");
            }
            return ReviewPage(gameId: gameId);
          },
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminPage(),
        ),
        GoRoute(
          path: '/add_game',
          builder: (context, state) => const AddGameForm(buttonName: "Add"),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => AboutPage(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const UsersPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchPage(),
        ),
        GoRoute(
          path: '/review-edit',
          builder: (context, state) => ReviewEdit(),
        ),
        GoRoute(
          path: '/review-page',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>?;
            final String? gameId = args?['gameId'] as String?;
            if (gameId == null) {
              return const ErrorPage(message: "Game ID not provided.");
            }
            return RatingForm(gameId: gameId);
          },
        ),
        GoRoute(
          path: '/game-detail',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>?;
            final game = args?['game'];
            if (game == null) {
              return const ErrorPage(message: "Game details not provided.");
            }
            return GameDetailPage(game: game);
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BetEbet',
      routerConfig: router,
      theme: ThemeData.dark(),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: Center(child: Text(message)),
    );
  }
}

void main() {
  runApp(const BetApp());
}
