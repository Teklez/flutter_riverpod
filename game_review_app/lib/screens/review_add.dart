import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_review_app/models/game_review.dart';
import 'package:game_review_app/providers/game_review_provider.dart';
import 'package:go_router/go_router.dart';

class AddReviewPage extends StatefulWidget {
  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ratingController.addListener(_updateRating);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _ratingController.removeListener(_updateRating);
    _ratingController.dispose();
    super.dispose();
  }

  void _updateRating() {
    setState(() {
      int? ratingValue = int.tryParse(_ratingController.text);
      rating = ratingValue != null && ratingValue > 0 && ratingValue <= 5
          ? ratingValue
          : 0;
    });
  }

  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              'Add Review',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'If you enjoy this app, take a moment to rate it?',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i <= 5; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            rating = i;
                            _ratingController.text = i.toString();
                          });
                        },
                        child: Icon(
                          Icons.star,
                          size: 40.0,
                          color: i <= rating ? Colors.yellow : Colors.grey,
                        ),
                      ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _descriptionController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: 'Review',
                            labelStyle: TextStyle(color: Colors.white)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _ratingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: 'Rating',
                            labelStyle: TextStyle(color: Colors.white)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a rating';
                          }
                          if (int.tryParse(value) == null ||
                              int.parse(value) < 1 ||
                              int.parse(value) > 5) {
                            return 'Please enter a number between 1 and 5';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final review = GameReview(
                              timeOfPost: DateTime.now(),
                              username: "Hanna Akalu",
                              description: _descriptionController.text,
                              rating: rating.toDouble(),
                            );
                            ref
                                .read(gameReviewProvider.notifier)
                                .addReview(review);
                            context.pop();
                          }
                        },
                        child: Text('Add Review'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
