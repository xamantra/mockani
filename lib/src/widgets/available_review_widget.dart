import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';

class AvailableReviewWidget extends StatelessWidget {
  const AvailableReviewWidget({
    super.key,
    required this.availableReview,
  });

  final int availableReview;

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
                    "$availableReview items",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "available now",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: availableReview == 0
                  ? null
                  : () {
                      Navigator.pushNamed(context, REVIEW_ROUTE);
                    },
              child: const Text("Review"),
            )
          ],
        ),
      ),
    );
  }
}
