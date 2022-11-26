import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/auth_provider.dart';
import 'package:mockani/src/providers/review_provider.dart';
import 'package:mockani/src/providers/summary_provider.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';
import 'package:mockani/src/screens/home.dart';
import 'package:mockani/src/screens/login.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const wanikaniRepository = WanikaniRepository();
    const customTheme = CustomTheme(
      primaryBackground: Color(0xffFFFFFF),
      secondaryBackground: Color(0xffF3F3F3),
      tertiaryBackground: Color(0xffE5E5E5),
      primary: Color(0xffF52BA7),
      success: Color(0xff88CC00),
      danger: Color(0xffFF0033),
      radical: Color(0xff009AE7),
      kanji: Color(0xffE50098),
      vocabulary: Color(0xff9E00ED),
    );
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider(wanikaniRepository)),
        Provider(create: (_) => SummaryProvider(wanikaniRepository)),
        Provider(create: (_) => ReviewProvider(wanikaniRepository)),
      ],
      child: MaterialApp(
        title: 'Mock Reviews for WaniKani',
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          brightness: Brightness.light,
          backgroundColor: customTheme.primaryBackground,
          useMaterial3: true,
        ).copyWith(
          primaryColor: customTheme.primary,
          extensions: [customTheme],
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.pink,
          brightness: Brightness.dark,
          backgroundColor: const Color(0xff252A3A),
          useMaterial3: true,
        ).copyWith(
          primaryColor: customTheme.primary,
          extensions: [
            customTheme.copyWith(
              primaryBackground: const Color(0xff252A3A),
              secondaryBackground: const Color(0xff252526),
              tertiaryBackground: const Color(0xff333333),
            ),
          ],
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "login",
        routes: {
          LOGIN_ROUTE: (_) => LoginScreen(),
          HOME_ROUTE: (_) => const HomeScreen(),
        },
      ),
    );
  }
}
