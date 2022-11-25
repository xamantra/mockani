import 'package:flutter/material.dart';
import 'package:mockani/src/data/summary.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewSummary extends StatelessWidget {
  const ReviewSummary({
    super.key,
    required this.review,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = getCustomTheme(context);
    return Container(
      width: 380,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 380,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.primary,
                  width: 3,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                "${review.subject_ids.length}",
                style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: theme.primary,
                    ),
              ),
            ),
            const Spacer(),
            review.isAvailableNow
                ? ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Review now",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                : Text(
                    "in ${timeago.format(review.availableAt, allowFromNow: true).replaceAll("from now", "").trim()}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ],
        ),
      ),
    );
  }
}
