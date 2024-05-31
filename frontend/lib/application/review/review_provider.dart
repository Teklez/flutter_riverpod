import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/review/review_notifier.dart';
import 'package:frontend/infrastructure/review/review_repository.dart';
import 'package:frontend/infrastructure/review/review_service.dart';
import '../../presentation/states/review_state.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(reviewService: ReviewService());
});

final reviewProvider =
    StateNotifierProvider<ReviewNotifier, ReviewState>((ref) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return ReviewNotifier(reviewRepository: reviewRepository);
});
