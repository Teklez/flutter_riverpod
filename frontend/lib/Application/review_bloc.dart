import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Domain/review_model.dart';
import '../Infrastructure/review_repository.dart';
import '../Infrastructure/review_service.dart';
import '../Domain/review_state.dart';

final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService();
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final reviewService = ref.watch(reviewServiceProvider);
  return ReviewRepository(reviewService);
});

final reviewNotifierProvider =
    StateNotifierProvider<ReviewBloc, ReviewState>((ref) {
  final reviewRepository = ref.watch(reviewRepositoryProvider);
  return ReviewBloc(reviewRepository);
});

class ReviewBloc extends StateNotifier<ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc(this.reviewRepository) : super(ReviewLoading());

  void fetchReviews(String gameId) async {
    try {
      final List<Review> reviews = await reviewRepository.getReviews(gameId);
      if (reviews.isEmpty) {
        state = ReviewIsEmpty("No reviews found");
      } else {
        state = ReviewsLoadSuccess(reviews);
      }
    } catch (e) {
      state = ReviewOperationFailure("Failed to load reviews");
    }
  }

  void addReview(Review review, String gameId) async {
    try {
      await reviewRepository.createReview(review, gameId);
      state = ReviewOperationSuccess("Review added successfully");
    } catch (e) {
      state = ReviewOperationFailure("Failed to add review");
    }
  }

  void editReview(Review review, String gameId) async {
    try {
      await reviewRepository.updateReview(review.id, review);
      state = ReviewUpdateSuccess("Review updated successfully");
    } catch (e) {
      state = ReviewOperationFailure("Failed to update review");
    }
  }

  void deleteReview(String reviewId, String gameId) async {
    try {
      await reviewRepository.deleteReview(reviewId, gameId);
      state = ReviewOperationSuccess("Review deleted successfully");
    } catch (e) {
      state = ReviewOperationFailure("Failed to delete review");
    }
  }

  void fetchReview(String reviewId) async {
    try {
      final review = await reviewRepository.getReview(reviewId);
      state = ReviewLoadSuccess(review);
    } catch (e) {
      state = ReviewOperationFailure("Failed to load review");
    }
  }
}
