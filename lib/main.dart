import 'package:flutter/material.dart';
import 'package:mockani/src/screens/home.dart';
import 'package:mockani/src/utils/theme_extension.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
    return MaterialApp(
      title: 'Mockani',
      theme: ThemeData.light().copyWith(extensions: [customTheme]),
      darkTheme: ThemeData.dark().copyWith(
        extensions: [
          customTheme.copyWith(
            primaryBackground: const Color(0xff252A3A),
            secondaryBackground: const Color(0xff252526),
            tertiaryBackground: const Color(0xff333333),
          ),
        ],
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
