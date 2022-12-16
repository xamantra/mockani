import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/utils/responsive.dart';
import 'package:mockani/src/utils/theme_extension.dart';

class HardItemsReviewWidget extends StatelessWidget {
  const HardItemsReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isVerySmall = isVerySmallScreen(context);
    final theme = getCustomTheme(context);

    return Card(
      child: InkWell(
        onTap: !isVerySmall
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
                          "Hard Items",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        !isVerySmall
                            ? const SizedBox()
                            : Icon(
                                Icons.keyboard_arrow_right,
                                color: theme.radical,
                              ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Review hard items.",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(width: isVerySmall ? 0 : 12),
              SizedBox(width: isVerySmall ? 0 : 12),
              isVerySmall
                  ? const SizedBox()
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HARD_ITEMS_REVIEW_ROUTE);
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
