import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockani/src/data/kanji.dart';
import 'package:mockani/src/providers/name_generator_provider.dart';
import 'package:mockani/src/utils/kana_kit.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:mockani/src/widgets/alert_widget.dart';

class KanjiApiDetailWidget extends StatelessWidget {
  const KanjiApiDetailWidget({
    super.key,
    required this.keyword,
    required this.kanji,
    required this.isAdded,
    required this.provider,
  });

  final String keyword;
  final Kanji kanji;
  final bool isAdded;
  final NameGeneratorProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = getCustomTheme(context);
    return Row(
      children: [
        BadgeWidget(
          color: theme.kanji,
          text: kanji.kanji,
          onTap: (kanji) {
            Clipboard.setData(ClipboardData(text: kanji)).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$kanji copied to clipboard"),
                  duration: const Duration(milliseconds: 1000),
                ),
              );
            });
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Tooltip(
                  message: "Grade level where this kanji is taught.",
                  child: Text(
                    "G${kanji.grade}",
                    style: TextStyle(
                      color: theme.onBackground.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  kanji.meanings.join(", "),
                  style: TextStyle(
                    color: theme.onBackground.withOpacity(0.85),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: kanji
                      .allReadings()
                      .map(
                        (e) => Tooltip(
                          message: toRomaji(e),
                          child: BadgeWidget(
                            color: theme.onBackground,
                            textColor: theme.kanji,
                            text: e,
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(width: 12),
                Tooltip(
                  message: isAdded ? "Remove this kanji from the Name Randomizer" : "Add this kanji in the Name Randomizer",
                  child: TextButton(
                    onPressed: () {
                      if (isAdded) {
                        provider.removeKanji(keyword, kanji);
                      } else {
                        provider.addKanji(keyword, kanji);
                      }
                    },
                    child: Text(
                      isAdded ? "Remove" : "Add",
                      style: TextStyle(
                        fontSize: 14,
                        color: isAdded ? theme.kanji : theme.radical,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
