import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_review.dart';

final gameReviewProvider =
    StateNotifierProvider<GameReviewNotifier, List<GameReview>>((ref) {
  return GameReviewNotifier();
});

class GameReviewNotifier extends StateNotifier<List<GameReview>> {
  GameReviewNotifier() : super([]);

  void addReview(GameReview review) {
    state = [...state, review];
  }

  void updateReview(DateTime originalTimeOfPost, GameReview updatedReview) {
    state = [
      for (final review in state)
        if (review.timeOfPost == originalTimeOfPost) updatedReview else review
    ];
  }

  void deleteReview(DateTime timeOfPost) {
    state = state.where((review) => review.timeOfPost != timeOfPost).toList();
  }
}

final ratingProgressProvider = Provider<Map<int, double>>((ref) {
  final reviews = ref.watch(gameReviewProvider);

  if (reviews.isEmpty) {
    return {1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0};
  }

  final totalReviews = reviews.length;
  final ratingCounts = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
  };

  for (final review in reviews) {
    final rating = review.rating.round();
    ratingCounts[rating] = (ratingCounts[rating] ?? 0) + 1;
  }

  final progressValues = ratingCounts.map((rating, count) {
    return MapEntry(rating, count / totalReviews);
  });

  return progressValues;
});

final averageRatingProvider = Provider<double>((ref) {
  final reviews = ref.watch(gameReviewProvider);

  if (reviews.isEmpty) return 0.0;

  final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
  return totalRating / reviews.length;
});

final totalReviewsProvider = Provider<int>((ref) {
  final reviews = ref.watch(gameReviewProvider);
  return reviews.length;
});
