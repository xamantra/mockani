import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/utils/responsive.dart';
import 'package:mockani/src/utils/theme_extension.dart';

class NameGeneratorWidget extends StatelessWidget {
  const NameGeneratorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isVerySmall = isVerySmallScreen(context);
    final theme = getCustomTheme(context);

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, GENERATE_NAME);
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
                          "Generate Name",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        !isVerySmall
                            ? const SizedBox()
                            : Icon(
                                Icons.keyboard_arrow_right,
                                color: theme.radical.withOpacity(1),
                              ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "using english words",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(width: isVerySmall ? 0 : 12),
              isVerySmall
                  ? const SizedBox()
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, GENERATE_NAME);
                      },
                      child: const Text("Open"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
