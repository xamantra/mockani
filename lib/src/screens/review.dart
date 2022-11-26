import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/data/subject_details.dart';
import 'package:mockani/src/providers/review_provider.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';
import 'package:mockani/src/utils/kana_kit.dart';
import 'package:mockani/src/utils/theme_extension.dart';
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
  final reviewProvider = ReviewProvider(const WanikaniRepository());

  bool answerMeaning = Random().nextBool();
  bool correctMeaning = false;
  bool correctReading = false;
  bool get answeredCurrentItem => correctMeaning && correctReading;

  List<SubjectDetails> answeredItems = [];

  TextEditingController inputController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    reviewProvider.init(widget.all);
  }

  @override
  Widget build(BuildContext context) {
    final theme = getCustomTheme(context);
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
                  if (provider.completed) {
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
                  if (provider.loadingMore && provider.reviewSubjects.isEmpty) {
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
                                  TextFormField(
                                    controller: inputController,
                                    focusNode: focusNode,
                                    maxLines: 1,
                                    minLines: 1,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: item.isRadical
                                          ? "Meaning"
                                          : answerMeaning
                                              ? "Meaning"
                                              : "Reading",
                                      hintStyle: TextStyle(
                                        color: theme.onBackground.withOpacity(0.1),
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
                                          inputController.text = toHiragana(value);
                                          inputController.selection = TextSelection.fromPosition(TextPosition(offset: inputController.text.length));
                                        }
                                      }
                                    },
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ReviewCounter(
                                  totalCount: provider.shuffledReviews.length,
                                  reviewedCount: provider.results.length,
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

    inputController.clear();
  }

  void submit(SubjectDetails item, String answer) {
    setState(() {
      if (answerMeaning || item.isRadical) {
        correctMeaning = reviewProvider.answerMeaning(item, answer);
        if (correctMeaning) {
          inputController.clear();
          answerMeaning = !answerMeaning;
        }
      } else {
        correctReading = reviewProvider.answerReading(item, answer);
        if (correctReading) {
          inputController.clear();
          answerMeaning = !answerMeaning;
        }
      }

      if (answeredCurrentItem || (correctMeaning && item.isRadical)) {
        reviewProvider.saveResult(item.id, answeredCurrentItem);
        resetStates();
      }
    });
  }
}
