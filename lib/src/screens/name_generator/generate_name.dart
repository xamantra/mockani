import 'package:flutter/material.dart';
import 'package:mockani/src/providers/name_generator_provider.dart';
import 'package:mockani/src/screens/name_generator/reading_selector.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:mockani/src/widgets/alert_widget.dart';
import 'package:mockani/src/widgets/kanjiapi_widget.dart';
import 'package:provider/provider.dart';

class GenerateNameScreen extends StatefulWidget {
  const GenerateNameScreen({super.key});

  @override
  State<GenerateNameScreen> createState() => _GenerateNameScreenState();
}

class _GenerateNameScreenState extends State<GenerateNameScreen> {
  late final provider = Provider.of<NameGeneratorProvider>(context, listen: false);
  late final theme = getCustomTheme(context);

  late final TextEditingController controller = TextEditingController();
  late final FocusNode focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    provider.init();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: provider.stream,
      builder: (context, snapshot) {
        final provider = snapshot.data ?? this.provider;
        return Scaffold(
          body: SafeArea(
            child: provider.allPossibleCombinations.isNotEmpty
                ? const ReadingSelector()
                : Container(
                    padding: const EdgeInsets.all(36),
                    child: Column(
                      children: [
                        TextFormField(
                          enabled: !provider.loading,
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: "Type a word and hit enter",
                            border: OutlineInputBorder(),
                          ),
                          onFieldSubmitted: (keyword) {
                            provider.addKeyword(keyword);
                            controller.clear();
                            focusNode.requestFocus();
                          },
                          onSaved: (keyword) {
                            if (keyword != null && keyword.isNotEmpty) {
                              provider.addKeyword(keyword);
                              controller.clear();
                              focusNode.requestFocus();
                            }
                          },
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: provider.keywords
                                  .map(
                                    (key) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 36),
                                        BadgeWidget(
                                          color: theme.radical,
                                          text: key,
                                          onTap: (keyword) {
                                            provider.removeKeyword(keyword);
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: provider
                                                .getKanji(key)
                                                .map((kanji) => KanjiApiDetailWidget(
                                                      keyword: key,
                                                      kanji: kanji,
                                                      provider: provider,
                                                      isAdded: provider.isKanjiAdded(key, kanji),
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          floatingActionButton: Tooltip(
            message: provider.allPossibleCombinations.isNotEmpty ? "Reset" : "Start generating random names from selected kanji.",
            child: FloatingActionButton(
              backgroundColor: provider.allPossibleCombinations.isNotEmpty ? theme.danger : theme.radical,
              onPressed: provider.selectedKanji.isEmpty
                  ? null
                  : () {
                      provider.warmupGenerator();
                      provider.generateNames();
                    },
              child: Icon(provider.allPossibleCombinations.isNotEmpty ? Icons.close : Icons.start),
            ),
          ),
        );
      },
    );
  }
}
