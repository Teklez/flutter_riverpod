import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Domain/review_model.dart';

final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService();
});

class ReviewService {
  static const String baseUrl = 'http://localhost:5000/reviews';

  Future<List<Review>> getReviews(String gameId) async {
    print("Fetching reviews for gameId: $gameId");
    try {
      final response = await http.get(Uri.parse('$baseUrl/game/$gameId'));
      print("=================>${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Review> reviews =
            body.map((item) => Review.fromJson(item)).toList();
        print('====================>fetched reviews ${reviews}');
        return reviews;
      } else {
        print("Error: ${response.statusCode}");
        throw "Failed to load fucking reviews";
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      throw "Failed to load  fucking reviews";
    }
  }

  Future<Review> getReview(String id) async {
    final response = await http.get(Uri.parse(baseUrl + 'reviews/' + id));
    if (response.statusCode == 200) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to load fucking review";
    }
  }

  Future<Review> createReview(Review review, gameId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/game/$gameId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(review.toJson()),
    );
    if (response.statusCode == 201) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to create review";
    }
  }

  Future<Review> updateReview(String id, Review review) async {
    print(
        "==================================================================>Updating review with id: $id");
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(review.toJson()),
    );
    if (response.statusCode == 200) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to update review";
    }
  }

  Future<void> deleteReview(String id, String gameId) async {
    print(
        "========================================================================>Deleting review with id: $id associated with the game with id: $gameId");
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'gameId': gameId,
      }),
    );

    if (response.statusCode != 204) {
      throw "Failed to delete review";
    }
  }
}
