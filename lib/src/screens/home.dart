import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/auth_provider.dart';
import 'package:mockani/src/providers/summary_provider.dart';
import 'package:mockani/src/providers/theme_provider.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:mockani/src/widgets/available_review_widget.dart';
import 'package:mockani/src/widgets/circular_loading.dart';
import 'package:mockani/src/widgets/profile_widget.dart';
import 'package:mockani/src/widgets/total_review_widget.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    theme = getCustomTheme(context);

    summaryProvider.fetchSummary();

    authProvider.stream.listen((event) {
      if (!event.loggedIn) {
        Navigator.pushNamedAndRemoveUntil(context, LOGIN_ROUTE, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: authProvider.stream,
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfileWidget(user: authProvider.user),
                const SizedBox(height: 32),
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
                            return SizedBox(
                              width: 380,
                              child: Column(
                                children: [
                                  AvailableReviewWidget(
                                    availableReview: summaryProvider.getAvailableReviews.length,
                                  ),
                                  const SizedBox(height: 12),
                                  TotalReviewWidget(
                                    totalReview: summaryProvider.getTotalReviews,
                                  ),
                                ],
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
    );
  }
}
