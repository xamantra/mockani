import 'package:flutter/material.dart';
import 'package:mockani/src/utils/theme_extension.dart';

class ReviewCounter extends StatelessWidget {
  const ReviewCounter({
    super.key,
    required this.totalCount,
    required this.reviewedCount,
    req,
    required this.correctCount,
    required this.incorrectCount,
  });

  final int totalCount;
  final int reviewedCount;

  final int correctCount;
  final int incorrectCount;

  @override
  Widget build(BuildContext context) {
    final theme = getCustomTheme(context);
    final captionFont = Theme.of(context).textTheme.caption;
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                correctCount.toString(),
                style: captionFont?.copyWith(
                  color: theme.success.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.check,
                size: 14,
                color: theme.success.withOpacity(0.6),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                incorrectCount.toString(),
                style: captionFont?.copyWith(
                  color: theme.danger.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.close,
                size: 14,
                color: theme.danger.withOpacity(0.6),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "$reviewedCount / $totalCount",
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
