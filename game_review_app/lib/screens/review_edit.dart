import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_review_app/models/game_review.dart';
import 'package:game_review_app/providers/game_review_provider.dart';

class EditReviewPage extends StatefulWidget {
  final GameReview review;

  EditReviewPage({required this.review});

  @override
  _EditReviewPageState createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _ratingController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.review.description);
    _ratingController =
        TextEditingController(text: widget.review.rating.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black87,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Edit your review',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Review',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
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
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a rating';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedReview = GameReview(
                          timeOfPost: DateTime.now(), // Update to current time
                          username: widget.review
                              .username, // Preserve the original username
                          description: _descriptionController.text,
                          rating: double.parse(_ratingController.text),
                        );
                        ref.read(gameReviewProvider.notifier).updateReview(
                            widget.review.timeOfPost, updatedReview);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Update Review'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
