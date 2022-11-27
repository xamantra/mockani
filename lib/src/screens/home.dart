import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/auth_provider.dart';
import 'package:mockani/src/providers/summary_provider.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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
              ],
            ),
          );
        },
      ),
    );
  }
}
