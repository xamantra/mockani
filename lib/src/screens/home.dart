import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/auth_provider.dart';
import 'package:mockani/src/providers/summary_provider.dart';
import 'package:mockani/src/widgets/circular_loading.dart';
import 'package:mockani/src/widgets/profile_widget.dart';
import 'package:mockani/src/widgets/review_summary.dart';
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
                      return Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${summaryProvider.getTotalReviews} total reviews",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, REVIEW_ALL_ROUTE);
                                },
                                child: Text(
                                  "Review all",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 32),
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: SizedBox(
                                  width: 380,
                                  child: ListView.builder(
                                    itemCount: summaryProvider.getSummaryCount,
                                    shrinkWrap: true,
                                    itemBuilder: (_, index) {
                                      return ReviewSummary(review: summaryProvider.getReviews[index]);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
