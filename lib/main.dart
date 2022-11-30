import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/auth_provider.dart';
import 'package:mockani/src/providers/summary_provider.dart';
import 'package:mockani/src/providers/theme_provider.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';
import 'package:mockani/src/screens/home.dart';
import 'package:mockani/src/screens/login.dart';
import 'package:mockani/src/screens/review.dart';
import 'package:mockani/src/utils/review_type.dart';
import 'package:mockani/src/utils/theme_extension.dart';
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
    const customTheme = CustomTheme(
      primaryBackground: Color(0xffFFFFFF),
      secondaryBackground: Color.fromARGB(255, 250, 250, 250),
      tertiaryBackground: Color(0xffE5E5E5),
      onBackground: Color(0xff333333),
      primary: Color(0xffF52BA7),
      success: Color(0xff88CC00),
      danger: Color(0xffFF0033),
      radical: Color(0xff009AE7),
      kanji: Color(0xffE50098),
      vocabulary: Color(0xff9E00ED),
    );
    final themeProvider = ThemeProvider();
    return MultiProvider(
      providers: [
        Provider(create: (_) => themeProvider),
        Provider(create: (_) => AuthProvider(wanikaniRepository)),
        Provider(create: (_) => SummaryProvider(wanikaniRepository)),
      ],
      child: StreamBuilder(
        stream: themeProvider.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Mock Reviews for WaniKani',
            themeMode: themeProvider.darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              backgroundColor: customTheme.primaryBackground,
              scaffoldBackgroundColor: customTheme.primaryBackground,
              cardTheme: CardTheme(
                color: customTheme.secondaryBackground,
                surfaceTintColor: Colors.transparent,
              ),
              useMaterial3: true,
            ).copyWith(
              primaryColor: customTheme.radical,
              extensions: [customTheme],
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              backgroundColor: const Color(0xff1E1E1E),
              scaffoldBackgroundColor: const Color(0xff1E1E1E),
              cardTheme: const CardTheme(
                color: Color(0xff333333),
                surfaceTintColor: Colors.transparent,
              ),
              useMaterial3: true,
            ).copyWith(
              primaryColor: customTheme.radical,
              extensions: [
                customTheme.copyWith(
                  primaryBackground: const Color(0xff1E1E1E),
                  secondaryBackground: const Color(0xff252526),
                  tertiaryBackground: const Color(0xff333333),
                  onBackground: const Color(0xffE8EAED),
                ),
              ],
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: LOGIN_ROUTE,
            routes: {
              LOGIN_ROUTE: (_) => const LoginScreen(),
              HOME_ROUTE: (_) => const HomeScreen(),
              REVIEW_ROUTE: (_) => const ReviewScreen(reviewType: ReviewType.available),
              ADVANCE_REVIEW_ROUTE: (_) => const ReviewScreen(reviewType: ReviewType.advanceReview),
            },
          );
        },
      ),
    );
  }
}
