import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_review_app/models/game_review.dart';

import 'package:go_router/go_router.dart';

class ReviewDetailPage extends ConsumerWidget {
  final GameReview review;

  ReviewDetailPage({required this.review});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          review.username,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              review.description,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Rating: ${review.rating}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Delete Review'),
            ),
            ElevatedButton(
              onPressed: () {
                return context.go("/edit_review", extra: review);
              },
              child: Text('Edit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
