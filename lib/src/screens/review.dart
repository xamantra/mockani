import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/data/subject.dart';
import 'package:mockani/src/providers/review_provider.dart';
import 'package:mockani/src/providers/theme_provider.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';
import 'package:mockani/src/utils/extension.dart';
import 'package:mockani/src/utils/kana_kit.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:mockani/src/widgets/alert_widget.dart';
import 'package:mockani/src/widgets/circular_loading.dart';
import 'package:mockani/src/widgets/review_counter.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.all});

  final bool all;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final themeProvider = Provider.of<ThemeProvider>(context);
  final reviewProvider = ReviewProvider(const WanikaniRepository());
  late CustomTheme theme;

  bool answerMeaning = Random().nextBool();
  bool correctMeaning = false;
  bool correctReading = false;
  bool commitedMistake = false;
  bool get answeredCurrentItem => correctMeaning && correctReading;

  List<SubjectData> answeredItems = [];

  String? error;
  String? warning;

  /// If the user answers incorrectly. It will show all accepted answers.
  List<String> answers = [];

  TextEditingController inputController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    reviewProvider.init(widget.all);

    theme = getCustomTheme(context);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => reviewProvider,
      child: Builder(builder: (context) {
        final provider = Provider.of<ReviewProvider>(context);
        return StreamBuilder(
          stream: provider.stream,
          builder: (context, snapshot) {
            return Scaffold(
              body: Builder(
                builder: (context) {
                  if (provider.completed || provider.nothingToReview) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Completed mock review",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          const SizedBox(height: 36),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context, HOME_ROUTE, (route) => false);
                            },
                            child: Text(
                              "HOME",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (provider.loading && provider.reviewSubjects.isEmpty) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularLoading(),
                          SizedBox(height: 12),
                          Text(
                            "Loading more review ...",
                          ),
                        ],
                      ),
                    );
                  }
                  final item = provider.getCurrent;
                  if (kDebugMode) {
                    print(["reviewProvider.getCurrent", item.id]);
                  }
                  return Column(
                    children: [
                      Expanded(
                        flex: 25,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.getColorFrom(item.object),
                          ),
                          child: Center(
                            child: (item.getCharacterImage != null)
                                ? SizedBox(
                                    height: 128,
                                    width: 128,
                                    child: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                      child: ScalableImageWidget.fromSISource(
                                        si: ScalableImageSource.fromSvgHttpUrl(
                                          Uri.parse(
                                            item.getCharacterImage!.url,
                                          ),
                                          currentColor: Colors.white,
                                        ),
                                        onLoading: (_) {
                                          return const CircularLoading(
                                            color: Colors.white,
                                            size: 64,
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : Text(
                                    item.data.characters,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 128,
                                      fontFamily:
                                          'Hiragino Kaku Gothic Pro", "Meiryo", "Source Han Sans Japanese", "NotoSansCJK", "TakaoPGothic", "Yu Gothic", "ヒラギノ角ゴ Pro W3", "メイリオ", "Osaka", "MS PGothic", "ＭＳ Ｐゴシック", "Noto Sans JP", "PingFang SC", "Noto Sans SC", sans-serif',
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 65,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 24),
                                  answers.isEmpty
                                      ? const SizedBox()
                                      : Text(
                                          "Incorrect",
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                color: theme.danger,
                                              ),
                                        ),
                                  const SizedBox(height: 24),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      textSelectionTheme: TextSelectionThemeData(
                                        selectionColor: theme.getColorFrom(item.object).withOpacity(0.8),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: inputController,
                                      focusNode: focusNode,
                                      maxLines: 1,
                                      minLines: 1,
                                      textAlign: TextAlign.center,
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: item.isRadical
                                            ? "Radical Name"
                                            : answerMeaning
                                                ? "Meaning"
                                                : "Reading",
                                        hintStyle: TextStyle(
                                          color: theme.onBackground.withOpacity(0.3),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 48,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: theme.onBackground,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 48,
                                      ),
                                      cursorColor: theme.getColorFrom(item.object),
                                      onFieldSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          submit(item, value);
                                        }
                                        focusNode.requestFocus();
                                      },
                                      onSaved: (value) {
                                        if (value != null && value.isNotEmpty) {
                                          submit(item, value);
                                        }
                                        focusNode.requestFocus();
                                      },
                                      onChanged: (value) {
                                        if (!answerMeaning) {
                                          if (item.isRadical) return;
                                          if (isDoubleNN(value)) {
                                            inputController.text = toHiragana(value.substring(0, value.length - 1));
                                            inputController.selection = TextSelection.fromPosition(TextPosition(offset: inputController.text.length));
                                          } else {
                                            if (value.isNotEmpty && value[value.length - 1] == "n") return;
                                            if (startsOrEndsWith(value, "ny")) return;
                                            inputController.text = toHiragana(value);
                                            inputController.selection = TextSelection.fromPosition(TextPosition(offset: inputController.text.length));
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 24),
                                    child: Builder(
                                      builder: (context) {
                                        var alerts = <String>[];
                                        if (error != null) {
                                          alerts.add(error!);
                                        } else if (warning != null) {
                                          alerts.add(warning!);
                                        } else if (answers.isNotEmpty) {
                                          alerts.addAll(answers);
                                        }
                                        return AlertWidget(
                                          color: theme.getColorFrom(item.object),
                                          alerts: alerts,
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      child: const AbsorbPointer(
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      onTap: () {
                                        focusNode.requestFocus();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ReviewCounter(
                                  totalCount: provider.reviewIds.length,
                                  reviewedCount: provider.results.length,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pushNamedAndRemoveUntil(context, HOME_ROUTE, (route) => false);
                                        },
                                        tooltip: "Back home",
                                        icon: Icon(
                                          Icons.home,
                                          size: 18,
                                          color: theme.onBackground,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: IconButton(
                                        onPressed: () {
                                          themeProvider.switchTheme();
                                        },
                                        tooltip: "Switch theme",
                                        icon: StreamBuilder(
                                          stream: themeProvider.stream,
                                          builder: (context, snapshot) {
                                            return Icon(
                                              themeProvider.darkMode ? Icons.dark_mode : Icons.light_mode,
                                              size: 18,
                                              color: theme.onBackground,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }

  void resetStates() {
    answerMeaning = Random().nextBool();
    correctMeaning = false;
    correctReading = false;
    commitedMistake = false;

    clearErrors();

    inputController.clear();
  }

  void clearErrors() {
    warning = null;
    error = null;
    answers = [];
  }

  void submit(SubjectData item, String answer) {
    setState(() {
      if (answerMeaning || item.isRadical) {
        if (isInputMixed(answer)) {
          warning = "Kindly double check your answer. Kana-romaji mixed.";
        } else if (isKana(answer)) {
          warning = "We want the meaning.";
        } else {
          correctMeaning = reviewProvider.answerMeaning(item, answer);
          if (correctMeaning) {
            inputController.clear();
            clearErrors();
            answerMeaning = !answerMeaning;
          } else {
            commitedMistake = true;
            checkMeaning(item, answer);
          }
        }
      } else {
        if (isInputMixed(answer) || isRomaji(answer)) {
          warning = "Kindly double check your answer. Either kana-romaji mixed or purely romaji.";
        } else {
          correctReading = reviewProvider.answerReading(item, answer);
          if (correctReading) {
            inputController.clear();
            clearErrors();
            answerMeaning = !answerMeaning;
          } else {
            commitedMistake = true;
            checkReading(item, answer);
          }
        }
      }

      if (answeredCurrentItem || (correctMeaning && item.isRadical)) {
        if (item.isRadical) {
          reviewProvider.saveResult(item.id, correctMeaning);
        } else {
          reviewProvider.saveResult(item.id, answeredCurrentItem && !commitedMistake);
        }
        resetStates();
      }
    });
  }

  void checkMeaning(SubjectData item, String answer) async {
    if (!correctMeaning) {
      // check for spelling error
      final distance = <String, double>{};
      for (final m in item.getMeaningAnswers) {
        distance[m] = answer.similarity(m) * 100;
        final alt = m.similarity(answer) * 100;
        if (alt > (distance[m] ?? 0.0)) {
          distance[m] = alt;
        }
      }

      final closest = (distance.values.toList()..sort((a, b) => b.compareTo(a))).first;
      if (closest >= 70) {
        warning = "Check your spelling ...";
      } else {
        warning = null;
        answers = item.getMeaningAnswers;
      }
    }
  }

  void checkReading(SubjectData item, String answer) {
    if (!correctReading) {
      warning = null;
      answers = item.getReadingAnswers;
    }
  }
}
