import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_review_app/providers/game_review_provider.dart';
import 'package:game_review_app/widgets/list_review.dart';
import 'package:game_review_app/widgets/rating_Progress_Indicator.dart';
import 'package:game_review_app/widgets/rating_star.dart';
import 'package:go_router/go_router.dart';

class GameReviewPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameReviews = ref.watch(gameReviewProvider);
    final ratingProgress = ref.watch(ratingProgressProvider);
    final averageRating = ref.watch(averageRatingProvider);
    final totalReviews = ref.watch(totalReviewsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          icon: const Icon(
            Icons.home,
            color: Colors.grey,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ratings and reviews are verified and are from people who use the same type of device that you use.",
              style: TextStyle(color: Colors.grey[200]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    averageRating.toStringAsFixed(1),
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
                        value: ratingProgress[5] ?? 0.0,
                      ),
                      RatingProgressIndicator(
                        text: "4",
                        value: ratingProgress[4] ?? 0.0,
                      ),
                      RatingProgressIndicator(
                        text: "3",
                        value: ratingProgress[3] ?? 0.0,
                      ),
                      RatingProgressIndicator(
                        text: "2",
                        value: ratingProgress[2] ?? 0.0,
                      ),
                      RatingProgressIndicator(
                        text: "1",
                        value: ratingProgress[1] ?? 0.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            RatingStar(
              rating: averageRating,
            ),
            Text(
              totalReviews.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[200],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Rate this app',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Share your experience with us',
              style: TextStyle(
                color: Colors.white,
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
                      return context.go("/add_review");
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
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
                          ),
                        ],
                        color: const Color.fromARGB(255, 76, 71, 71),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "What do you think of this Game?",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 110,
                                ),
                                RatingStar(
                                  rating: 0,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      height: 90,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Conditionally display the list of reviews or a "no reviews yet" message
            Expanded(
              child: gameReviews.isEmpty
                  ? Center(
                      child: Text(
                        'No reviews yet.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListReview(gameReviews: gameReviews),
            ),
          ],
        ),
      ),
    );
  }
}
