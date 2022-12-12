import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/data/user.dart';
import 'package:mockani/src/providers/home_review_provider.dart';
import 'package:mockani/src/utils/responsive.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:provider/provider.dart';

class ReviewLevelWidget extends StatefulWidget {
  const ReviewLevelWidget({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<ReviewLevelWidget> createState() => _ReviewLevelWidgetState();
}

class _ReviewLevelWidgetState extends State<ReviewLevelWidget> {
  var selectedTypes = ["radical", "kanji", "vocabulary"];

  @override
  Widget build(BuildContext context) {
    final isVerySmall = isVerySmallScreen(context);
    final homeReviewProvider = Provider.of<HomeReviewProvider>(context, listen: false);
    final theme = getCustomTheme(context);

    return Card(
      child: InkWell(
        onTap: !isVerySmall
            ? null
            : () {
                showDialog<List<String>>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => _TypeSelectionDialog(
                    levels: [widget.user.data.level],
                    selectedTypes: selectedTypes,
                    homeReviewProvider: homeReviewProvider,
                  ),
                );
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Level ${widget.user.data.level}",
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
                      "Study current level.",
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
                        showDialog<List<String>>(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => _TypeSelectionDialog(
                            levels: [widget.user.data.level],
                            selectedTypes: selectedTypes,
                            homeReviewProvider: homeReviewProvider,
                          ),
                        );
                      },
                      child: const Text("Study"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeSelectionDialog extends StatefulWidget {
  const _TypeSelectionDialog({
    required this.levels,
    required this.selectedTypes,
    required this.homeReviewProvider,
  });

  final List<int> levels;
  final List<String> selectedTypes;

  final HomeReviewProvider homeReviewProvider;

  @override
  State<_TypeSelectionDialog> createState() => _TypeSelectionDialogState();
}

class _TypeSelectionDialogState extends State<_TypeSelectionDialog> {
  late List<String> selectedTypes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    selectedTypes = widget.selectedTypes;
  }

  @override
  Widget build(BuildContext context) {
    final theme = getCustomTheme(context);

    return Dialog(
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Study Level ${widget.levels.join(', ')}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            CheckboxListTile(
              value: selectedTypes.any((t) => t == "radical"),
              title: Text("Radical", style: Theme.of(context).textTheme.caption),
              activeColor: theme.radical,
              dense: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              onChanged: (value) {
                toggleType("radical");
              },
            ),
            CheckboxListTile(
              value: selectedTypes.any((t) => t == "kanji"),
              title: Text("Kanji", style: Theme.of(context).textTheme.caption),
              activeColor: theme.kanji,
              dense: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              onChanged: (value) {
                toggleType("kanji");
              },
            ),
            CheckboxListTile(
              value: selectedTypes.any((t) => t == "vocabulary"),
              title: Text("Vocabulary", style: Theme.of(context).textTheme.caption),
              activeColor: theme.vocabulary,
              dense: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              onChanged: (value) {
                toggleType("vocabulary");
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 320,
              child: ElevatedButton(
                onPressed: selectedTypes.isEmpty
                    ? null
                    : () {
                        widget.homeReviewProvider.selectLevelAndType(levels: widget.levels, types: selectedTypes);
                        Navigator.pushNamed(context, LEVEL_STUDY_ROUTE);
                      },
                child: const Text("START"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleType(String type) {
    setState(() {
      if (selectedTypes.any((t) => t == type)) {
        selectedTypes.remove(type);
      } else {
        selectedTypes.add(type);
      }
    });
  }
}
