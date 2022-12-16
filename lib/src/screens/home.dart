import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/auth_provider.dart';
import 'package:mockani/src/providers/summary_provider.dart';
import 'package:mockani/src/providers/theme_provider.dart';
import 'package:mockani/src/screens/reviews/review_hard_items.dart';
import 'package:mockani/src/screens/reviews/review_level.dart';
import 'package:mockani/src/utils/array_slice.dart';
import 'package:mockani/src/utils/responsive.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:mockani/src/screens/reviews/review_available.dart';
import 'package:mockani/src/widgets/circular_loading.dart';
import 'package:mockani/src/widgets/separated_list.dart';
import 'package:mockani/src/widgets/profile_widget.dart';
import 'package:mockani/src/screens/reviews/review_advance.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final authProvider = Provider.of<AuthProvider>(context);
  late final summaryProvider = Provider.of<SummaryProvider>(context);
  late final themeProvider = Provider.of<ThemeProvider>(context);
  late CustomTheme theme;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      summaryProvider.fetchSummary();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    theme = getCustomTheme(context);

    authProvider.stream.listen((event) {
      if (!event.loggedIn) {
        Navigator.pushNamedAndRemoveUntil(context, LOGIN_ROUTE, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: authProvider.stream,
          builder: (context, snapshot) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ProfileWidget(user: authProvider.user),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: StreamBuilder(
                            stream: summaryProvider.stream,
                            builder: (context, snapshot) {
                              if (summaryProvider.loading) {
                                return const CircularLoading();
                              }

                              final reviewWidgets = sliceList(source: [
                                AvailableReviewWidget(summaryProvider: summaryProvider),
                                AdvanceReviewWidget(summaryProvider: summaryProvider),
                                ReviewLevelWidget(user: authProvider.user),
                                const HardItemsReviewWidget(),
                                // add more review types here.
                              ], itemsPerSet: 2);

                              return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Container(
                                  width: 768,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: isSmallScreen(context)
                                      ? SeparatedList(
                                          separator: const SizedBox(height: 12),
                                          builder: (_, children) {
                                            return Column(children: children);
                                          },
                                          children: reviewWidgets.expand((e) => e).toList(),
                                        )
                                      : SeparatedList(
                                          separator: const SizedBox(height: 12),
                                          builder: (_, children) {
                                            return Column(children: children);
                                          },
                                          children: reviewWidgets
                                              .map(
                                                (x) => SeparatedList(
                                                  separator: const SizedBox(width: 12),
                                                  builder: (_, children) {
                                                    return Row(children: children);
                                                  },
                                                  children: x.map((y) => Expanded(child: y)).toList(),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
