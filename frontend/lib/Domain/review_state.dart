import 'package:frontend/Domain/review_model.dart';

class ReviewState {
  const ReviewState();
}

class ReviewLoading extends ReviewState {}

class ReviewsLoadSuccess extends ReviewState {
  final List<Review> reviews;
  ReviewsLoadSuccess(this.reviews);
}

class ReviewOperationSuccess extends ReviewState {
  final String message;

  ReviewOperationSuccess(this.message);
}

class ReviewOperationFailure extends ReviewState {
  final String message;

  ReviewOperationFailure(this.message);
}

class ReviewLoadSuccess extends ReviewState {
  final dynamic review;

  ReviewLoadSuccess(this.review);
}

class ReviewIsEmpty extends ReviewState {
  final String message;

  ReviewIsEmpty(this.message);
}

class ReviewUpdateSuccess extends ReviewState {
  final String message;

  ReviewUpdateSuccess(this.message);
}
