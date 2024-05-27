import 'package:flutter/cupertino.dart';
import 'package:game_review_app/models/game_review.dart';
import 'package:game_review_app/screens/review.dart';
import 'package:game_review_app/screens/review_add.dart';
import 'package:game_review_app/screens/review_detail.dart';
import 'package:game_review_app/screens/review_edit.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return GameReviewPage();
      },
      routes: [
        GoRoute(
          path: 'add_review',
          builder: (BuildContext context, GoRouterState state) {
            return AddReviewPage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/edit_review',
      builder: (BuildContext context, GoRouterState state) {
        final review = state.extra as GameReview;
        return EditReviewPage(review: review);
      },
    ),
    GoRoute(
      path: '/detail_review',
      builder: (BuildContext context, GoRouterState state) {
        final review = state.extra as GameReview;
        return ReviewDetailPage(review: review);
      },
    ),
  ],
);
