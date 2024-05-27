import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatingStar extends StatelessWidget {
  final double rating;
  final TextStyle? style;

  const RatingStar({
    Key? key,
    required this.rating,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          color: index < rating.round() ? Colors.amber : Colors.grey,
          size: style?.fontSize ?? 16,
        ),
      ),
    );
  }
}
