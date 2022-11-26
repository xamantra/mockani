import 'package:flutter/material.dart';

class ReviewCounter extends StatelessWidget {
  const ReviewCounter({super.key, required this.totalCount, required this.reviewedCount});

  final int totalCount;
  final int reviewedCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$reviewedCount / $totalCount",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
