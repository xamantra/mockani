import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mockani/src/data/subject_details.dart';
import 'package:mockani/src/providers/review_provider.dart';
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
  late final ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context);

  bool answerMeaning = Random().nextBool();
  bool answeredMeaning = false;
  bool answeredReading = false;
  bool get answeredCurrentItem => answeredMeaning && answeredReading;

  bool correctMeaning = false;
  bool correctReading = false;
  bool get isCorrect => correctMeaning && correctReading;

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
    return StreamBuilder(
      stream: reviewProvider.stream,
      builder: (context, snapshot) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              if (reviewProvider.loadingMore && reviewProvider.reviewSubjects.isEmpty) {
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
              final item = reviewProvider.getCurrent;
              return Column(
                children: [
                  Expanded(
                    flex: 35,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.getColorFrom(item.object),
                      ),
                      child: Center(
                        child: (item.getCharacterImage != null) && item.data.characters.isEmpty
                            ? SvgPicture.network(
                                item.getCharacterImage!.url,
                                color: Colors.white,
                                height: 128,
                                width: 128,
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
                              const Spacer(),
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
                                    fontSize: 84,
                                  ),
                                ),
                                style: TextStyle(
                                  color: theme.onBackground,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 84,
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
                                    if (value.isNotEmpty && value[value.length - 1] == "n") return;
                                    inputController.text = toHiragana(value);
                                    inputController.selection = TextSelection.fromPosition(TextPosition(offset: inputController.text.length));
                                  }
                                },
                              ),
                              const Spacer(),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ReviewCounter(
                              totalCount: reviewProvider.shuffledReviews.length,
                              reviewedCount: reviewProvider.results.length,
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
  }

  void resetStates() {
    answerMeaning = Random().nextBool();
    answeredMeaning = false;
    answeredReading = false;
    correctMeaning = false;
    correctReading = false;

    inputController.clear();
  }

  void submit(SubjectDetails item, String answer) {
    setState(() {
      if (answerMeaning || item.isRadical) {
        correctMeaning = reviewProvider.answerMeaning(item, answer);
        answeredMeaning = true;
        if (correctMeaning) {
          inputController.clear();
        }
      } else {
        correctReading = reviewProvider.answerReading(item, answer);
        answeredReading = true;
        if (correctReading) {
          inputController.clear();
        }
      }
      answerMeaning = !answerMeaning;

      if (answeredCurrentItem || (answeredMeaning && item.isRadical)) {
        reviewProvider.saveResult(item.id, isCorrect);
        resetStates();
      }
    });
  }
}
