// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/data/subject.dart';
import 'package:mockani/src/utils/array_slice.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:mockani/src/widgets/character.dart';
import 'package:mockani/src/widgets/separated_list.dart';
import 'package:provider/provider.dart';

import 'package:mockani/src/providers/pointers_provider.dart';
import 'package:mockani/src/providers/summary_provider.dart';
import 'package:mockani/src/widgets/circular_loading.dart';

class ReviewPointers extends StatefulWidget {
  const ReviewPointers({super.key});

  @override
  State<ReviewPointers> createState() => _ReviewPointersState();
}

class _ReviewPointersState extends State<ReviewPointers> {
  late final provider = Provider.of<PointersProvider>(context, listen: false);
  late final summaryProvider = Provider.of<SummaryProvider>(context, listen: false);

  SubjectData? hovering;

  @override
  void initState() {
    super.initState();

    provider.loadSubjects(summaryProvider.getAvailableReviews);
  }

  @override
  Widget build(BuildContext context) {
    final theme = getCustomTheme(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: StreamBuilder(
                  stream: provider.stream,
                  builder: (context, snapshot) {
                    if (provider.loading) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularLoading(),
                            SizedBox(height: 12),
                            Text(
                              "Loading subjects ...",
                            ),
                          ],
                        ),
                      );
                    }

                    final grouped = groupBy(provider.reviewSubjects, (v) => v.object);

                    return Center(
                      child: SizedBox(
                        width: 1280,
                        child: ListView.builder(
                          itemCount: grouped.keys.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final g = grouped.keys.toList()[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 48),
                              child: Center(
                                child: Builder(
                                  builder: (context) {
                                    final subjects = sliceList(source: grouped[g]!, itemsPerSet: 5);

                                    return ListView.builder(
                                      itemCount: subjects.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, j) {
                                        final items = subjects[j];
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 24),
                                          child: SeparatedList(
                                            separator: const SizedBox(width: 12),
                                            builder: (context, children) {
                                              return Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: children,
                                              );
                                            },
                                            children: items
                                                .map(
                                                  (s) => SizedBox(
                                                    height: 240,
                                                    width: 240,
                                                    child: MouseRegion(
                                                      onEnter: (event) {
                                                        setState(() {
                                                          hovering = s;
                                                        });
                                                      },
                                                      onExit: (event) {
                                                        setState(() {
                                                          hovering = null;
                                                        });
                                                      },
                                                      child: Card(
                                                        elevation: 0,
                                                        color: theme.getColorFrom(s.object),
                                                        child: Center(
                                                          child: Column(
                                                            children: [
                                                              const Spacer(),
                                                              Character(
                                                                item: s,
                                                                size: 128,
                                                              ),
                                                              const Spacer(),
                                                              AnimatedOpacity(
                                                                opacity: isHoveringItem(s) ? 1 : 0,
                                                                duration: const Duration(milliseconds: 300),
                                                                child: Text(
                                                                  s.getPrimaryReadings.join(", "),
                                                                  style: Theme.of(context).textTheme.titleMedium,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 8),
                                                              AnimatedOpacity(
                                                                opacity: isHoveringItem(s) ? 1 : 0,
                                                                duration: const Duration(milliseconds: 300),
                                                                child: Text(
                                                                  s.getPrimaryMeanings.join(", "),
                                                                  style: Theme.of(context).textTheme.titleMedium,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, HOME_ROUTE, (_) => false);
                },
                icon: const Icon(
                  Icons.close,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isHoveringItem(SubjectData subjectData) {
    return hovering != null && hovering!.id == subjectData.id;
  }
}
