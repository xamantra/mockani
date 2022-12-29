import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/summary_provider.dart';
import 'package:mockani/src/utils/responsive.dart';
import 'package:mockani/src/utils/theme_extension.dart';

class AvailableReviewWidget extends StatelessWidget {
  const AvailableReviewWidget({
    super.key,
    required this.summaryProvider,
  });

  final SummaryProvider summaryProvider;

  int get availableReview => summaryProvider.getAvailableReviews.length;
  bool get noAvailable => availableReview == 0;

  @override
  Widget build(BuildContext context) {
    final isVerySmall = isVerySmallScreen(context);
    final theme = getCustomTheme(context);

    return Card(
      child: InkWell(
        onTap: (!isVerySmall || availableReview == 0)
            ? null
            : () {
                Navigator.pushNamed(context, REVIEW_ROUTE);
              },
        borderRadius: BorderRadius.circular(12),
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
                    Row(
                      children: [
                        Text(
                          "$availableReview items",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        !isVerySmall
                            ? const SizedBox()
                            : Icon(
                                Icons.keyboard_arrow_right,
                                color: theme.radical.withOpacity(noAvailable ? 0.3 : 1),
                              ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    noAvailable
                        ? Text(
                            "No reviews",
                            style: Theme.of(context).textTheme.caption,
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, POINTERS_ROUTE);
                            },
                            child: Text(
                              "check pointers",
                              style: Theme.of(context).textTheme.caption?.copyWith(
                                    color: theme.radical,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(width: isVerySmall ? 0 : 12),
              SizedBox(width: isVerySmall ? 0 : 12),
              isVerySmall
                  ? const SizedBox()
                  : ElevatedButton(
                      onPressed: noAvailable
                          ? null
                          : () {
                              Navigator.pushNamed(context, REVIEW_ROUTE);
                            },
                      child: const Text("Review"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
