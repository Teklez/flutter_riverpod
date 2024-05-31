import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/review/review_provider.dart';
import 'package:frontend/presentation/events/review_event.dart';
import 'package:frontend/presentation/states/review_state.dart';
import 'package:frontend/presentation/widgets/rating.dart';
import 'package:frontend/presentation/widgets/rating_Progress_Indicator.dart';
import 'package:frontend/presentation/widgets/user_review_card.dart';
import 'package:go_router/go_router.dart';

class ReviewPage extends ConsumerWidget {
  final String gameId;
  const ReviewPage({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameId = this.gameId;

    ref.listen<ReviewState>(reviewProvider, (previous, state) {
      if (state is ReviewsLoadSuccess) {}
    });

    ref.read(reviewProvider.notifier).handleFetchReviews(FetchReviews(gameId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          final state = ref.watch(reviewProvider);
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewsLoadSuccess) {
            final reviews = state.reviews;
            List<int> ratingCount = [0, 0, 0, 0, 0];
            var totalRating = 0.0;
            var totalReviews = reviews.length;

            for (var review in reviews) {
              totalRating += review.rating;
              ratingCount[review.rating.toInt() - 1]++;
            }

            totalRating =
                reviews.isNotEmpty ? totalRating / reviews.length : 0.0;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ratings and reviews are verified and are from people who use the same type of device that you use.",
                      style: TextStyle(color: Colors.grey[200]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            totalRating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[350],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              RatingProgressIndicator(
                                text: "5",
                                value: totalReviews > 0
                                    ? ratingCount[4] / totalReviews
                                    : 0.0,
                              ),
                              RatingProgressIndicator(
                                text: "4",
                                value: totalReviews > 0
                                    ? ratingCount[3] / totalReviews
                                    : 0.0,
                              ),
                              RatingProgressIndicator(
                                text: "3",
                                value: totalReviews > 0
                                    ? ratingCount[2] / totalReviews
                                    : 0.0,
                              ),
                              RatingProgressIndicator(
                                text: "2",
                                value: totalReviews > 0
                                    ? ratingCount[1] / totalReviews
                                    : 0.0,
                              ),
                              RatingProgressIndicator(
                                text: "1",
                                value: totalReviews > 0
                                    ? ratingCount[0] / totalReviews
                                    : 0.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    RatingStar(
                      rating: totalRating,
                    ),
                    Text(
                      totalReviews.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[200]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Rate this app',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Share your experience with us',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.push('/review-page', extra: {
                                'gameId': gameId,
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    offset: const Offset(2.0, 2.0),
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  ),
                                  const BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-1.0, -1.0),
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  )
                                ],
                                color: const Color.fromARGB(255, 76, 71, 71),
                              ),
                              height: 90,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "What do you think of this Game?",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 110,
                                        ),
                                        RatingStar(
                                          rating: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(height: 20),
                    // Displaying UserReview widgets for each review
                    ...reviews.map((review) => UserReview(
                          review: review,
                          gameId: gameId,
                        )),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
