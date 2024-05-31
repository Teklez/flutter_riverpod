import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/review_model.dart';

final reviewFormProvider = Provider.autoDispose((ref) => ReviewForm());

class ReviewForm extends ChangeNotifier {
  final TextEditingController reviewController = TextEditingController();
  int rating = 0;

  void setRating(int value) {
    rating = value;
    notifyListeners();
  }

  Future<void> submitReview(BuildContext context, String gameId) async {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a rating')),
      );
      return;
    }
    if (reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a review')),
      );
      return;
    }

    // Form is valid
    double ratingValue = rating.toDouble();
    String review = reviewController.text;

    final curReview = Review(
      username: "Hanni",
      id: review,
      comment: review,
      rating: ratingValue,
      date: DateTime.now().toString(),
    );

    // You can perform the review submission logic here
    // For demonstration purpose, I'm just printing the review
    print('Submitting review: $curReview for gameId: $gameId');

    Navigator.pop(context);
  }
}

class RatingForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewForm = ref.watch(reviewFormProvider);

    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String gameId = arguments['gameId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If you enjoy this app, take a moment to rate it?',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () {
                      reviewForm.setRating(i);
                    },
                    child: Icon(
                      Icons.star,
                      size: 40.0,
                      color:
                          i <= reviewForm.rating ? Colors.yellow : Colors.grey,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: reviewForm.reviewController,
              maxLines: null,
              minLines: 2,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white), // Text color set to white
              decoration: InputDecoration(
                hintText: 'Enter your review here...',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                // Background color of the text field
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a review';
                }
                return null;
              },
            ),
            SizedBox(height: 24.0),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  reviewForm.submitReview(context, gameId);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
