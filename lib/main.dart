import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/auth_provider.dart';
import 'package:mockani/src/providers/home_review_provider.dart';
import 'package:mockani/src/providers/name_generator_provider.dart';
import 'package:mockani/src/providers/pointers_provider.dart';
import 'package:mockani/src/providers/summary_provider.dart';
import 'package:mockani/src/providers/theme_provider.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';
import 'package:mockani/src/screens/name_generator/generate_name.dart';
import 'package:mockani/src/screens/home.dart';
import 'package:mockani/src/screens/login.dart';
import 'package:mockani/src/screens/review.dart';
import 'package:mockani/src/screens/review_pointers.dart';
import 'package:mockani/src/utils/review_type.dart';
import 'package:mockani/src/utils/theme.dart';
import 'package:mockani/src/widgets/scroll_behavior.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const wanikaniRepository = WanikaniRepository();

    final themeProvider = ThemeProvider();
    return MultiProvider(
      providers: [
        Provider(create: (_) => themeProvider),
        Provider(create: (_) => AuthProvider(wanikaniRepository)),
        Provider(create: (_) => SummaryProvider(wanikaniRepository)),
        Provider(create: (_) => HomeReviewProvider()),
        Provider(create: (_) => PointersProvider(wanikaniRepository)),
        Provider(create: (_) => NameGeneratorProvider()),
      ],
      child: StreamBuilder(
        stream: themeProvider.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Mock Reviews for WaniKani',
            themeMode: themeProvider.darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              backgroundColor: lightTheme.primaryBackground,
              scaffoldBackgroundColor: lightTheme.primaryBackground,
              cardTheme: CardTheme(
                color: lightTheme.secondaryBackground,
                surfaceTintColor: Colors.transparent,
              ),
              useMaterial3: true,
            ).copyWith(
              primaryColor: lightTheme.radical,
              extensions: [lightTheme],
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              backgroundColor: darkTheme.primaryBackground,
              scaffoldBackgroundColor: darkTheme.primaryBackground,
              cardTheme: CardTheme(
                color: darkTheme.tertiaryBackground,
                surfaceTintColor: Colors.transparent,
              ),
              useMaterial3: true,
            ).copyWith(
              primaryColor: darkTheme.radical,
              extensions: [darkTheme],
            ),
            debugShowCheckedModeBanner: false,
            scrollBehavior: MyCustomScrollBehavior(),
            routes: {
              LOGIN_ROUTE: (BuildContext _) => const LoginScreen(),
              HOME_ROUTE: (BuildContext _) => const HomeScreen(),
              REVIEW_ROUTE: (BuildContext _) => const ReviewScreen(reviewType: ReviewType.available),
              POINTERS_ROUTE: (BuildContext _) => const ReviewPointers(),
              ADVANCE_REVIEW_ROUTE: (BuildContext _) => const ReviewScreen(reviewType: ReviewType.advanceReview),
              HARD_ITEMS_REVIEW_ROUTE: (BuildContext _) => const ReviewScreen(reviewType: ReviewType.hardItemsReview),
              LEVEL_STUDY_ROUTE: (BuildContext _) => const ReviewScreen(reviewType: ReviewType.level),
              GENERATE_NAME: (BuildContext _) => const GenerateNameScreen(),
            },
          );
        },
      ),
    );
  }
}
