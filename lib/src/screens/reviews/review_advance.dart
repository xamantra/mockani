import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/summary_provider.dart';
import 'package:mockani/src/utils/responsive.dart';
import 'package:mockani/src/utils/theme_extension.dart';

class AdvanceReviewWidget extends StatelessWidget {
  const AdvanceReviewWidget({
    super.key,
    required this.summaryProvider,
  });

  final SummaryProvider summaryProvider;

  int get advanceReview => summaryProvider.getUnavailableReviews.length;

  @override
  Widget build(BuildContext context) {
    final isVerySmall = isVerySmallScreen(context);
    final theme = getCustomTheme(context);

    return Card(
      child: InkWell(
        onTap: (!isVerySmall || advanceReview == 0)
            ? null
            : () {
                Navigator.pushNamed(context, ADVANCE_REVIEW_ROUTE);
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
                          "$advanceReview items",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        !isVerySmall
                            ? const SizedBox()
                            : Icon(
                                Icons.keyboard_arrow_right,
                                color: theme.radical.withOpacity(advanceReview == 0 ? 0.3 : 1),
                              ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "in the next 24 hours",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(width: isVerySmall ? 0 : 12),
              isVerySmall
                  ? const SizedBox()
                  : ElevatedButton(
                      onPressed: advanceReview == 0
                          ? null
                          : () {
                              Navigator.pushNamed(context, ADVANCE_REVIEW_ROUTE);
                            },
                      child: const Text("Advance review"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
