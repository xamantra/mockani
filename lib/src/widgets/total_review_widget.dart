import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';

class TotalReviewWidget extends StatelessWidget {
  const TotalReviewWidget({
    super.key,
    required this.totalReview,
  });

  final int totalReview;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$totalReview items",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "in the next 24 hours",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: totalReview == 0
                  ? null
                  : () {
                      Navigator.pushNamed(context, ADVANCE_REVIEW_ROUTE);
                    },
              child: const Text("Advance review"),
            )
          ],
        ),
      ),
    );
  }
}
