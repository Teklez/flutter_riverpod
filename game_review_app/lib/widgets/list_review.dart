import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_review_app/models/game_review.dart';
import 'package:game_review_app/screens/review_add.dart';
import 'package:game_review_app/widgets/dialogues.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ListReview extends StatelessWidget {
  const ListReview({
    Key? key,
    required this.gameReviews,
  }) : super(key: key);

  final List<GameReview> gameReviews;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gameReviews.length,
      itemBuilder: (context, index) {
        final review = gameReviews[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          review.username,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        _formatDateTime(review.timeOfPost),
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          review.description,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        review.rating.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      EditDeleteDialogue(
                        review: review,
                        route: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddReviewPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                return context.go("/detial_review", extra: review);
              }),
        );
      },
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  final date = DateFormat.yMMMd().format(dateTime);
  final time = DateFormat.jm().format(dateTime);
  return '$date at $time';
}
