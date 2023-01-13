// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockani/src/providers/name_generator_provider.dart';
import 'package:mockani/src/utils/kana_kit.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:mockani/src/widgets/alert_widget.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ReadingSelector extends StatefulWidget {
  const ReadingSelector({super.key});

  @override
  State<ReadingSelector> createState() => _ReadingSelectorState();
}

class _ReadingSelectorState extends State<ReadingSelector> {
  late final provider = Provider.of<NameGeneratorProvider>(context, listen: false);
  late final theme = getCustomTheme(context);

  int? selectedIndex;

  Map<int, int> selectedReadingIndex = {};

  String selectedReading = "";

  bool get selectionComplete {
    return selectedReadingIndex.length == provider.keywords.length;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: provider.stream,
      builder: (context, snapshot) {
        final provider = snapshot.data ?? this.provider;
        return Container(
          padding: const EdgeInsets.all(36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectionComplete
                  ? Row(
                      children: [
                        BadgeWidget(
                          color: theme.radical,
                          text: toRomaji(selectedReading),
                          onTap: (value) {
                            Clipboard.setData(ClipboardData(text: value));
                          },
                        ),
                        const SizedBox(width: 24),
                        BadgeWidget(
                          color: theme.kanji,
                          text: provider.allPossibleCombinations[selectedIndex!].map((e) => e.kanji).join(""),
                          onTap: (value) {
                            Clipboard.setData(ClipboardData(text: value));
                          },
                        ),
                        const SizedBox(width: 24),
                        BadgeWidget(
                          color: theme.vocabulary,
                          text: selectedReading,
                          onTap: (value) {
                            Clipboard.setData(ClipboardData(text: value));
                          },
                        ),
                      ],
                    )
                  : Text(
                      selectedIndex != null ? "Pick a reading from each Kanji" : "Pick a kanji combination",
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
              const SizedBox(height: 36),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: provider.allPossibleCombinations
                        .mapIndexed(
                          (index, kanjiSet) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: AnimatedOpacity(
                              opacity: shouldDisableUnselected(index) ? 0.2 : 1,
                              duration: const Duration(milliseconds: 300),
                              child: Column(
                                children: [
                                  TextButton(
                                    onPressed: shouldDisableUnselected(index)
                                        ? null
                                        : () {
                                            setState(() {
                                              if (selectedIndex == index) {
                                                selectedReadingIndex = {};
                                                selectedIndex = null;
                                                selectedReading = "";
                                              } else {
                                                selectedIndex = index;
                                              }
                                            });
                                          },
                                    child: Text(
                                      selectedIndex == index ? "Unselect" : "Select",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: selectedIndex == index ? theme.kanji : theme.radical,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: kanjiSet
                                        .mapIndexed(
                                          (kanjiIndex, kanji) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Tooltip(
                                                message: kanji.meanings.join(", "),
                                                child: BadgeWidget(
                                                  color: theme.kanji,
                                                  text: kanji.kanji,
                                                  onTap: (value) {
                                                    Clipboard.setData(ClipboardData(text: value));
                                                  },
                                                ),
                                              ),
                                              ...kanji
                                                  .allReadings()
                                                  .mapIndexed(
                                                    (readingIndex, reading) => AnimatedOpacity(
                                                      opacity: shouldDisableUnselectedReading(index, kanjiIndex, readingIndex) ? 0.2 : 1,
                                                      duration: const Duration(milliseconds: 300),
                                                      child: BadgeWidget(
                                                        color: theme.onBackground,
                                                        textColor: theme.kanji,
                                                        text: reading,
                                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                                        onTap: shouldDisableUnselectedReading(index, kanjiIndex, readingIndex)
                                                            ? null
                                                            : (value) {
                                                                if (selectedIndex != null) {
                                                                  setState(() {
                                                                    selectedReadingIndex[kanjiIndex] = readingIndex;
                                                                    selectedReading += value;
                                                                  });
                                                                }
                                                              },
                                                      ),
                                                    ),
                                                  )
                                                  .toList()
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(height: !hasReadingSelected(index) ? 0 : 12),
                                  !hasReadingSelected(index)
                                      ? const SizedBox()
                                      : TextButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedReading = "";
                                              selectedReadingIndex = {};
                                            });
                                          },
                                          child: Text(
                                            "Reset",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: theme.kanji,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool shouldDisableUnselected(int index) {
    return selectedIndex != null && selectedIndex != index;
  }

  bool shouldDisableUnselectedReading(int index, int kanjiIndex, int readingIndex) {
    return selectedIndex == index && selectedReadingIndex.containsKey(kanjiIndex) && selectedReadingIndex[kanjiIndex] != readingIndex;
  }

  bool hasReadingSelected(int index) {
    return selectedIndex == index && selectedReadingIndex.isNotEmpty;
  }
}
