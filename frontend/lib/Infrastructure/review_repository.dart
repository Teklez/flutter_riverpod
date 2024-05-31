import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/review_model.dart';
import 'package:frontend/Infrastructure/review_service.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final reviewService = ref.watch(reviewServiceProvider);
  return ReviewRepository(reviewService);
});

class ReviewRepository {
  final ReviewService _reviewService;

  ReviewRepository(this._reviewService);

  Future<List<Review>> getReviews(String gameId) async {
    return _reviewService.getReviews(gameId);
  }

  Future<Review> getReview(String id) async {
    return _reviewService.getReview(id);
  }

  Future<Review> createReview(Review review, String gameId) async {
    return _reviewService.createReview(review, gameId);
  }

  Future<Review> updateReview(String id, Review review) async {
    return _reviewService.updateReview(id, review);
  }

  Future<void> deleteReview(String id, String gameId) async {
    return _reviewService.deleteReview(id, gameId);
  }
}
