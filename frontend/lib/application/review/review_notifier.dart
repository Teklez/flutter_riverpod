import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/events/review_event.dart';
import 'package:frontend/domain/review_model.dart';
import 'package:frontend/infrastructure/review/review_repository.dart';
import 'package:frontend/presentation/states/review_state.dart';

class ReviewNotifier extends StateNotifier<ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewNotifier({required this.reviewRepository}) : super(ReviewLoading());

  Future<void> handleFetchReviews(FetchReviews event) async {
    try {
      final List<Review> reviews =
          await reviewRepository.getReviews(event.gameId);
      state = ReviewsLoadSuccess(reviews);
    } catch (e) {
      state = ReviewOperationFailure("Failed to load reviews");
    }
  }

  Future<void> handleAddReview(AddReview event) async {
    try {
      await reviewRepository.createReview(event.review, event.gameId);
      final List<Review> reviews =
          await reviewRepository.getReviews(event.gameId);
      state = ReviewsLoadSuccess(reviews);
    } catch (e) {
      state = ReviewOperationFailure("Failed to add review");
      throw Exception('Error adding review: $e');
    }
  }

  Future<void> handleEditReview(EditReview event) async {
    try {
      await reviewRepository.updateReview(event.review.id, event.review);
      final List<Review> reviews =
          await reviewRepository.getReviews(event.gameId);
      state = ReviewsLoadSuccess(reviews);
    } catch (e) {
      state = ReviewOperationFailure("Failed to update review");
    }
  }

  Future<void> handleDeleteReview(DeleteReview event) async {
    try {
      await reviewRepository.deleteReview(event.reviewId, event.gameId);
      final List<Review> reviews =
          await reviewRepository.getReviews(event.gameId);
      state = ReviewsLoadSuccess(reviews);
    } catch (e) {
      state = ReviewOperationFailure("Failed to delete review");
    }
  }

  Future<void> handleFetchReview(FetchReview event) async {
    try {
      final dynamic review = await reviewRepository.getReview(event.reviewId);
      state = ReviewLoadSuccess(review);
    } catch (e) {
      state = ReviewOperationFailure("Failed to load review");
    }
  }
}
